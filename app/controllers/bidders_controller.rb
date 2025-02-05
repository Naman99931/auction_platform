class BiddersController < ApplicationController
  before_action :authenticate_user!

  def index
    @bidders = User.where(role:"bidder")
  end

  def buy_items
    @items = Item.where(winner_id: current_user.id)
  end

end
