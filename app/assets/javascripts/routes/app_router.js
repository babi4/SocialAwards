SocialAwards.Router = Ember.Router.extend({
  location : 'history',

  root: Ember.Route.extend({
    nominations: Ember.Route.extend({
      route: '/',

      // You'll likely want to connect a view here.
       connectOutlets: function(router) {
         console.log('11111');
         router.get('applicationController').connectOutlet('Nominations');
       }

      // Layout your routes here...
    }),
    nomination: Ember.Route.extend({
      route: '/nominations/:nomination_id',

      connectOutlets: function(router) {
         router.get('applicationController').connectOutlet('NominationDetailed');
      }


    })
  })
});

