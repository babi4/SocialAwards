SocialAwards.SearchVariant = Ember.Object.extend
  name        : Ember.computed ->
    "#{@get 'first_name'} #{@get 'last_name'}"
  .property('first_name', 'last_name')
