App = share

class CardsCollection extends Meteor.Collection
  createCard: (newData, callback) ->

    data = _.defaults {}, newData,
      content: 'New Card'
      board_id: App.Boards.getDefaultBoard()._id
      user_id: Meteor.user()?._id

    data.content = 'New Card' if data.content?.length < 1

    @insert data, callback

  updateCard: (id, newData, callback) ->

    @update id, $set: newData, callback

  destroyCard: (id, callback) ->
    @remove id, callback

  moveCard: (cardId, boardId, callback) ->

    @updateCard cardId, board_id: boardId, callback


App.Cards = Cards = new CardsCollection 'cards'

Cards.allow
  insert: ->
    true

  update: ->
    true

  remove: ->
    true