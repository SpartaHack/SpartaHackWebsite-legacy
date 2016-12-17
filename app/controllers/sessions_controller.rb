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

  def forgot_password
  end

  def send_password_email
    unless session_params[:email].present?
      flash[:error] = "Email is required"
      render :forgot_password and return
    end

    begin
      url = URI.parse("#{ENV['API_SITE']}/users/request_password_token")
      req = Net::HTTP::Post.new(url.to_s)
      req.set_form_data({'email' => session_params[:email]}, ';')
      req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")

      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true if url.scheme == 'https'
      res = res.start {|http|
        http.request(req)
      }

      user =  JSON.parse(res.body)
      unless user['errors'].blank?
        flash[:error] = "No account with email: <strong>#{session_params[:email]}</strong>".html_safe
        render :forgot_password and return
      end

      UserMailer.reset_password_email(
        user['first_name'], user['email'], user['reset_password_token']
      ).deliver_now

      flash[:error] = "Reset link sent to <strong>#{session_params[:email]}</strong>".html_safe
    rescue => e
      p e
      flash[:error] = "Error getting Reset Token"
    end

    render :forgot_password and return
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
