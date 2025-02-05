class AdminController < ApplicationController
  def all_sellers
    @sellers = User.where(role:"seller")
  end

  def all_bidders
    @bidders = User.where(role:"bidder")
  end

  def user_items
    user = User.find(params[:id])
    if user.role == "seller"
      seller_id = params[:id]
      @items = Item.where(user_id:seller_id)
    elsif user.role == "bidder"
      bidder_id = params[:id]
      @items = Item.where(winner_id:bidder_id)
    end
  end

  def show_notifications
    @notifications = Notification.all
  end

  def approve_seller
    user = User.find(params[:user_id])
    user.update_column(:approved, true)
    respond_to do |format|
      format.html { redirect_back fallback_location: admin_show_notifications_path, notice: "Seller approved" }
    end
  end
end
