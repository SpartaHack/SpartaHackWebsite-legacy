class AppController < ApplicationController
  def new

  end

  def create
    if App.new(app_params)
      User.create(
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )
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
end
