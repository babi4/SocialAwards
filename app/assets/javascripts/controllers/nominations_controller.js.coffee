SocialAwards.NominationsController = Em.ArrayProxy.create
  content: []

  createNomination: (nomination) ->
    nomination = SocialAwards.Nomination.create nomination
    @pushObject nomination


  fill_by_object: (nomination_arr=[]) ->
    for nomination in nomination_arr
      @createNomination nomination
    
