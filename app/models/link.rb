class Link < ApplicationRecord
  before_save :set_gist

  has_one :gist, class_name: "Link::Gist", foreign_key: "link_id"
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :validate_url, on: :create

  attr_reader :client

  URL = /^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)/i.freeze

  def gist?
    @client = GistService.new
    @client.gist?(url)
  end

  private

  def validate_url
    errors.add(:url, "it's not a url") unless url =~ URL
  end

  def set_gist
    gist = Link::Gist.create(@client.gist) if gist?
  end
end

class Link::Gist < ApplicationRecord

  belongs_to :link, optional: true

  validates :name, :content, :url, presence: true

  attr_reader :name, :content, :url

  def initialize(gist)
    data = gist.files.first.last
    name = data.filename
    content = data.content
    url = "https://gist.github.com/Akalaimakalai/#{gist.id}"
  end
end
