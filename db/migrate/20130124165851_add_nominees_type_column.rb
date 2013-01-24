class AddNomineesTypeColumn < ActiveRecord::Migration
  def change
    add_column :nominations, :nominees_type, :string, :null => false, :default => :user
  end
end
