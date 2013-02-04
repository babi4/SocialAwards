class AddTokenFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :token, :string,    :null => false
  	add_column :users, :expires, :boolean, :null => false
  	add_column :users, :expires_at, :date, :null => false
  end
end
