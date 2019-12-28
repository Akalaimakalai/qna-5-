class Coment < ApplicationRecord
  belongs_to :user
  belongs_to :comentable, polymorphic: true

  validates :body, presence: true

  default_scope { order(created_at: :asc) }
end
