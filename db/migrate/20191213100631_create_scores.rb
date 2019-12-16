class CreateScores < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Schema.define do
      enable_extension 'hstore' unless extension_enabled?('hstore')
      create_table :scores do |t|
        t.references :author, foreign_key: { to_table: :users }
        t.references :scorable, polymorphic: true
        t.integer :sum, default: 0
        t.hstore 'voters'
        t.timestamps
      end
    end
  end
end
