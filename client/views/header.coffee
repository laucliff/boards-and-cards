App = share

Template.header.numCards = () ->
  App.Cards.find().count()

Template.header.numBoards = () ->
  App.Boards.find().count()

Template.header.greeting = () ->
  "This is boards-and-cards."