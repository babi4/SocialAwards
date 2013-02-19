SocialAwards.Person = DS.Model.extend({
  first_name   : DS.attr 'string'
  last_name    : DS.attr 'string'
  score        : DS.attr 'number'
  nomineeScore : DS.hasMany 'SocialAwards.NomineeScore'
  name         : Ember.computed ->
    "#{@get 'first_name'} #{@get 'last_name'}"
  .property('first_name', 'last_name')

  update_score: (new_score) ->
    console.log 'update_score'
    @set 'score', new_score
});
