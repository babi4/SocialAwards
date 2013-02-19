SocialAwards.NomineesScoresController = Ember.ArrayController.extend
  vote : (nominee_and_score) ->
    console.log arguments
    #CHECH CUR
    user = @controllerFor('auth').get 'current_user'
    nomination = @controllerFor('nomination').get 'model'
    nominee = nominee_and_score.get 'nominee'
    if user
      jQuery.ajax
        type : "POST"
        url : '/vote'
        data :
          nomination_id : nomination.get 'id'
          nominee_id    : nominee.get 'id'
          vote_score    :  1
      .success (resp) =>
        if resp.error is false
          @after_vote(resp.data, nominee_and_score)
        else
          alert "Vote error: #{resp.error}"

    else
      alert "Залогинься мудило"
      return

  after_vote: (data, nominee_and_score) -> 
    nominee_and_score.update_score data.new_score
