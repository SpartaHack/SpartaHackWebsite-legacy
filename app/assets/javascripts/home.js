

window.onload = function(){
  ////////////////////////////////////////////////////
  // Variables
  ///////////////////////////////////////////////////
  var headerBoxShadow = "0px 0px 22px 0px rgba(0,0,0,0.04)";
  var themeElements = "body, nav, .active-q, .sweet-alert";



  ////////////////////////////////////////////////////
  // FAQ
  ///////////////////////////////////////////////////
<<<<<<< Updated upstream
  var questions = document.getElementById("questions").getElementsByTagName("article");

  for (var questionIndex = 0; questionIndex < questions.length; questionIndex++) {
    if (questions.hasOwnProperty(questionIndex)) {
      questions[questionIndex].addEventListener("click", function(){
        // Remove active-q class from previously selected element
        var currentQuestionList = this.parentElement.getElementsByClassName("active-q");
        var currentModeList = this.parentElement.getElementsByClassName("dark");

        currentQuestionList[0].classList.remove("active-q");

        if (currentModeList.length > 0) {
          currentModeList[0].classList.remove("dark");

          // Add dark mode to clicked element
          this.classList.add("dark");
        }


        // Add active-q to clicked element
        this.classList.add("active-q");

        var answers = document.getElementById("answers");

        // Add hidden-question class to previously selected element
        var currentAnswerList = answers.getElementsByClassName("current-answer");
        currentAnswerList[0].classList.add("hidden-answer");
        currentAnswerList[0].classList.remove("current-answer");

        // Add current-answer class to new element
        hiddenAnswerList = answers.getElementsByClassName("hidden-answer");
        var answerIndex = Number(this.children[0].getAttribute("id"));
        hiddenAnswerList[answerIndex].classList.add("current-answer");
        hiddenAnswerList[answerIndex].classList.remove("hidden-answer");
      });
=======
  if (document.getElementById('questions') !== null) {
    var questions = document.getElementById("questions").getElementsByTagName("article");

    for (var questionIndex = 0; questionIndex < questions.length; questionIndex++) {
      if (questions.hasOwnProperty(questionIndex)) {
        questions[questionIndex].addEventListener("click", function(){
          // Remove active-q class from previously selected element
          var currentQuestionList = this.parentElement.getElementsByClassName("active-q");
          currentQuestionList[0].classList.remove("active-q");

          // Add active-q to clicked element
          this.classList.add("active-q");

          var answers = document.getElementById("answers");

          // Add hidden-question class to previously selected element
          var currentAnswerList = answers.getElementsByClassName("current-answer");
          currentAnswerList[0].classList.add("hidden-answer");
          currentAnswerList[0].classList.remove("current-answer");

          // Add current-answer class to new element
          hiddenAnswerList = answers.getElementsByClassName("hidden-answer");
          var answerIndex = Number(this.children[0].getAttribute("id"));
          hiddenAnswerList[answerIndex].classList.add("current-answer");
          hiddenAnswerList[answerIndex].classList.remove("hidden-answer");
        });
      }
>>>>>>> Stashed changes
    }
  }

  ////////////////////////////////////////////////////
  // email
  ///////////////////////////////////////////////////
  var emailForm = document.getElementById("notify-email-input");
  if (emailForm !== null) {
    emailForm.addEventListener("focus", function() {
      this.setAttribute("placeholder", "Email");
      this.nextElementSibling.classList.remove("hide");
    });

    emailForm.addEventListener("blur", function() {
      this.setAttribute("placeholder", "SIGN UP");
      this.nextElementSibling.classList.add("hide");
    });
  }


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
      var elemTop = Math.round( rect.top + document.body.scrollTop );

      var elemBottom = elemTop + $elem.offsetHeight;

      return ((elemTop < viewportBottom) && (elemBottom > viewportTop));
  }


  function hasClass(el, cls) {
    return el.className && new RegExp("(\\s|^)" + cls + "(\\s|$)").test(el.className);
  }

  function addClass(ele,cls) {
      if (!hasClass(ele,cls)) ele.className += " "+cls;
  }

  function removeClass(ele,cls) {
      if (hasClass(ele,cls)) {
          var reg = new RegExp('(\\s|^)'+cls+'(\\s|$)');
          ele.className=ele.className.replace(reg,' ');
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
          text: "Want us to forget your theme preference?",
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

  checkAnimation(document.getElementsByClassName('spartahack-title-animation')[0]);
  checkAnimation(document.getElementById('event-date-animation'));
  checkAnimation(document.getElementById('event-location-animation'));
  if($(window).scrollTop()) document.getElementById("header").style["boxShadow"] = headerBoxShadow;

<<<<<<< Updated upstream
  // Capture scroll events
  window.addEventListener("scroll", function(){
    if($(window).scrollTop()) { //abuse 0 == false :)
      document.getElementById("header").style["boxShadow"] = headerBoxShadow;
    } else {
      document.getElementById("header").style["boxShadow"] = "none";
    }
    checkAnimation(document.getElementsByClassName('spartahack-title-animation')[0]);
    checkAnimation(document.getElementById('event-date-animation'));
    checkAnimation(document.getElementById('event-location-animation'));
  });
=======
  if (document.getElementsByClassName('spartahack-title-animation') !== null) {
    // Capture scroll events
    window.addEventListener("scroll", function(){
      checkAnimation(document.getElementsByClassName('spartahack-title-animation')[0]);
      checkAnimation(document.getElementById('event-date-animation'));
      checkAnimation(document.getElementById('event-location-animation'));

      ////////////////////////////////////////////////////
      // Navigation
      ///////////////////////////////////////////////////

      // How far the scroll is from the top of the page
      var scroll = document.body.scrollTop;
      // // Navbar
      // var topNav = document.getElementById("topNav");
      // var notifyNav = document.getElementById("notifyNav");
      // var aboutNav = document.getElementById("aboutNav");
      // var faqNav = document.getElementById("faqNav");
      // var sponsorNav = document.getElementById("sponsorNav");
      // var contactNav = document.getElementById("contactNav");
      // // Sections
      // var emailSection = document.getElementById("notify-email");
      // var aboutSection = document.getElementById("event-description");
      // var faqSection = document.getElementById("faq");
      // var sponsorSection = document.getElementById("sponsors");
      // var contactSection = document.getElementById("contact");

    });
  }
>>>>>>> Stashed changes
};
