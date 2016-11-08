class AdminController < ApplicationController
  before_action :check_login

  def dashboard
    @user = User.current_user

    user_t = User.all.count
    app_t = Application.all.count
    @total = [user_t,app_t,0]
  end

  def statistics
  end

  def faq
    @faq = Faq.new
    @faqs = Faq.all
    @faqs.to_a.sort! { |a,b| a.question.downcase <=> b.question.downcase }
  end

  def faq_view
    if faq_params.present?
      @faq = Faq.find(faq_params[:id])
    else
      redirect_to "/admin/faq" and return
    end
  end

  private

  def check_login
    if User.current_user.blank? || User.current_user.roles.exclude?("director")
      redirect_to '/dashboard'
    end
  end

  def faq_params
    params.permit(:id)
  end


end
