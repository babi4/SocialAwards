SocialAwards.Nomination = DS.Model.extend({
  name     : DS.attr  'string'
  award_id : DS.attr  'number'
  nominees_scores : DS.hasMany 'SocialAwards.NomineeScore'
#  nominees : DS.hasMany 'SocialAwards.Nominee'
  url : (() ->
    "/nominations/#{@.get 'id'}"
  ).property 'id'

  subscribe_channel: () ->
    "/nomination/#{@.get 'id'}"


  add_nominee: (nominee_data) ->
    console.log nominee_data
    #HERE
    #1. find or create nominee
    #2. add nominee score
    #3. check all
});
