$(document).on('turbolinks:load', function() {
  eventForEditQuestion();

  var medal = $('.new-medal-link');

  if (medal) {
    medal.on('click', function(e) {
      e.preventDefault();
      $(this).hide();
  
      var questionId = $(this).data('questionId');
  
      $('new-medal-question-' + questionId).removeClass('hidden');
    });
  };
});

function eventForEditQuestion() {
  $('.edit-question-link').on('click', function(e) {
    e.preventDefault();
    $(this).hide();

    var questionId = $(this).data('questionId');

    $('form#edit-question-' + questionId).removeClass('hidden');
  });
};
