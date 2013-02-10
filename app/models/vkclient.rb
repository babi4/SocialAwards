require "net/http"

class Vkclient
  def self.fetch_profile(uid)
    custom_parse_uri "uid=#{uid}&fields=uid,first_name,last_name,screen_name,sex,bdate"
  end

  def self.custom_parse_uri(uri_params)
    uri = URI.parse(URI.encode("https://api.vk.com/method/users.get?#{uri_params}&#{access_token}"))

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
#    http.cert = OpenSSL::X509::Certificate.new(pem)
#    http.key = OpenSSL::PKey::RSA.new(pem)
#    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    puts response.body
    body = JSON.parse response.body
    if body["error"]
      #LOG ERROR
      false
    else
      body['response']
    end
  end

  def self.access_token
#   TODO get_access_token
    "access_token=72ac21244d5ce2470be58cc00e9aefe9b7032ee5141409ed575821e25e296a66a682ce9962a6c302a0545"
  end

end

#https://api.vk.com/method/getProfiles?uid=66748&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3