class CreateNominations < ActiveRecord::Migration
  def change
    create_table :nominations do |t|
      t.string :name, :null => false
      t.string :voting_type, :null => false
      t.string :voting_constraints, :null => false
      t.timestamps
    end
  end
end
