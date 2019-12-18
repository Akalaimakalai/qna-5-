class Question < ApplicationRecord
  include Linkable
  include Scorable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :medal, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :medal, reject_if: :all_blank

  validates :title, :body, presence: true
end
