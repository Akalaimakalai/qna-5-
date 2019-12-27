class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :medals
  has_many :scores, foreign_key: "author_id"
  has_many :votes
  has_many :coments

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def is_author?(object)
    object.user_id == id
  end
end
