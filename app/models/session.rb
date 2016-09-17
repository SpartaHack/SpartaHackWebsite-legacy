class Session < ActiveResource::Base
  # self.headers["AUTHORIZATION"] = "Token token=\"#{ENV['AUTH_TOKEN']}\""
  self.site = "d.api.spartahack.com"
end
