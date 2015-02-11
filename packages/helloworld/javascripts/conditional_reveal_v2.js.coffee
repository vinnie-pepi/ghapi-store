QUESTION_TMPL = '''
  .question(data-question-prefix=prefix, data-question-id=prefix + question.id)
    .question-content= question.text
    .btn-group(data-toggle="buttons")
      label.btn.btn-default.answer
        input(type="radio", autocomplete="off", name="question-for-" + prefix + question.id, value="T")
        | YES
      label.btn.btn-default.answer
        input(type="radio", autocomplete="off", name="question-for-" + prefix + question.id, value="F")
        | NO
    .questions
'''

class @ConditionalRevealV2
  constructor: (root, @questions, @answers) ->
    @$root = $(root)
    @$root.addClass('questions')

    @tmpl = jade.compile(QUESTION_TMPL)

    @buildQuestions(@$root, @questions)
    @registerEvents()
    @populateByAnswers(@$root, @answers)

  buildQuestions: ($root, questions, prefix) ->
    prefix ||= ''
    questions.forEach (question) =>
      $question = $(@tmpl({ prefix: prefix, question: question }))
      $subQuestions = $question.find('.questions').hide()
      $root.append($question)
      # init btn group's default value
      $question.find('.btn-group').button('reset')
      @buildQuestions($subQuestions, question.children || [], prefix + question.id + '-')

  registerEvents: ->
    @$root.on 'click', 'label.answer', (e) =>
      # bootstrap 'btn-group' will populate the radio's value after this event
      # setTimeout can put this callback in next tick for getting the correct value
      $question = $(e.currentTarget).closest('.question')
      setTimeout (=> @toggleChildren($question)), 0

  populateByAnswers: ($questions, answers, prefix) ->
    prefix ||= ''
    (answers || []).forEach (answer, idx) =>
      $question = $questions.find("[data-question-id=" + prefix + answer.id + "]")
      $btnGroup = $question.find(">.btn-group")
      $children = $question.find(">.questions")
      if answer.value == true
        $btnGroup.find("input[value=T]").closest('.answer').click()
      else
        if answer.value == false
          $btnGroup.find("input[value=F]").closest('.answer').click()
        else
          $btnGroup.button('reset')
      @populateByAnswers($children, answer.children, prefix + answer.id + '-')


  isFinished: ->
    return @dumpAnswers() != null

  dumpAnswers: ($questions=@$root, required=true) ->
    answers = []

    for dom in $questions.find('>.question')
      $question = $(dom)

      prefix = $question.data('question-prefix')
      id = $question.data('question-id')
      val = $question.find(':checked').val()
      answer = if val == 'T'
        true
      else
        if val == 'F'
          false
        else
          null

      return null if required && answer == null

      children = @dumpAnswers($question.find('>.questions'), !!answer)

      return null if children == null

      answers.push
        id: id.replace(new RegExp("^" + prefix), '')
        value: answer
        children: children

    return answers

  toggleChildren: ($question) ->
    val = $question.find(':checked').val()
    $children = $question.find('>.questions')
    if val == 'T'
      $children.show()
    else
      $children.hide()
      $children.find('.btn-group').button('reset')
      $children.find('.questions').hide()
