class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :award_id, :null => false
      t.integer :nomination_id, :null => false
      t.integer :user_id, :null => false
      t.references :nominee, :polymorphic => true, :null => false
      t.date :created_at, :null => false
    end
  end
end
