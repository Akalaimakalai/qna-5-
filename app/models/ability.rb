# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    return guest_abilities unless @user

    @user.admin? ? admin_abilities : user_abilities
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    guest_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [ Question, Answer, Comment, Subscription ]
    can :create, Vote do |vote|
      vote.votable.user_id != user.id
    end

    can :update, [ Question, Answer ], user_id: user.id

    can :destroy, [ Question, Answer, Comment ], user_id: user.id
    can :destroy, ActiveStorage::Attachment do |file|
      file.record.user_id == user.id
    end
    can :destroy, Link do |link|
      link.linkable.user_id == user.id
    end

    can :best, Answer, user_id: user.id
  end
end
