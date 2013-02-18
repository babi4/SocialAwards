SocialAwards.NomineeScore = DS.Model.extend({
  score  :     DS.attr 'number'
  nomination : DS.belongsTo 'SocialAwards.Nomination'
#  person : DS.belongsTo 'SocialAwards.Person'
#  public : DS.belongsTo 'SocialAwards.Public'
});
