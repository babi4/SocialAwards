require "bundler"


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
    log message
  end

  def log(*args)
    puts "[#{Time.now.to_f.to_s.ljust(18)} || #{Time.now.to_s}] #{args.join(' ')}"
  end

end

EM.synchrony do
  DealCheckDaemon.new
end