class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:subscribe, :rememberTheme]

  require 'json'
  require 'net/http'
  require 'pp'

  def index
    @faqs = Faq.all.to_a.sort_by {|obj| obj.priority}
    @faqs = @faqs.select { |faq| faq.display? }
    @faqs = @faqs.select { |faq| faq.placement == 'home' || faq.placement.downcase == 'both' }
    @sponsors = { :partner => [], :trainee => [], :warrior => [], :commander => [] }

    # get sponsors
    begin
      get_sponsors
    rescue
      p "Error getting Sponsors"
    end

  end


  def subscribe
    @button = "#D4B166"
    if subscribe_params[:emailinput] == ""
      @type = "error"
      @desc = "You cannot submit an empty form."
      @title = "Uh Oh!"
    elsif subscribe_params[:emailinput].downcase !~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      @type = "error"
      @desc = "You must include a valid email."
      @title = "Uh Oh!"
    else
      begin
        mailchimp = Mailchimp::API.new(ENV["MAILCHIMP_API_KEY"])
        mailchimp.lists.subscribe(ENV["MAILCHIMP_LIST_ID"],
        { "email" => subscribe_params['emailinput']})

        @type = "success"
        @desc = "Now you just need to confirm your email address!"
        @title = "Sweet!"
      rescue Exception
        @type = "error"
        @desc = "You've already signed up with this email."
        @title = "Uh Oh!"
      end
    end
  end

  def rememberTheme
    if remember_params[:theme] == 'dark'
      cookies.signed[:theme] = { value: "dark" }
    elsif remember_params[:theme] == 'light'
      cookies.signed[:theme] = { value: "light" }
    else
      cookies.signed[:theme] == "light" ? cookies.signed[:theme] = "dark" : cookies.signed[:theme] = "light"
    end
  end

  def change_sponsors
    @sponsors = { :partner => [], :trainee => [], :warrior => [], :commander => [] }
    get_sponsors
  end

  private
  def subscribe_params
    params.permit(:emailinput, :authenticity_token, :utf8)
  end

  def remember_params
    params.permit(:theme)
  end

  def get_sponsors
    url = URI.parse("#{ENV['API_SITE']}/sponsors")
    req = Net::HTTP::Get.new(url.to_s)
    req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")

    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true if url.scheme == 'https'
    res = res.start {|http|
      http.request(req)
    }

    unfiltered_sponsors =  JSON.parse(res.body)
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
end
