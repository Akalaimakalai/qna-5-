App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: -> 
    console.log 'Connected!'
    @perform 'subscribed', text: 'hello!'
    # Called when the subscription is ready for use on the server
  ,

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('.questions').append(JST["templates/question"]({ data: data }))
    # Called when there's incoming data on the websocket for this channel
