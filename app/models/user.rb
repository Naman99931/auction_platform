class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable 
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :timeoutable, :omniauthable, omniauth_providers: %i[google_oauth2]

  after_create :user_notify

  validates :firstname, :lastname, presence: true  # :phone_no, :pan_no, :address,
  validates :email, uniqueness: true
  # validate :check_user
  # validates :phone_no, uniqueness: true
  # validates :pan_no, uniqueness: true
  # validates :gst_no, uniqueness: true

  # validates :phone_no, length: { is: 10 }

  enum :role, [ :bidder, :seller, :admin]

  has_many :items, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # def check_user
  #   if self&.role == "bidder"
  #     if self.pan_no.present? && self.phone_no.present? && self.address.present?
  #     else
  #       self.update_column(:role, nil)
  #       errors.add("please enter full details")
  #     end
  #   elsif self&.role == "seller"
  #     if self.pan_no.present? && self.phone_no.present? && self.address.present? && self.gst_no.present?
  #     else
  #       self.update_column(:role, nil)
  #       errors.add("please enter full details")
  #     end
  #   end
  # end



  def user_notify
    if(self.role=="admin")
      UserRegisterNotifyJob.perform_now(self)
    end
  end


  # Omniauth setting :
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(
           email: data['email'],
           password: Devise.friendly_token[0,20],
           firstname: data['first_name'],
           lastname: data['last_name']

        )
    end
    user
  end
end
