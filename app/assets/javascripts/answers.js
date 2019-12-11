$(document).on('turbolinks:load', function () {
  eventForEditAnswer();
});

function eventForEditAnswer() {

  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();

    var answerId = $(this).data('answerId');

    $('form#edit-answer-' + answerId).show();
  });
}
