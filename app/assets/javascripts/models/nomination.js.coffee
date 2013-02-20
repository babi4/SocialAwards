SocialAwards.Nomination = DS.Model.extend({
  name          : DS.attr  'string'
  award_id      : DS.attr  'number'
  nominees_type : DS.attr 'string'
  nominee_model : Ember.computed ->
    if (@get 'nominees_type') is 'person'
      SocialAwards.Person
    else if (@get 'nominees_type') is 'public'
      SocialAwards.Public
  .property 'nominees_type'

  nominees_scores : DS.hasMany 'SocialAwards.NomineeScore'
#  nominees : DS.hasMany 'SocialAwards.Nominee'
  url : (() ->
    "/nominations/#{@.get 'id'}"
  ).property 'id'

  subscribe_channel: () ->
    "/nomination/#{@.get 'id'}"

  add_nominee: (nominee_data) ->
    nominee = (@get 'nominee_model').createRecord nominee_data.nominee #TODO check for exists!
    nominee_score = SocialAwards.NomineeScore.createRecord score: nominee_data.nominee_score.score #TODO why we cant connect it by id??
    nominee_score.set (@get 'nominees_type'), nominee
    nominee_score.set 'nomination', this
});
