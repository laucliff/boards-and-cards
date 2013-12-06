App = share

class BoardsCollection extends Meteor.Collection
  getDefaultBoard: ->
    Boards.findOne(name: 'board0')

  createBoard: (newData, callback)->
    Boards.insert newData, callback

  destroyBoard: (id, callback) ->
    # Destroy cards attached to board
    App.Cards.find(board_id: id).forEach (card) ->
      App.Cards.destroyCard card._id

    # Destroy Board
    @remove id, callback

App.Boards = Boards = new BoardsCollection 'boards'

Boards.allow

  insert: (newData) ->
    return false if not newData?
    true

  update: ->
    true

  remove: (id)->
    true

if Meteor.isServer

  Meteor.startup ->
    # Bootstrap in some test data
    numTestBoards = 2
    if Boards.find().count() != numTestBoards
      Boards.find().forEach (board) ->
        Boards.destroyBoard board._id
      Boards.createBoard name: "board#{n}" for n in [0..numTestBoards-1]
