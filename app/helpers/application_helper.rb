module ApplicationHelper
  def current_user
    if session[:current_session].present?
      User.find(session[:current_session])
    end
  end
end
