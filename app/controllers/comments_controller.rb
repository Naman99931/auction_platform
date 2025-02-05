class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :comment_params, only: [:create]
  def index
    @item = Item.find(params[:item_id])
    @comments = @item.comments
  end

  def new
    @item = Item.find(params[:item_id])
    @comment = @item.comments.new
  end

  def create
    @item = Item.find(params[:item_id])
    @comment = @item.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to item_bids_path(@item.id)
    else
      flash[:alert] = "Add a Valid Comment"
      redirect_back fallback_location: item_bids_path(@item.id)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    item_id = @comment.item_id
      if @comment.destroy
        flash[:notice] = "Comment deleted successfully."
      else
        flash[:alert] = "Failed to delete Comment."
      end
      redirect_back fallback_location: item_comments_path(item_id)
  end

  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
  
end
