class ItemsController < ApplicationController
  #before_action :item_params, only: [:create]
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    #@item = Item.new(item_params, :current_user)
    @item = current_user.items.new(item_params)
    respond_to do |format|
      if @item.save
        format.html { redirect_to sellers_index_url(current_user), notice: "Item was created successfully." }
      else
        format.html { render :new, status: :unprocessable_entity }
        puts @item.errors.full_messages
      end
    end
  end

  # def ongoing_auction
  #   @items = Item.where(:start_time < Time.now).where(:end_time > Time.now)
  # end

  # def upcoming_auction
  #   @items = Item.where(:start_time > Time.now)
  # end

  # def ended_auction
  #   @items = Item.where(:end_time < Time.now)
  # end

  private
  def item_params
    params.expect(item: [:title, :user_id, :item_description, :reserved_price, :start_time, :end_time, :images])
  end

end
