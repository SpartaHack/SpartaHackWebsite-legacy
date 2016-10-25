$('#save-app').click(function(e){
  e.preventDefault();

  if ($("#firstName").val().length == 0 || $("#lastName").val().length == 0) {
    $("#popup").html("You must input your full name.");
    popUpBottom();
  } else  if ($("#gender").val().length == 0 ) {
    $("#popup").html("Gender is required.");
    popUpBottom();
  } else if ($("#birthday").val().length == 0 || $("#birthyear").val().length == 0 || $("#birthmonth").val().length == 0) {
    $("#popup").html("Your full birthdate is required.");
    popUpBottom();
  } else if (!document.getElementById('highschool-student').checked && !document.getElementById('university-student').checked) {
    $("#popup").html("Please indicate your current enrollment.");
    popUpBottom();
  } else if (document.getElementById('university-student').checked && $("#university").val().length == 0 && $("#otherUniversity").val().length == 0) {
    $("#popup").html("Please indicate your university.");
    popUpBottom();
  } else if (document.getElementById('university-student').checked && $("#major").val() == null || document.getElementById('university-student').checked && $("#major").val().length == 0) {
    $("#popup").html("Please indicate your major.");
    popUpBottom();
  } else if (document.getElementById('university-student').checked && $("#gradeLevel").val().length == 0) {
    $("#popup").html("Please indicate your year in school.");
    popUpBottom();
  } else if (!document.getElementById('agree').checked) {
    $("#popup").html("Please agree to the MLH Code of Conduct.");
    popUpTop();
  } else {
    $("#popup").html("Saving Application...");
    popUpBottom();
    setTimeout(function () {
      $('#save_app').trigger('submit.rails');
    }, 500);
  }
});
