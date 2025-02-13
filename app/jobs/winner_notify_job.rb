class WinnerNotifyJob < ApplicationJob
  queue_as :default

  def perform(winner, item)
    name = winner.firstname
    title = item.title
    winner.notifications.create(note:"Auction for the #{title} is ended and the winner is #{name}.")
  end
end
