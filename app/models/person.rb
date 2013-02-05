class Person < ActiveRecord::Base
  attr_accessible :uid, :first_name, :last_name, :nickname, :sex, :bdate, :screen_name
  # 
  def self.create_by_uid(uid)
    p_data = fetch_data_from_snetwork(uid).first
    puts p_data
    self.create p_data.except(:nickname)
  end

  def self.fetch_data_from_snetwork uid
    Vkclient.fetch_profile uid
  end

  def self.fetch_by_ids(ids=[])
    ar_table = self.arel_table
    self.where ar_table[:id].in ids
  end

end
