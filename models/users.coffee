App = share

if Meteor.server
  Accounts.onCreateUser (options, user) ->
    App.Boards.createBoard
      owner_id: user._id
      type: 'private'
      name: "#{user.username}'s Board"

    user

Meteor.methods
  deleteUser: (id, callback) ->

    # return if not admin

    App.Boards.find(owner_id: id)?.forEach (board) ->
      App.Boards.destroyBoard board._id

    Meteor.users.remove id, callback