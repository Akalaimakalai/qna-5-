class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :medals
  has_many :scores, foreign_key: "author_id"
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subs, through: :subscriptions, source: :question

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[ github vkontakte ]

  def self.find_for_oauth(auth)
    FindForOauthService.call(auth)
  end

  def follower?(resource)
    subs.include?(resource)
  end
end
