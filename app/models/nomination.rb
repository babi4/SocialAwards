class Nomination < ActiveRecord::Base
  attr_accessible :name, :voting_type, :voting_constraints, :award_id

#  self.include_root_in_json = true
  
  def get_nominees_hash(page=0)
    Nominees.new(self).get    
  end

  def get_nominee_score(nominee_id)
    $redis.zscore sset_name, nominee_id
  end

  def sset_name
    "nomination:#{self.id}:nominants"
  end

#  def nominee_nomnations_set_name
#      "nomination:#{self.id}:nominants"    
#  end
#  
#  
  def nominee_model
    if self.nominees_type == 'person'
      Person
    else
      throw "nominees_type '#{self.nominees_type}' not implemented"
    end
  end


  def get_nominee_score(n_id)
    $redis.zscore sset_name, n_id
  end


  def nominate(nominee)
    res = $redis.pipelined do
      $redis.sadd nominee.nominations_set_name, self.id #TODO maybe use id
      $redis.zadd sset_name, 0, nominee.id
    end
    res.last
  end

  def self.find_nominatios_with_nominee_json(screen_name, id)
    nomination_ids = $redis.smembers "nominee:#{screen_name}:nominations"
    fetch_by_ids_with_score_json nomination_ids, nominee_id
  end


  def self.fetch_by_ids_with_score_json(ids, nominee_id)
    nominations = fetch_by_ids ids
    nominations.each do |nomination|
      nomination.serializable_hash.merge(:score => nomination.get_nominee_score(nominee_id))
    end
  end


  def self.fetch_by_ids(ids=[])
    nominations_table = User.arel_table
    Nomination.where nominations_table[:id].in ids
  end

  def add_score(nominee, vote_score)
    return false unless nominee
    if $redis.sismember nominee.nominations_set_name, self.id
      $redis.zincrby sset_name, vote_score, nominee.id
    else
      return false
    end
  end



end

#TODO create nominee object