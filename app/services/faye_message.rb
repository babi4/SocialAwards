require "net/http"

class FayeMessage
  def initialize(message_type, data)
    @message_type = message_type
    @data = data
  end

  def get_message
    case @message_type
    when :new_vote
      @message = {:channel => "/nomination/#{@data[:nomination_id]}", :data => @data}
    when :user_notify
      @message = {:channel => "/user/#{@data[:user_id]}", :data => @data}
    else
      raise "Message type #{@message_type} not implemented"
    end
  end

  def get_server
    @server_url = "http://localhost:9292/faye"
  end


  def perform_send
    #TODO use client
    puts "SEND #{@message.inspect}"
    uri = URI.parse @server_url
    Net::HTTP.post_form(uri, :message => @message.to_json)
  rescue
    puts "FAILED TO SEND"
  end

  def send
    get_message
    get_server
    perform_send
  end

end