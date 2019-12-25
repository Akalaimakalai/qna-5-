class Vote < ApplicationRecord
  before_create { votable.delete_voter(user) }

  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true
  validates :value, inclusion: { in: [ 1, -1 ] }
end
