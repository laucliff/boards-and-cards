App = share

Template.app.helpers
  showLogin: ->
    Session.get 'showLogin'

Template.app.events
  'click .login-backdrop': (e, t) ->
    Session.set 'showLogin', !Session.get('showLogin')

  'mousemove': (e, t) ->
    drag = Session.get 'cardDragging'
    if drag and not drag.dropping
      $el = $('.card.dragging')

      # Position draggable x relative to original grab point, but center draggable Y about current cursor position
      posX = e.pageX-drag.offset.x
      posY = e.pageY-($el.height()/2)

      # Immediately update the css position of dragging element.
      $el.css
        left: posX + 'px'
        top: posY + 'px'

      # Session variable for drag element re-renders.
      Session.set 'cardDragCoords',
        x: posX
        y: posY

      # Get the element beneath the object being dragged.
      # Note: This causes mousemove to fire continuously (even on not mousemove.)
      # Same issue seems to happen with native dragmove event.

      $el.hide()
      targetElement = document.elementFromPoint e.pageX, e.pageY
      $el.show()

      $(targetElement).trigger 'showPlaceholder', 
        x: e.pageX
        y: e.pageY

  'mouseup': (e, t) ->
    # Drop is handled in a Deps.autorun in cards.coffee
    drag = Session.get 'cardDragging'
    if drag and not drag.dropping
      drag.dropping = true
      Session.set 'cardDragging', drag

Template.app.rendered = ->
  $el = $('.app')
  $el.unbind('showPlaceholder')
  $el.bind 'showPlaceholder', (event, data) =>
    # Triggering here means the the cursor is not inside a cards collection.
    # (stopPropagation() is called in boards.coffee)
    # Clear placeholder.
    Session.set 'cardPlaceholderTarget', null