App = share

Template.main.helpers
  boards: ->
    App.Boards.getDeskBoards()

  myBoard: ->
    if Meteor.user()?
      App.Boards.getMyBoard()