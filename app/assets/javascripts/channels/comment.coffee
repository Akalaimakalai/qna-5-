App.comments = App.cable.subscriptions.create {channel: "CommentsChannel", question_id: gon.question_id},
  connected: -> 
    console.log 'Connected Comment!'
    @perform 'subscribed', text: 'hello!'
    # Called when the subscription is ready for use on the server
  ,

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $(".comments[data-resource=#{data['data']['commentable_type_down']}][data-resource-id=#{data['data']['commentable_id']}]").append(JST["templates/comment"]({ data: data }))
    # Called when there's incoming data on the websocket for this channel
