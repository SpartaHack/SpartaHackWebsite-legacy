module ApplicationHelper
  def current_user
    if session[:current_session].present?
      id = (session[:current_session].class == Hash ? session[:current_session]['id'] : session[:current_session].id)
      User.find(id)
    end
  end
end
