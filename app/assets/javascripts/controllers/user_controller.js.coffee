SocialAwards.UserController = Ember.ObjectController.extend
  content : {}
  subscribe_channel: Ember.computed ->
    "/user/#{@get 'id' }"
  .property 'id'

  faye_subscribe : ->
    SocialAwards.FayeClient.subscribe (@get 'subscribe_channel'), (message) => @faye_callback message

  faye_callback: (message) ->
    return false unless message.action
    switch message.action
      when 'deal_check'
        @deal_check_action message
      else
        console.log "Unknown message action #{message.action}"

  deal_check_action: (message) ->
    console.log message
    deals = SocialAwards.Deal.filter (deal) -> (deal.get 'id') is ( message.deal_id + "") #TODO not string
    deal = deals.toArray()[0]
    deal.set 'status', false if deal
    if message.status is 'success'
      deal.setDone()
    else
      #TODO mb alert? 
      deal.setFailed()
      # ...
    
    