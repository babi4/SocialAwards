SocialAwards.DealsController = Ember.ArrayController.extend({
  hidden : true
  deals_loaded : false
  content: []
  toggle_view : ->
    if (@get 'hidden') is true
      @show_deals()
    else
      @hide_deals()

  show_deals: ->
    @load_items()
    @set 'hidden', false

  hide_deals: ->
    @set 'hidden', true


  load_items : ->
    console.log this
    #https://github.com/emberjs/data/pull/735
    promise = SocialAwards.Deal.find({})
    #TODO find way to catch server error
    promise.on 'didLoad', () =>
      console.log arguments
      @set 'deals_loaded', true


  check_deal: (deal) -> 
    deal.setChecking()
    console.log "/deals/#{deal.get 'id'}/check"
    jQuery.ajax
      type : 'POST',
      url : "/deals/#{deal.get 'id'}/check"


});
