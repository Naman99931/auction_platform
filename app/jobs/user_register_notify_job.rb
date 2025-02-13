class UserRegisterNotifyJob < ApplicationJob
  queue_as :default

  def perform(user)
    if user.role == "seller"
      user.notifications.create(note:"#{user.firstname} wants to be a seller, and added the details successfully, and yet to be approved.")
    elsif user.role == "admin"
      user.notifications.create(note:"#{user.firstname} registered successfully as admin, and yet to be approved.")
    elsif user.role == "bidder"
      user.notifications.create(note:"#{user.firstname} wants to be a bidder, and added the details successfully, and yet to be approved.")
    end
  end
end
