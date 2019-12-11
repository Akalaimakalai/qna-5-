class CreateGistModel < ActiveRecord::Migration[5.2]
  def change
    create_table :gists do |t|
      t.string :name
      t.string :content
      t.string :url
      t.references :link, foreign_key: true
    end
  end
end
