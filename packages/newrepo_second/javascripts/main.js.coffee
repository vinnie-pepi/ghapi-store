$ ->
  $('table td').hover (->
    $(this).css('background-color', 'red')
  ), (->
    $(this).css('background-color', '')
  )