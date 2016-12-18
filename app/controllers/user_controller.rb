class UserController < ApplicationController
  def new
  end

  def show
  end

  def create
  end

  def dashboard
    check_login ? nil : (redirect_to '/login' and return)

    begin
      @batch = Batch.find(:first, :params => {:id => User.current_user.id})
      @batch.hackers.delete("#{User.current_user.first_name.capitalize} #{User.current_user.last_name.capitalize}")
    rescue
      @batch = nil
    end

    user = User.current_user
    # In the event a user is created but no application exists for them.
    if !user.application.blank?
      hash = user.application.instance_variables.each_with_object({}) { |var, hash|
        hash[var.to_s.delete("@")] = user.application.instance_variable_get(var)
      }
      @application = Application.new(hash['attributes'])

      if @application.status.present?
        @decision = case @application.status.downcase
        when 'denied'   then "Not admitted, we encourage you to apply again next year."
        when 'accepted'   then "You've been accepted! Congrats :)"
        when 'waitlisted' then "You've been waitlisted, check back soon."
        else                   nil
        end
      end
    end

    if !user.rsvp.blank?
      hash = user.rsvp.instance_variables.each_with_object({}) { |var, hash|
        hash[var.to_s.delete("@")] = user.rsvp.instance_variable_get(var)
      }
      @rsvp = Rsvp.new(hash['attributes'])
    end


  end

  def change_password
    check_login ? nil : (redirect_to '/login' and return)

  end

  def change_password_post
    begin
      url = URI.parse("#{ENV['API_SITE']}/users/change_password")
      req = Net::HTTP::Post.new(url.to_s)
      req.form_data = {
        'current_password' => password_params[:current_password],
        'password' => password_params[:password],
        'password_confirmation' => password_params[:password_confirmation]
      }
      req.add_field("X-WWW-User-Token", User.current_user.auth_token)

      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true if url.scheme == 'https'
      res = res.start {|http|
        http.request(req)
      }

      user =  JSON.parse(res.body)
      p user
      unless user['errors'].blank?
        key, value = user['errors'].first
        key = key_string(key)
        flash[:error] = "#{key}#{value[0]}."
        render :change_password and return
      end

    rescue
    end

    User.current_user = nil
    session.delete(:current_session)
    flash[:error] = "Password Successfully Changed"
    redirect_to '/login' and return
  end

  def reset_password
    unless !check_login and params["t"].present?
      redirect_to '/login' and return
    end
  end

  def reset_password_post
    begin
      url = URI.parse("#{ENV['API_SITE']}/users/reset_password")
      req = Net::HTTP::Post.new(url.to_s)
      req.form_data = {'password' => password_params[:password], 'password_confirmation' => password_params[:password_confirmation] }
      req.add_field("X-WWW-RESET-PASSWORD-TOKEN", password_params[:token])

      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true if url.scheme == 'https'
      res = res.start {|http|
        http.request(req)
      }

      user =  JSON.parse(res.body)
      unless user['errors'].blank?
        key, value = user['errors'].first
        key = key_string(key)
        flash[:error] = "#{key}#{value[0]}. Please request a new link."
        redirect_to '/login' and return
      end

    rescue
    end

    flash[:error] = "Password Successfully Reset"
    redirect_to '/login' and return
  end

  def edit
  end

  def update
  end

  def destroy
    @user = User.current_user
    @user.destroy

    # Terminates user from Thread and session
    User.current_user = nil
    session.delete(:current_session)

    redirect_to '/'
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, roles: [])
  end

  def password_params
    params.permit(:token, :current_password, :password, :password_confirmation)
  end

  def check_login
    User.current_user.present?
  end

  def key_string(key)
    key_array = key.split('_')
    key = ""
    key_array.each do |k|
      key += k.capitalize + " "
    end

    key
  end
end
