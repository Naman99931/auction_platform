class BiddersController < ApplicationController
  before_action :authenticate_user!
  def index
    @items = Item.all.includes(images_attachment: :blob)
  end
end
