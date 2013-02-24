class Person < ActiveRecord::Base
  attr_accessible :uid, :first_name, :last_name, :nickname, :sex, :bdate, :screen_name

  has_many :votes, :as => :nominee

  has_one :deals, :as => :target

  # 
  def self.create_by_uid(uid)
    p_data = fetch_data_from_snetwork(uid)
    puts p_data.inspect
    if p_data
      self.create p_data.first.except(:nickname)
    else
      false
    end
  end

  def self.fetch_data_from_snetwork uid
    Vkclient.fetch_profile uid
  end

  def self.fetch_by_ids(ids=[])
    ar_table = self.arel_table
    self.where ar_table[:id].in ids
  end


  def nominations_set_name
    "nominee:#{self.screen_name}:nominations"
  end

end
