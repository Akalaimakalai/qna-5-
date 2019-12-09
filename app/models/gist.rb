class Gist < ApplicationRecord
  belongs_to :link

  validates :name, :content, :url, presence: true
end
