class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :comment_params, only: [:create]
  #before_action :reply_params, only: [:save_reply]
  skip_before_action :verify_authenticity_token


  def new
    @item = Item.find(params[:item_id])
    @comment = @item.comments.new
    authorize! :create, @comment
  end

  def create
    @item = Item.find(params[:item_id])
    @comment = @item.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format| 
        format.html { redirect_to item_bids_path(@item.id) }
      end
    else
      flash[:alert] = "Add a valid comment"
      redirect_back fallback_location: item_bids_path(@item.id)
    end
  end

  
  # private
  
  # def render_comment(comment)
  #   ApplicationController.renderer.render(partial: 'comments/comment', locals: { comment: comment })
  # end
  

  # def create
  #   @item = Item.find(params[:item_id])
  #   @comment = @item.comments.build(comment_params)
  #   @comment.user = current_user

  #   if @comment.save
  #     respond_to do |format| 
  #       format.html { redirect_to item_bids_path(@item.id) }
  #     end
  #   else
  #     flash[:alert] = "Add a valid comment"
  #     redirect_back fallback_location: item_bids_path(@item.id)
  #   end
  # end

  # def create
  #   @comment = Comment.create! content: params[:comment][:content], item: @item
  # end

  def destroy 
    @comment = Comment.find(params[:id])
    if can? :destroy, @comment
      item_id = @comment.item_id
        if @comment.destroy
          flash[:notice] = "Comment deleted successfully."
        else
          flash[:alert] = "Failed to delete Comment."
        end
        redirect_back fallback_location: item_comments_path(item_id)
    else
      forbidden
    end
  end

  def flag_comment
    # authorization
    @comment = Comment.find(params[:id])
    @comment.update_column(:flagged, true)
    if current_user_role == "admin"
      UserCommentFlaggedNotifyJob.perform_later(@comment)
    elsif current_user_role == "seller"
      UserCommentFlaggedNotifyJob.perform_later(@comment)
      AdminCommentFlaggedNotifyJob.perform_later(@comment, current_user)
    end
    redirect_back fallback_location: item_bids_path(@comment.item_id)
  end
  # def comment_reply
  #   # @reply = @item.comments.new
  #   # @reply.reply_id = @comment.id
  #   # @reply.user = current_user
  #   @comment = Comment.find(params[:id])
  #   @reply = @comment.replies.new
  # end

  # def save_reply
  #   item_id = @reply.item_id
  #   @reply = current_user.replies.new(reply_params)
  #   @reply.save
  #   redirect_back fallback_location: item_comments_path(item_id)
  # end
  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end

  # def reply_params
  #   params.require(:reply).permit(:content)
  # end
  
end
