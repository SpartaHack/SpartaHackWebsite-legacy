class Rsvp < ActiveResource::Base
  cattr_accessor :static_headers

  self.static_headers = headers
  self.site = "#{ENV['API_SITE']}"
  self.element_name = "rsvp"

  def self.headers
    new_headers = static_headers.clone
    new_headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
    new_headers["Accept"] = "rsvp/json"
    new_headers["X-WWW-User-Token"] = User.temp_user.auth_token
    new_headers
  end

  schema do

    string :attending, :dietary_restrictions, :other_dietary_restrictions, :resume, :shirt_size, :carpool_sharing, :jobs
  end

end
