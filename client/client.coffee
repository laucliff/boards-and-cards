
App = share

# Meteor.subscribe 'allCards'
# Meteor.subscribe 'allBoards'
Meteor.subscribe 'allUsers'

Meteor.subscribe 'comments'

Deps.autorun () ->
  Meteor.subscribe 'boards'
  Meteor.subscribe 'cards'

Meteor.startup ->
  console.log 'This is client'
  Session.set 'cardDragging', null