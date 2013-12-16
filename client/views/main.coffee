App = share

Template.app.showLogin = ->
  Session.get 'showLogin'

Template.app.events
  'click .login-backdrop': (e, t) ->
    Session.set 'showLogin', !Session.get('showLogin')

  'mousemove': (e, t) ->
    if Session.get 'isDragging'
      $el = $(t.dragTarget)

      # Position draggable x relative to original grab point, but center draggable Y about current cursor position
      posX = e.pageX-t.dragOffset.x
      posY = e.pageY-($el.height()/2)

      $el.css
        left: posX + 'px'
        top: posY + 'px'

      # Get the element beneath the object being dragged.
      # $el.hide()
      # console.log document.elementFromPoint e.pageX, e.pageY
      # $el.show()

Template.app.rendered =  ->

  # Element dragging is handled on the app level in order to allow dragging anywhere in the app space.

  # Make sure there is only one drag bind
  # Note: this is not the native html5 dragstart event. Native dragstart does not support mobile.
  $('.app').unbind 'dragStart'
  $('.app').bind 'dragStart', (event, data) =>

    # Set app state as dragging
    Session.set 'isDragging', true

    # Store target being dragged and relative positioning for drag updates.
    @dragTarget = data.target
    @dragOffset = 
      x: data.clickEvent.pageX
      y: data.clickEvent.pageY

Template.main.boards = ->
  App.Boards.getAllowedBoards()

Template.main.myBoard = ->
  if Meteor.user()?
    App.Boards.getMyBoard()