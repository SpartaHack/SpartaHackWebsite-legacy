module ApplicationHelper
  def current_user
    if session[:current_session].present?
      begin
        ActiveResource::Base.headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
        User.find(session[:current_session])
      rescue
        redirect_to '/login' and return
      end
    end
  end
end
