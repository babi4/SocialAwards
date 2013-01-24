class Nominees
  def initialize(nomination)
    @nomination = nomination
    @nominees = []
    @nominees_ids_to_scores = {}
    if nomination.nominees_type == 'user'
      @nominees_class = User
    else
      throw "nominees_type #{nomination.nominees_type} not implemented"
#      @nominees_class = Public
    end
  end

  def get(page=0)
    get_ids page
    return [] if page > 0
    fetch_nominees nominees_ids_to_scores.keys
    merge_nominees_and_scores
  end

  def get_ids(page=0)
    page = page.to_i
    return [] if page < 0
    offset = page * nominees_per_page
    nominees_a = $redis.zrevrangebyscore "nomination:#{@nomination.id}:nominants", '+inf', 0, {
          :limit => [offset, @nominees_per_page],
        :withscores => true
    }
    nominees = {}
    nominees_a.in_groups_of(2) do |array|
      nominee_id = array.first.to_i
      score     = array.last.to_i
      nominees[nominee_id] = score
    end
    @nominees_ids_to_scores = nominees
  end

  def fetch_nominees(ids=[])
    @nominees = @nominees_class.fetch_by_ids ids
  end

  def merge_nominees_and_scores
    @nominees.each do |nominee|
      nominee.serializable_hash.merge(:score => nominees_ids_to_scores[nominee.id])          
    end
  end

  def nominees_per_page
    10
  end


end

