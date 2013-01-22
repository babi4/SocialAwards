SocialAwards.Nomination = Em.Object.extend({
  url : (() ->
    "/nomination/#{@.get 'id'}"
  ).property 'id'
});