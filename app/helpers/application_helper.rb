module ApplicationHelper
  def current_user
    if session[:current_session].present?
      begin
        User.find(session[:current_session])
      rescue
        ActiveResource::Base.headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
        current_user
      end
    end
  end
end
