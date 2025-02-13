class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  default from: 'najain@bestpeers.in'

  def bid_placed(user)
    @user = user
    # @url  = 'http://localhost:3000/login'
    mail(to: @user.email, subject: "Your Bid is placed successfully")
  end

  def outbid(user)
    @user = user
    mail(to: @user.email, subject: "Your bid is Outbided")
  end

  def payment_alert(user)
    @user = user
    mail(to: @user.email, subject: "Congratulations, you win an auction")
  end

  def auction_end_alert(user)
    @user = user
    mail(to: @user.email, subject: "Auction is about to end")
  end

  def account_approved(user)
    @user = user
    mail(to: @user.email, subject: "Your Account got Approved")
  end

  def payment_success(user)
    @user = user
    mail(to: @user.email, subject: "Your payment completed successfully")
  end

  def item_got_approved(user)
    @user = user
    mail(to: @user.email, subject: "Your Listed item got approved, and its ready for the auction.")
  end
  
end
