class CommentsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "comments_channel"
  end

  # def received(data)
  # end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    comment = Comment.create(content: data['message'], user: data['user'])
    ActionCable.server.broadcast("comment_channel", comment: comment.content, user: comment.user)
  end

end
