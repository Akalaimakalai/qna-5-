class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :medals
  has_many :scores, foreign_key: "author_id"
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[ github ]

  def is_author?(object)
    object.user_id == id
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end
end
