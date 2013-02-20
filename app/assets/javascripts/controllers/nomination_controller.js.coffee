SocialAwards.NominationController = Ember.ObjectController.extend
  faye_callback: (data) ->
    nominees_score = @find_nominee_by_id data.nominee_id
    nominees_score.update_score data.new_score

  find_nominee_by_id: (nominee_id) ->
    @content.get('nominees_scores').find (nominee_score) ->  
      nominee = nominee_score.get 'nominee'
      ((nominee.get 'id') + "") is (nominee_id + "") #REALY TO STRING?
