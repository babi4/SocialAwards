SocialAwards.Router = Ember.Router.extend
  location : 'history'

SocialAwards.Router.map () ->
  @resource 'nominations'


SocialAwards.NominationsRoute = Ember.Route.extend
  model : () ->
    SocialAwards.Nomination.find()