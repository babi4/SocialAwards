SocialAwards.Router = Ember.Router.extend({
  location: 'hash',

  root: Ember.Route.extend({
    nominations: Ember.Route.extend({
      route: '/',

      // You'll likely want to connect a view here.
       connectOutlets: function(router) {
         router.get('applicationController').connectOutlet('Nominations');
       }

      // Layout your routes here...
    })
  })
});

