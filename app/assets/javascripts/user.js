if ($('#dashboard').length > 0) {
  $(".dash-title-animation").animate({
    opacity: 1
  }, 200);
  checkAnimation(document.getElementsByClassName('dash-title-animation')[0]);
}
