$(document).on('turbolinks:load', function() {
  eventForEditQuestion();
  scoreVoteLink();
  scoreRevoteLink();
});

function eventForEditQuestion() {
  $('.edit-question-link').on('click', function(e) {
    e.preventDefault();
    $(this).hide();

    var questionId = $(this).data('questionId');

    $('form#edit-question-' + questionId).removeClass('hidden');
  });
};

function scoreVoteLink() {
  $('.score-vote-link').on('ajax:success', function(e) {
    sumChange(e);
  });
};

function scoreRevoteLink() {
  $('.score-revote-link').on('ajax:success', function(e) {
    sumChange(e);
  });
};

function sumChange(e) {
  var score = e.detail[0];
  var scoreSum = $('.score-sum[data-score-id="' + score.id + '"]');
  console.log(score);

  scoreSum.html(score.sum);
};
