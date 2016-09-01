class User < ActiveResource::Base
  self.headers["AUTHORIZATION"] = "Token token=\"#{ENV['AUTH_TOKEN']}\""
  self.site = "http://api.spartahack-api.dev/"
end
