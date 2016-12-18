if ($('#dashboard').length > 0) {
  $(".dash-title-animation").animate({
    opacity: 1
  }, 200);
  checkAnimation(document.getElementsByClassName('dash-title-animation')[0]);

  $("#destroy-account").click(function() {

    swal({
        title: "Wait!",
        type: "warning",
        text: "Are you sure you want to delete all your information? \nWe'd hate to see you go :(",
        showCancelButton: true,
        showConfirmButton: true,
        confirmButtonColor: "#D4B166",
        confirmButtonText: "Yes delete it",
        cancelButtonText: "Nevermind",
        allowEscapeKey: true,
        allowOutsideClick: true
      },
      function() {
        $('<form action="/users/account/destroy" method="POST"></form>').appendTo('body').submit();
      }
    );
    (darkTheme == true) ?
    $(".sweet-alert").addClass("dark"): $(".sweet-alert").removeClass("dark");

    return false;
  });
}

$('#group-update').keyup(function() {
  if ($(this).val().length == 6) {
    $("#update-token").trigger('submit.rails');
  }
})

if ($('#reset-password, #change-password').length > 0) {
  $(".reset-pass-title-animation").animate({
    opacity: 1
  }, 200);
  checkAnimation(document.getElementsByClassName('reset-pass-title-animation')[0]);
}
