class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :medals

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def is_author?(object)
    object.user_id == id
  end
end
