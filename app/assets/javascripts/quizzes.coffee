# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

quizEdit = ->
  $('body').on 'click', '.edit-quiz-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-quiz').show();

$(document).on("turbolinks:load", quizEdit);
