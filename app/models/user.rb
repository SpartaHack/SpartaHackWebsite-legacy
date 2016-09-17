class User < ActiveResource::Base
  self.headers["AUTHORIZATION"] = "Token token=\"#{ENV['AUTH_TOKEN']}\""
  self.site = "http://localhost:3001"
end
