class ItemsController < ApplicationController
  #before_action :item_params, only: [:create]
  before_action :authenticate_user!
  def index
    if current_user.role == "seller"
      @items = current_user.items.includes(images_attachment: :blob)
    

    else
      @items = Item.all.includes(images_attachment: :blob)
    end
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
    @item.current_price = @item.reserved_price
    respond_to do |format|
      if @item.save
        AuctionWinnerJob.set(wait_until: @item.end_time).perform_later(@item)
        format.html { redirect_to items_url, notice: "Item was created successfully." }
      else
        format.html { render :new, status: :unprocessable_entity }
        puts @item.errors.full_messages
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
  
    if @item.update(item_params)
      redirect_to @item, notice: "Item was successfully updated."
    else
      flash[:alert] = "Failed to update item."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])
      if @item.destroy
        flash[:notice] = "Item deleted successfully."
      else
        flash[:alert] = "Failed to delete item."
      end
    if current_user.role == "seller"
      redirect_back fallback_location: items_path
    elsif current_user.role == "admin"
      redirect_back fallback_location: admin_all_sellers_path
    end
  end
  

  def set_alert
    @item = Item.find(params[:id])

    SendAlertJob.set(wait_until: @item.end_time - 1.hour).perform_later(current_user)
    
    respond_to do |format|
      format.html { redirect_back fallback_location: items_url, notice: "Will send an alert email 1 hour before ending the auction" }
    end
  end

  def end_auction
    @item = Item.find(params[:id])
    @item.update_column(:end_time, Time.current)
    if @item.save
      AuctionWinnerJob.perform_later(@item)
      respond_to do |format|
        format.html { redirect_back fallback_location: items_url, notice: "Forcefully ended the auction" }
      end
     end
  end

  private
  def item_params
    params.expect(item: [:title, :user_id, :item_description, :reserved_price, :start_time, :end_time, :images])
  end

end
