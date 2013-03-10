require "bundler"
require "logger"
require_relative "../app/models/vkclient.rb"#TODO to services

Bundler.require :daemons


def log(*args)
  puts "[#{Time.now.to_f.to_s.ljust(18)} || #{Time.now.to_s}] #{args.join(' ')}"
end



module DaemonMixin

  def init_rails_notifier
    env = ENV['RAILS_ENV'] || 'development'
    case env
      when 'production'
        @@rails_url = 'vkpremia.ru'
      when 'staging'
        @@rails_url = 'dev.vkpremia.ru'
      else
        @@rails_url = 'localhost:8080'
    end

    @@daemon_token = take_rails_notifier_params(env)
  end

  def take_rails_notifier_params(env)
    file_path = File.dirname(__FILE__) + '/config/daemon_token.yml'
    YAML::load(File.open(file_path))[env]
  end


  def notify_rails(url_postfix, method, params={})
    url = "http://#{@@rails_url}/#{url_postfix}/"
    params.merge! :daemon_token => @@daemon_token
    EventMachine::HttpRequest.new(url).send method.to_sym, :body => params
    #TODO check response
  end



  def establish_connection(params)
#    @connections = EventMachine::Synchrony::ConnectionPool.new(size: 5) do
#        ActiveRecord::Base.establish_connection params
#    end
    connections = ActiveRecord::Base.establish_connection params
    ActiveRecord::Base.logger = Logger.new(STDOUT) #TODO set level
    connections.connection.execute("SELECT 1") #FOR TEST
  end
  
  #TODO UNUSED
  def take_db_params(env)
    file_path = File.dirname(__FILE__) + '/config/database.yml'
    YAML::load(File.open(file_path))[env]
  end
end


class Deal < ActiveRecord::Base
  attr_accessible :body, :title, :action_type, :url
  belongs_to :target, :polymorphic => true
end

class SuccessUserDeal < ActiveRecord::Base
  attr_accessible :user, :deal
  belongs_to :user
  belongs_to :deal
end

class Person < ActiveRecord::Base
  attr_accessible :uid, :first_name, :last_name, :nickname, :sex, :bdate, :screen_name
  has_one :deals, :as => :target
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :provider, :email, :password, :password_confirmation, :remember_me, :first_name, :second_name, :nickname, :screen_name, :sex, :bdate, :expires, :expires_at, :token

  has_many :success_user_deals
  has_many :deals, :through => :success_user_deals
end



class DealCheckDaemon

  include DaemonMixin

  def initialize

    #TODO ensure reactor is running
    init_rails_notifier

    zmq = EM::ZeroMQ::Context.new 1

    upstream = zmq.socket ZMQ::UPSTREAM
    upstream.bind "ipc:///tmp/deal_check"

    upstream.on(:message) do |part|
      recieve_message part.copy_out_string
      part.close
    end

    connect_to_db
    log "Started"

    start_succ_deal_fetcher
    start_succ_deal_processor
#  rescue => e
#    puts e.inspect
  end

  def start_succ_deal_fetcher
    @suc_deal_fetcher = SuccDealFetcher.new
  end

  def start_succ_deal_processor
    if @suc_deal_fetcher
      @deal_processor = DealProcessor.new @suc_deal_fetcher, self
    else
      log "Please start SuccDealFetcher"
    end
  end


  def connect_to_db
    env = ENV['RAILS_ENV'] || 'development'
    params = take_db_params env
    raise "DBerror" if params.nil?
    establish_connection params
  end





  def recieve_message message
    messages_hash = Yajl::Parser.parse message, :symbolize_keys => true
    log messages_hash
    case messages_hash[:action_type] 
    when 'follow'
      follow = FollowerCheck.new(messages_hash[:target], messages_hash[:user]).perform
      send_to_server messages_hash[:deal_id], messages_hash[:user][:id], follow
    else
      log "Unknown action_type: #{messages_hash[:action_type]}"
    end

  end


  def send_to_server(deal_id, user_id, status)
    notify_rails "deals/#{deal_id}/report", :post, user_id: user_id, status: status
  end

end


class FollowerCheck 
  def initialize(target, user)
    @target = target
    @user = user
  end
  def perform
    if @target[:type] == 'Person'
      person_follow_check
    else
      log "Not implemented"
      false
    end

  end


  def person_follow_check
      #Check subscriptions
      #Check friends 
      subs = Vkclient.fetch_user_subscriptions @user[:uid], @user[:token]
      return false if subs == false
      if subs[:users].include? @target[:uid]
        return true
      end
      friends = Vkclient.check_user_friendship @target[:uid], @user[:token]
      return false if friends == false
      if friends.first[:friend_status] == 1
        return true
      end
      false      
  end


end

class SuccDealFetcher
  def initialize
    @suc_deals_period = 1.minute
    @timer_delay = 1.minute
    @deals = []
    @timer = false
    fetch
  end

  def fetch
    return false if @timer
    @deals = SuccessUserDeal.select(:id).where("updated_at < ?", @timer_delay.ago).map(&:id)
    if @deals.empty?
      @timer = EM::Synchrony.add_timer @timer_delay do
        @timer = false
        fetch
      end
    end
  end

  def get_random_deal
    return nil if @deals.empty?
    deal_id = @deals[rand @deals.length]
    fetch_deal deal_id
  end

  def fetch_deal(deal_id)
    deal = false
    SuccessUserDeal.transaction do
       deal = SuccessUserDeal.
          where("id = ? and updated_at < ?", deal_id,  @timer_delay.ago).
          lock(true).
          includes(:deal => {:target => {}}, :user => {}). #TODO do not include
          first
    end
    deal
  end

  def remove_deal(deal_id)
    @deals.delete_if {|c_deal_id| c_deal_id == deal_id }
  end

end


class DealProcessor
  def initialize(fetcher, parent)
    raise "Please add fetcher" unless fetcher
    @fetcher = fetcher
    @parent = parent
    @timer = false
    @timer_delay = 5.seconds
    fetch_new
  end


  def fetch_new
    return false if @timer
    deal = @fetcher.get_random_deal
    if deal
      follow = process_deal deal
      if follow
        deal.touch
      else
        send_to_server deal.id
      end
      @fetcher.remove_deal deal.id
    else
      log "No deals"
    end
    @timer = EM::Synchrony.add_timer @timer_delay do
      @timer = false
      fetch_new
    end
  end

  def process_deal sdeal
    deal = sdeal.deal
    user = sdeal.user
    target = {:uid => deal.target.uid, :type => deal.target_type }
    user = {:id => user.id, :uid => user.uid, :token => user.token}
    FollowerCheck.new(target, user).perform
  end

  def send_to_server(deal_id)
    @parent.notify_rails "success_user_deals/#{deal_id}", :delete
  rescue => e
    puts e
  end

end

EM.synchrony do
  DealCheckDaemon.new
end