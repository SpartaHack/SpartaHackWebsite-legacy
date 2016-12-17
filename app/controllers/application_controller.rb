class ApplicationController < ActionController::Base
  around_filter :set_current_user
  before_filter :mailer_set_url_options
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

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host
    ActionMailer::Base.default_url_options[:protocol] = "#{request.ssl? ? 'https://' : 'httpx://'}"
  end
end
