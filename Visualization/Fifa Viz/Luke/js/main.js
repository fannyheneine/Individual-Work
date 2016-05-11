
// SVG drawing area

var margin = {top: 40, right: 40, bottom: 60, left: 60};

var width = 600 - margin.left - margin.right,
		height = 500 - margin.top - margin.bottom;

var svg = d3.select("#chart-area").append("svg")
		.attr("width", width + margin.left + margin.right)
		.attr("height", height + margin.top + margin.bottom)
	.append("g")
		.attr("transform", "translate(" + margin.left + "," + margin.top + ")");


// Scales
var x =d3.time.scale()
	   .range([0, width]);

var y = d3.scale.linear()
    .range([height, 0]);
// Date parser (https://github.com/mbostock/d3/wiki/Time-Formatting)
var formatDate = d3.time.format("%Y");


// Initialize data
loadData();

// FIFA world cup
// var startingYear;
// var endingYear;
var data;
var yearFormatDate = d3.time.format("%Y");

// Load CSV file
function loadData() {
	d3.csv("data/fifa-world-cup.csv", function(error, csv) {

		csv.forEach(function(d){
			// Convert string to 'date object'
			d.YEAR = formatDate.parse(d.YEAR);
			d.yearConverted  = yearFormatDate(d.YEAR);
			
			// Convert numeric values to 'numbers'
			d.TEAMS = +d.TEAMS;
			d.MATCHES = +d.MATCHES;
			d.GOALS = +d.GOALS;
			d.AVERAGE_GOALS = +d.AVERAGE_GOALS;
			d.AVERAGE_ATTENDANCE = +d.AVERAGE_ATTENDANCE;
		});

		// Store csv data in global variable
		data = csv;
		// Draw the visualization for the first time
		updateVisualization();
	});
}

// Make a tip: https://github.com/Caged/d3-tip/blob/master/examples/circles.html
var tip = d3.tip()
  .attr('class', 'd3-tip')
  .html(function(d) { 
  		return d.EDITION + "</br> " + d[val]})
  .direction('nw')
  .offset([0, 3]);
// Make an xAx
var xAx = d3.svg.axis()
    .scale(x)
    .orient("bottom");

// Create bar y-axis.
var yAx = d3.svg.axis()
    .scale(y)
    .orient("left");

// Appends y-axis
var appendY = svg.append("g")
		        .attr("class", "axis y-axis")
		        .call(yAx);

// Attach x-axis
var appendX = svg.append("g")
		        .attr("class", "axis x-axis")
		        .attr("transform", "translate (0," + (height)+ ")")
		        .call(xAx);
  
var type = d3.select("#ranking-type").on("change", updateVisualization);

// var lowerDate = "1970"// d3.select("#startingYear").on("submit", changeData);
// var upperDate = "2015" // d3.select("#endingYear").on("submit", changeData);

// console.log(upperDate);

// function changeData(input){

// 	formatDate.parse(upperDate);
// 	formatDate.parse(lowerDate);

// 	console.log(lowerDate)

// 	data = (data.YEAR > lowerDate && data.YEAR < upperDate);
// 	updateVisualization(data);

// }

// Create listener for filter year change
d3.select("#filterYear").on("click", updateVisualization);
// function changeYear() {
//     // Set start and end year to input box choice
//     startingYear = formatDate.parse(d3.select("#fromYear").property("value"));
//     endingYear = formatDate.parse(d3.select("#toYear").property("value"));
// }

var line = d3.svg.line()
			.x(function(d) { 
				return x(d.YEAR); //running through a scale
			})
			.y(function(d) { //d3 component
				return y(d[val]); //running through a scale
			});		

var circle;
var pathline;		

//var test = svg.append("g").attr("class", "animal");
// Render visualization
function updateVisualization() {


val = d3.select('#ranking-type').property("value");

startingYear = formatDate.parse(d3.select("#fromYear").property("value"));
endingYear = formatDate.parse(d3.select("#toYear").property("value"));

var dataFiltered = data.filter( function(d) {
       // console.log(d.YEAR >= startingYear && d.YEAR <= endingYear);
        return formatDate(d.YEAR) >= formatDate(startingYear) && formatDate(d.YEAR) <= formatDate(endingYear);
 });

//
 // if(data.yearConverted < upperDate && data.yearConverted > lowerDate){data = data};
//
console.log(dataFiltered.yearConverted);
  dataFiltered.sort(function(a, b) { return b.YEAR - a.YEAR; });
  y.domain([0, d3.max(data, function(d) { return d[val] })]);
  x.domain([d3.min(dataFiltered, function(d) { return d.YEAR }), d3.max(dataFiltered, function(d) { return d.YEAR })])//data.map(function(d) { return d.YEAR; }));
  yAx.scale(y);
  xAx.scale(x);
  d3.select('.y-axis').transition().duration(300).call(yAx);
  d3.select('.x-axis').transition().duration(300).call(xAx);

		
			circle = svg.selectAll(".line-point")
					 .data(dataFiltered);

				circle
					 .enter()
					 .append("circle")
					 .attr("fill", "steelblue")
					 .attr("class", "line-point");

			  circle.transition()
			  		.ease("linear")
			  		.duration(300)
					 .attr("cx", function (d) {
					 	return x(d.YEAR)
					 })
					 .attr("cy", function (d) {
					 	return y(d[val])
					 })
					 .attr("r", function(d) {
					 	return 4;
					 });
				
				circle  
				    .call(tip)
					.on('mouseover', tip.show)
      				.on('mouseout', tip.hide)
      				.on('click', function(d){
      					showEdition(d);
      				});

circle.exit().remove();
//svg.selectAll(".line-point").remove();

// svg.selectAll("line-circle").transition().duration(300);
	pathline = svg.selectAll(".pathline")
				 .data([dataFiltered]); // requires an array --> path needs an array 

	pathline
		.enter()
		.append("path")
		.attr("class", "pathline");

	pathline.transition()
			.ease("linear")
			.duration(300)
			.attr("d", function(d){
				return line(d);
			});

	pathline.exit().remove();



// svg.selectAll("path.dataLine").interrupt().transition().duration(800).remove();
 
// var lineDrawn = svg.append("path").attr("class", "dataLine").attr("d", line(dataFiltered));
// circle.exit().remove();
}

// Show details for a specific FIFA World Cup
function showEdition(d){

	document.getElementById("edition").innerHTML = d.EDITION
	document.getElementById("year").innerHTML = formatDate(d.YEAR)
	document.getElementById("winner").innerHTML = d.WINNER
	document.getElementById("teams").innerHTML = d.TEAMS
	document.getElementById("matches").innerHTML = d.MATCHES
	document.getElementById("goals").innerHTML = d.GOALS
	document.getElementById("average-goals").innerHTML = d.AVERAGE_GOALS
	document.getElementById("average-attendance").innerHTML = d.AVERAGE_ATTENDANCE
	
}
