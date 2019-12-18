class AddNullValidationToDatabase < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:answers, :body, false)
    change_column_null(:gists, :name, false)
    change_column_null(:gists, :content, false)
    change_column_null(:gists, :url, false)
    change_column_null(:links, :name, false)
    change_column_null(:links, :url, false)
    change_column_null(:medals, :name, false)
    change_column_null(:questions, :title, false)
    change_column_null(:questions, :body, false)
    change_column_null(:scores, :sum, false)
  end
end
