module ApplicationHelper
  def current_user
    if session[:current_session].present?
      User.find(session[:current_session]['id'])
    else
      nil
    end
  end
end
