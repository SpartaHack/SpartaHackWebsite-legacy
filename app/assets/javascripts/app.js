////////////////////////////////////////////////////
// Select2 calls
///////////////////////////////////////////////////

$('#gender').select2({placeholder: "Your Gender", allowClear: true});

$('#birthday').select2({placeholder: "Birth Day", allowClear: true});

$('#birthmonth').select2({placeholder: "Birth Month", allowClear: true});

$('#birthyear').select2({placeholder: "Birth Year", allowClear: true});

$('#race').select2({placeholder: "Ethnicity/Race (Choose all that apply)", allowClear: true});

$('#university-enrolled').select2({placeholder: "Which school do you attend?", allowClear: true});

$('#university-travelling').select2({placeholder: "Which school will you be travelling from? (Choose closest)", allowClear: true});

$('#gradYear').select2({placeholder: "Graduation Year", allowClear: true});

$('#gradSemester').select2({placeholder: "Graduation Semester", allowClear: true});

$('#major').select2({placeholder: "What are you studying?"});

////////////////////////////////////////////////////
// Application
///////////////////////////////////////////////////
$('#other-university-enrolled-confirm').click(function() {
  $('.other-university-enrolled').toggle();
});