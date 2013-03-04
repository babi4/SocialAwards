class DaemonConnector
  class << self
    def send_to_deal_check(data)
      $daemon_transport.send 'deal_check', data.to_json
    end
  end
end

class DeamonMessage
end