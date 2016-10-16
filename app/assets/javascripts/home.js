

window.onload = function(){
  ////////////////////////////////////////////////////
  // FAQ
  ///////////////////////////////////////////////////
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
    }
  }

  ////////////////////////////////////////////////////
  // email
  ///////////////////////////////////////////////////
  var emailForm = document.getElementById("notify-email-input");
  emailForm.addEventListener("focus", function() {
    this.setAttribute("placeholder", "Email");
    this.nextElementSibling.classList.remove("hide");
  });

  emailForm.addEventListener("blur", function() {
    this.setAttribute("placeholder", "SIGN UP");
    this.nextElementSibling.classList.add("hide");
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

  checkAnimation(document.getElementsByClassName('spartahack-title-animation')[0]);
  checkAnimation(document.getElementById('event-date-animation'));
  checkAnimation(document.getElementById('event-location-animation'));
  if($(window).scrollTop()) document.getElementById("header").style["boxShadow"] = headerBoxShadow;

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
};
