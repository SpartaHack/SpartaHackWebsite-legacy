module Authentication

  def set_http_auth_token
    ActiveResource::Base.headers["AUTHORIZATION"] = "Token token=\"08f64132a108ddd9e7d167cd9c62c549\""
    ActiveResource::Base.headers["Accept"] = "application/json"
  end

  # Create this method when needed
  def set_user_auth_token
  end

end
