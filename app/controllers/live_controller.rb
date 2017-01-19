class LiveController < ApplicationController
  require 'json'
  require 'net/http'
  require 'open-uri'
  require 'pp'

  def index
    unless File.exist?("app/assets/pdfs/SpartaHack-Map.pdf")
      open('app/assets/pdfs/SpartaHack-Map.pdf', 'wb') do |file|
        file << open('https://d.api.spartahack.com/map').read
      end
    end

    unless File.exist?("app/assets/pdfs/SpartaHack-Map-Dark.pdf")
      open('app/assets/pdfs/SpartaHack-Map-Dark.pdf', 'wb') do |file|
        file << open('https://d.api.spartahack.com/map/dark').read
      end
    end

    begin
      get_announcements()
    rescue => e
      pp e
    end

    begin
      @prizes_array = []
      prizes = JSON.parse(query_api('prizes').body)
      prizes.sort_by! { |h| h['name']}.reverse

      prizes.each do |prize|
        @prizes_array.push([prize["name"], prize["description"], !prize["sponsor"].nil? ? prize["sponsor"] : "SpartaHack"])
      end

      if cookies.signed[:theme] && cookies.signed[:theme] == 'dark'
        @theme = "logo_svg_dark"
        @theme_alt = "logo_svg_light"
      else
        @theme = "logo_svg_light"
        @theme_alt = "logo_svg_dark"
      end
    rescue => e
      pp e
    end

    begin
      @faq_array = []
      faqs = Faq.all.to_a.sort_by {|obj| obj.priority}
      faqs.each do |f|
        @faq_array.push([f.question, f.answer])
      end
    rescue => e
      pp e
    end


    begin
      @schedule = [
        ["Friday",[ ] ],
        ["Saturday",[ ] ],
        ["Sunday",[ ] ]
      ]

      schedule = JSON.parse(query_api('schedule').body)
      schedule.each do |s|
        day = s["time"].in_time_zone("Eastern Time (US & Canada)").strftime("%e")
        time = s["time"].in_time_zone("Eastern Time (US & Canada)").strftime("%H:%M")
        if day.to_i == 20
          @schedule[0][1].push([time,s["title"],s["description"],s["location"]])
        elsif day.to_i == 21
          @schedule[1][1].push([time,s["title"],s["description"],s["location"]])
        else
          @schedule[2][1].push([time,s["title"],s["description"],s["location"]])
        end
      end

      @schedule[0][1]= @schedule[0][1].sort do |a,b| a[0] <=> b[0] end
      @schedule[1][1]= @schedule[1][1].sort do |a,b| a[0] <=> b[0] end
      @schedule[2][1]= @schedule[2][1].sort do |a,b| a[0] <=> b[0] end

    rescue => e
      pp e
    end

    begin
      @hardware_array = []
      hardware = JSON.parse(query_api('hardware').body)

      hardware.each do |item|
        @hardware_array.push([item['item'],
          item['quantity'].blank? ? "See desk" : item['quantity'],
        item['lender'].blank? || item['lender'] == "SpartaHack" ? "SpartaHack" : item['lender']])
      end

    rescue => e
      pp e
    end

    begin
      @resources_array = []
      resources = JSON.parse(query_api('resources').body)

      resources.each do |resource|
        @resources_array.push([resource['name'], resource["url"], resource["sponsor"].blank? ? "SpartaHack" : resource["sponsor"]])
      end

      pp resources_array
    rescue => e
      pp e
    end

  end

  def push
    begin
      get_announcements()
      render json: { title: @announcements_array[0][0], description: @announcements_array[0][1], time: @announcements_array[0][2]}, status: 200
    rescue
    end
  end

  def subscribe
    unless session[:installation_updated].blank?
      return
    end
    token_array = subscribe_params[:token].split '/'

    url = URI.parse("#{ENV['API_SITE']}/installations")
    req = Net::HTTP::Post.new(url.to_s)
    req.set_form_data({"installation[device_type]" => "android", "installation[token]" => "#{token_array[-1]}" })
    req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")
    if User.current_user.present?
      req.add_field("X-WWW-USER-TOKEN", "#{User.current_user.auth_token}")
    end

    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true if url.scheme == 'https'
    res = res.start {|http|
      http.request(req)
    }
    resp = JSON.parse(res.body)
    pp resp


    if resp["id"].present?
      session[:installation_id] = resp["id"]
    end

    if resp["errors"].present? and resp["errors"]["token"] and User.current_user.present? and session[:installation_id].present?
      url = URI.parse("#{ENV['API_SITE']}/installations/#{session[:installation_id]}")
      req = Net::HTTP::Put.new(url.to_s)
      req.set_form_data({"installation[device_type]" => "android", "installation[token]" => "#{token_array[-1]}" })
      req.add_field("X-WWW-USER-TOKEN", "#{User.current_user.auth_token}")

      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true if url.scheme == 'https'
      res = res.start {|http|
        http.request(req)
      }
      resp = JSON.parse(res.body)

      session[:installation_updated] = true
    end
  end

  def unsubscribe
    url = URI.parse("#{ENV['API_SITE']}/installations/#{session[:installation_id]}")
    req = Net::HTTP::Delete.new(url.to_s)
    req.add_field("X-WWW-USER-TOKEN", "#{User.current_user.auth_token}")

    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true if url.scheme == 'https'
    res = res.start {|http|
      http.request(req)
    }

    session[:installation_updated] = nil
    session[:installation_id] = nil
  end

  private

  def subscribe_params
    params.permit(:token)
  end

  def query_api(endpoint)
    url = URI.parse("#{ENV['API_SITE']}/#{endpoint}")
    req = Net::HTTP::Get.new(url.to_s)
    req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")

    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true if url.scheme == 'https'
    res = res.start {|http|
      http.request(req)
    }

  end

  def get_sponsors
    @sponsors = { :partner => [], :trainee => [], :warrior => [], :commander => [] }
    unfiltered_sponsors =  JSON.parse(query_api('sponsors').body)
    unfiltered_sponsors.each do |sponsor|
      if sponsor["level"].downcase == "commander"
        @sponsors[:commander].push sponsor
      elsif sponsor["level"].downcase == "warrior"
        @sponsors[:warrior].push sponsor
      elsif sponsor["level"].downcase == "trainee"
        @sponsors[:trainee].push sponsor
      else
        @sponsors[:partner].push sponsor
      end

    end

    @sponsors.each do |key, value|
      @sponsors[key] = @sponsors[key].sort_by { |k| k['name'] }
    end

    if cookies.signed[:theme] && cookies.signed[:theme] == 'dark'
      @theme = "logo_svg_dark"
      @theme_alt = "logo_svg_light"
    else
      @theme = "logo_svg_light"
      @theme_alt = "logo_svg_dark"
    end
  end

  def get_announcements
    @announcements_array = []
    announcements = JSON.parse(query_api('announcements').body)
    announcements.sort_by! { |h| h['created_at']}

    announcements.each do |a|
      string_array = a["description"].split(" ")
      announcement_string = ""

      string_array.each do |word|
        if word.include? "http"
          announcement_string += " <a href='#{word}' target='_blank'>#{word}</a>"
        else
          announcement_string += " #{word}"
        end
      end

      time = ( ( Time.now - DateTime.parse(a['created_at']) ) / ( 60 * 60) ).to_i
      time_string = ""

      if time < 1
        time = ( ( Time.now - DateTime.parse(a['created_at']) ) / 60 ).to_i
        if time > 1
          time_string = "#{time} minutes ago"
        elsif time == 1
          time_string = "1 minute ago"
        else
          time_string = "#{( ( Time.now - DateTime.parse(a['created_at']) ) ).to_i} seconds ago"
        end
      else
        if time > 1
          time_string = "#{time} hours ago"
        else
          time_string = "1 hour ago"
        end
      end

      time = "#{} hours ago"
      @announcements_array.push([a['title'], announcement_string.strip, time_string])
    end
    @announcements_array.reverse!
  end

end
