require 'pp'
class ApplicationsController < ::ApplicationController
  wrap_parameters :user, include: [:password, :password_confirmation]
  before_action :set_http_auth_token, only: [:create]

  def new
    if flash[:app_params]
      @application = Application.new(flash[:app_params])
      @user = User.new(flash[:user_params])
    elsif current_user.present?
      redirect_to '/application/edit' and return
    else
      @application = Application.new
      @user = User.new
    end
  end

  def create
    session.clear
    reset_session
    flash[:popup] = []
    flash[:popup_errors] = []
    validate('/apply')
    conditionality
    @user = User.new(user_params.to_h)
    begin
      if @user.save
        session[:current_session] = @user.id
        # set_user_auth_token
        ActiveResource::Base.headers["X-WWW-User-Token"] = "#{ @user.auth_token }"
        create_application
      else
        messages = []
        @user.errors.each {|attr, msg| messages.push(attr.to_s.humanize + " " + msg)}
        logger.debug "Error on user creation: #{messages}"
        flash[:popup_errors].push(messages)
        flash[:app_params] = app_params.to_h
        flash[:user_params] = user_params.to_h
        redirect_to '/apply' and return
      end
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      logger.debug "Fatal error on user creation"
      flash[:popup_errors].push("Something went wrong, please resubmit.")
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/apply' and return
    end

  end

  def edit
    if flash[:app_params]
      @application = Application.new(flash[:app_params])
      @user = User.new(flash[:user_params])
    elsif current_user.present?
      set_http_auth_token
      user = current_user
      if !user.application.blank?
        hash = user.application.instance_variables.each_with_object({}) { |var, hash|
          hash[var.to_s.delete("@")] = user.application.instance_variable_get(var)
        }
        @application = Application.new(hash['attributes'])
      else
        @application = Application.new()
      end
      @user = User.new({first_name: user.first_name, last_name: user.last_name})
    else
      redirect_to "/login"
    end
  end

  def update
    flash[:popup] = []
    flash[:popup_errors] = []
    if current_user.present?
      validate('/application/edit', 1)
      conditionality
      set_http_auth_token
      @user = current_user
      @user.load(user_params.to_h)
      update_user
    else
      flash[:error] = "An error occured please try again by logging in."
      redirect_to '/login'
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

  def update_user
    ActiveResource::Base.headers["X-WWW-User-Token"] = "#{ @user.auth_token }"
    begin
      if @user.save
        if @user.application.blank?
          create_application
        else
          update_application
        end
      else
        messages = []
        @user.errors.each {|attr, msg| messages.push(attr.to_s.humanize + " " + msg)}
        Rails.logger.debug "Error on user update: #{messages}"
        flash[:app_params] = app_params.to_h
        flash[:user_params] = user_params.to_h
        redirect_to '/application/edit' and return
      end
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      Rails.logger.debug "Fatal error on user update"
      flash[:popup_errors].push("Something went wrong, please resubmit.")
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/application/edit' and return
    end

  end

  def update_application
    @application = Application.find(@user.application.id)
    @application.load(app_params.to_h)
    begin
      if @application.save
        redirect_to '/dashboard' and return
      else
        messages = []
        @app.errors.each {|attr, msg| messages.push(attr.to_s.humanize + " " + msg)}
        Rails.logger.debug "Error on application update: #{messages}"
        flash[:popup_errors].push(messages)
        flash[:app_params] = app_params.to_h
        flash[:user_params] = user_params.to_h
        redirect_to '/application/edit' and return
      end
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      Rails.logger.debug "Fatal error on application update"
      flash[:popup_errors].push("Something went wrong, please resubmit.")
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/application/edit' and return
    end

  end

  def create_application
    ActiveResource::Base.headers["X-WWW-User-Token"] = "#{ @user.auth_token }"
    app = Application.new(app_params.to_h)
    begin
      ActiveResource::Base.headers["X-WWW-User-Token"] = "#{ @user.auth_token }"
      if app.save
        UserMailer.welcome_email(
          user_params[:first_name], user_params[:email]
        ).deliver_now
        flash[:email] = user_params[:email]
        redirect_to '/dashboard' and return
      else
        messages = []

        ActiveResource::Base.headers["X-WWW-User-Token"] = "#{ @user.auth_token }"
        @user.destroy
        app.errors.each {|attr, msg| messages.push(attr.to_s.humanize + " " + msg)}
        Rails.logger.debug "Error on application creation: #{messages}"
        flash[:popup_errors].push(messages)
        flash[:app_params] = app_params.to_h
        flash[:user_params] = user_params.to_h
        redirect_to '/apply' and return
      end
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      Rails.logger.debug "Fatal error on application creation"
      ActiveResource::Base.headers["X-WWW-User-Token"] = "#{ @user.auth_token }"
      @user.destroy
      flash[:popup_errors].push("Something went wrong, please resubmit.")
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/apply' and return
    end
  end

  def validate(redirection, edit = 0)
    application_validation
    user_validation(edit)
    redirect_on_errors(redirection)
  end

  def application_validation
    params[:application][:hackathons] = params[:application][:hackathons].to_i
    params[:application][:birth_day] = params[:application][:birth_day].to_i
    params[:application][:birth_month] = params[:application][:birth_month].to_i
    params[:application][:birth_year] = params[:application][:birth_year].to_i

    if params[:application][:hackathons] > 100 then params[:application][:hackathons] = 100 end
    if app_params[:birth_day].blank? then flash[:popup].push("Birth day") end
    if app_params[:birth_month].blank? then flash[:popup].push("Birth month") end
    if app_params[:birth_year].blank? then flash[:popup].push("Birth year") end
    if app_params[:education].blank? then flash[:popup].push("Current enrollment") end
    if app_params[:education] != "High School" &&
      app_params[:university].blank? && app_params["other_university"].blank?
      flash[:popup_errors].push("College or University is required")
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
    if app_params['hackathons'].blank? ||
      (app_params['hackathons'].blank? && app_params['hackathons'] < 0)
      flash[:popup_errors].push("Hackathons attended must be 0 or more")
    end
    if params["mlh"] != "true"
      flash[:popup_errors].push("You must agree to our terms.")
    end
  end

  def user_validation(edit)
    if user_params['first_name'].blank? then flash[:popup].push("First name") end
    if user_params['last_name'].blank? then flash[:popup].push("Last name") end

    if edit != 1
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
    end
  end

  def redirect_on_errors(redirection)
    if flash[:popup].size > 0 || flash[:popup_errors].size > 0
      logger.debug "Errors on validation: #{[flash[:popup], flash[:popup_errors]]}"
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to redirection and return
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
