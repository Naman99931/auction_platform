class ItemsController < ApplicationController
  #before_action :item_params, only: [:create]
  before_action :authenticate_user!
  def index
    @items = Item.where("approved = ? AND flagged = ?", true, false).includes(images_attachment: :blob)
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    authorize! :create, @item 
  end

  def create
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
    authorize! :update, @item
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
    if can? :destroy, @item
      if current_user_role == "admin" || current_user.id == @item.user_id
          if @item.destroy
            flash[:notice] = "Item deleted successfully."
            redirect_to items_path
          else
            flash[:alert] = "Failed to delete item."
          end
      else
        flash[:alert] = "Failed to delete item, you are not the owner of this item."
      end
    else
      head :forbidden
    end
  end
  
  def set_alert
    @item = Item.find(params[:id])
    if can? :send_alert, @item
      SendAlertJob.set(wait_until: @item.end_time - 1.hour).perform_later(current_user)
    
      respond_to do |format|
        format.html { redirect_back fallback_location: items_url, notice: "Will send an alert email 1 hour before ending the auction" }
      end
    else
      head :forbidden
    end
  end

  def end_auction
    @item = Item.find(params[:id])
    if can? :end_auction, @item
      @item.update_column(:end_time, Time.current)
      if @item.save
        AuctionWinnerJob.perform_later(@item)
        respond_to do |format|
          format.html { redirect_back fallback_location: items_url, notice: "Forcefully ended the auction" }
        end
      end
    else
      head :forbidden
    end
  end

  def user_items
    if current_user_role == "admin"
      @user = User.find(params[:id])
      if @user.role == "seller"
        @items = @user.items.includes(images_attachment: :blob)
      else
        @items = Item.where(winner_id:@user.id)
      end
    else
      @items = current_user.items.includes(images_attachment: :blob)
    end
  end

  def buy_items
    @items = Item.where(winner_id: current_user.id)
  end

  def report_item
    item = Item.find(params[:id])
    seller = User.find(item.user_id)
    current_user.notifications.create(note:"The item named #{item.title} is reported by the user named #{current_user.firstname}", item_id:item.id, user_role:"admin")
    seller.notifications.create(note:"Your item named #{item.title} is reported. Kindly review this item, otherwise it will get flagged", item_id:item.id, user_role:"seller")
    respond_to do |format|
      format.html { redirect_back fallback_location: items_url, notice: "Will take an action, thanks for your feedback." }
    end
  end

  def all_flagged_items
    @items = Item.where("approved = ? AND flagged = ?", true, true)
  end

  def remove_flag_item
    @item = Item.find(params[:id])
    @item.update_column(:flagged, false)
    seller = User.find(@item.user_id)
    seller.notifications.create(note:"Flag from your item  #{@item.title}, has been removed successfully.", item_id:@item.id)
    respond_to do |format|
      format.html { redirect_back fallback_location: all_flagged_items_path, notice:"Flag from the item removed successfully."}
    end
  end

  private
  def item_params
    params.expect(item: [:title, :user_id, :item_description, :reserved_price, :start_time, :end_time, :images])
  end

end
