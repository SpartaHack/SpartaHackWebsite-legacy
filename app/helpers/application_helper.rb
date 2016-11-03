module ApplicationHelper
  def current_user
    if session[:current_session].present?
      begin
        User.find(session[:current_session])
      rescue
        redirect_to '/login'
      end
    end
  end
end
