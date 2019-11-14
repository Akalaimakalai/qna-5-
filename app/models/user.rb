class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def is_author?(object)
    object.user == self
  end
end
