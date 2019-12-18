$(document).on('turbolinks:load', function() {
  scoreVoteLink();
});

function scoreVoteLink() {
  $('.score-vote-link').on('ajax:success', function(e) {
    var score = e.detail[0];
    var scoreSum = $('.score-sum[data-score-id="' + score.id + '"]');
  
    scoreSum.html(' ' + score.sum);
  });
};
