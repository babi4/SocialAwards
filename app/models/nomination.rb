class Nomination < ActiveRecord::Base
  # attr_accessible :title, :body
  # 
  # 
  # 
  
  def get_hash_with_nominees(page=0)
  	Nominees.new(self).get
  end


end
