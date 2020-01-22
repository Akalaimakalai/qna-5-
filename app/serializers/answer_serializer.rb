class AnswerSerializer < ActiveModel::Serializer
  attributes %i[ id body user_id created_at updated_at ]
end
