class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable 
  devise :database_authenticatable, :registerable, #:omniauthable ; will be added later
         :recoverable, :rememberable, :validatable, :timeoutable

  after_create :user_notify

  validates :firstname, :lastname, :phone_no, :pan_no, :address, :role, presence: true
  validates :email, uniqueness: true
  validates :phone_no, length: { is: 10 }

  enum :role, [ :bidder, :seller, :admin]

  has_many :items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def user_notify
    if(self.role=="seller")
      SellerRegisterNotifyJob.perform_now(self)
    end
  end
end
