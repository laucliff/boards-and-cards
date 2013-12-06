App = share

Meteor.startup () ->
  console.log 'this is server'

  console.log "#{App.Cards.find().count()} Cards, #{App.Boards.find().count()} Boards."

  console.log "#{Meteor.users.find().count()} Users."

Meteor.publish 'allCards', ->
  App.Cards.find()

Meteor.publish 'allBoards', ->
  App.Boards.find()

Meteor.publish 'allUsers', ->
  Meteor.users.find()