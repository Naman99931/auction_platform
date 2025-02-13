class UserCommentFlaggedNotifyJob < ApplicationJob
  queue_as :default

  def perform(comment)
    user = User.find(comment.user_id)
    user.notifications.create(note:"Your comment has been flagged.", item_id:comment.item_id, user_role:user.role)
  end
end
