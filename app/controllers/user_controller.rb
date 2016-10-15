class UserController < ApplicationController
  def new
  end

  def create
    if User.new(user_params)
      redirect_to '/admin'
    end
  end

  def application
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
end
