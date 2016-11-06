class ApplicationsController < ::ApplicationController
  wrap_parameters :user, include: [:password, :password_confirmation]

  def new
    if flash[:app_params]
      # In the event of an error repopulate form.
      @application = Application.new(flash[:app_params])
      @user = User.new(flash[:user_params])
    elsif User.current_user.present?
      redirect_to '/application/edit' and return
    else
      @application = Application.new
      @user = User.new
    end
  end

  def create
    session.clear
    reset_session

    validate('/apply')
    conditionality
    @user = User.new(user_params.to_h)
    begin
      if @user.save
        User.current_user = @user
        session[:current_session] = @user.id
        create_application
      else
        messages = []
        @user.errors.each {|attr, msg| messages.push(attr.to_s.humanize + " " + msg)}
        logger.debug "Error on user creation: #{messages}"

        flash[:popup_errors] = messages
        flash[:app_params] = app_params.to_h
        flash[:user_params] = user_params.to_h
        redirect_to '/apply' and return
      end
    rescue => e
      logger.debug "Fatal error on user creation: #{Rails.logger.error e.message}"

      flash[:popup_errors].push("Something went wrong, please resubmit.")
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/apply' and return
    end

  end

  # Allows the editing of a User's Application.
  def edit
    if flash[:app_params]
      # In the event of an error repopulate form.
      @application = Application.new(flash[:app_params])
      @user = User.new(flash[:user_params])
    elsif User.current_user.present?
      user = User.current_user
      # In the event a user is created but no application exists for them.
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

  # Updates the User and Application.
  def update
    if User.current_user.present?
      @user = User.current_user
      validate('/application/edit', 1)
      conditionality

      # Only upate the user if anything has changed.
      if @user.first_name != user_params[:first_name] || @user.last_name != user_params[:last_name]
        update_user
      else
        update_application
      end
    else
      flash[:error] = "An error occured please try again by logging in."
      redirect_to '/login'
    end
  end

  private
  def app_params
    @app_params ||= params.require(:application).permit(
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
      :statement,
      :other_university_enrolled_confirm
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

  # Updates a User with new first_name or last_name.
  def update_user
    @user.load(user_params.to_h)
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

        flash[:popup_errors] = messages
        flash[:app_params] = app_params.to_h
        flash[:user_params] = user_params.to_h
        redirect_to '/application/edit' and return
      end
    rescue => e
      Rails.logger.debug "Fatal error on user update"
      Rails.logger.error e.message

      flash[:popup_errors].push("Something went wrong, please resubmit.")
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/application/edit' and return
    end

  end

  # Updates a User's Application.
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

        flash[:popup_errors] = messages
        flash[:app_params] = app_params.to_h
        flash[:user_params] = user_params.to_h
        redirect_to '/application/edit' and return
      end
    rescue => e
      Rails.logger.debug "Fatal error on application update"
      Rails.logger.error e.message

      flash[:popup_errors].push("Something went wrong, please resubmit.")
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/application/edit' and return
    end

  end

  # Creates an Application on successful User creation.
  def create_application
    begin
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
        Rails.logger.debug "Error on application creation: #{messages}"
        @user.destroy

        flash[:popup_errors] = messages
        flash[:app_params] = app_params.to_h
        flash[:user_params] = user_params.to_h
        redirect_to '/apply' and return
      end
    rescue => e
      Rails.logger.debug "Fatal error on application creation"
      Rails.logger.error e.message
      @user.destroy

      flash[:popup_errors].push("Something went wrong, please resubmit.")
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to '/apply' and return
    end
  end

  # Calls the User and Application validation checks and redirects on errors.
  def validate(redirection, edit = 0)
    flash[:popup] = []
    flash[:popup_errors] = []
    application_validation
    user_validation(edit)
    redirect_on_errors(redirection)
  end

  # Checks for all required fields related to Application creation and update.
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

  # Checks for all required fields related to User creation or update.
  def user_validation(edit)
    if user_params['first_name'].blank? then flash[:popup].push("First name") end
    if user_params['last_name'].blank? then flash[:popup].push("Last name") end

    # These validations aren't necessary for application editing.
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

  # Called after validations, redirects if errors on validation.
  def redirect_on_errors(redirection)
    if flash[:popup].size > 0 || flash[:popup_errors].size > 0
      logger.debug "Errors on validation: #{[flash[:popup], flash[:popup_errors]]}"
      flash[:app_params] = app_params.to_h
      flash[:user_params] = user_params.to_h
      redirect_to redirection and return
    end
  end

  # Prevents storage of unnecessary information.
  def conditionality
    if app_params[:education] == "High School"
      app_params[:university] = nil
      app_params[:other_university] = nil
      app_params[:major] = nil
    end

    if app_params[:outside_north_america].downcase == "yes"
      app_params[:travel_origin] = nil
    end

    if app_params[:other_university_enrolled_confirm] == "true"
      app_params[:university] = nil
    else
      app_params[:other_university] = nil
    end
  end
end
