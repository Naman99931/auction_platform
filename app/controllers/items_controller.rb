class ItemsController < ApplicationController
  before_action :set_params, only: [:create]
  def index
    @item = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    item = Item.create(set_params)
    if item.save
      redirect_to show
    end
    # session[:item_id] = item.id
    # redirect_to root_path
  end

  private
  def set_params
    params.expect(item: [:title, :item_description, :reserved_price, :start_time, :end_time, :images])
  end

end
