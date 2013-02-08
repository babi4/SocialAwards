class Award < ActiveRecord::Base
  attr_accessible :id, :name, :social_newtwork, :start_date, :end_date, :expert_voting_end_date

  def self.get_current
    self.new :id => 1, :name => :VK #TODO fill
  end
end
