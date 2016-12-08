//= require d3.min

window.onload = function() {
  HorizontalBarGraph = function(el, series) {
    this.el = d3.select(el);
    this.series = series;
  };

  HorizontalBarGraph.prototype.draw = function() {
    var x = d3.scaleLinear()
      .domain([0, d3.max(this.series, function(d) {
        return d.value
      })])
      .range([0, 100]);

    var segment = this.el
      .selectAll(".horizontal-bar-graph-segment")
      .data(this.series)
      .enter()
      .append("div").classed("horizontal-bar-graph-segment", true);

    segment
      .append("div").classed("horizontal-bar-graph-label", true)
      .text(function(d) {
        return d.label
      });

    segment
      .append("div").classed("horizontal-bar-graph-value", true)
      .append("div").classed("horizontal-bar-graph-value-bar", true)
      .style("background-color", function(d) {
        return d.color
      })
      .text(function(d) {
        return d.inner_label ? d.inner_label : ""
      })
      .transition()
      .duration(1000)
      .style("min-width", function(d) {
        return x(d.value) + "%"
      });
  };

  // RSVP
  $('input').click(function() {
    var application_checked = document.getElementById('application').checked;
    var rsvp_checked = document.getElementById('rsvp').checked;
    // var attending_checked = document.getElementById('attending').checked;

    // if (rsvp_checked) {
    //   document.querySelector('#rsvp-stats').style.visibility = "visible";
    //   document.querySelector('#rsvp-stats').style.position = "inherit";
    //   document.querySelector('#rsvp-stats').style.opacity = "1";
    //
    //   document.querySelector('#app-stats').style.visibility = "hidden";
    //   document.querySelector('#app-stats').style.position = "fixed";
    //   document.querySelector('#app-stats').style.opacity = "0";
    //
    //   document.querySelector('#attending-stats').style.visibility = "hidden";
    //   document.querySelector('#attending-stats').style.position = "fixed";
    //   document.querySelector('#attending-stats').style.opacity = "0";
    // }
    if (application_checked) {
      document.querySelector('#rsvp-stats').style.position = "fixed";
      document.querySelector('#rsvp-stats').style.visibility = "hidden";
      document.querySelector('#rsvp-stats').style.opacity = "0";

      document.querySelector('#app-stats').style.position = "inherit";
      document.querySelector('#app-stats').style.visibility = "visible";
      document.querySelector('#app-stats').style.opacity = "1";

      document.querySelector('#attending-stats').style.position = "fixed";
      document.querySelector('#attending-stats').style.visibility = "hidden";
      document.querySelector('#attending-stats').style.opacity = "0";
    }
    // if (attending_checked) {
    //   document.querySelector('#rsvp-stats').style.position = "fixed";
    //   document.querySelector('#rsvp-stats').style.visibility = "hidden";
    //   document.querySelector('#rsvp-stats').style.opacity = "0";
    //
    //   document.querySelector('#app-stats').style.position = "fixed";
    //   document.querySelector('#app-stats').style.visibility = "hidden";
    //   document.querySelector('#app-stats').style.opacity = "0";
    //
    //   document.querySelector('#attending-stats').style.position = "inherit";
    //   document.querySelector('#attending-stats').style.visibility = "visible";
    //   document.querySelector('#attending-stats').style.opacity = "1";
    //
    //
    // }
  });

  // App stats js

  var data = $('.applications_data_submission_dates').data('temp');
  var row_width = $('.row').width();

  var margin = {
      top: 20,
      right: 20,
      bottom: 30,
      left: 50
    },
    width = row_width - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

  var parseDate = d3.timeParse("%d-%b-%y");

  var x = d3.scaleTime()
    .range([0, width]);

  var y = d3.scaleLinear()
    .range([height, 0]);

  var xAxis = d3.axisBottom(x)
    .tickSizeInner(-height)
    .tickPadding(10);

  var yAxis = d3.axisLeft(y)
    .tickSizeInner(-width)
    .tickPadding(10)

  var line = d3.line()
    .x(function(d) {
      return x(d[0]);
    })
    .y(function(d) {
      return y(d[1]);
    });

  var svg = d3.select("#apps-submissions-graph").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  data.forEach(function(d) {
    d[0] = parseDate(d[0]);
    d[1] = +d[1];
  });

  x.domain(d3.extent(data, function(d) {
    return d[0];
  }));
  y.domain(d3.extent(data, function(d) {
    return d[1];
  }));

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Applications submitted per day");

  svg.append("path")
    .datum(data)
    .attr("class", "line")
    .attr("d", line);

  var genderValues = [$('.applications_data_gender_count').data('temp')][0];
  var genderGraph = new HorizontalBarGraph('#apps-gender-graph', [{
    label: "Male",
    inner_label: genderValues["Male"],
    value: genderValues["Male"],
    color: "#D8CBC7"
  }, {
    label: "Female",
    inner_label: genderValues["Female"],
    value: genderValues["Female"],
    color: "#CC3F0C"
  }, {
    label: "Non-binary",
    inner_label: genderValues["Non-binary"],
    value: genderValues["Non-binary"],
    color: "#9A6D38"
  }]);


  var ageValues = [$('.applications_data_age_count').data('temp')][0];
  var ageGraphArray = []
  var colorArray = ["#D8CBC7", "#CC3F0C", "#9A6D38", "#33673B", "#D8CBC7", "#CC3F0C", "#9A6D38",
    "#33673B", "#D8CBC7", "#CC3F0C", "#9A6D38", "#33673B"
  ]

  for (i = 0; i < ageValues.length && i < 10; i++) {
    ageGraphArray.push({
      label: ageValues[i][0],
      inner_label: ageValues[i][1],
      value: ageValues[i][1],
      color: colorArray[i]
    });
  }

  var ageGraph = new HorizontalBarGraph('#apps-age-graph', ageGraphArray);

  var gradeValues = [$('.applications_data_grade_count').data('temp')][0];
  var gradeGraphArray = []

  for (i = 0; i < gradeValues.length && i < 10; i++) {
    gradeGraphArray.push({
      label: gradeValues[i][0],
      inner_label: gradeValues[i][1],
      value: gradeValues[i][1],
      color: colorArray[i]
    });
  }

  var gradeGraph = new HorizontalBarGraph('#apps-grade-graph', gradeGraphArray);

  var hsGradeValues = [$('.applications_data_hs_grade_count').data('temp')][0];
  var hsGradeGraphArray = []

  for (i = 0; i < hsGradeValues.length && i < 10; i++) {
    hsGradeGraphArray.push({
      label: hsGradeValues[i][0],
      inner_label: hsGradeValues[i][1],
      value: hsGradeValues[i][1],
      color: colorArray[i]
    });
  }

  var hsGradeGraph = new HorizontalBarGraph('#apps-hs-grade-graph', hsGradeGraphArray);

  var hackathonValues = [$('.applications_data_hackathon_count').data('temp')][0];
  var graphArray = []

  for (i = 0; i < hackathonValues.length && i < 10; i++) {
    graphArray.push({
      label: hackathonValues[i][0],
      inner_label: hackathonValues[i][1],
      value: hackathonValues[i][1],
      color: colorArray[i]
    });
  }
  // First Year, Second Year, Third Year, Fourth Year, Fifth Year, Graduate Student, Not a Student
  var hackathonGraph = new HorizontalBarGraph('#apps-hackathon-graph', graphArray);

  genderGraph.draw();

  // ageGraph.draw();

  gradeGraph.draw();

  hsGradeGraph.draw();

  hackathonGraph.draw();

  var word_array = [];

  var data_common_words = [$('.applications_data_common_words').data('temp')][0].slice(12, 82);
  console.log(data_common_words)
    // Check if there are no words -- like on dev :P
  if (data_common_words.length == 0) {
    console.log("bruh");
    data_common_words = ["I really want to attend SpartaHack because it sounds awesome!!! This is a default reason for attending SpartaHack."];
  } else {
    for (i = 0; i < 70; i++) {
      word_array[i] = {
        text: data_common_words[i][0],
        weight: data_common_words[i][1]
      }
    }

    $("#apps-wordcloud").jQCloud(word_array, {
      removeOverflowing: false,
    });
  }
}
