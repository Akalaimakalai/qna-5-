class AnswerSerializer < ActiveModel::Serializer
  attributes %i[ id body created_at updated_at ]
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
  belongs_to :user
end
