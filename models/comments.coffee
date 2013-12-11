App = share

class CommentsCollection extends Meteor.Collection

  createComment: (newData, callback) ->
    data = _.defaults {}, newData,
      user_id: Meteor.user()._id
      content: 'New Comment'

    data.content = 'New Card' if data.content?.length < 1

    @insert data, callback

App.Comments = Comments = new CommentsCollection 'comments'


Comments.allow
  insert: ->
    true

  update: ->
    true

  remove: ->
    true