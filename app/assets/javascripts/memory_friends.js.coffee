jQuery(($) ->
  class Canvas
    constructor: (json)->
      @canvas = $('.friends_memory_canvas')
      @friends = json
      @firstState = true
      @setSelectedFriends()
      @render()

    setSelectedFriends: ->
      @selectedFriends = []
      for _ in [1..@friendShowCount()]
        @selectedFriends.push(@friends[@randomIdx()])

    render: ->
      if @firstState
        @canvas.html('')
        @renderFriends(@selectedFriends)

      friendElement = @canvas.find('.friend')

      if @isNameShown()
        friendElement.find('.name').show()
        friendElement.find('.number').hide()
      else
        friendElement.find('.number').show()
        friendElement.find('.name').hide()

    renderFriends: (friends) ->
      count = friends.length
      base = @canvas.innerWidth() / count
      if base > 400
        base = 400
        @canvas.css(paddingLeft: "#{(@canvas.innerWidth() - 400 * count) / 2}px")
      else
        @canvas.css(
          paddingLeft: 0
          paddingTop: "#{(400 - base) / 2}px"
        )

      for friend in friends
        friendHtml = $("
          <div class='friend'>
            <div class='name'>
              <img src='#{friend.picture_url}' class='image' />
              <div class='name_text'>#{friend.name}</div>
            </div>
            <div class='number'>#{@numberWithPadding(friend.number)}</div>
          </div>
        ")
        friendHtml.css(
          width: "#{base}px"
        ).find('.image').css(
          width: "#{base}px"
          height: "#{base}px"
        ).end().find('.name').css(
          fontSize: "#{base * 0.1 }px"
        ).end().find('.number').css(
          fontSize: "#{base * 0.9}px"
          marginTop: "-#{base * 0.15}px"
        )
        # @canvas.css(paddingLeft: "#{(@canvas.width() - base * 2 * count) / 2}px")
        @canvas.append(friendHtml)

    switch: =>
      @firstState = !@firstState
      if @firstState
        @setSelectedFriends()
      @render()

    numberWithPadding: (num) ->
      "0#{num}".slice(-2)

    randomIdx: ->
      Math.floor(Math.random() * @friends.length)

    isNameShown: ->
      if $('.friends_memory_mode a.active').data('first') == 'name'
        @firstState
      else
        !@firstState

    friendShowCount: ->
      $('.friends_memory_mode .count .dropdown-toggle').data('count')

    renderWithFirstState: ->
      @firstState = true
      @render()

    switchWithFirstState: ->
      @firstState = false
      @switch()

  $.getJSON($('.friends_memory_canvas').data('path'), (data) ->
    canvas = new Canvas(data)

    $('.friends_memory_canvas').click(canvas.switch)
    $(document).keydown((e) ->
      switch e.keyCode
        when 74
        then canvas.switch()
        when 75
        then canvas.renderWithFirstState()
    )

    $('.friends_memory_mode .first a').click((e) ->
      e.preventDefault()
      $(this).closest('.btn-group').find('a').toggleClass('active')
      canvas.switchWithFirstState()
    )

    $('.friends_memory_mode .count .dropdown-menu a').click((e) ->
      e.preventDefault()
      $(this).closest('.btn-group').find('.dropdown-toggle').
        data('count', $(this).data('count')).
        find('.text').text("count #{$(this).data('count')}")
      canvas.switchWithFirstState()
    )
  )
)
