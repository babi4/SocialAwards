class Deal < ActiveRecord::Base
  attr_accessible :body, :title, :action_type, :url
  belongs_to :target, :polymorphic => true
end
