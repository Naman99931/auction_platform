class Comment < ApplicationRecord
  # after_create_commit { RenderCommentJob.perform_later self }

  validates :content, presence: true
  belongs_to :user

  belongs_to :item

  has_many :replies, class_name: "Comment", foreign_key: "reply_id"

  belongs_to :reply, class_name: "Comment", optional: true

  # def broadcast_comment
  #   broadcast_append_to(
  #     "comments_#{item_id}",
  #     target: "comments",
  #     partial: "comments/comment",
  #     locals: { comment: self }
  #   )
  # end
end
