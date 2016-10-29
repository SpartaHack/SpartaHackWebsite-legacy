class ApplicationsController < ApplicationController
  before_action :set_http_auth_token, only: [:create]
  wrap_parameters :user, include: [:password, :password_confirmation]

  def new
  end

  def create
    user = User.create({ :user => {
      first_name: user_params[:first_name],
      last_name: user_params[:last_name],
      email: user_params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      roles: ["hacker"]
    }})

    if user.errors.messages.empty?
      if Applications.new(app_params)
        debugger
      end
    else
      p user.errors.messages
      # flash[:error] = user.errors.messages[:base][0]
      # render :new
    end
  end

  private
    def app_params
      params.permit(
        :gender,
        :birth_day,
        :birth_month,
        :birth_year,
        :education,
        :university,
        :other_university,
        :travel_origin,
        :graduation_season,
        :graduation_year,
        :major,
        :hackathons,
        :github,
        :linkedin,
        :website,
        :devpost,
        :other_link,
        :statement
      )
    end

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation
      )
    end
end
