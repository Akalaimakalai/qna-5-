class SearchController < ApplicationController
  CLASSES = {
    "Везде" => nil,
    "Вопросы" => Question,
    "Ответы" => Answer,
    "Комментарии" => Comment,
    "Пользователи" => User
}.freeze

  def index
    @results = ThinkingSphinx.search(params[:search], classes: [find_class])
  end

  private

  def find_class
    CLASSES[params[:classes]]
  end
end
