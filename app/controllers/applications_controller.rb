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
    validation
    conditionality
    user = User.new(user_params.to_h)
    if user.save
      session[:current_session] = Session.create( {
        :email => user_params[:email], :password => user_params[:password]
      }).id
      create_application
    else
      messages = []
      user.errors.each {|attr, msg| messages.push(attr.to_s.humanize + " " + msg)}
      logger.debug "Error on user creation: #{messages}"
      flash[:popup_errors] = messages
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
      redirect_to '/dashboard' and return
    else
      messages = []
      app.errors.each {|attr, msg| messages.push(attr.to_s.humanize + " " + msg)}
      logger.debug "Error on application creation: #{messages}"
      flash[:popup_errors] = messages
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/apply' and return
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
      :outside_north_america,
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

  def validation
    params[:application][:hackathons] = params[:application][:hackathons].to_i
    params[:application][:birth_day] = params[:application][:birth_day].to_i
    params[:application][:birth_month] = params[:application][:birth_month].to_i
    params[:application][:birth_year] = params[:application][:birth_year].to_i

    flash[:params] = app_params
    flash[:popup] = []
    flash[:popup_errors] = []
    if user_params['first_name'].blank? then flash[:popup].push("First name") end
    if user_params['last_name'].blank? then flash[:popup].push("Last name") end
    if user_params['email'].blank? then flash[:popup].push("Email") end
    if user_params['email_confirmation'].blank? then flash[:popup].push("Email confirmation") end
    if user_params['email_confirmation'] != user_params['email'] && !user_params['email'].blank?
      flash[:popup_errors].push("Emails do not match.")
    end
    if user_params['password'].length < 6
      flash[:popup_errors].push("Password must be greater than 5 characters")
    end
    if user_params['password'].blank? then flash[:popup].push("Password") end
    if user_params['password_confirmation'].blank?
      flash[:popup].push("Password confirmation")
    end
    if user_params['password_confirmation'] != user_params['password'] &&
      !user_params['password'].blank?
      flash[:popup_errors].push("Passwords do not match.")
    end
    if app_params[:birth_day].blank? then flash[:popup].push("Birth day") end
    if app_params[:birth_month].blank? then flash[:popup].push("Birth month") end
    if app_params[:birth_year].blank? then flash[:popup].push("Birth year") end
    if app_params[:education].blank? then flash[:popup].push("Current enrollment") end
    if app_params[:education] != "High School" &&
      app_params[:university].blank? && app_params["other_university"].blank?
      flash[:popup].push("University")
    end
    if app_params[:outside_north_america].blank?
      flash[:popup_error].push("Indicate if you are traveling from North America")
    end
    if app_params[:outside_north_america] == "No" && app_params["travel_origin"].blank?
      flash[:popup].push("Travel origin")
    end
    if app_params["graduation_season"].blank? then flash[:popup].push("Graduation season") end
    if app_params["graduation_year"].blank? then flash[:popup].push("Graduation year") end
    if app_params[:education] != "High School" && app_params['major'].blank?
      flash[:popup].push("Major")
    end
    if app_params['hackathons'].blank? then flash[:popup].push("Hackathons attended count") end
    if params["mlh"] != "true"
      flash[:popup_errors].push("You must agree to our terms.")
    end
    if flash[:popup].size > 0 || flash[:popup_errors].size > 0
      logger.debug "Error on user creation: #{[flash[:popup], flash[:popup_errors]]}"
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/apply' and return
    end
  end

  def conditionality
    if app_params[:education] == "High School"
      params[:application].delete :university
      params[:application].delete :other_university
      params[:application].delete :major
    elsif app_params[:outside_north_america] == "Yes"
      params[:application].delete :travel_origin
    end

  end
end
