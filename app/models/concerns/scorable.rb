require 'active_support/concern'

module Scorable
  extend ActiveSupport::Concern

  included do
    after_save :create_score
    has_one :score, dependent: :destroy, as: :scorable
  end


  private

  def create_score
    # Вопрос: для коректной работы этого консёрна требуется наличие связи с юзером
    # нужно ли всвязи с этим вносить belongs_to :user в данный консёрн?
    Score.create!(author: user, scorable_type: self.class.name, scorable_id: id)
  end
end
