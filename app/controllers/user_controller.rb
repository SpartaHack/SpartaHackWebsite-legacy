require 'net/http'
require 'net/https'

class UserController < ApplicationController
  before_action :set_http_auth_token, :except => [:destroy]

  def new
  end

  def show
  end

  def create
    if User.new(user_params)
      redirect_to '/admin'
    end
  end

  def dashboard
    check_login
  end

  def edit
  end

  def update
  end

  def destroy
    set_http_auth_token
    @user = current_user
    delete_u(@user, { id: @user.id })
    redirect_to '/logout'
  end

  def delete_u(u, id_hash)
    uri = URI.parse("#{ENV['API_SITE']}/users/#{u.id}.json")
    # uri.query = URI.encode_www_form(id_hash)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Delete.new(uri.request_uri)
    request['Authorization'] =  u.auth_token
    http.request(request).body
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, roles: [])
  end

  def check_login
    if !current_user.present?
      redirect_to '/login'
    end
  end
end
