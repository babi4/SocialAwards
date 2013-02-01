class Award < ActiveRecord::Base
  attr_accessible :name, :social_newtwork, :start_date, :end_date, :expert_voting_end_date
end
