App = share

Template.board.helpers
  cards: ->
    cards = App.Cards.find 
      board_id: this._id
    ,
      sort:
        ordinal: 1

    # console.log cards.map (card) ->
    #     card.ordinal

    cards

  isCardPlaceholder: ->
    @isPlaceholder

  ownerName: ->
    ownerId = this.owner_id
    username = Meteor.users.findOne(_id: ownerId)?.username

    username or 'No Owner'

Template.board.events
  'click .new-card': (e, t) ->

    newContent = t.find('.new-card-text').value

    data = 
      content: newContent
      board_id: this._id

    App.Cards.createCard data, (err, _id) ->
      t.find('.new-card-text').value = ''
      console.log 'New Card', App.Cards.findOne(_id)

Template.board.rendered = ->
  $cards = $(@find('.cards'))
  $cards.unbind 'showPlaceholder'
  
  $cards.bind 'showPlaceholder', (event, data) ->
    event.stopPropagation()