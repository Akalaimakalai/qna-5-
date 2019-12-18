class Vote < ApplicationRecord
  belongs_to :score
  belongs_to :user

  validates :value, presence: true
end
