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
    last_bid = @item.bids.last
    last_user = User.find(last_bid.user_id)
    @bid = @item.bids.new(bid_params)
    @bid.user = current_user
    
    if @bid.amount >= expect_amount(@item.current_price)
      @item.current_price = @bid.amount
      respond_to do |format|
        if @bid.save
          UserMailer.bid_placed(current_user).deliver_now
          UserMailer.outbid(last_user).deliver_now
          format.html { redirect_to item_bids_path(@item), notice: "Bid created successfully." }
        else
          format.html { render :new, status: :unprocessable_entity }
          puts @bid.errors.full_messages
        end
      end
    else
      format.html { render :new, status: :unprocessable_entity }
      puts @bid.errors.full_messages
    end
  end

  private
  def bid_params
     params.require(:bid).permit(:amount)
  end

  def expect_amount(current_amount)
    expected_amount = current_amount.to_i + ((current_amount.to_i)/5)
  end

end
