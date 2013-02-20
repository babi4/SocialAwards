SocialAwards.NomineeScore = DS.Model.extend({
  score  :     DS.attr 'number'
  nomination : DS.belongsTo 'SocialAwards.Nomination'
  #WAITING FOR POLYMORPHISM IN EMBER DATA
  person : DS.belongsTo 'SocialAwards.Person'
  public : DS.belongsTo 'SocialAwards.Public'#FOR EXAMPLE
  #HOPE WE NEVER GET PERSON AND PUBLIC IN ONE NOMINEE SCORE
  nominee   : Ember.computed ->
    (@get 'person') || (@get 'public')
  .property('person', 'public')

  update_score: (new_score) ->
    console.log 'update_score'
    @set 'score', new_score

});
