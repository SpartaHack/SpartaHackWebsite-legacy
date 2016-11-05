class Batch < ActiveResource::Base
  cattr_accessor :static_headers

  self.static_headers = headers
  self.site = "#{ENV['API_SITE']}"
  self.element_name = "batch"
  self.collection_name = "batch"
  self.include_format_in_path = false

  def self.headers
    new_headers = static_headers.clone
    new_headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
    new_headers["Accept"] = "application/json"
    new_headers["X-WWW-User-Token"] = User.current_user.auth_token
    new_headers
  end
end
