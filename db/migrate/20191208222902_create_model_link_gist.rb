class CreateModelLinkGist < ActiveRecord::Migration[5.2]
  def change
    create_table :link_gists do |t|
      t.string :name
      t.string :content
      t.string :url
      t.references :link, foreign_key: true
    end
  end
end
