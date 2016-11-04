class Application < ActiveResource::Base
  cattr_accessor :static_headers

  self.static_headers = headers
  self.site = "#{ENV['API_SITE']}"
  self.element_name = "application"

  def self.headers
    new_headers = static_headers.clone
    new_headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
    new_headers["Accept"] = "application/json"
    new_headers["X-WWW-User-Token"] = User.current_user.auth_token
    new_headers
  end

  schema do

    integer :birth_day, :birth_month, :birth_year, :graduation_year, :hackathons

    string :github, :linkedin, :website, :devpost, :other_link, :gender,
    :education, :university, :other_university, :travel_origin,
    :graduation_season, :outside_north_america

    # unsupported types should be left as strings
    # overload the accessor methods if you need to convert them
    string :statement, :race, :major
  end
end
