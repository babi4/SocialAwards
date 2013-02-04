class Person < ActiveRecord::Base
  # attr_accessible :title, :body
  # 
  def self.create_by_uid(uid)
    p_data = fetch_data_from_snetwork uid
    puts p_data 
    true
  end

  def self.fetch_data_from_snetwork uid
    Vkclient.fetch_profile uid
  end
end
