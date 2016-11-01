class SessionsController < ApplicationController
  before_action :set_http_auth_token, only: [:create, :destroy]
  skip_before_filter :verify_authenticity_token

  # Sign in
  def new
    check_login
  end

  def create
    session[:current_session] = Session.create( { :email => session_params[:email], :password => session_params[:password] } )

    if session[:current_session].errors.messages.empty?
      redirect_to '/dashboard'
    else
      p session_response.errors.messages
      session[:current_session] = nil
      flash[:error] = session_response.errors.messages[:base][0]
      render :new
    end

  end

  def destroy
    session.delete(:current_session)
    redirect_to root_url
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end

  def check_login
    if current_user.present?
      redirect_to '/dashboard'
    end
  end

end
