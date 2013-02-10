SocialAwards.NominateFormView = Ember.View.extend
  keyUp : (data) ->
    @controller.fetch_variants()
  #TODO обясните мне как эвент сюда проходит?