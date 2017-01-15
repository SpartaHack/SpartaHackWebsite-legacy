class User < ActiveResource::Base
  cattr_accessor :static_headers

  self.static_headers = headers
  self.site = "#{ENV['API_SITE']}"
  self.element_name = "user"

  schema do
    string :first_name, :last_name, :email, :password, :password_confirmation
    boolean :checked_in
  end

  def self.headers
    new_headers = static_headers.clone
    new_headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
    new_headers["Accept"] = "application/json"
    unless User.current_user.blank?
      new_headers["X-WWW-User-Token"] = User.current_user.auth_token
    end
    new_headers
  end

  def self.current_user
    Thread.current[:current_user]
  end

  def self.current_user=(usr)
    Thread.current[:current_user] = usr
  end

  def self.temp_user
    Thread.current[:temp_user]
  end

  def self.temp_user=(usr)
    Thread.current[:temp_user] = usr
  end
end
