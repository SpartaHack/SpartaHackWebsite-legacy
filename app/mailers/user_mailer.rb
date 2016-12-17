class UserMailer < ApplicationMailer
  default from: "\"#{ENV['MAIL_FROM_EMAIL_NAME']}\" <#{ENV['MAIL_FROM_EMAIL']}>"

  def welcome_email(name, email)
    attachments.inline['banner.png'] = File.read("#{Rails.root}/app/assets/images/logo/banner.png")
    @name = name
    mail :to => email, :subject => "SpartaHack 2017 Application Received"
  end

  def reset_password_email(name, email, token)
    attachments.inline['banner.png'] = File.read("#{Rails.root}/app/assets/images/logo/banner.png")
    @name = name
    @token = token
    mail :to => email, :subject => "SpartaHack 2017 Reset Password Link"
  end

end
