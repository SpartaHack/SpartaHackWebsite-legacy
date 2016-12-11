if ($('#dashboard').length > 0) {
  $(".dash-title-animation").animate({
    opacity: 1
  }, 200);
  checkAnimation(document.getElementsByClassName('dash-title-animation')[0]);
}

$('#group-update').keyup(function() {
  if ($(this).val().length == 6) {
    $("#update-token").trigger('submit.rails');
  }
})
