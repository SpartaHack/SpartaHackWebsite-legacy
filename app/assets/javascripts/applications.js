////////////////////////////////////////////////////
// Select2 calls
///////////////////////////////////////////////////
function createSelects() {
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
}

function showOtherUniversity() {
  if ($('.university').is(':visible')) {
    $('.university').stop().slideUp(function() {
      $('.other_university_enrolled').stop().slideDown({
        start: createSelects
      });
    });
  }
  createSelects();
}

function hideOtherUniversity() {
  $('.other_university_enrolled').stop().slideUp(function() {
    $('.university').stop().slideDown({
      start: createSelects
    });
  });
}

function validateFormOne(edit) {
  if ($("#user_first_name").val().length == 0 || $("#user_last_name").val().length == 0) {
    $("#popup").html("You must input your full name.");
    popUpTop();
  } else if ($("#application_birth_day").val().length == 0 || $("#application_birth_year").val().length == 0 || $("#application_birth_month").val().length == 0) {
    $("#popup").html("Your full birthdate is required.")
    popUpTop();
  } else if (!document.getElementById('application_education_high_school').checked && !document.getElementById('application_education_undergraduate').checked && !document.getElementById('application_education_graduate').checked) {
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
    if (edit === undefined) {
      $('.page1').addClass('hide-page');
      $('.page2').removeClass('hide-page');
      window.scrollTo(0, 0);
    } else {
      $('#application-form')[0].submit();
    }
  }
}

var emailPattern = /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

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
  } else if (!emailPattern.test($("#user_email").val())) {
    $("#popup").html("Your email is invalid.");
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

////////////////////////////////////////////////////
// Conditionality
///////////////////////////////////////////////////
window.onload = function() {
  $('#other_university_enrolled_confirm').click(function() {
    if ($(this).is(':checked')) {
      showOtherUniversity();
    } else {
      hideOtherUniversity();
    }
  });

  $('input[name="application[education]"]').change(function() {
    if (this.value === "Undergraduate" || this.value === "Graduate") {
      $('.university-enrolled').stop().slideDown({
        duration: 'slow',
        start: createSelects
      });

      if ($('#other_university_enrolled_confirm').is(':checked')) {
        showOtherUniversity();
      } else {
        hideOtherUniversity();
      }

    } else {
      $('.university-enrolled').stop().slideUp({
        duration: 'slow',
        start: createSelects
      });
    }
  });

  $('input[name="application[outside_north_america]"]').change(function() {
    if (this.value === "Yes") {
      $('.university-traveling').stop().slideUp({
        duration: 'slow',
        start: createSelects
      });
    } else {
      $('.university-traveling').stop().slideDown({
        duration: 'slow',
        start: createSelects
      });
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

  $('#application-edit').click(function(event) {
    event.preventDefault();
    validateFormOne('edit');
    return false;
  });

  $('#backApp').click(function(event) {
    event.preventDefault();
    $('.page1').removeClass('hide-page');
    $('.page2').addClass('hide-page');
  });

  $('#popup-wrapper, #popup-error-wrapper, #popup-wrapper p').click(function(e) {
    if (e.target !== this)
      return;

    $('#popup-wrapper, #popup-error-wrapper').fadeOut('slow');
  });

  $(window).resize(function() {
    createSelects();
  })

  $(window).scroll(function() {
    $("#popup-wrapper, #popup-error-wrapper").fadeOut('fast');
  });

  var characterCount = $("#application_statement").val().length
  $('#current').text(characterCount);
  $('#application_statement').keyup(function() {

    characterCount = $(this).val().length,
      current = $('#current'),
      maximum = $('#maximum'),
      theCount = $('#the-count');

    current.text(characterCount);


    /*This isn't entirely necessary, just playin around*/
    if (characterCount < 1000) {
      current.css('color', '#D4B166');
      current.css('font-weight', 'normal');
    }
    if (characterCount > 999 && characterCount < 2000) {
      current.css('color', '#D4B166');
      current.css('font-weight', 'bold');
    }
    if (characterCount > 1999 && characterCount < 2500) {
      current.css('color', '#B58A2D');
      current.css('font-weight', 'normal');
    }
    if (characterCount > 2499 && characterCount < 3000) {
      current.css('color', '#B58A2D');
      current.css('font-weight', '900');
    }

    if (characterCount == 3000) {
      maximum.css('color', '#B58A2D');
      current.css('color', '#B58A2D');
      theCount.css('font-weight', '900');
    } else {
      maximum.css('color', '#D4B166');
      theCount.css('font-weight', 'normal');
    }


  });

  createSelects();
  // hide old selection arrow;
  // $('b[role="presentation"]').hide();
  // $('.select2-selection__arrow').append('<i class="fa fa-angle-down"></i>');
  // $('.select2-container--open').append('<i class="fa fa-angle-up"></i>');
}
