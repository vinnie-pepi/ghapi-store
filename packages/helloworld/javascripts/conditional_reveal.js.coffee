QUESTION_TMPL = '''
  .questions
    each question in questions
      .question(data-question-id=question.id)
        .question-content= question.text
        .btn-group(data-toggle="buttons")
          label.btn.btn-default
            input(type="radio", autocomplete="off", name="question-for-" + question.id, value="T")
            | YES
          label.btn.btn-default
            input(type="radio", autocomplete="off", name="question-for-" + question.id, value="F")
            | NO
'''

class @ConditionalReveal
  constructor: (root, questions, answers) ->
    @$root = $(root)
    @$tmpl = jade.compile(QUESTION_TMPL)

    @buildQuestions(questions)
    @renderByCheckboxStatus()
    @populateByAnswers(answers)

  buildQuestions: (questions) ->
    @$root.html(@$tmpl({ questions: questions }))
    @$questions = @$root.find('.question')

    @$questions.on 'click', 'label', =>
      # bootstrap 'btn-group' will populate the radio's value after this event
      # setTimeout can put this callback in next tick for getting the correct value
      setTimeout (=> @renderByCheckboxStatus()), 0

  populateByAnswers: (answers) ->
    for answer in answers
      $question = @$questions.filter("[data-question-id=" + answer.id + "]")

      if answer.value == true
        $question.find("input[value=T]").click()
      else
        if answer.value == false
          $question.find("input[value=F]").click()
        else
          $question.find('.btn-group').button('reset')

  dumpAnswers: ->
    answers = []
    hasNoAnswer = false

    @$questions.each ->
      $question = $(@)
      id = $question.data('question-id')

      if hasNoAnswer
        answers.push
          id: id
          value: null
      else
        val = $question.find(':checked').val()
        answers.push
          id: id
          value: if val == 'T'
            true
          else
            if val == 'F'
              false
            else
              null

        if $question.find(':checked').val() != 'T'
          hasNoAnswer = true

    return answers

  isFinished: ->
    prevYes = true

    for answer in @dumpAnswers()
      if prevYes and answer.value == null
        return false
      else
        prevYes = answer.value == true

    return true

  renderByCheckboxStatus: ->
    hasNoAnswer = false

    @$questions.each ->
      $question = $(@)

      if hasNoAnswer
        $question.hide()
        $question.find('.btn-group').button('reset')
      else
        $question.show()
        if $question.find(':checked').val() != 'T'
          hasNoAnswer = true
