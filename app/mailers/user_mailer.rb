class UserMailer < ApplicationMailer
  default from: "\"#{ENV['MAIL_FROM_EMAIL_NAME']}\" <#{ENV['MAIL_FROM_EMAIL']}>"

  def welcome_email(name, email)
    @name = name
    mail :to => email, :subject => "SpartaHack 2017 Application Received"
  end

end
