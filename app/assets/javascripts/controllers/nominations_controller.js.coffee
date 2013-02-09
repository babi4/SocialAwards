SocialAwards.NominationsController = Ember.ArrayController.extend
  faye_callback: (data) ->
    nomination = SocialAwards.Nomination.find data.nomination_id
    nominee = nomination.get('nominees').find (n) ->  n.get('id') is (data.nominee_id + "") # TODO realy find
    nominee.update_score data.new_score
  
#  createNomination: (nomination) ->
#    nomination = SocialAwards.Nomination.create nomination
#    @pushObject nomination
#
#
#  fill_by_object: (nomination_arr=[]) ->
#    for nomination in nomination_arr
#      @createNomination nomination
#    
