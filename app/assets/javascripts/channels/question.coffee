App.question = App.cable.subscriptions.create {channel: "QuestionChannel", question_id: gon.question_id},
  connected: -> 
    console.log 'Connected Question-olololo!'
    @perform 'subscribed', text: 'hello!'
    # Called when the subscription is ready for use on the server
  ,

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('.answers').append(JST["templates/answer"]({ data: data }))
    # Called when there's incoming data on the websocket for this channel
