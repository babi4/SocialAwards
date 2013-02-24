#MUST IMPLEMENT SEND METHOD
class DaemonTransport 
  def initialize
    context = ZMQ::Context.new 1
    puts "Opening ZMQ connection"

    @outbound = context.socket ZMQ::DOWNSTREAM
    @outbound.connect "tcp://127.0.0.1:9000"
    
  end
  def send(data)
    @outbound.send data
  end
end


$daemon_transport = DaemonTransport.new