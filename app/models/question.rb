class Question < ApplicationRecord
  include Linkable

  after_save :create_score

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :medal, dependent: :destroy
  has_one :score, dependent: :destroy, as: :scorable

  has_many_attached :files

  accepts_nested_attributes_for :medal, reject_if: :all_blank

  validates :title, :body, presence: true

  private

  def create_score
    Score.create!(author: user, scorable_type: "Question", scorable_id: id)
  end
end
