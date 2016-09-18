window.onload = function(){
  ////////////////////////////////////////////////////
  // FAQ
  ///////////////////////////////////////////////////
  var questions = document.getElementById("questions").getElementsByTagName("article");

  for (var questionIndex in questions) {
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
    this.setAttribute("placeholder", "Enter your email here and hit submit to get notified!");
    this.nextElementSibling.classList.remove("hide");
  });

  emailForm.addEventListener("blur", function() {
    this.setAttribute("placeholder", "NOTIFY ME WHEN APPLICATIONS OPEN");
    this.nextElementSibling.classList.add("hide");
  });
};
