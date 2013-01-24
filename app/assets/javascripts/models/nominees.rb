class Nominees
  def initialize(nomination)
    @nomination = nomination
    if nomination.nominees_type == 'user'
      @nominees_class = User
    else
      throw "nominees_type #{nomination.nominees_type} not implemented"
#      @nominees_class = Public
    end
  end

  def get(page=0)
    ids = get_ids page
    return [] if page > 0
    fetch_nominees ids
  end

  def get_ids(page=0)
    page = page.to_i
    return [] if page < 0
    offset = page * nominees_per_page
    $redis.zrevrangebyscore "nomination:#{@nomination.id}:nominants", '+inf', 0, {
          :limit => [offset, @nominees_per_page],
        :withscores => true
    }
  end

  def fetch_nominees(ids=[])
    @nominees_class.fetch_by_ids ids
  end

  def nominees_per_page
    10
  end


end

#TODO
#2 add Users
#2 add fetch_by_ids in User class
