SocialAwards.Router = Ember.Router.extend
  location : 'history'

SocialAwards.Router.map () ->
  @resource 'nominations'
  @resource 'nomination', path: '/nominations/:nomination_id'


SocialAwards.NominationsRoute = Ember.Route.extend
  model : () ->
    SocialAwards.Nomination.find()

SocialAwards.ApplicationRoute = Ember.Route.extend
  setupController: () ->
    @controllerFor('auth').set 'current_user', window.current_user



SocialAwards.NominationRoute = Ember.Route.extend
  setupController: (controller, model) ->
    callback = controller.faye_callback.bind controller
    SocialAwards.FayeClient.subscribe model.subscribe_channel(), callback
