class SellerRegisterNotifyJob < ApplicationJob
  queue_as :default

  def perform(seller)
    seller.notifications.create(note:"#{seller.firstname} registered successfully, and yet to be approved.")
  end
end
