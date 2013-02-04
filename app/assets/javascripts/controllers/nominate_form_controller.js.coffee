SocialAwards.NominateFormController = Ember.Controller.extend({
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
      #create record
      
    else
      alert "Залогинься, мудило"
});
