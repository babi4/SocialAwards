SocialAwards.NominateFormController = Ember.Controller.extend
  nominate_value : ""
  variants: []


  send_nominate : (uid) ->
    return false unless uid
    user = @controllerFor('auth').get 'current_user'
    if user
      nomination = @controllerFor('nomination').get 'model'

      jQuery.ajax
        type : "POST",
        url  : '/nominees'
        data : 
          nomination_id : nomination.get 'id'
          uid : uid
      .success (resp) => 
        if resp.error is false
          @add_nominee resp.data, nomination
        else
          alert resp.error
      #create record
      
    else
      alert "Залогинься, мудило"

  add_nominee: (nominee_data, nomination) ->
    if nominee_data.status is 'already_nominated'
      #TODO show nominee page
    else if nominee_data.status is 'nominated'
      nomination.add_nominee nominee_data
    else
      alert 'Error happened!'

  fetch_variants: () ->
    text = @get 'nominate_value'
    return false if text is ""
    user = @controllerFor('auth').get 'current_user'
    return false unless user
    token = user.token
    SocialAwards.VKclient.get_users 
      text: text
      clb:  @fill_variants
      clb_context: this
      token: token

  fill_variants: (total, variants) ->
    variants_arr = []
    for variant in variants
      sv = (new SocialAwards.SearchVariant).setProperties variant
      variants_arr.push sv
    @set 'variants', variants_arr

  nominate: (searchVariant) ->
    @send_nominate searchVariant.get 'uid'
    @clear_form()

  clear_form: ->
    @set 'variants', []
    @set 'nominate_value', ""
