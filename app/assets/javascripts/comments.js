$(document).on('turbolinks:load', function() {
  eventForAddComment();
});

function eventForAddComment() {
  $('.add-comment-link').on('click', function(e) {
    e.preventDefault();
    $(this).hide();

    var resource = $(this).data('resource')
    var resourceId = $(this).data('resourceId');

    $('form#add-comment-' + resource + '-' + resourceId).removeClass('hidden');
  });
};
