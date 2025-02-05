class AuctionWinnerJob < ApplicationJob
  queue_as :default

  def perform(item)
      if item.bids.last.present?
          winner_bid = item.bids.last
          winner_bid.update_column(:final_bid, true)
          winner = User.find(winner_bid.user_id)
          item.update_column(:winner_id, winner.id)
          item.save
          UserMailer.payment_alert(winner).deliver_now
          WinnerNotifyJob.perform_now(winner, item)
      end
    end 
end
