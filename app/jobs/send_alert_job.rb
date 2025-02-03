class SendAlertJob < ApplicationJob
  queue_as :default

  def perform(user)
    UserMailer.auction_end_alert(current_user).deliver_now
  end
end
