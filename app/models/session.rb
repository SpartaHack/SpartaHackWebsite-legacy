class Session < ActiveResource::Base
  self.site = "https://d.api.spartahack.com"
  self.headers["AUTHORIZATION"] = "Token token=\"#{ENV['AUTH_TOKEN']}\""
end
