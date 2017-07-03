pointEdit = ->
  $('body').on 'click', '.edit-point-link', (e) ->
    e.preventDefault();
    $(this).hide();
    point_id = $(this).data('pointId');
    $('form#edit-point-' + point_id).show();

$(document).on("turbolinks:load", pointEdit);
