class AdminController < ApplicationController
  before_action :check_login
  require "pp"

  def dashboard
    @user = User.current_user

    user_t = User.all.count
    app_t = Application.all.count
    @total = [user_t,app_t,0]
  end

  def statistics
  end

  def faq
    @faq = Faq.new
    @faqs = Faq.all.to_a.sort_by {|obj| obj.priority}
  end

  def faq_view
    @faqs = Faq.all
    if faq_params.present?
      @faq = Faq.find(faq_params[:id])
    else
      redirect_to "/admin/faq" and return
    end
  end

  def sponsorship
    # Used to populate Edit Sponsors section.
    @sponsors = []

    begin
      # get sponsors
      url = URI.parse("#{ENV['API_AUTH_TOKEN']}/sponsors")
      req = Net::HTTP::Get.new(url.to_s)
      req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")

      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true if url.scheme == 'https'
      res = res.start {|http|
        http.request(req)
      }
      companies =  JSON.parse(res.body)
      companies.each do |c|
        @sponsors.push([c["id"].to_i, c["name"]])
      end
    rescue
      p "Error getting Sponsors"
    end
  end

  def sponsorship_view
  end

  def statistics
    @event_date = Date.new(2016, 1, 20)
    @most_common_words = ["the", "be", "to", "of", "and", "a", "in", "that",
      "have", "i", "it", "for", "not", "on", "with", "he", "as", "you", "do",
      "at", "this", "but", "his", "by", "from", "they", "we", "say", "her",
      "she", "or", "an", "will", "my", "one", "all", "would", "there",
      "their", "what", "so", "up", "out", "if", "about", "who", "get",
      "which", "go", "me", "when", "make", "can", "like", "time", "no",
      "just", "him", "know", "take", "person", "into", "year", "your", "good",
      "some", "could", "them", "see", "other", "than", "then", "now", "look",
      "only", "come", "its", "over", "think", "also", "back", "after", "use",
      "two", "how", "our", "work", "first", "well", "way", "even", "new",
      "want", "because", "any", "these", "give", "day", "most", "us", "im",
    "ive", "id", "am"]

    @applications = Application.all()
    @applications = @applications.sort do |a,b|
      DateTime.parse(a.created_at) <=> DateTime.parse(b.created_at)
    end

    @universities = {:Other => 0}
    @international = 0
    @majors = {}
    @genders = {}
    @ages = {}
    @minors = 0
    @adults = 0
    @graduation_years = {}
    @graduation_hs_years = {}
    @hackathons = {}
    @created_dates = {}
    @statement_string = ""


    @applications.each do |app|
      unless app.university.blank?
        @universities[app.university] ||= 0
        @universities[app.university] += 1
        if app.university[0,3] != "USA"
          @international += 1
        end

        @graduation_years[app.graduation_year] ||= 0
        @graduation_years[app.graduation_year] += 1
      end

      unless app.statement.blank?
        @statement_string += " " + app.statement
      end

      unless app.other_university.blank?
        @universities[:Other] += 1
        @graduation_years[app.graduation_year] ||= 0
        @graduation_years[app.graduation_year] += 1
      end

      unless app.major.blank?
        (1..app.major.count-1).each do |index|
          @majors[app.major[index]] ||= 0
          @majors[app.major[index]] += 1
        end
      end

      unless app.gender.blank?
        @genders[app.gender] ||= 0
        @genders[app.gender] += 1
      end

      if app.other_university.blank? && app.university.blank?
        @graduation_hs_years[app.graduation_year] ||= 0
        @graduation_hs_years[app.graduation_year] += 1
      end

      current_birthday = Time.zone.local(app.birth_year.to_i, app.birth_month.to_i, app.birth_day.to_i, 0, 0)
      applicant_age = determine_age(current_birthday, @event_date)
      applicant_age < 18 ? @minors += 1 : @adults +=1

      @ages[applicant_age] ||= 0
      @ages[applicant_age] += 1

      current_day = ( Time.parse(app.created_at) - 9*3600).strftime("%d-%b-%y")
      @created_dates[current_day] ||= 0
      @created_dates[current_day] += 1

      @hackathons[app.hackathons] ||= 0
      @hackathons[app.hackathons] += 1

    end

    random_count = 0
    @random_statements = []
    while random_count < 4
      random_i = rand(@applications.count - 1)
      unless @applications[random_i].statement.blank?
        @random_statements.push @applications[random_i].statement
        random_count += 1
      end
    end

    @universities = @universities.sort_by {|k,v| v}.reverse.to_h
    @ages = @ages.sort_by {|k,v| k}.to_h
    @genders = @genders.sort_by {|k,v| v}.to_h
    @majors = @majors.sort_by {|k,v| v}.reverse.to_h
    @graduation_years = @graduation_years.sort_by {|k,v| k}.to_h
    @graduation_hs_years = @graduation_hs_years.sort_by {|k,v| k}.to_h
    @hackathons = @hackathons.sort_by {|k,v| k}.to_h

    @common_words = most_common(@statement_string)
    @most_common_words.each do |word|
      @common_words.delete(word)
    end


    @common_words = @common_words.sort_by {|_key, value| value}.reverse
  end

  private

  def check_login
    if User.current_user.blank? || User.current_user.roles.exclude?("director")
      redirect_to '/dashboard'
    end
  end

  def faq_params
    params.permit(:id)
  end


  def determine_age(dob, diq)
    diq = diq.to_date
    diq.year - dob.year - ((diq.month > dob.month || (diq.month == dob.month && diq.day >= dob.day)) ? 0 : 1)
  end

  # Find most common words for word map
  def most_common(str)
    str.gsub(/./) do |c|
      case c
      when /\w/ then c.downcase
      when /\s/ then c
      else ''
      end
    end.split
    .group_by {|w| w}
    .map {|k,v| [k,v.size]}
    .sort_by(&:last)
    .reverse
    .to_h
  end


end
