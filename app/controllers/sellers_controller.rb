class SellersController < ApplicationController
  before_action :authenticate_user!
  def index
    @seller_items = Item.where("user_id = ?", params[:format])
  end
  
end
