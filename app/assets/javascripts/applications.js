////////////////////////////////////////////////////
// Select2 calls
///////////////////////////////////////////////////

$('#application_gender').select2({
  placeholder: "Your Gender",
  allowClear: true
});

$('#application_birth_day').select2({
  placeholder: "Birth Day",
  allowClear: true
});

$('#application_birth_month').select2({
  placeholder: "Birth Month",
  allowClear: true
});

$('#application_birth_year').select2({
  placeholder: "Birth Year",
  allowClear: true
});

$('#application_race').select2({
  placeholder: "Ethnicity/Race (Choose all that apply)",
  allowClear: true
});

$('#application_university_enrolled').select2({
  placeholder: "Which school do you attend?",
  allowClear: true
});

$('#application_university_traveling').select2({
  placeholder: "Which school will you be traveling from? (Choose closest)",
  allowClear: true
});

$('#graduation_year').select2({
  placeholder: "Graduation Year",
  allowClear: true
});

$('#application_graduation_season').select2({
  placeholder: "Graduation Semester",
  allowClear: true
});

$('#major').select2({
  placeholder: "What are you studying?"
});

////////////////////////////////////////////////////
// Application
///////////////////////////////////////////////////
$('#other-university-enrolled-confirm').click(function() {
  $('.other-university-enrolled').toggle();
});

$('#createAccount').click(function(event) {
  event.preventDefault();
  // var form = $('#application-form');
  // if (!form[0].checkValidity()) {
  //   $('#application').click();
  // } else {
  $('.page1').addClass('hide-page');
  $('.page2').removeClass('hide-page');
  // }
  return false;
});

$('#backApp').click(function(event) {
  event.preventDefault();
  $('.page1').removeClass('hide-page');
  $('.page2').addClass('hide-page');
});
