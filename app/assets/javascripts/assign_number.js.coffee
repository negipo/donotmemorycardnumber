jQuery(($)->
  $('.friend .buttons a').click((e) ->
    e.preventDefault()
    $(this).closest('form').submit()
  )
)
