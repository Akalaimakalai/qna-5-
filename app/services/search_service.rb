class SearchService
  CLASSES = {
    "Везде" => nil,
    "Вопросы" => Question,
    "Ответы" => Answer,
    "Комментарии" => Comment,
    "Пользователи" => User
  }.freeze

  def initialize(query, scope: nil)
    @query = ThinkingSphinx::Query.escape(query)
    @scope = CLASSES[scope]
  end

  def call
    return [] if @query.delete(" ").empty?
    ThinkingSphinx.search(@query, classes: [@scope])
  end
end
