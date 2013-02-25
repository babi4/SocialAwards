#MUST IMPLEMENT SEND METHOD
class DaemonTransport 
  def initialize
    puts "Opening ZMQ connection"    
    @context = ZMQ::Context.new 1    
  end
  def send(addr, data)
    outbound = @context.socket ZMQ::DOWNSTREAM
    outbound.connect "IPC://tmp/"
    result = outbound.send data
    outbound.close
    result
  rescue => e
    puts "Error #{e.inspect}"
  end
end


$daemon_transport = DaemonTransport.new