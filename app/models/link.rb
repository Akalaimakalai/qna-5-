class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :validate_url, on: :create

  URL = /^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)/i.freeze

  private

  def validate_url
    errors.add(:url, "it's not a url") unless url =~ URL
  end
end
