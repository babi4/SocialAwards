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
    deal = SocialAwards.Deal.find message.deal_id
    deal.set 'isChecked', false

      # ...
    