$(document).on('turbolinks:load', function() {
  scoreVoteLink();
});

function scoreVoteLink() {
  $('.vote-link').on('ajax:success', function(e) {
    var record = e.detail[0];
    var score = $(this).parent().find('.score');

    score.html(' ' + record.score);
  });
};
