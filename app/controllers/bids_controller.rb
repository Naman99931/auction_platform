class BidsController < ApplicationController
  before_action :bid_params, only: [:create]
  before_action :authenticate_user!
  def index
    @item = Item.find(params[:item_id])
    @bids = @item.bids
  end

  def new
    @item = Item.find(params[:item_id])
    # @bid = @item.bids.new
    @bid = @item.bids.new
  end

  def create
    @item = Item.find(params[:item_id])
    @bid = @item.bids.new(bid_params)
    @bid.user = current_user
    respond_to do |format|
      if @bid.save
        format.html { redirect_to item_bids_path(@item), notice: "Bid created successfully." }
      else
        format.html { render :new, status: :unprocessable_entity }
        puts @bid.errors.full_messages
      end
    end
  end

  private
  def bid_params
     params.require(:bid).permit(:amount)
  end

end
