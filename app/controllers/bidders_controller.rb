class BiddersController < ApplicationController
  before_action :authenticate_user!
  def index
    @items = Item.all.includes(images_attachment: :blob)
  end

  def buy_items
    @items = Item.where(winner_id:current_user.id)
  end
end
