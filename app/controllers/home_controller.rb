class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:subscribe, :rememberTheme]

  require 'json'
  require 'net/http'

  def index
    @faqs = Faq.all.to_a.sort_by {|obj| obj.priority}
    @faqs = @faqs.select { |faq| faq.display? }

    # get sponsors
    url = URI.parse('http://localhost:3001/sponsors')
    req = Net::HTTP::Get.new(url.to_s)
    req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.use_ssl = ENV['API_SSL_ON'] == "true" ? true : false
      http.request(req)
    }

    unfiltered_sponsors =  JSON.parse(res.body)

    @sponsors = { :partner => [], :trainee => [], :warrior => [], :commander => [] }
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
    elsif remember_params[:theme] == { value: 'light' }
      cookies.signed[:theme] = { value: "light" }
    else
      cookies.delete :theme
    end
  end

  private
  def subscribe_params
    params.permit(:emailinput, :authenticity_token, :utf8)
  end

  def remember_params
    params.permit(:theme)
  end
end
