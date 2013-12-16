App = share

Template.header.helpers
  numCards: ->
    App.Cards.find().count()

  numBoards: ->
    App.Boards.find().count()

  greeting: ->
    "This is boards-and-cards."