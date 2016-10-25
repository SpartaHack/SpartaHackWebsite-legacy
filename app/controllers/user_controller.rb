class UserController < ApplicationController
  before_action :set_http_auth_token

  def new
  end

  def show
  end

  def create
    if User.new(user_params)
      redirect_to '/admin'
    end
  end

  def application
  end

  def dashboard
    check_login
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, roles: [])
    end

    def check_login
      if !current_user.present?
        redirect_to '/login'
      end
    end
end
