class SessionsController < ApplicationController

  # Sign in
  def new
    check_login
  end

  def create
    session_response = Session.create( { :email => session_params[:email], :password => session_params[:password] } )

    if session_response.errors.messages.empty?
      User.current_user = session_response
      session[:current_session] = User.current_user.id
      if User.current_user.roles.include? "director"
        redirect_to '/admin' and return
      else
        redirect_to '/dashboard' and return
      end
    else
      messages = []
      session_response.errors.each {|attr, msg| messages.push(attr.to_s.humanize + " " + msg)}
      Rails.logger.debug "Error on application creation: #{messages}"
      session[:current_session] = nil
      flash[:error] = session_response.errors.messages[:base][0]
      render :new
    end

  end

  def destroy
    User.current_user = nil
    session.delete(:current_session)

    redirect_to root_url
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end

  def check_login
    if User.current_user.present?
      if User.current_user.roles.include?("director")
        redirect_to '/admin'
      else
        redirect_to '/dashboard'
      end
    end
  end

end
