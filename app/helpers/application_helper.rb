module ApplicationHelper
  def current_user
    if session[:current_session].present?
      begin
        ActiveResource::Base.headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
        User.find(session[:current_session])
      rescue
        nil
      end
    end
  end
end
