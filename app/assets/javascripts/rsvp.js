////////////////////////////////////////////////////
// Select2 calls
///////////////////////////////////////////////////
function createSelects() {
  $('#rsvp_dietary_restrictions').select2({
    placeholder: "Dietary Restrictions",
    allowClear: true
  });

  $('#rsvp_shirt_size').select2({
    placeholder: "Shirt Size",
    allowClear: true
  });

  $('#rsvp_jobs').select2({
    placeholder: "I am looking for...",
    allowClear: true
  });
}

////////////////////////////////////////////////////
// popups
///////////////////////////////////////////////////
function popUpBottom() {
  $(".popup").css("bottom", "170px");
  $(".popup").css("top", "");
  $("#popup-wrapper").fadeIn("slow");
}

function popUpTop() {
  $(".popup").css("top", "80px");
  $(".popup").css("bottom", "");
  $("#popup-wrapper").fadeIn("slow");
}

$('#popup-wrapper, #popup-error-wrapper, #popup-wrapper p').click(function(e) {
  if (e.target !== this)
    return;

  $('#popup-wrapper, #popup-error-wrapper').fadeOut('slow');
});

$(window).resize(function() {
  createSelects();
});

$(window).scroll(function() {
  $("#popup-wrapper, #popup-error-wrapper").fadeOut('fast');
});

////////////////////////////////////////////////////
// Conditionality
///////////////////////////////////////////////////
$('input[name="rsvp[attending]"]').change(function() {
  if (this.value === "Yes") {
    $('.attending-form').stop().slideDown({
      duration: 'slow',
      start: createSelects
    });
  } else {
    $('.attending-form').stop().slideUp({
      duration: 'slow',
      start: createSelects
    });
  }
});

$('#rsvp_dietary_restrictions').change(function() {
  if ($(this).val() !== null && $(this).val().includes("Other")) {
    $('#other-dietary-restrictions-wrap').stop().slideDown({
      duration: 'slow'
    });
  } else {
    $('#other-dietary-restrictions-wrap').stop().slideUp({
      duration: 'slow'
    });
  }
});

////////////////////////////////////////////////////
// Validations
///////////////////////////////////////////////////

function validate() {
  if ($('input[name="rsvp[attending]"]:checked').val() === "Yes") {
    if ($("#rsvp_dietary_restrictions").val() === null) {
      $(".popup").html("Please indicate any dietary restrictions.");
      popUpTop();
    } else if ($("#rsvp_dietary_restrictions").val().includes("None") && $("#rsvp_dietary_restrictions").val().length > 1) {
      $(".popup").html("Dietary restrictions has conflicting information. Please review that section.");
      popUpTop();
    } else if ($("#rsvp_dietary_restrictions").val().includes("Other") && $("#rsvp_other_dietary_restrictions").val().length === 0) {
      $(".popup").html("Please indicate your other dietary restriction.");
      popUpTop();
    } else if ($("#rsvp_shirt_size").val().length === 0) {
      $(".popup").html("Please indicate your shirt size.");
      popUpTop();
    } else if ($('input[name="rsvp[carpool_sharing]"]:checked').val() === undefined) {
      $(".popup").html("Please indicate your carpool sharing preference.");
      popUpTop();
    } else if ($('#rsvp_resume').val() === "") {
      $(".popup").html("Please upload a resume.");
      popUpTop();
    } else if ($('#rsvp_jobs').val() === "") {
      $(".popup").html("Please choose your job preference.");
      popUpTop();
    } else {
      $("#rsvp-form")[0].submit();
    }
  } else if ($('input[name="rsvp[attending]"]:checked').val() === "No") {
    $("#rsvp-form")[0].submit();
  } else {
    $(".popup").html("Please indicate whether or not you are going.");
    popUpTop();
  }
}

$('#submit-rsvp').click(function(event) {
  event.preventDefault();
  validate();
});

createSelects();
