SocialAwards.Nominee = DS.Model.extend({
  name : DS.attr 'string'
  nomination : DS.belongsTo 'SocialAwards.Nomination'
});
