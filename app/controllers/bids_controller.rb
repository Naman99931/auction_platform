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
    authorize! :create, @bid 
    if current_user.approved == true && current_user.flagged == false
    else
      raise "you are not authorized"
    end
  end

  def create
    if current_user.approved == true && current_user.flagged == false
      @item = Item.find(params[:item_id])
        if @item.end_time > Time.current
          if @item.bids.last.present?
              last_bid = @item.bids.last
              last_user = User.find(last_bid.user_id)
          end
          @bid = @item.bids.new(bid_params)
          @bid.user = current_user
          respond_to do |format|
            if @bid.amount >= expect_amount(@item.current_price)
              #@item.current_price = @bid.amount
              
                if @bid.save
                  @item.update_column(:current_price, @bid.amount)

                  if last_user.present?
                    UserMailer.outbid(last_user).deliver_later
                  end
                  UserMailer.bid_placed(current_user).deliver_later
                  format.html { redirect_to item_bids_path(@item), notice: "Bid created successfully." }
                else
                  format.html { render :new, status: :unprocessable_entity }
                  puts @bid.errors.full_messages
                end
            else
              format.html { redirect_to new_item_bid_path(@item), notice: "Please place a higher amount." }
            end
          end
        end
    else
      raise "you are not authorized"
    end
  end

  private
  def bid_params
     params.require(:bid).permit(:amount)
  end

  def expect_amount(current_amount)
    expected_amount = current_amount.to_i + ((current_amount.to_i)/20)
  end

end
