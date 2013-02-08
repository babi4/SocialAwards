class Vote < ActiveRecord::Base
  attr_accessible :award_id, :user_id, :score
end

  # t.integer "award_id",      :null => false
  #   t.integer "nomination_id", :null => false
  #   t.integer "user_id",       :null => false
  #   t.integer "nominee_id",    :null => false
  #   t.string  "nominee_type",  :null => false
  #   t.date    "created_at",    :null => false
  #   t.integer "score",         :null => false