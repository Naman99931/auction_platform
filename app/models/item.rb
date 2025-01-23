class Item < ApplicationRecord
  validates :title , :item_description, :reserved_price, :start_time, :end_time, presence: true
  validates :reserved_price, numericality: {greater_than: 0}
  validate :check_start_time, :check_end_time

  belongs_to :user
  has_many_attached :images

  def check_start_time
    if start_time.present? && start_time < Date.today
      errors.add(:start_time, "cant be in the past")
    end
  end
  def check_end_time
    if end_time < start_time
      errors.add(:end_time, "cant be less than start time")
    end
  end
end
