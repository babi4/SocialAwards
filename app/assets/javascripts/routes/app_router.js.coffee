SocialAwards.Router = Ember.Router.extend
  location : 'history'

SocialAwards.Router.map () ->
  @resource 'nominations'
  @resource 'nomination', path: '/nominations/:nomination_id'


SocialAwards.NominationsRoute = Ember.Route.extend
  model : () ->
    SocialAwards.Nomination.find()



#SocialAwards.NominationRoute = Ember.Route.extend
#  model : () ->
#    SocialAwards.Nomination.find()
