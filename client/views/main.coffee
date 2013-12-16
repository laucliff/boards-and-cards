App = share

Template.main.helpers
  boards: ->
    App.Boards.getAllowedBoards()

  myBoard: ->
    if Meteor.user()?
      App.Boards.getMyBoard()