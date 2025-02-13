# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    can :create, Item if user.seller?
    can :update, Item if user.seller?
    can :send_alert, Item if user.bidder?
    can :end_auction, Item if user.admin?
    can :destroy, Item if user.admin?||user.seller?
    can :end_auction, Item if user.admin?||user.seller?

    can :create, Bid if user.bidder?

    can :create, Comment if user.bidder?||user.seller?
    can :destroy, Comment if user.seller?||user.admin?
    
    can :all_sellers, :sellers if user.admin?
    can :all_bidders, :bidders if user.admin?
    can :approve_seller, Notification if user.admin?


  end
end
