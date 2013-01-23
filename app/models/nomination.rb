class Nomination < ActiveRecord::Base
  # attr_accessible :title, :body
  # 
  # 
  # 
  
  def get_nominees(page=0)
  	page = page.to_i
  	return [] if page > 0
  	offset = page * nominees_per_page
  	$redis.zrevrangebyscore "nomination:#{self.id}:nominants", '+inf', 0,{
        :limit => [offset, @nominees_per_page],
        :withscores => true
      }
  end


  def nominees_per_page
  	10
  end


end
