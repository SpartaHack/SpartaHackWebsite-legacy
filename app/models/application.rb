class Application < ActiveResource::Base
  self.site = "#{ENV['API_SITE']}"
  self.element_name = "application"

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
