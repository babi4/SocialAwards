SocialAwards.NominationController = Ember.ObjectController.extend
  faye_callback: (data) ->
    console.log @content.get('nominees').toArray()
    nominee = @find_nominee_by_id data.nominee_id
    nominee.update_score data.new_score

  find_nominee_by_id: (nominee_id) ->
    @content.get('nominees').find (n) ->  n.get('id') is (nominee_id + "") # TODO realy find?
