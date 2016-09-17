module ApplicationHelper
  def current_user
    if session[:current_session].present?
      require 'ostruct'
      OpenStruct.new(session[:current_session])
    else
      nil
    end
  end
end
