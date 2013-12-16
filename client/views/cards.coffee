App = share

setPlaceholder = (cardId, orientation) ->
  Session.set 'currentCardPlaceholder',
    cardId: cardId
    orientation: orientation

Template.card.helpers
  boards: ->
    App.Boards.getAllowedBoards()

  # This is calling render on every card every time placeholder is updated.
  # Should only update if losing a placeholder, or adding/moving a placeholder.
  hasPlaceholder: (orientation) ->
    placeholder = Session.get 'currentCardPlaceholder'
    return null if placeholder?.cardId != this._id

    if !orientation 
      return true
    else
      return placeholder.orientation == orientation

  dragging: ->
    cardDragging = Session.get 'cardDragging'
    if cardDragging and cardDragging.id == this._id
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

    if not Session.get 'cardDragging'
      el = t.find('.card')

      Session.set 'cardDragging', 
        id: this._id
        offset:
          x: e.pageX
          y: e.pageY

      # dragStart handled in app template.
      $(el).trigger 'dragStart',
        clickEvent: e
        target: el

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

  cardDragging = Session.get 'cardDragging'
  if cardDragging and cardDragging.id == this.data._id
    coords = Session.get('cardDragCoords')
    return if not coords
    $el.css
      left: coords.x + 'px'
      top: coords.y + 'px'
