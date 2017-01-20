class AdminController < ApplicationController
  before_action :check_login
  require "pp"

  def dashboard
    @user = User.current_user
  end

  def dashboard_stats
    users = User.all
    app_total = 0
    accepted = 0
    denied = 0
    waitlisted = 0
    rsvp_total = 0
    rsvp_yes = 0
    rsvp_no = 0
    users.each do |user|
      if user.application.present?
        app_total += 1
        if user.application.status.present?
          case user.application.status.downcase
          when 'accepted' then accepted +=1
          when 'denied' then denied +=1
          when 'waitlisted' then waitlisted +=1
          end
        end
      end

      if user.rsvp.present?
        rsvp_total += 1
        case user.rsvp.attending.downcase
        when 'yes' then rsvp_yes +=1
        when 'no' then rsvp_no +=1
        end
      end
    end

    @total = [users.count, app_total, accepted, waitlisted, denied, rsvp_total, rsvp_yes, rsvp_no]
  end

  def notifications
    if !notification_params[:description].blank? && !notification_params[:title].blank?
      pp "-------------------"
      pp JSON.parse(announce.body)
    end
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

  def onsite_registration
    unless params["email_check"].blank? || session[:has_forms]
      @user = find_user(params["email_check"])
      if @user.present?
        @has_rsvp = @user.rsvp.present?
        @has_application = @user.application.present?
        if @has_rsvp && @has_application
          check_in_res = check_in_user(@user.id)
          if !@user.checked_in && check_in_res["errors"].blank?
            flash[:notice] = "#{@user.first_name.capitalize} has been checked in successfully!"
            redirect_to(:back) && return
          else
            if check_in_res["errors"] == {"user" => ["is a minor"]} && params[:commit] == "Check Email"
              flash[:notice] = "#{@user.first_name.capitalize} is a minor"
              @minor = true
            elsif params[:commit] == "Has Forms"
              if check_in_user(@user.id, true)
                flash[:notice] = "#{@user.first_name.capitalize} has been checked in successfully!"
                session[:has_forms] = true
                redirect_to(:back) && return
              else
                flash[:notice] = "#{@user.first_name.capitalize} has been not been checked in, an error occurred."
                session[:has_forms] = true
                redirect_to(:back) && return
              end
            elsif params[:commit] == "Does Not Have Forms"
              flash[:notice] = "#{@user.first_name.capitalize} cannot be checked in without forms"
              session[:has_forms] = true
              redirect_to(:back) && return
            else
              flash[:notice] = "#{@user.first_name.capitalize} has already been checked in"
              @has_application = false
            end
          end
        elsif @has_application && (!@has_rsvp || @user.rsvp.attending == "No")
          @user.application.status = "didn't rsvp"
          @rsvp = Rsvp.new(user: @user, attending: "Yes")
        end
      else
        #create an application
        @user = User.new(email: params["email_check"])
        @application = Application.new
        @create_user = true
        @has_rsvp = false
        @has_application = false
      end
    end
    if session[:has_forms]
      session[:has_forms] = nil
    end
    if params["rsvp"].present?
      @user = find_user(params["email"])
      set_temp_user(@user.id)
      @rsvp = Rsvp.new(params[:rsvp])
      @rsvp.onsite = true
      @rsvp.user_id = @user.id
      @rsvp.carpool_sharing = 'No'
      if @rsvp.save
        if check_in_user(@user.id)
          flash[:notice] = "#{@user.first_name.capitalize} has been checked in successfully!"
          redirect_to redirect_to(:back) && return
        else
          #user did not check in correctly
        end
      end
    elsif params["application"].present?
      @user = User.new(params[:user])
      if @user.save
        set_temp_user(@user.id)
        @application = Application.new(params[:application])
        if @application.save
          flash[:notice] = "#{@user.first_name.capitalize} now has an account! Click anywhere to continue filling out the registration."
          set_temp_user("")
          redirect_to redirect_to(:back) && return
        else
          #application was not created
        end
      else
        # user was not created
      end
    end
  end

  def sponsorship
    # Used to populate Edit Sponsors section.
    @sponsors = { :partner => [], :trainee => [], :warrior => [], :commander => [] }

    begin
      # get sponsors
      url = URI.parse("#{ENV['API_SITE']}/sponsors")
      req = Net::HTTP::Get.new(url.to_s)
      req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")

      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true if url.scheme == 'https'
      res = res.start {|http|
        http.request(req)
      }

      companies =  JSON.parse(res.body)
      companies.each do |c|
        sponsor = [c["id"].to_i, c["name"]]
        if c["level"].downcase == "commander"
          @sponsors[:commander].push sponsor
        elsif c["level"].downcase == "warrior"
          @sponsors[:warrior].push sponsor
        elsif c["level"].downcase == "trainee"
          @sponsors[:trainee].push sponsor
        else
          @sponsors[:partner].push sponsor
        end
      end

      @sponsors.each do |key, value|
        @sponsors[key] = @sponsors[key].sort_by { |k| k[1] }
      end
    rescue
      p "Error getting Sponsors"
    end
  end

  def sponsorship_view
    unless sponsorship_params[:id].present?
      redirect_to "/admin/sponsorship" and return
    end

    begin
      # get sponsors
      url = URI.parse("#{ENV['API_SITE']}/sponsors/#{sponsorship_params[:id]}")
      req = Net::HTTP::Get.new(url.to_s)
      req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")

      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true if url.scheme == 'https'
      res = res.start {|http|
        http.request(req)
      }
      @company =  JSON.parse(res.body)
    rescue
      p "Error getting Sponsors"
      redirect_to "/admin/sponsorship" and return
    end
  end

  def statistics
    @event_date = Date.new(2017, 1, 20)
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

    @users = User.all
    @users = @users.sort do |a,b|
      DateTime.parse(a.created_at) <=> DateTime.parse(b.created_at)
    end
    @applications = []

    @apps_accepted_total = 0
    @universities = {:Other => 0}
    @international = 0
    @traveling = {}
    @traveling_international = 0
    @majors = {}
    @races = {}
    @genders = {}
    @ages = {}
    @minors = 0
    @adults = 0
    @graduation_years = {}
    @graduation_hs_years = {}
    @hackathons = {}
    @created_dates = {}
    @statement_string = ""

    @rsvpd_applications = []
    @rsvp_attending_count = 0
    @rsvps_total = 0
    @rsvp_minors = 0
    @rsvp_adults = 0
    @rsvp_international = 0
    @dietary_restrictions = {}
    @rsvp_genders = {}
    @rsvp_ages = {}
    @rsvp_universities = {}
    @rsvp_graduation_years = {}
    @rsvp_majors = {}

    @users.each do |user|
      unless user.application.blank?
        @applications.push(user.application)
        application_stats(user.application)
      end

      unless user.rsvp.blank?
        rsvp_stats(user.rsvp, user.application)
      end
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
    @traveling = @traveling.sort_by {|k,v| v}.reverse.to_h
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

  def notification_params
    params.require(:announcement).permit(:title, :description, :pinned)
  end

  def sponsorship_params
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

  def find_user(email)
    begin
      User.find(:first, :params => {:email => email})
    rescue
      nil
    end
  end

  def application_stats(app)
    unless app.status.blank?
      if app.status == "accepted"
        @apps_accepted_total += 1
      end
    end

    unless app.university.blank?
      @universities[app.university] ||= 0
      @universities[app.university] += 1
      if app.university[0,3] != "USA"
        @international += 1
      end

      @graduation_years[app.graduation_year] ||= 0
      @graduation_years[app.graduation_year] += 1
    end

    unless app.travel_origin.blank?
      @traveling[app.travel_origin] ||= 0
      @traveling[app.travel_origin] += 1
      if app.travel_origin[0,3] != "USA"
        @traveling_international += 1
      end
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

    unless app.race.blank?
      if app.race.length > 2
        @races["Multiracial"] ||= 0
        @races["Multiracial"] += 1
      else
        (1..app.race.count-1).each do |index|
          @races[app.race[index]] ||= 0
          @races[app.race[index]] += 1
        end
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

  def rsvp_stats(rsvp, app)
    @rsvps_total += 1
    if rsvp.attending == "Yes"
      @rsvp_attending_count += 1
      rsvp.user = @users.find {|i| i.id == rsvp.user}
      @rsvpd_applications.append(rsvp.user.application)
    end

    rsvp.dietary_restrictions = JSON.parse(rsvp.dietary_restrictions)
    unless rsvp.dietary_restrictions.blank? && rsvp.dietary_restrictions.count > 1
      (1..rsvp.dietary_restrictions.count-1).each do |index|
        @dietary_restrictions[rsvp.dietary_restrictions[index]] ||= 0
        @dietary_restrictions[rsvp.dietary_restrictions[index]] += 1
      end
    end

    pp app
    unless app.gender.blank?
      @rsvp_genders[app.gender] ||= 0
      @rsvp_genders[app.gender] += 1
    end

    current_birthday = Time.zone.local(app.birth_year.to_i, app.birth_month.to_i, app.birth_day.to_i, 0, 0)
    applicant_age = determine_age(current_birthday, @event_date)
    applicant_age < 18 ? @rsvp_minors += 1 : @rsvp_adults +=1

    @rsvp_ages[applicant_age] ||= 0
    @rsvp_ages[applicant_age] += 1

    unless app.university.blank?
      @rsvp_universities[app.university] ||= 0
      @rsvp_universities[app.university] += 1
      if app.university[0,3] != "USA"
        @rsvp_international += 1
      end

      @rsvp_graduation_years[app.graduation_year] ||= 0
      @rsvp_graduation_years[app.graduation_year] += 1
    end

    unless app.major.blank?
      (1..app.major.count-1).each do |index|
        @rsvp_majors[app.major[index]] ||= 0
        @rsvp_majors[app.major[index]] += 1
      end
    end
  end

  def check_in_user(id, is_minor = false)
    uri = URI.parse("#{ENV['API_SITE']}/checkin")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'

    request = Net::HTTP::Post.new(uri.request_uri)
    is_minor ? request.set_form_data({"id" => id, "forms" => 1}) : request.set_form_data({"id" => id})
    request["X-WWW-USER-TOKEN"] = "#{current_user.auth_token}"

    http = http.start {|h|
      h.request(request)
    }
    JSON.parse(http.body)
  end

  def announce
    url = URI.parse("#{ENV['API_SITE']}/announcements")
    req = Net::HTTP::Post.new(url.to_s)
    req.set_form_data({"announcement[pinned]" => notification_params[:pinned].blank? ? "false" : notification_params[:pinned],
      "announcement[description]" => notification_params[:description],
    "announcement[title]" => notification_params[:title] })
    req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")
    req.add_field("X-WWW-USER-TOKEN", "#{User.current_user.auth_token}")

    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true if url.scheme == 'https'
    res = res.start {|http|
      http.request(req)
    }

  end


end
