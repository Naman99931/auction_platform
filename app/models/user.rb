class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable 
  devise :database_authenticatable, :registerable, #:omniauthable ; will be added later
         :recoverable, :rememberable, :validatable, :timeoutable

  validates :firstname, :lastname, :phone_no, :pan_no, :address, :role, presence: true
  validates :email, uniqueness: true
  validates :phone_no, length: { is: 10 }

  enum :role, [ :bidder, :seller, :admin]

  has_many :items
  has_many :bids
  has_many :comments
end
