class @Main
  constructor: (@questions, @answers) ->
    cr = new ConditionalRevealV2('.questions-placeholder', @questions, @answers)

    $reason = $('#reason')
    $status = $('#status')

    $divQuestions = $('.questions-container')
    $divAsProblem = $('.asproblem-container')

    $btnAsProblem = $('.asproblem-btn')
    $btnNoProblem = $('.noproblem-btn')

    status = if $status.val() == 'problem' then 'problem' else 'done'

    if status == 'problem'
      $divQuestions.hide()
      $divAsProblem.show()
      $btnAsProblem.hide()
      $btnNoProblem.show()
    else
      $divQuestions.show()
      $divAsProblem.hide()
      $btnAsProblem.show()
      $btnNoProblem.hide()

    $btnAsProblem.click ->
      $divQuestions.hide()
      $divAsProblem.show()
      $btnAsProblem.hide()
      $btnNoProblem.show()
      status = 'problem'

    $btnNoProblem.click ->
      $divQuestions.show()
      $divAsProblem.hide()
      $btnAsProblem.show()
      $btnNoProblem.hide()
      status = 'done'

    $('form').submit ->
      $status.val(status)

      if $reason.val().trim().length == 0
        alert('please fill in the reason')
        return false

      if status == 'problem'
        $('#answers').val('')
      else
        unless cr.isFinished()
          alert('not finished')
          return false
        else
          $('#answers').val(JSON.stringify(cr.dumpAnswers()))
