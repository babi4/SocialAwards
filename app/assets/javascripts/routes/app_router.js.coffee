SocialAwards.Router = Ember.Router.extend
  location : 'history'

SocialAwards.Router.map () ->
  @resource 'nominations'
  @resource 'nomination', path: '/nominations/:nomination_id'
  #TODO make it nested ^^

SocialAwards.NominationsRoute = Ember.Route.extend
  model : () ->
    if window.nominations
      @store.loadMany SocialAwards.Nomination, window.nominations
    else
      SocialAwards.Nomination.find()

  setupController: (controller, model) ->
    #Be carefull with this
    controller.set 'content', SocialAwards.Nomination.all().toArray()

SocialAwards.ApplicationRoute = Ember.Route.extend
  setupController: () ->
    @controllerFor('auth').set 'current_user', window.current_user



SocialAwards.NominationRoute = Ember.Route.extend
  model : (params) ->
    if window.nomination_info?.nomination?.id is (params.nomination_id - 0)
      @store.loadMany SocialAwards.Nominee, window.nomination_info.nominees
      @store.load SocialAwards.Nomination, window.nomination_info.nomination
    SocialAwards.Nomination.find params.nomination_id

  setupController: (controller, model) ->
#    controller.set 'content', SocialAwards.Nomination.
    callback = controller.faye_callback.bind controller
    SocialAwards.FayeClient.subscribe model.subscribe_channel(), callback
