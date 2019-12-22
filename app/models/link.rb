class Link < ApplicationRecord
  after_save :set_gist

  belongs_to :linkable, polymorphic: true
  has_one :gist, dependent: :destroy

  validates :name, :url, presence: true
  validate :validate_url, on: :create

  URL = /^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)/i.freeze

  private

  def set_gist(arg: nil)
    @client = GistService.new(client: arg)

    Gist.create!(gist_params) if @client.gist?(url)
  end

  def gist_params
    data = @client.gist.files.first.last

    { name: data.filename,
    content: data.content,
    url: "https://gist.github.com/Akalaimakalai/#{@client.gist.id}",
    link_id: id }
  end

  def validate_url
    errors.add(:url, "it's not a url") unless url =~ URL
  end
end
