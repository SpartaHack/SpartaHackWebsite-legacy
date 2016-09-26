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

  // Also Navigation
  var navElements = document.getElementsByClassName("nav-element");

  for (var i = 0; i < navElements.length; i++) {
    navElements[i].addEventListener('click', function(event) {
      event.preventDefault();
      var element = document.getElementById(this.getAttribute('href')).scrollIntoView({behavior: "smooth"});
    });
  }

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
};
