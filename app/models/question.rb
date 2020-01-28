class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  before_create :add_author_to_followers
  after_create_commit :broadcast_question
  after_create :calculate_reputation

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :followers, through: :subscriptions, source: :user
  has_one :medal, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :medal, reject_if: :all_blank

  validates :title, :body, presence: true

  default_scope { order(created_at: :asc) }

  scope :yesterday, -> { where(created_at: (1.day.ago..Time.zone.now)) }

  private

  def broadcast_question
    ActionCable.server.broadcast('questions', data: self)
  end

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def add_author_to_followers
    followers << user
  end
end
