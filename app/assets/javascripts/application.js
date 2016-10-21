// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require sweetalert

////////////////////////////////////////////////////
// Variables
///////////////////////////////////////////////////
var headerBoxShadow = "0px 0px 22px 0px rgba(0,0,0,0.04)";
var themeElements = "body, nav, .active-q, .sweet-alert";


////////////////////////////////////////////////////
// Dark Theme
///////////////////////////////////////////////////
if (darkTheme == true) {
  $("body, nav, .active-q").toggleClass("dark");
}

$('.diamond, #logo-center').click(function() {
  // var clicks = $(this).data('clicks');
  // if (clicks) {
    if (!themeTrigger) {
      darkTheme = !darkTheme;
      $(themeElements).toggleClass("dark");

      swal({
        title:"Awesome",
        text: "You've found an easter egg! What theme should we remember?",
        showCancelButton: true,
        cancelButtonText: "Dark is swell",
        confirmButtonColor: "#D4B166",
        confirmButtonText: "Light is cool",
        allowEscapeKey:	true,
        allowOutsideClick: true,
      },
      function(isConfirm){
        if (isConfirm) {
          $.ajax({
             url: '/rememberTheme',
             type: 'post',
             data: {"theme" : "light"}
          });

          $(themeElements).removeClass("dark");
          darkTheme = false;
        } else {
          $.ajax({
             url: '/rememberTheme',
             type: 'post',
             data: {"theme" : "dark"}
          });
          (darkTheme != true) ? $(themeElements).toggleClass("dark") : null;
          (darkTheme != true) ? darkTheme = true : null;
        }
      });
      (darkTheme == true) ? $(".sweet-alert").addClass("dark") : $(".sweet-alert").removeClass("dark");
      themeTrigger = true;

    } else {

      swal({
        title:"Hey again",
        text: "Want us to forget your theme preference and toggle the theme?",
        showCancelButton: true,
        cancelButtonText: "Nah",
        confirmButtonColor: "#D4B166",
        confirmButtonText: "Yeah dude",
        allowEscapeKey:	true,
        allowOutsideClick: true,
      },
      function(isConfirm){
        if (isConfirm) {
          $.ajax({
             url: '/rememberTheme',
             type: 'post',
          });
          $(themeElements).toggleClass("dark");
          $(".sweet-alert").removeClass("dark");
          themeTrigger = false;
          darkTheme = !darkTheme;
        }
      });
      (darkTheme == true) ? $(".sweet-alert").removeClass('dark').addClass("dark") : $(".sweet-alert").removeClass("dark");
    }
  // } else {
  //   $("body").switchClass("light", "dark");
  // }
  // $(this).data("clicks", !clicks);
});

////////////////////////////////////////////////////
// Navigation
///////////////////////////////////////////////////
$(function () {
  $("[href^='#']").on("click", function (e)  {
    var target = $(this).attr('href');

    var scrollTop = $( target ).offset().top-$('#header').height()-$('#header').outerHeight();

    if ( target =='#spartahack'){
      scrollTop = 0;
    }

    $("body, html").animate({
      scrollTop: scrollTop
    }, 800);

    e.preventDefault();
  });
});
