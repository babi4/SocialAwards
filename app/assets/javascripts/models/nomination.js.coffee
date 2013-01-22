SocialAwards.Nomination = Em.Object.extend({
  url : (() ->
    "/nominations/#{@.get 'id'}"
  ).property 'id'
});


SocialAwards.Nomination.reopenClass({
  find: (id) ->
    nom = SocialAwards.Nomination.create name : 'test', id : id
    nom
  findAll: () ->
    console.log "CALL FIND ALL"
});