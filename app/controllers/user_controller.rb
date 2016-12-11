class UserController < ApplicationController
  def new
  end

  def show
  end

  def create
  end

  def dashboard
    check_login
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

      if @application.status.present? and @application.status.downcase == 'accepted'
        @decision = case @application.status.downcase
        when 'denied'   then "Not Admitted"
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

  def check_login
    if !User.current_user.present?
      redirect_to '/login'
    end
  end
end
