require "bundler"
require_relative "../app/models/vkclient.rb"#TODO to services

Bundler.require :daemons


class DealCheckDaemon
  def initialize

    #TODO ensure reactor is running

    zmq = EM::ZeroMQ::Context.new 1

    upstream = zmq.socket ZMQ::UPSTREAM
    upstream.bind "ipc:///tmp/deal_check"

    upstream.on(:message) do |part|
      recieve_message part.copy_out_string
      part.close
    end

    log "Started"

  end

  def recieve_message message
    messages_hash = Yajl::Parser.parse message, :symbolize_keys => true
    log messages_hash
    case messages_hash[:action_type] 
    when 'follow'
      FollowerCheck.new(messages_hash[:target], messages_hash[:user]).perform
    else
      log "Unknown action_type: #{messages_hash[:action_type]}"
    end

  end

  def log(*args)
    puts "[#{Time.now.to_f.to_s.ljust(18)} || #{Time.now.to_s}] #{args.join(' ')}"
  end

end


class FollowerCheck 
  def initialize(target, user)
    @target = target
    @user = user
  end
  def perform
    if @target[:type] == 'Person'
      #Check subscriptions
      #Check friends 
      find = false
      subs = Vkclient.fetch_user_subscriptions @user[:uid], @user[:token]
      return false if subs == false
      if subs[:users].include? @target[:uid]
        find = true
      else
        find = false
      end
      if find == false
        friends = Vkclient.check_user_friendship @target[:uid], @user[:token]
        if friends.first[:friend_status] == 1
          find = true
        else
          find = false
        end
      end
      puts "FIND: #{find}"
    else
      puts "Not implemented"
   end

  end
end

EM.synchrony do
  DealCheckDaemon.new
end