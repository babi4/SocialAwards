SocialAwards.Deal = DS.Model.extend
  title: DS.attr 'string'
  body: DS.attr 'string'
  url : DS.attr 'string'
  status : 'new'


  isNew : Ember.computed ->
    (@get 'status') is 'new'
  .property 'status'

  isChecking : Ember.computed ->
    (@get 'status') is 'checking'
  .property 'status'

  isDone : Ember.computed ->
    (@get 'status') is 'done'
  .property 'status'

  isFailed : Ember.computed ->
    (@get 'status') is 'failed'
  .property 'status'


  setChecking: ->
    @set 'status', 'checking'

  setDone: ->
    @set 'status', 'done'

  setFailed: ->
    @set 'status', 'failed'
