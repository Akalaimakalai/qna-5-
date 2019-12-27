class CreateComents < ActiveRecord::Migration[5.2]
  def change
    create_table :coments do |t|
      t.text :body, null: false
      t.references :user, foreign_key: true
      t.references :comentable, polymorphic: true
      t.timestamps
    end
  end
end
