class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.references :author, foreign_key: { to_table: :users }
      t.references :scorable, polymorphic: true
      t.integer :sum, default: 0
      t.timestamps
    end
  end
end
