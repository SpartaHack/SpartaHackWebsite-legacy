class Session < ActiveResource::Base
  self.site = "#{ENV['API_SITE']}"
end
