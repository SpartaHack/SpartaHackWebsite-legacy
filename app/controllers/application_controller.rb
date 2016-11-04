class ApplicationController < ActionController::Base
  around_filter :set_current_user
  include ApplicationHelper

  protect_from_forgery with: :null_session, if: ->{request.format.json?}


  def set_current_user
    unless session[:current_session].blank?
      User.current_user = User.find(session[:current_session])
    end
    yield
    ensure
    # to address the thread variable leak issues in Puma/Thin webserver
    User.current_user = nil
  end
end
