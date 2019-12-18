class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.references :user, foreign_key: true
      t.references :score, foreign_key: true
      t.timestamps
    end
  end
end
