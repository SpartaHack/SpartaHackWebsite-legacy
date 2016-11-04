class Session < ActiveResource::Base
  self.headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
  self.headers["Accept"] = "application/json"
  self.site = "#{ENV['API_SITE']}"
end
