module ItemsHelper
  def return_winner(item)
    if item.winner_id.present? 
      winner_id = item.winner_id 
      winner = User.find(winner_id)
    end
  end

  def ongoing_auctions(items)
    items = items&.where("start_time < ? AND end_time >= ?", Time.current, Time.current)
  end

  def upcoming_auctions(items)
    items = items&.where("start_time > ?", Time.current)
  end

  def ended_auctions(items)
    items = items&.where("end_time < ?", Time.current)
  end

  def check_admin
    if current_user_role == "admin" && current_user.approved == true
        return true
    else
        return false
    end
  end

  def return_seller(item_id)
    item = Item.find(item_id)
    seller = User.find(item.user_id)
  end
end