class CommentsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "comments_channel_#{params[:item_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
