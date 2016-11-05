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
