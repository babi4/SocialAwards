class Nomination < ActiveRecord::Base
  attr_accessible :name, :voting_type, :voting_constraints, :award_id
  
  def get_hash_with_nominees(page=0)
    self.serializable_hash.merge(:nominees => Nominees.new(self).get)
  end

  def get_nominee_score(nominee_id)
    $redis.zscore sset_name, nominee_id
  end

  def sset_name
    "nomination:#{self.id}:nominants"
  end





  def self.find_nominatios_with_nominee_json(screen_name, id)
    nomination_ids = $redis.smembers "nominee:#{screen_name}:nominations"
    fetch_by_ids_with_score_json nomination_ids, nominee_id
  end


  def self.fetch_by_ids_with_score_json(ids=[], nominee_id)
    nominations = fetch_by_ids ids
    nominations.each do |nomination|
      nomination.serializable_hash.merge(:score => nomination.get_nominee_score(nominee_id))
    end
  end

  def self.fetch_by_ids(ids=[])
    nominations_table = User.arel_table
    Nomination.where nominations_table[:id].in ids
  end

end
