App = share

Template.app.showLogin = ->
  Session.get 'showLogin'

Template.app.events
  'click .login-backdrop': (e, t) ->
    Session.set 'showLogin', !Session.get('showLogin')
    
Template.main.boards = ->
  App.Boards.getAllowedBoards()

Template.main.myBoard = ->
  if Meteor.user()?
    App.Boards.getMyBoard()
