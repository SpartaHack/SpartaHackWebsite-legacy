class SessionsController < ApplicationController
  # Sign in
  def new

  end

  def create
    session[:current_session] = Session.create( {:session => { :email => session_params[:email], :password => session_params[:password] } } )
    redirect_to root_url

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
