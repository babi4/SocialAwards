class SuccessUserDeal < ActiveRecord::Base
  attr_accessible :user, :deal
  belongs_to :user
  belongs_to :deal
end
