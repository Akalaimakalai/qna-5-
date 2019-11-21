class AddBestForAssociationToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :best_for, foreign_key: { to_table: :questions }
  end
end
