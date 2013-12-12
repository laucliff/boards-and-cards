App = share

Template.login.users = ->
  Meteor.users.find()

Template.login.numUsers = ->
  Meteor.users.find().count()

Template.login.showLogin = ->
  Session.get 'showLogin'

Template.login.events
  'click .toggle-login': (e, t) ->
    Session.set 'showLogin', !Session.get('showLogin')

  'click .login': (e, t) ->
    username = t.find('.username').value
    password = 'password'

    Meteor.loginWithPassword username, password, (err) ->
      if err?
        console.log "Login Failed: #{err}"
      else
        console.log "Login Success."

  'click .logout': (e,t) ->
    Meteor.logout (err) ->
      if err?
        console.log "Logout Failed: #{err}"
      else
        console.log "Logout Success."

  'click .add-user': (e, t) ->
    username = t.find('.new-username').value

    if username.length < 1
      console.log 'Bad username'
      return

    password = 'password'

    Accounts.createUser
      username: username
      password: password
    , (err) ->
      if err?
        console.log err
      else
        console.log 'user created'

  'click .delete-user': (e, t) ->
    # Meteor.users.remove this._id
    Meteor.call 'deleteUser', this._id