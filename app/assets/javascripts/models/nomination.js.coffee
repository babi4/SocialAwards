SocialAwards.Nomination = DS.Model.extend({
  url : (() ->
    "/nominations/#{@.get 'id'}"
  ).property 'id'
});


SocialAwards.Nomination.reopenClass({
  find: (id) ->
    #TODO here
    #@_super()

  findAll: () ->
    console.log "CALL FIND ALL"
});