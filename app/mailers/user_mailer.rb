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

  def logistics_email(name, email, id)
    require 'rqrcode'
    @name = name

    @qr = RQRCode::QRCode.new( id.to_s, :size => 1, :level => :h, :mode => :alphanumeric )
    @png = @qr.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 240,
      border_modules: 4,
      module_px_size: 6,
      file: "#{Rails.root}/app/assets/qr/qr-#{id}.png" # path to write
    )

    attachments.inline['qr.png'] = File.read("#{Rails.root}/app/assets/qr/qr-#{id}.png")
    attachments.inline['banner.png'] = File.read("#{Rails.root}/app/assets/images/logo/banner.png")
    attachments.inline['footer.png'] = File.read("#{Rails.root}/app/assets/images/favicons/push-192x192.png")

    mail :to => email, :subject => "SpartaHack 2017 Logistics"
  end

end
