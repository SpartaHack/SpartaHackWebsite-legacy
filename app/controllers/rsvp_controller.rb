class RsvpController < ::ApplicationController
  wrap_parameters :user, include: [:password, :password_confirmation]

  def new
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

end
