VKclient = 
  #TODO params to object
  get_users : (text, clb, clb_context, token) ->
    new VKrequest 'get_users', text, clb, clb_context, token

class VKrequest
  constructor: (@type, @text, @clb, @clb_context, @token) ->

    if @type is 'get_users'
      @get_users()
    else
      alert "Request type not implemented"

  get_users: ->
    callback_name = @generate_callback()
    script = document.createElement 'SCRIPT'
    script.src = "https://api.vk.com/method/users.search?q=#{@text}&access_token=#{@token}&callback=#{callback_name}"
    (document.getElementsByTagName "head")[0].appendChild script

  generate_callback: ->
    rand = Math.round (Math.random 1000) * 1000 
    name = "request_callback_#{rand}"
    VKclient[name] = (result) =>
      @parse_users_result result
    "SocialAwards.VKclient.#{name}"

  parse_users_result: (result) ->
    if result.error
      #TODO  if token expired -> log out
      alert result.error.error_msg
    total = result.response.shift()
    users = result.response
    @clb.call @clb_context, total, users

SocialAwards.VKclient = VKclient

# var script = document.createElement('SCRIPT'); 

# script.src = "https://api.vk.com/method/getProfiles?uid=66748&access_token=533bacf...&callback=callbackFunc"; 

# document.getElementsByTagName("head")[0].appendChild(script); 

# function callbackFunc(result) { 
#   alert(result); 
#} 
