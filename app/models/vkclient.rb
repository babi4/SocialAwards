require "net/http"
require "yajl"

class Vkclient
  def self.fetch_profile(uid)
    perform_request 'users.get', "uid=#{uid}&fields=uid,first_name,last_name,screen_name,sex,bdate"
  end


  def self.fetch_user_friends(uid, fields="uid,first_name,last_name,screen_name,sex,bdate")
    perform_request 'friends.get', "uid=#{uid}&fields=#{fields}"
  end

  def self.check_user_friendship(uids, token)
    perform_request 'friends.areFriends', "uids=#{uids}", token
  end

  def self.fetch_user_subscriptions(uid, token)
    perform_request 'subscriptions.get', "uid=#{uid}&count=100", token
  end

  def self.fetch_user_groups(uid, filter=nil)
    params = "uid=#{uid}&count=1000"
    if filter
      #TODO filter filter parameter
      params += filter
    end
    perform_request 'groups.get', params
  end

  def self.perform_request(method, uri_params, access_token=nil)
    puts uri_params
    puts access_token
    access_token ||= shared_access_token
    url = "https://api.vk.com/method/#{method}?#{uri_params}&access_token=#{access_token}"
    puts url
    uri = URI.parse(URI.encode(url))

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
#    http.cert = OpenSSL::X509::Certificate.new(pem)
#    http.key = OpenSSL::PKey::RSA.new(pem)
#    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    puts response.body
    body = Yajl::Parser.parse response.body, :symbolize_keys => true
    if body[:error]
      #TODO LOG ERRORS
      false
    else
      body[:response]
    end
  rescue => e
    puts "Error: #{e.inspect}"
    false
  end

  def self.shared_access_token
    "72ac21244d5ce2470be58cc00e9aefe9b7032ee5141409ed575821e25e296a66a682ce9962a6c302a0545"
  end

end

#https://api.vk.com/method/getProfiles?uid=66748&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3