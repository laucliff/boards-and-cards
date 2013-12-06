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
    numTestBoards = 3
    numTestCards = 2

    if Boards.find().count() != numTestBoards
      Boards.find().forEach (board) ->
        Boards.destroyBoard board._id
      if numTestBoards > 0
        for n in [0..numTestBoards-1]
          Boards.createBoard name: "board#{n}", (err, id) ->
            return if not id
            numCards = Math.round numTestCards*Math.random()
            console.log numCards
            if numCards > 0
              App.Cards.createCard board_id: id for n in [0..numCards-1]

