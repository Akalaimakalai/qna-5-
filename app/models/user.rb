class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :medals
  has_many :votes, class_name: "Score", foreign_key: "author_id"

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def is_author?(object)
    object.user_id == id
  end
end
