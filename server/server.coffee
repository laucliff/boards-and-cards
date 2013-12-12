App = share

Meteor.startup () ->
  console.log 'this is server'

  console.log "#{App.Cards.find().count()} Cards, #{App.Boards.find().count()} Boards."

  console.log "#{Meteor.users.find().count()} Users."

Meteor.publish 'cards', ->
  App.Cards.find()

  publicBoardIds = App.Boards.getPublicBoards().map (board) ->
    board._id

  myBoardIds = App.Boards.find(owner_id: this.userId).map (board) ->
    board._id

  App.Cards.find 
    $or: [
      user_id: this.userId
    ,
      board_id: 
        $in: publicBoardIds.concat myBoardIds
    ]

Meteor.publish 'allUsers', ->
  Meteor.users.find()

Meteor.publish 'boards', () ->
  # App.Boards.getAllowedBoards this.userId
  App.Boards.find
    $or: [
        owner_id: this.userId
      ,
        type: 'public'
      ]

Meteor.publish 'comments', ->
  App.Comments.find()