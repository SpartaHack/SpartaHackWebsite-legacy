window.onload = function() {
  var mlhJs = true;
  var mlhHasBeenTrigged = false;

  ////////////////////////////////////////////////////
  // FAQ
  ///////////////////////////////////////////////////
  var questions = document.getElementById("questions").getElementsByTagName("article");

  for (var questionIndex = 0; questionIndex < questions.length; questionIndex++) {
    if (questions.hasOwnProperty(questionIndex)) {
      questions[questionIndex].addEventListener("click", function() {
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

  $('#questions').on('scroll', function() {
    if ($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight) {
      $(".fa-angle-down").fadeOut();
    } else {
      $(".fa-angle-down").fadeIn();
    }

    if ($(this).scrollTop() == 0) {
      $(".fa-angle-up").fadeOut();
    } else {
      $(".fa-angle-up").fadeIn();
    }
  })

  function checkMlh() {
    if ($(window).width() < 769) {
      mlhJs = false
      $('#mlh-trust-badge img').fadeIn(1200);
    } else {
      mlhJs = true
    }
    console.log($(window).scrollTop())
    if ($(window).scrollTop() >= 300 && !mlhHasBeenTrigged && mlhJs) {
      console.log("sdf")
      $('#mlh-trust-badge img').fadeIn(2000);
      mlhHasBeenTrigged = true;
    } else if ($(window).scrollTop() < 300 && mlhHasBeenTrigged && mlhJs) {
      console.log("aaa")
      $('#mlh-trust-badge img').fadeOut();
      mlhHasBeenTrigged = false;
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

  checkAnimation(document.getElementsByClassName('spartahack-title-animation')[0]);
  checkAnimation(document.getElementById('event-date-animation'));
  checkAnimation(document.getElementById('event-location-animation'));
  if ($(window).scrollTop()) document.getElementById("header").style["boxShadow"] = headerBoxShadow;

  // Capture scroll events
  window.addEventListener("scroll", function() {
    if ($(window).scrollTop()) { //abuse 0 == false :)
      document.getElementById("header").style["boxShadow"] = headerBoxShadow;
    } else {
      document.getElementById("header").style["boxShadow"] = "none";
    }
    checkMlh();

    checkAnimation(document.getElementsByClassName('spartahack-title-animation')[0]);
    checkAnimation(document.getElementById('event-date-animation'));
    checkAnimation(document.getElementById('event-location-animation'));
  });

  checkMlh();
  $(window).resize(function() {
    checkMlh();
  });

};
