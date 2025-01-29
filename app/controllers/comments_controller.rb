class CommentsController < ApplicationController
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
    @comment = @item.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        
        format.html { redirect_to item_comments_path(@item) }
      else
        format.html { render :new, status: :unprocessable_entity }
        puts @comment.errors.full_messages
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
