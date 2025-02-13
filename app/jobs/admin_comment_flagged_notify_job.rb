class AdminCommentFlaggedNotifyJob < ApplicationJob
  queue_as :default

  def perform(comment, user)
    flagged_comment_user = User.find(comment.user_id)
    flagged_comment_user.notifications.create(note:"Comment posted by #{flagged_comment_user.firstname} reported by the seller named : #{user.firstname}", item_id:comment.item_id, user_role:"admin" )
  end
end
