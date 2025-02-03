class AdminController < ApplicationController
  def all_sellers
    @sellers = User.where(role:"seller")
  end

  def seller_items
    seller_id = params[:id]
    @items = Item.where(user_id:seller_id)
  end

  def show_notifications
    @notifications = Notification.all
  end

end
