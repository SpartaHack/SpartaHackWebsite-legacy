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


var SPY = function() {
  function e(a, d, b) {
    console.log(b)
    var c, f, g, h;
    b == a.length ? k.animationComplete = !0 : (g = d.innerHTML, h = Math.floor(14 * Math.random() + 5), c = 32 === a[b] ? 32 : a[b] - h, f = setInterval(function() {
      d.innerHTML = g + String.fromCharCode(c);
      c == a[b] ? (clearInterval(f), c = 32, b++, setTimeout(function() {
        e(a, d, b);
      }, 10)) : c++;
    }, 5));
  }
  var k = {};
  return k = {animationComplete:!1, text:function(a) {
    this.animationComplete = !1;
    a = document.getElementById(a);
    for (var d = a.innerHTML, b = [], c = 0;c < d.length;c++) {
      b.push(d.charCodeAt(c));
    }
    a.innerHTML = "";
    e(b, a, 0);
  }};
}();


$( 'document' ).ready(function() {
  $('#greeting').css('width', $('#greeting').width()+35)

  // Hide header
  $( '#greeting' ).hide();
  // Transition background
  $( '#greeting-wrapper'  ).animate({ opacity: 1 });

  // Timeout for crypto text
  setTimeout( function() {
    $( '#greeting' ).fadeIn( 'slow' );
      SPY.text( 'greeting' );
  }, 300);

});
