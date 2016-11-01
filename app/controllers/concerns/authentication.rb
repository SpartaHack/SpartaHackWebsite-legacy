module Authentication

  def set_http_auth_token
    ActiveResource::Base.headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
    ActiveResource::Base.headers["Accept"] = "application/json"
  end

  # Create this method when needed
  def set_user_auth_token
    ActiveResource::Base.headers["AUTHORIZATION"] = "Token token=\"#{current_user.auth_token}\""
    ActiveResource::Base.headers["Accept"] = "application/json"
  end

end
