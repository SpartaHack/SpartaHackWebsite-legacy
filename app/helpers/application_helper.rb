module ApplicationHelper
  def current_user
    if session[:current_session].present?
      begin
        user = User.find(session[:current_session])
        Rails.logger.debug "Current User #{user} "
        user
      rescue
        ActiveResource::Base.headers["AUTHORIZATION"] = "Token token=\"#{ENV['API_AUTH_TOKEN']}\""
        current_user
      end
    end
  end
end
