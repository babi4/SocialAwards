class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
			t.string   :name, :null => false, :unique => true
			t.string   :social_newtwork, :null => false
			t.datetime :start_date, :null => false
			t.datetime :end_date,   :null => false
			t.datetime :expert_voting_end_date, :null => false
			t.text :comment
      t.timestamps
    end
  end
end
