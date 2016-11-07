class Faq < ActiveResource::Base
  cattr_accessor :static_headers

  self.static_headers = headers
  self.site = "#{ENV['API_SITE']}"

  def self.headers
    new_headers = static_headers.clone
    new_headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
    new_headers["Accept"] = "application/json"
    unless User.current_user.blank?
      new_headers["X-WWW-User-Token"] = User.current_user.auth_token
    end
    new_headers
  end

  schema do
    string :question, :answer
  end
end
