class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :uid, :null => false
      t.string  :first_name, :null => false, :default => ""
      t.string  :second_name, :null => false, :default => ""
      t.integer :sex, :null => false
      t.string  :bdate, :null => false, :default => ""
      t.timestamps
    end
  end
end
