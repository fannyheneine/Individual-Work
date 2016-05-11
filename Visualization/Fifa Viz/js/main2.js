// SVG drawing area

var margin = {top: 60, right: 40, bottom: 60, left: 60};

var width = 600 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var svg = d3.select("#chart-area").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


// Date parser (https://github.com/mbostock/d3/wiki/Time-Formatting)
var formatDate = d3.time.format("%Y");

// Scales
var xScale = d3.time.scale()
    .range([0, width]);

var yScale = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(xScale)
    .orient("bottom")
    .tickFormat(function(d) { return formatDate(d)});

var yAxis = d3.svg.axis()
    .scale(yScale)
    .orient("left");

svg.append("g")
    .attr("class", "axis x-axis")
    .attr("transform", "translate(0 ," + (height) + ")");

svg.append("g")
    .attr("class", "axis y-axis");


// Initialize data
loadData();

// FIFA world cup
var data;


// Load CSV file
function loadData() {
    d3.csv("data/fifa-world-cup.csv", function(error, csv) {

        csv.forEach(function(d){
            // Convert string to 'date object'
            d.YEAR = formatDate.parse(d.YEAR);

            // Convert numeric values to 'numbers'
            // d.YEAR=+d.YEAR;
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

d3.select("#ranking-type").on("change", updateVisualization)
var choice= "GOALS" ;

var line = d3.svg.line()
    .x(function (d) {return xScale(d.YEAR);})
    .y(function (d) {return yScale(d[choice]);})
    .interpolate("linear");

var dataFiltered= data;

// Add the line path.
svg.append("path")
    .datum(dataFiltered)
    .attr("class", "line")
    .attr("d", line)
    .transition()
    .duration(800)
    .attr("opacity", 1);

// Create listener for filter year change
d3.select("#filterYear").on("click", updateVisualization());
console.log(d3.select("#filterYear"));


// Render visualization
function updateVisualization() {

    console.log(data);

    d3.select("#label").remove();

    choice = d3.select("#ranking-type").property("value")

    var startingYear = formatDate.parse(d3.select("#fromYear").property("value"));
    var endingYear = formatDate.parse(d3.select("#toYear").property("value"));

    console.log(startingYear)

    dataFiltered = data.filter( function(d) {
        // console.log(d.YEAR >= startingYear && d.YEAR <= endingYear);
        return formatDate(d.YEAR) >= formatDate(startingYear) && formatDate(d.YEAR) <= formatDate(endingYear);
    });

//
    // if(data.yearConverted < upperDate && data.yearConverted > lowerDate){data = data};
//
    xScale.domain([d3.min(dataFiltered, function(d) { return d.YEAR; }),d3.max(dataFiltered,function (d) {
        return (d.YEAR);
    })]);

    //x.domain(d3.extent(data, function(d) { return d.YEAR; }))

    yScale.domain([d3.min(data, function (d) {
        return d[choice];
    }), d3.max(data, function (d) {
        return d[choice];
    })]);

    svg.select(".y-axis").transition().duration(800).ease("sin-in-out")
        .call(yAxis);

    svg.select(".x-axis").transition().duration(800).ease("sin-in-out")
        .call(xAxis);


    svg.append("text")
        .attr("y", height + margin.bottom/2)
        .attr("x",width)
        .attr("dy", "1em")
        .attr("font-weight","bold")
        .text("YEAR");


    var myLabel=svg.append("text")
        .data(data)
        .attr("id", "label")
        .attr("y", 0 - margin.top/2)
        .attr("x",0-margin.left)
        .attr("dy", "1em")
        .attr("font-weight","bold");

    myLabel.data(data)
            .transition()
            .duration(800)
            .style("opacity", 0)
            .transition().duration(400)
            .style("opacity", 1)
            .text(choice);

    line.x(function (d) {return xScale(d.YEAR);})
        .y(function (d) {return yScale(d[choice]);})
        .interpolate("linear");

        // Make the changes
        svg.selectAll(".line").transition()
            .duration(1200)
            .attr("d", line(dataFiltered));

        var selection = svg.selectAll("circle").data(dataFiltered);

        selection.enter().append("circle")
            .attr("fill", "white")
            .attr("stroke", "steelblue");

        selection.transition()
            .duration(1200).attr("r", 4)
            .attr("cx", function (d) {
                return xScale(d.YEAR)
            })
            .attr("cy", function (d) {
                return yScale(d[choice])
            });

        selection.exit().transition()
            .duration(200).remove();

        var tip = d3.tip()
            .attr('class', 'd3-tip')
            .html(function(d) {
                return d.EDITION + "</br> " + d[choice] +" "+choice})
            .direction('ne')
            .offset([0, 3]);

        selection.call(tip)
            .on('mouseover', tip.show)
            .on('mouseout', tip.hide)
            .on('click', function(d){
                showEdition(d);
            });


};




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

// PROBLEMS: it seems that it is not updating onclick, only when I change the other value