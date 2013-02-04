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
    (JSON.parse response.body)['response']
  end

  def self.access_token
    "access_token=#{VKONTAKTE_ACCESS_TOKEN}"
  end

end

#https://api.vk.com/method/getProfiles?uid=66748&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3