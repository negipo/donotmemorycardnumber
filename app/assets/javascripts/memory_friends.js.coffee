jQuery(($) ->
  class Canvas
    constructor: (json)->
      @canvas = $('.friends_memory_canvas')
      @friends = json
      @firstState = true
      @idx = @randomIdx()
      @render()
    render: ->
      friend = @friends[@idx]
      friendElement = @renderFriend(friend)
      friendElement.show()
      if @isNameShown()
        friendElement.find('.name').show()
        friendElement.find('.number').hide()
      else
        friendElement.find('.number').show()
        friendElement.find('.name').hide()
    renderFriend: (friend) ->
      friendHtml = $("
        <div class='friend'>
          <div class='name'>
            <img src='#{friend.picture_url}' class='image' />
            <div class='name_text'>#{friend.name}</div>
          </div>
          <div class='number'>#{friend.number}</div>
        </div>
      ")
      @canvas.append(friendHtml)
      @canvas.find('.friend')
    switch: =>
      @canvas.html('')
      @idx = @randomIdx() unless @firstState
      @firstState = !@firstState
      @render()
    randomIdx: ->
      Math.floor(Math.random() * @friends.length)
    isNameShown: ->
      if $('.friends_memory_mode a.active').data('first') == 'name'
        @firstState
      else
        !@firstState
    switchWithFirstState: ->
      @firstState = false
      @switch()

  $.getJSON($('.friends_memory_canvas').data('path'), (data) ->
    canvas = new Canvas(data)
    $('.friends_memory_canvas').click(canvas.switch)
    $(document).keydown((e) ->
      if e.keyCode == 74
        canvas.switch()
    )
    $('.friends_memory_mode .first a').click((e) ->
      e.preventDefault()
      $(this).closest('.btn-group').find('a').toggleClass('active')
      canvas.switchWithFirstState()
    )
  )
)
