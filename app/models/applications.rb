class Applications < ActiveResource::Base
  self.site = "#{ENV['API_SITE']}"
  self.element_name = "application"
end
