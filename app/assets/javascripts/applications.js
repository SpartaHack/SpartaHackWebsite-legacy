////////////////////////////////////////////////////
// Select2 calls
///////////////////////////////////////////////////

$('#application_gender').select2({
  placeholder: "Your Gender (For statistical purposes only)",
  allowClear: true
});

$('#application_birth_day').select2({
  placeholder: "Birth Day *",
  allowClear: true
});

$('#application_birth_month').select2({
  placeholder: "Birth Month *",
  allowClear: true
});

$('#application_birth_year').select2({
  placeholder: "Birth Year *",
  allowClear: true
});

$('#application_race').select2({
  placeholder: "Ethnicity/Race (Choose all that apply) (For statistical purposes only)",
  allowClear: true
});

$('#application_university').select2({
  placeholder: "Which school do you attend? *",
  allowClear: true
});

$('#application_travel_origin').select2({
  placeholder: "Which school will you be traveling from? (Choose closest) *",
  allowClear: true
});

$('#application_graduation_year').select2({
  placeholder: "Graduation Year *",
  allowClear: true
});

$('#application_graduation_season').select2({
  placeholder: "Graduation Semester *",
  allowClear: true
});

$('#application_major').select2({
  placeholder: "What are you studying? (Choose all that apply) *"
});

////////////////////////////////////////////////////
// Conditionality
///////////////////////////////////////////////////
$('#other_university_enrolled_confirm').click(function() {
  $('.other_university_enrolled').toggle();
  if (!this.checked) {
    $('.other_university_enrolled input').val("");
  }
});

$('input[name="application[education]"]').change(function() {
  if (this.value === "undergraduate" || this.value === "graduate") {
    $('.university-enrolled').show();
  } else {
    $('.university-enrolled').hide();
    $('.university-enrolled select').val("").trigger('change');
    if ($('#other_university_enrolled_confirm')[0].checked) {
      $('#other_university_enrolled_confirm').click();
    }
  }
});

$('input[name="application[outside_north_america]"]').change(function() {
  if (this.value === "yes") {
    $('.university-traveling').hide();
  } else {
    $('.university-traveling').show();
  }
});

////////////////////////////////////////////////////
// Validations
///////////////////////////////////////////////////

$('#createAccount').click(function(event) {
  event.preventDefault();
  validateFormOne();
  return false;
});

$('#application').click(function(event) {
  event.preventDefault();
  validateFormTwo();
  return false;
});

$('#backApp').click(function(event) {
  event.preventDefault();
  $('.page1').removeClass('hide-page');
  $('.page2').addClass('hide-page');
});

function validateFormOne() {
  if ($("#user_first_name").val().length == 0 || $("#user_last_name").val().length == 0) {
    $("#popup").html("You must input your full name.");
    popUpTop();
  } else if ($("#application_birth_day").val().length == 0 || $("#application_birth_year").val().length == 0 || $("#application_birth_month").val().length == 0) {
    $("#popup").html("Your full birthdate is required.")
    popUpTop();
  } else if (!document.getElementById('application_education_highschool').checked && !document.getElementById('application_education_undergraduate').checked && !document.getElementById('application_education_graduate').checked) {
    $("#popup").html("Please indicate your current enrollment.");
    popUpTop();
  } else if ((document.getElementById('application_education_undergraduate').checked || document.getElementById('application_education_graduate').checked) && ($("#application_university").val().length === 0) && !($('#other_university_enrolled_confirm')[0].checked && $('#application_other_university').val() !== "")) {
    $("#popup").html("Please indicate your university.");
    popUpTop();
  } else if (!$('#application_outside_north_america_no')[0].checked && !$('#application_outside_north_america_yes')[0].checked) {
    $("#popup").html("Please indicate if you are traveling from outside North America.");
    popUpTop();
  } else if ($('#application_outside_north_america_no')[0].checked && $("#application_travel_origin").val().length == 0) {
    $("#popup").html("Please indicate the university you are traveling from.");
    popUpTop();
  } else if ($("#application_graduation_season").val().length == 0 || $("#application_graduation_year").val().length == 0) {
    $("#popup").html("Please indicate when you intend to graduate.");
    popUpTop();
  } else if ((document.getElementById('application_education_undergraduate').checked || document.getElementById('application_education_graduate').checked) && ($("#application_major").val() == null)) {
    $("#popup").html("Please indicate your major.");
    popUpTop();
  } else if ($('#application_hackathons').val() == "") {
    $("#popup").html("Please indicate the number of hackathons you have attended.");
    popUpTop();
  } else if (!document.getElementById('agree').checked) {
    $("#popup").html("Please agree to the MLH Code of Conduct.");
    popUpTop();
  } else {
    $('.page1').addClass('hide-page');
    $('.page2').removeClass('hide-page');
  }
}

function validateFormTwo() {
  if ($("#user_email").val().length === 0) {
    $("#popup").html("Please indicate your email");
    popUpTop();
  } else if ($("#user_email_confirmation").val().length === 0) {
    $("#popup").html("Please indicate your confirmed email");
    popUpTop();
  } else if ($("#user_email_confirmation").val() !== $("#user_email").val()) {
    $("#popup").html("Your emails do not match.");
    popUpTop();
  } else if ($("#user_password").val().length === 0) {
    $("#popup").html("Please indicate your password");
    popUpTop();
  } else if ($("#user_password_confirmation").val().length === 0) {
    $("#popup").html("Please indicate your confirmed password");
    popUpTop();
  } else if ($("#user_password_confirmation").val() !== $("#user_password").val()) {
    $("#popup").html("Your passwords do not match.");
    popUpTop();
  } else if ($("#user_password").val().length < 6) {
    $("#popup").html("Your password is too short.");
    popUpTop();
  } else {
    $('#application-form')[0].submit();
  }
}

function popUpBottom() {
  $("#popup").css("bottom", "170px");
  $("#popup").css("top", "");
  $("#popup-wrapper").fadeIn("slow");
}

function popUpTop() {
  $("#popup").css("top", "80px");
  $("#popup").css("bottom", "");
  $("#popup-wrapper").fadeIn("slow");
}

$('#popup-wrapper').click(function(e) {
  if (e.target !== this)
    return;

  $('#popup-wrapper').fadeOut('slow');
});
