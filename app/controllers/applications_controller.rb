class ApplicationsController < ::ApplicationController
  wrap_parameters :user, include: [:password, :password_confirmation]
  before_action :set_http_auth_token, only: [:create]
  before_action :set_user_auth_token, only: [:create_application]


  def new
    @application = Application.new
    p @application
  end

  def create
    user = User.new(user_params.to_h)
    if user.save
      session[:current_session] = Session.create( { :email => user_params[:email], :password => user_params[:password] } )
      create_application
    else
      p user.errors.messages
      # flash[:error] = user.errors.messages[:base][0]
      # render :new
    end
  end

  def create_application
    if Applications.new(app_params.to_h)
      debugger
    end
  end

  private
  def app_params
    params.require(:application).permit(
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
