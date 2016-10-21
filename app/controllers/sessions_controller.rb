class SessionsController < ApplicationController
  before_action :set_http_auth_token, only: [:create, :destroy]
  # Sign in
  def new

  end

  def create
    session_response = Session.create( { :email => session_params[:email], :password => session_params[:password] } )
    if session_response.errors.messages.empty?
      session[:current_session] = session_response
      redirect_to root_url
    else
      p session_response.errors.messages
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
end
