class HomeController < ApplicationController
  include ApplicationHelper
  require 'json'

  def subscribe
    if subscribe_params[:emailinput] == "" && subscribe_params[:fname] == "" && subscribe_params[:lname] == ""
      flash[:error] = "You cannot submit an empty form."
      redirect_to "/#notify-email" and return
    elsif subscribe_params[:emailinput] == ""
      flash[:error] = "You must include your email."
      redirect_to "/#notify-email" and return
    elsif subscribe_params[:emailinput].downcase !~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      flash[:error] = "You must include a valid email."
      redirect_to "/#notify-email" and return
    else
      begin
      	mailchimp = Mailchimp::API.new(ENV["MAILCHIMP_API_KEY"])
    		mailchimp.lists.subscribe(ENV["MAILCHIMP_LIST_ID"],
    		                   { "email" => subscribe_params['emailinput']})

      	@type = "success"
      	@desc = "Now you just need to confirm your email address!"
      	@title = "Sweet!"
        @button = "#D4B166"
      rescue Exception => e
      	p e
      	puts
      	@type = "error"
      	@desc = "You've already signed up with this email."
      	@title = "Uh Oh!"
        @button = "#D4B166"
      end
    end
	end

  def index
    @past_sponsors = Dir.glob("app/assets/images/pastSponsors/*")
    p @past_sponsors
  end

  private
    def subscribe_params
      params.permit(:emailinput, :authenticity_token, :utf8)
    end
end
