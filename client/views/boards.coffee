App = share

Template.board.cards = () ->
  App.Cards.find board_id: this._id

Template.board.events
  'click .new-card': (e, t) ->

    newContent = t.find('.new-card-text').value

    data = 
      content: newContent
      board_id: this._id

    App.Cards.createCard data, (err, _id) ->
      t.find('.new-card-text').value = ''
      console.log 'New Card', App.Cards.findOne(_id)