class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :title, :null => false
      t.text :body, :null => false
      t.string :action_type, :null => false
      t.string :url, :null => false
      t.references :target, :polymorphic => true, :null => false

      t.timestamps
    end
  end
end
