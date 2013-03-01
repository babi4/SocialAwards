class CreateSuccessUserDeals < ActiveRecord::Migration
  def change
    create_table :success_user_deals do |t|
      t.integer :user_id, :null => false
      t.integer :deal_id, :null => false
      t.timestamps
    end
  end
end
