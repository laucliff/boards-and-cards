App = share

Deps.autorun ->

  # Handle card drop event. Insert the card in the currently active placeholder target if it exists.
  # Otherwise just return the card back to its original location.
  # Card dropping handled is called on mouseup in app.coffee
  drag = Session.get 'cardDragging'
  if drag?.dropping
    placeholderTarget = Session.get 'cardPlaceholderTarget'
    placeholderOrientation = Session.get 'cardPlaceholderOrientation'

    if placeholderTarget
      target = App.Cards.findOne _id: placeholderTarget

      if placeholderOrientation == 'before'
        index = target.ordinal - 1
      else
        index = target.ordinal + 1

      Meteor.call 'insertCard', drag.id, target.board_id, index


    Session.set 'cardDragging', null
    Session.set 'cardPlaceholderTarget', null

setPlaceholder = (cardId, orientation) ->
  Session.set 'cardPlaceholderTarget', cardId
  Session.set 'cardPlaceholderOrientation', orientation

Template.card.helpers
  boards: ->
    App.Boards.find()

  # This is calling render on every card every time placeholder is updated.
  # Should only update if losing a placeholder, or adding/moving a placeholder.
  hasPlaceholder: (orientation) ->

    return false if Session.get('cardPlaceholderTarget') != this._id

    placeholderOrientation = Session.get 'cardPlaceholderOrientation'

    if !orientation
      return true
    else
      return placeholderOrientation == orientation

  dragging: ->
    drag = Session.get 'cardDragging'
    if drag and drag.id == this._id and not drag.dropping
      return 'dragging'
    else
      return ''


Template.card.events
  'click .update-card': (e, t) ->
    newContent = t.find('input:text').value

    App.Cards.updateCard this._id, content: newContent

  'click .delete-card': (e, t) ->
    App.Cards.destroyCard this._id

  'click .move-card': (e, t) ->
    newBoardId = t.find('.select-board').value

    App.Cards.moveCard this._id, newBoardId

  'click': (e, t) ->
    t.mouseDown = false

    true

  'mousedown': (e, t) ->
    t.mouseDown = true

  'mouseup': (e, t) ->
    t.mouseDown = false

    true

  'mousemove': (e, t) ->
    if t.mouseDown and not Session.get 'cardDragging'
      el = t.find('.card')

      # Start dragging card.
      # Dragging behaviour handled in app.coffee
      Session.set 'cardDragging', 
        id: this._id
        offset:
          x: e.pageX
          y: e.pageY

Template.card.rendered = ->
  $el = $(@find('.card'))

  $el.unbind('showPlaceholder')
  $el.bind 'showPlaceholder', (event, data) =>
    absMedianY = $el.offset().top + $el.height()/2 #should probably cache for performance
    # Put placeholder before card if mouse is less than halfway past card, else put it after.
    if data.y < absMedianY
      setPlaceholder this.data._id, 'before'
    else if data.y > absMedianY
      setPlaceholder this.data._id, 'after'

  drag = Session.get 'cardDragging'
  if drag and drag.id == this.data._id
    coords = Session.get('cardDragCoords')
    return if not coords
    $el.css
      left: coords.x + 'px'
      top: coords.y + 'px'
