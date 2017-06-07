quizAppEdit = ->
  $('body').on 'click', '.edit-quiz-app-link', (e) ->
    e.preventDefault();
    $(this).hide();
    quiz_app_id = $(this).data('quizAppId');
    $('form#edit-quiz-app-' + quiz_app_id).show();

$(document).on("turbolinks:load", quizAppEdit);
