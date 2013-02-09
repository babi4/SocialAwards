FayeClient = 
  initialized : false
  get_client: ->
    @initialize() unless @initialized
    @client

  initialize: ->
    host = document.location.hostname
    port = 9292
    @client = new Faye.Client "http://#{host}:#{port}/faye"

  subscribe: (channel, callback) ->
    @get_client().subscribe channel, callback

SocialAwards.FayeClient = FayeClient