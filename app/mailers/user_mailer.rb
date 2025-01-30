class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  default from: 'najain@bestpeers.in'

  def bid_placed(user)
    @user = user
    @url  = 'http://localhost:3000/login'
    mail(to: @user.email, subject: "Your Bid is placed successfully")
  end

  def outbid(user)
    @user = user
    @url = 'http://localhost:3000/login'
    mail(to: @user.email, subject: "Your bid is Outbided")
  end
end
