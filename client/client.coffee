
App = share

Meteor.subscribe 'allCards'
Meteor.subscribe 'allBoards'
Meteor.subscribe 'allUsers'
Meteor.subscribe 'visibleComments'

Meteor.startup ->
  console.log 'This is client'