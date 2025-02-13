class ApproveItemJob < ApplicationJob
  queue_as :default

  def perform(item)
    user_id = item.user_id
    user = User.find(user_id)
    item_id = item.id
    user.notifications.create(note:"#{user.firstname} adds a new item with title '#{item.title}' for the auction, wants an approvel.", item_id:item.id)
  end
end
