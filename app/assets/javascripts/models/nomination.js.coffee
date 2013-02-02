SocialAwards.Nomination = DS.Model.extend({
  name     : DS.attr  'string'
  award_id : DS.attr  'number'
  nominees : DS.hasMany 'SocialAwards.Nominee'
  url : (() ->
    "/nominations/#{@.get 'id'}"
  ).property 'id'
});


SocialAwards.Nomination.reopenClass({
  findAll: () ->
    console.log "CALL FIND ALL"
});