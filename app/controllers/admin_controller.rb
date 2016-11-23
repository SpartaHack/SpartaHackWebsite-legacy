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
    @faqs = Faq.all.to_a.sort_by {|obj| obj.priority}
  end

  def faq_view
    @faqs = Faq.all
    if faq_params.present?
      @faq = Faq.find(faq_params[:id])
    else
      redirect_to "/admin/faq" and return
    end
  end

  def sponsorship
    # Used to populate Edit Sponsors section.
    @sponsors = []

    # get sponsors
    url = URI.parse('http://localhost:3001/sponsors')
    req = Net::HTTP::Get.new(url.to_s)
    req.add_field("Authorization", "Token token=\"#{ENV['API_AUTH_TOKEN']}\"")
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.use_ssl = ENV['API_SSL_ON'] == "true" ? true : false
      http.request(req)
    }

    companies =  JSON.parse(res.body)
    companies.each do |c|
      @sponsors.push([c["id"].to_i, c["name"]])
    end
  end

  def sponsorship_view
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
