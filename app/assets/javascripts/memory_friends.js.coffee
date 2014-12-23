jQuery(($) ->
  class Canvas
    constructor: (friends, objects, actions)->
      @canvas = $('.friends_memory_canvas')
      @friends = friends
      @objects = objects
      @actions = actions
      @firstState = true
      @setSelectedMemories()
      @render()

    setSelectedMemories: ->
      @selectedMemories = []
      for place in [1..@friendShowCount()]
        source = null
        switch @memorySource()
          when 'all', 'friends'
            source = @friends[@randomIdx()]
          when 'objects'
            source = @objects[@randomIdx()]
          when 'actions'
            source = @actions[@randomIdx()]
        @selectedMemories.push(source)

    render: ->
      if @firstState
        @canvas.html('')
        @renderMemories(@selectedMemories)

      memoryElement = @canvas.find('.memory')

      if @isNameShown()
        memoryElement.find('.name').show()
        memoryElement.find('.number').hide()
      else
        memoryElement.find('.number').show()
        memoryElement.find('.name').hide()

    renderMemories: (memories) ->
      count = memories.length
      base = @canvas.innerWidth() / count
      if base > 400
        base = 400
        @canvas.css(paddingLeft: "#{(@canvas.innerWidth() - 400 * count) / 2}px")
      else
        @canvas.css(
          paddingLeft: 0
          paddingTop: "#{(400 - base) / 2}px"
        )

      for memory in memories
        if memory.picture_url
          memoryHtml = $("
            <div class='memory'>
              <div class='name'>
                <img src='#{memory.picture_url}' class='image' />
                <div class='name_text'>#{memory.name}</div>
              </div>
              <div class='number'>#{@numberWithPadding(memory.number)}</div>
            </div>
          ")

          # TODO: It's a bit mess
          if @memorySource() == 'all'
            object = $.grep(@objects, (object) => object.number == memory.number)[0]
            action = $.grep(@actions, (action) => action.number == memory.number)[0]
            memoryHtml.
              find('.name').
              append("<div class='additional'>#{object.name} #{action.name}</div>")
        else
          memoryHtml = $("
            <div class='memory'>
              <div class='name'>
                &nbsp;
                <div class='name_text_huge'>#{memory.name}</div>
              </div>
              <div class='number'>#{@numberWithPadding(memory.number)}</div>
            </div>
          ")
        memoryHtml.css(
          width: "#{base}px"
        ).find('.image').css(
          width: "#{base}px"
          height: "#{base}px"
        ).end().find('.name_text').css(
          fontSize: "#{base * 0.1}px"
        ).end().find('.additional').css(
          fontSize: "#{base * 0.05}px"
        ).end().find('.name_text_huge').css(
          fontSize: "#{base * 0.2}px"
          marginTop: "#{base * 0.3}px"
        ).end().find('.number').css(
          fontSize: "#{base * 0.9}px"
          marginTop: "-#{base * 0.15}px"
        )
        # @canvas.css(paddingLeft: "#{(@canvas.width() - base * 2 * count) / 2}px")
        @canvas.append(memoryHtml)

    switch: =>
      @firstState = !@firstState
      if @firstState
        @setSelectedMemories()
      @render()

    numberWithPadding: (num) ->
      "0#{num}".slice(-2)

    randomIdx: ->
      Math.floor(Math.random() * @friends.length)

    isNameShown: ->
      if $('.friends_memory_mode .first a.active').data('first') == 'name'
        @firstState
      else
        !@firstState

    memorySource: ->
      $('.friends_memory_mode .memory a.active').data('memory')

    friendShowCount: ->
      $('.friends_memory_mode .count .dropdown-toggle').data('count')

    renderWithFirstState: ->
      @firstState = true
      @render()

    switchWithFirstState: ->
      @firstState = false
      @switch()

  callApi = (path) ->
    deferred = Promise.defer()

    $.getJSON(path, (data) ->
      deferred.resolve(data)
    )

    deferred.promise

  friends = null
  objects = null
  actions = null

  p1 = callApi($('.friends_memory_canvas').data('path')).then((data)->
    friends = data
  )
  p2 = callApi($('.friends_memory_canvas').data('objects-path')).then((data)->
    objects = data
  )
  p3 = callApi($('.friends_memory_canvas').data('actions-path')).then((data)->
    actions = data
  )

  Promise.all([p1, p2, p3]).then(->
    canvas = new Canvas(friends, objects, actions)

    $('.friends_memory_canvas').click(canvas.switch)
    $(document).keydown((e) ->
      switch e.keyCode
        when 74
        then canvas.switch()
        when 75
        then canvas.renderWithFirstState()
    )

    $('.friends_memory_mode .memory a').click((e) ->
      e.preventDefault()
      self = this
      $(this).closest('.btn-group').find('a').each((idx, a) ->
        if a == self
          $(a).addClass('active')
        else
          $(a).removeClass('active')
      )
      canvas.switchWithFirstState()
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
