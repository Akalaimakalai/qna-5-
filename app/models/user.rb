class User < ApplicationRecord
  has_many :questions, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
end
