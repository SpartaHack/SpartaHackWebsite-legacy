class RsvpController < ::ApplicationController

  def new
    check_login

    if !User.current_user.rsvp.blank?
      redirect_to '/dashboard' and return
    end


    if flash[:app_params]
      @rsvp = Rsvp.new(flash[:app_params])
    else
      @rsvp = Rsvp.new(user: current_user)
    end
  end

  def create
    debugger
  end

  def edit

  end

  private

  def check_login
    unless User.current_user.present?
      redirect_to '/login' and return
    end
  end

end
