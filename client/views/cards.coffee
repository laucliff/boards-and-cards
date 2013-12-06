App = share

Template.card.boards = ->
  App.Boards.find()

Template.card.events
  'click .update-card': (e, t) ->
    newContent = t.find('input:text').value

    App.Cards.updateCard this._id, content: newContent

  'click .delete-card': (e, t) ->
    App.Cards.destroyCard this._id

  'click .move-card': (e, t) ->
    newBoardId = t.find('.select-board').value

    App.Cards.moveCard this._id, newBoardId