require "bundler"
require_relative "../app/models/vkclient.rb"#TODO to services

Bundler.require :daemons


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


  def notify_rails(url_postfix, params)
    url = "http://#{@@rails_url}/#{url_postfix}/"
    params.merge! :daemon_token => @@daemon_token
    EventMachine::HttpRequest.new(url).post :body => params
    #TODO check response
  end

  def log(*args)
    puts "[#{Time.now.to_f.to_s.ljust(18)} || #{Time.now.to_s}] #{args.join(' ')}"
  end


  def establish_connection(params)
#    @connections = EventMachine::Synchrony::ConnectionPool.new(size: 5) do
#        ActiveRecord::Base.establish_connection params
#    end
    @connections = ActiveRecord::Base.establish_connection params
    @connections.connection.execute("SELECT 1") #FOR TEST
  end
  
  #TODO UNUSED
  def take_db_params(env)
    file_path = File.dirname(__FILE__) + '/config/database.yml'
    YAML::load(File.open(file_path))[env]
  end
end


class Deal < ActiveRecord::Base
  attr_accessible :body, :title, :action_type, :url
#  belongs_to :target, :polymorphic => true
end

class SuccessUserDeal < ActiveRecord::Base
  attr_accessible :user, :deal
  belongs_to :user
  belongs_to :deal
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
    start_succ_deal_fetcher
    start_succ_deal_processor

    log "Started"

  end

  def start_succ_deal_fetcher
    
  end

  def start_succ_deal_processor
    
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
    notify_rails "deals/#{deal_id}/report", user_id: user_id, status: status
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
      puts "Not implemented"
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

EM.synchrony do
  DealCheckDaemon.new
end