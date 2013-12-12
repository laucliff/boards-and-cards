App = share

Template.main.boards = ->
  App.Boards.getAllowedBoards()

Template.main.myBoard = ->
  if Meteor.user()?
    App.Boards.getMyBoard()