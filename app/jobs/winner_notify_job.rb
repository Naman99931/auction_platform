class WinnerNotifyJob < ApplicationJob
  queue_as :default

  def perform(winner, @item)
    name = winner.firstname
    title = @item.title
    user_id = winner.id
    winner.notifications.create(content:"Auction for the #{title} is ended and the winner is #{name}.")
  end
end
