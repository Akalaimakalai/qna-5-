class SearchService
  CLASSES = {
    "Везде" => nil,
    "Вопросы" => Question,
    "Ответы" => Answer,
    "Комментарии" => Comment,
    "Пользователи" => User
  }.freeze

  def self.do_search(user_string, search_klass)
    return [] if user_string.delete(" ").empty? || !CLASSES.include?(search_klass)
    ThinkingSphinx.search(user_string, classes: [CLASSES[search_klass]])
  end
end
