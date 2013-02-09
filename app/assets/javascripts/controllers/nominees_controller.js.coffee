SocialAwards.NomineesController = Ember.ArrayController.extend
  vote : (nominee) ->
    #CHECH CUR
    user = @controllerFor('auth').get 'current_user'
    nomination = @controllerFor('nomination').get 'model'
    if user
      jQuery.ajax
        type : "POST"
        url : '/vote'
        data :
          nomination_id : nomination.id
          nominee_id    : nominee.get 'id'
          vote_score    :  1
      .success (resp) =>
        if resp.error is false
          @after_vote(resp.data, nominee)
        else
          alert "Vote error: #{resp.error}"

    else
      alert "Залогинься мудило"
      return

  after_vote: (data, nominee) -> 
    window.n = nominee
    nominee.update_score data.new_score
