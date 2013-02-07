SocialAwards.NomineesController = Ember.ArrayController.extend
  vote : (nominee) ->
    #CHECH CUR
    user = @controllerFor('auth').get 'current_user'
    nomination = @controllerFor('nomination').get 'model'
    if user
      jQuery.ajax
        type : "POST"
        url : 'vote'
        data :
          nomination_id : nomination.id
      .success (resp) =>
        @after_vote()
    else
      alert "Залогинься мудило"
      return

  after_vote: () -> 
    