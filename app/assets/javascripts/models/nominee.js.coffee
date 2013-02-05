SocialAwards.Nominee = DS.Model.extend({
  first_name  : DS.attr 'string'
  last_name   : DS.attr 'string'
  score       : DS.attr 'number'
  name        : Ember.computed ->
  	"#{@get 'first_name'} #{@get 'last_name'}"
  .property('first_name', 'last_name')
  nomination  : DS.belongsTo 'SocialAwards.Nomination'
});
