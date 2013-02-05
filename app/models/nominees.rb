class Nominees
  def initialize(nomination)
    @nomination = nomination
    @nominees = []
    @nominees_ids_to_scores = {}
    if nomination.nominees_type == 'user'
      @nominees_class = Person
    else
      throw "nominees_type #{nomination.nominees_type} not implemented"
#      @nominees_class = Public
    end
  end

  def get(page=0)
    get_ids page
    return {} if page < 0
    puts @nominees_ids_to_scores
    fetch_nominees @nominees_ids_to_scores.keys
    merge_nominees_and_scores
    return_hash
  end

  def get_ids(page=0)
    page = page.to_i
    if page < 0
      @nominees_ids_to_scores = {}
      return
    end
    offset = page * nominees_per_page
    nominees_a = $redis.zrevrangebyscore @nomination.sset_name, '+inf', 0, {
        :limit => [offset, nominees_per_page],
        :withscores => true
    }
    nominees = {}

    nominees_a.each do |nominee|
      nominee_id = nominee.first.to_i
      score     = nominee.last.to_i
      nominees[nominee_id] = score
    end
    @nominees_ids_to_scores = nominees
  end

  def fetch_nominees(ids=[])
    @nominees = @nominees_class.fetch_by_ids ids
  end

  def merge_nominees_and_scores
    @nominees = @nominees.map do |nominee|
      puts nominee
      nominee.serializable_hash.merge(:score => @nominees_ids_to_scores[nominee.id])          
    end
  end

  def return_hash
    hsh = Hash.new
    @nominees.each do |nominee|
      hsh[nominee['id']] = nominee
    end
    hsh
  end


  def nominees_per_page
    10
  end


end

