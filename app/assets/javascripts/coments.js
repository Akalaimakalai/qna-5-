$(document).on('turbolinks:load', function() {
  eventForAddComent();
});

function eventForAddComent() {
  $('.add-coment-link').on('click', function(e) {
    e.preventDefault();
    $(this).hide();

    var resource = $(this).data('resource')
    var resourceId = $(this).data('resourceId');

    $('form#add-coment-' + resource + '-' + resourceId).removeClass('hidden');
  });
};
