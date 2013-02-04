require "net/http"

class Vkclient
  def self.fetch_profile(uid)
    custom_parse_uri "uid=#{uid}"
  end

  def self.custom_parse_uri(uri_params)
    uri = URI.parse(URI.encode("http://api.vk.com/api.php?#{uri_params}&#{access_token}"))
    puts "http://api.vk.com/api.php?#{uri_params}&#{access_token}"
    response = Net::HTTP.get_response(uri)
    JSON.parse response.body
  end

  def self.access_token
    "access_token=#{VKONTAKTE_ACCESS_TOKEN}"
  end

end

#https://api.vk.com/method/getProfiles?uid=66748&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3