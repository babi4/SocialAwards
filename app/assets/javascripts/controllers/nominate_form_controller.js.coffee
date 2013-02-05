SocialAwards.NominateFormController = Ember.Controller.extend
  nominate_value : ""

  nominate : () ->
    user = @controllerFor('auth').get 'current_user'
    if user
      nomination = @controllerFor('nomination').get 'model'

      jQuery.ajax
        type : "POST",
        url  : '/nominees'
        data : 
          nomination_id : nomination.get 'id'
          uid : @get 'nominate_value'
      .success (resp) => 
        if resp.error is false
          @add_nominee resp.data.nominee, nomination
        else
          alert resp.error
      #create record
      
    else
      alert "Залогинься, мудило"

  add_nominee: (nominee, nomination) ->
    SocialAwards.Nominee.createRecord
      first_name : nominee.first_name
      last_name  : nominee.last_name
      score      : 0
      nomination : nomination #USE FIND AND ID
    console.log nominee

