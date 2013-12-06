
App = share

Meteor.subscribe 'allCards'
Meteor.subscribe 'allBoards'
Meteor.subscribe 'allUsers'

Meteor.startup ->
  console.log 'This is client'