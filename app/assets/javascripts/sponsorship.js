function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function(e) {
      $('#' + input.name + '-prev')
        .attr('src', e.target.result)
    };

    reader.readAsDataURL(input.files[0]);
  }
}

window.onload = function() {

  $('#level').select2({
    placeholder: "Level of Sponsorship",
    allowClear: true
  });

  $('b[role="presentation"]').hide();
  $('.select2-selection__arrow').append('<i class="fa fa-angle-down"></i>');
  $('.select2-container--open').append('<i class="fa fa-angle-up"></i>');

  $('#create_sponsor').submit(function() {
    var formData = new FormData($(this)[0]);
    console.log($(this).find('input[name="user"]').val())

    $.ajax({
      url: $(this).attr('action'),
      headers: {
        'Authorization': $(this).find('input[name="auth"]').val(),
        'X-WWW-USER-TOKEN': $(this).find('input[name="user"]').val()
      },
      data: formData,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      complete: function(data) {
        location.reload();
      }
    });

    return false
  })

};
