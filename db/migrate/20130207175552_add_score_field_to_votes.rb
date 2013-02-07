class AddScoreFieldToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :score, :integer, :null => false
  end
end
