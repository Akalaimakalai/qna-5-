class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :medals
  has_many :scores, foreign_key: "author_id"
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_to_questions, through: :subscriptions, source: :question

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

  def follower?(question)
    subscribed_to_questions.include?(question)
  end

  def find_sub(question)
    subscriptions.find_by(question_id: question.id)
  end
end
