class AddDefaultToVoters < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:scores, :voters, from: nil, to: {})
  end
end
