App = share

class CardsCollection extends Meteor.Collection
  createCard: (newData, callback) ->

    data = _.defaults {}, newData,
      content: 'New Card'
      board_id: App.Boards.getDefaultBoard()._id
      user_id: Meteor.user()?._id

    data.content = 'New Card' if data.content?.length < 1

    ordinal = @find(board_id: data.board_id).count()
    data.ordinal = ordinal if not data.ordinal?

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


Meteor.methods
  insertCard: (cardId, boardId, index, callback) ->

    # Make room for new card

    App.Cards.update
      board_id: boardId
      ordinal:
        $gt: index || 0
    ,
      $inc:
        ordinal: 1
    ,
      multi: true

    # Insert card

    App.Cards.update cardId,
      $set:
        board_id: boardId
        ordinal: index || 0

    # Normalize ordinals

    App.Cards.find
      board_id: boardId
    ,
      sort:
        ordinal: 1
    .forEach (card, index) ->
      App.Cards.update card._id,
        $set:
          ordinal: index