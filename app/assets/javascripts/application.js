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
//= require select2.min

////////////////////////////////////////////////////
// Variables
///////////////////////////////////////////////////
var mobileToggled = false
var headerBoxShadow = "0px 0px 22px 0px rgba(0,0,0,0.04)";
var themeElements = ".active-q, .sweet-alert, input, #popup-wrapper, \
#popup-error-wrapper, .popup, #statement_count, #dashboard #app, #mlh-trust-badge, \
#apps-submissions-graph, .action-button, i";

////////////////////////////////////////////////////
// Dark Theme
///////////////////////////////////////////////////
if (darkTheme === true) {
  $(themeElements).toggleClass("dark");
}

themeElements += ", body, nav"

$('.diamond, #logo-center').click(function() {
  // var clicks = $(this).data('clicks');
  // if (clicks) {
  if (!themeTrigger) {
    darkTheme = !darkTheme;
    $(themeElements).toggleClass("dark");

    swal({
      title: "Awesome",
      text: "You've found an easter egg! What theme should we remember?",
      showCancelButton: true,
      cancelButtonText: "Dark is swell",
      confirmButtonColor: "#D4B166",
      confirmButtonText: "Light is cool",
      allowEscapeKey: true,
      allowOutsideClick: true
    }, function(isConfirm) {
      if (isConfirm) {
        $.ajax({
          url: '/rememberTheme',
          type: 'post',
          data: {
            "theme": "light"
          }
        }).done(function() {
          $.ajax({
            url: '/changeSponsors',
            type: 'post'
          });
        });

        $(themeElements).removeClass("dark");
        darkTheme = false;
      } else {
        $.ajax({
          url: '/rememberTheme',
          type: 'post',
          data: {
            "theme": "dark"
          }
        }).done(function() {
          $.ajax({
            url: '/changeSponsors',
            type: 'post'
          });
        });
        (darkTheme != true) ?
        $(themeElements).toggleClass("dark"): null;
        (darkTheme != true) ?
        darkTheme = true: null;
      }
    });
    (darkTheme == true) ?
    $(".sweet-alert").addClass("dark"): $(".sweet-alert").removeClass("dark");
    themeTrigger = true;

  } else {

    swal({
      title: "Hey again",
      text: "Want us to forget your theme preference?",
      showCancelButton: true,
      cancelButtonText: "Nah",
      confirmButtonColor: "#D4B166",
      confirmButtonText: "Yeah dude",
      allowEscapeKey: true,
      allowOutsideClick: true
    }, function(isConfirm) {
      if (isConfirm) {
        $.ajax({
          url: '/rememberTheme',
          type: 'post'
        }).done(function() {
          $.ajax({
            url: '/changeSponsors',
            type: 'post'
          });
        });
        $(themeElements).toggleClass("dark");
        $(".sweet-alert").removeClass("dark");
        themeTrigger = false;
        darkTheme = !darkTheme;
      }
    });
    (darkTheme == true) ?
    $(".sweet-alert").removeClass('dark').addClass("dark"): $(".sweet-alert").removeClass("dark");
  }
  // } else {
  //   $("body").switchClass("light", "dark");
  // }
  // $(this).data("clicks", !clicks);
});

////////////////////////////////////////////////////
// Navigation
///////////////////////////////////////////////////
$('#mobile-overlay').on('click', function() {
  $('#mobile-menu-icon').click();
});

$('#mobile-menu-icon').on('click', function() {
  $('#mobile-overlay').toggleClass('overlayed')
  if (!mobileToggled) {
    $("#mobile").animate({
      right: 0
    }, 250);
    mobileToggled = true
  } else {
    $("#mobile").animate({
      right: '-50vw'
    }, 150);
    mobileToggled = false
  }
})

$(function() {
  $("[href^='#']").on("click", function(e) {
    var target = $(this).attr('href');
    if (target != "#app") {
      $('#mobile-menu-icon').click();
    }

    var scrollTop = $(target).offset().top - $('#header').height() - $('#header').outerHeight();

    if (target == '#spartahack') {
      scrollTop = 0;
    }

    $("body, html").animate({
      scrollTop: scrollTop
    }, 800);

    e.preventDefault();
  });
});

////////////////////////////////////////////////////
// SVG Animations
///////////////////////////////////////////////////
// Returns true if the specified element has been scrolled into the viewport.
function isElementInViewport(elem) {
  var $elem = elem;

  // Get the scroll position of the page.
  var scrollElem = ((navigator.userAgent.toLowerCase().indexOf('webkit') != -1) ? 'body' : 'html');
  var viewportTop = $(scrollElem).scrollTop();
  var viewportBottom = viewportTop + $(window).height();

  // Get the position of the element on the page.
  var rect = $elem.getBoundingClientRect();
  var elemTop = Math.round(rect.top + document.body.scrollTop);

  var elemBottom = elemTop + $elem.offsetHeight;

  return ((elemTop < viewportBottom) && (elemBottom > viewportTop));
}


function hasClass(el, cls) {
  return el.className && new RegExp("(\\s|^)" + cls + "(\\s|$)").test(el.className);
}

function addClass(ele, cls) {
  if (!hasClass(ele, cls)) ele.className += " " + cls;
}

function removeClass(ele, cls) {
  if (hasClass(ele, cls)) {
    var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
    ele.className = ele.className.replace(reg, ' ');
  }
}

// Check if it's time to start the animation.
function checkAnimation(elem) {
  var $elem = elem;

  // If the animation has already been started
  if (hasClass($elem, 'start')) return;

  if (isElementInViewport($elem)) {
    // Start the animation
    addClass($elem, 'start');
  }
}
