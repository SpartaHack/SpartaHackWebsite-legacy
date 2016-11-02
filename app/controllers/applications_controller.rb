class ApplicationsController < ::ApplicationController
  wrap_parameters :user, include: [:password, :password_confirmation]
  before_action :set_http_auth_token, only: [:create]


  def new
    if flash[:app_params]
      @application = Application.new(flash[:app_params])
      @user = User.new(flash[:user_params])
    else
      @application = Application.new
      @user = User.new
    end
  end

  def create
    flash[:params] = app_params
    flash[:popup] = []
    flash[:popup_errors] = []
    if user_params['first_name'].blank? then flash[:popup].push("First name") end
    if user_params['last_name'].blank? then flash[:popup].push("Last name") end
    if user_params['email'].blank? then flash[:popup].push("Email") end
    if user_params['email_confirmation'].blank? then flash[:popup].push("Email confirmation") end
    if user_params['email_confirmation'] != user_params['email'] && user_params['email'].length > 1
      flash[:popup_errors].push("Emails do not match.")
    end
    if user_params['password'].length < 7
      flash[:popup_errors].push("Password must be greater than 5 characters")
    end
    if user_params['password'].blank? then flash[:popup].push("Password") end
    if user_params['password_confirmation'].blank?
      flash[:popup].push("Password confirmation")
    end
    if user_params['password_confirmation'] != user_params['password']
      flash[:popup_errors].push("Passwords do not match.")
    end
    if app_params["birth_day"].blank? then flash[:popup].push("Birth day") end
    if app_params["birth_month"].blank? then flash[:popup].push("Birth month") end
    if app_params["birth_year"].blank? then flash[:popup].push("Birth year") end
    if app_params["education"].blank? then flash[:popup].push("Current enrollment") end
    if app_params["university"].blank? then flash[:popup].push("University") end
    if app_params["travel_origin"].blank? then flash[:popup].push("Travel origin") end
    if app_params["graduation_season"].blank? then flash[:popup].push("Graduation season") end
    if app_params["graduation_year"].blank? then flash[:popup].push("Graduation year") end
    if app_params['major'].blank? then flash[:popup].push("Major") end
    if app_params['hackathons'].blank? then flash[:popup].push("Hackathons attended count") end
    if params["mlh"] != "true"
      flash[:popup_errors].push("You must agree to our terms.")
    end
    if flash[:popup].size > 0 || flash[:popup_errors].size > 0 || !flash[:popup_agree].blank?
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/apply' and return
    end

    user = User.new(user_params.to_h)
    if user.save
      session[:current_session] = Session.create( {
        :email => user_params[:email], :password => user_params[:password]
      }).id
      create_application
    else
      flash[:popup_errors] = user.errors.messages[:base][0]
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/apply' and return
    end

  end

  def create_application
    set_user_auth_token
    app = Application.new(app_params.to_h)
    if app.save
      UserMailer.welcome_email(
        user_params[:first_name], user_params[:email]
      ).deliver_now
      flash[:email] = user_params[:email]
      redirect_to '/dashboard'
    else
      p app.errors.messages
    end
  end

  private
  def app_params
    params.require(:application).permit(
      :birth_day,
      :birth_month,
      :birth_year,
      :education,
      :university,
      :gender,
      {:race => []},
      :other_university,
      :travel_origin,
      :graduation_season,
      :graduation_year,
      :outside_north_america
      {:major => []},
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
      :email_confirmation,
      :password,
      :password_confirmation
    )
  end
end
