App = share

Template.main.numCards = () ->
  App.Cards.find().count()

Template.main.numBoards = () ->
  App.Boards.find().count()

Template.main.greeting = () ->
  "This is test-meteor using coffeescript."

Template.main.boards = ->
  App.Boards.find()
  # App.Boards.getAllowedBoards()