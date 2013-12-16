App = share

Template.card.boards = ->
  App.Boards.getAllowedBoards()

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

    if not Session.get 'isDragging'
      el = t.find('.card')

      $(el).css
        'background-color': 'red'
        'position': 'fixed'
        'width': '100%'
        'z-index': 4000

      t.isDragging = true

      # dragStart handled in app template.
      $(el).trigger 'dragStart',
        clickEvent: e
        target: el