class SellerRegisterNotifyJob < ApplicationJob
  queue_as :default

  def perform
    current_user.notifications.create(content:"#{current_user.firstname} registered successfully, and yet to be approved.")
  end
end
