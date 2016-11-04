class User < ActiveResource::Base
  self.headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
  self.site = "#{ENV['API_SITE']}"
  self.element_name = "user"

  schema do
    string :first_name, :last_name, :email, :password, :password_confirmation
  end
end
