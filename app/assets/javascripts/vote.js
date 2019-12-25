$(document).on('turbolinks:load', function() {
  scoreVoteLink();
});

function scoreVoteLink() {
  $('.vote-link').on('ajax:success', function(event) {
    var record = event.detail[0];
    var score = $('.' + record.klass + '-score[data-id="' + record.id + '"]');

    score.html(' ' + record.sum);
  });
};
