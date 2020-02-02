ThinkingSphinx::Index.define :question, with: :active_record do
  #fields - по полям непосредственно производится поиск документов(объектов)
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :author, sortable: true

  #attributes - по аттрибутам не производится поиск, но задаётся сортировка(группировка)
  has user_id, created_at, updated_at
end
