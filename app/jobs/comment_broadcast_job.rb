class CommentBroadcastJob < ApplicationJob
  queue_as :default

  def perform(item, comment_html)
    # Do something later
    CommentsChannel.broadcast_to(item, comment_html)
  end
end
