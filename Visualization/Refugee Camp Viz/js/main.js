
// SVG Size
var width = 500,
	height = 500;

var margin=50;

var svg = d3.select("#chart-area1").append("svg")
	.attr("width", width)
	.attr("height", height);

//Anpther way of doing the svg which is more effective in that case is:
// var margin=(top:40, right:10, bottome:40, left:40)

// var svg=d3.select("#chart-area1").append("svg")
//			.attr("width",width + margin.left + margin.right)
//			.attr("height",height + margin.top + margin.bottom)
//			.append("g")
//   		.attr("transform","translate(" +margin.left+"," +margin.top +")")


var svg2 = d3.select("#chart-area2").append("svg")
	.attr("width", width)
	.attr("height", height);


var type1 ={
	shelter:"Caravans",
	percent:0.7968,
};

var type2 ={
	shelter:"Combination",
	percent:0.1081,
};

var type3 ={
	shelter:"Caravans",
	percent:0.0951,
};


var shelterType =[type1, type2, type3];


var percentScale = d3.scale.linear()
	.domain([d3.min(shelterType, function(d) { return d.percent}), d3.max(shelterType, function(d) { return d.percent+0.1; })])
	.range([height-margin, margin]);

var xScale = d3.scale.ordinal()
	.rangeBands([0, 500]);

var barWidth = 150;

var bar = svg2.selectAll("g")
	.data(shelterType)
	.enter().append("g")
	.attr("transform", function(d, i) { return "translate(" + i * barWidth + ",0)"; });

bar.append("rect")
	.attr("y", function(data){ return percentScale(data.percent);})
	.attr("x",function(d,i){return i+50 })
	.attr("height", function(data){ return percentScale(data.percent)*100})
	.attr("width", barWidth-40 )
	.attr("fill","#FEE0C6");

bar.append("text")
	.attr("x", barWidth / 2.1)
	.attr("y", height-margin/1.5)
	.attr("dy", ".75em")
	.text(function(d) { return d.shelter; });

var perc=d3.format("%");

bar.select("text.value")
	.data(shelterType)
	.enter()
	.append("text")
	.text(function(d){
		return perc(d.percent);
	})
	.attr("text-anchor", "middle")
	.attr("dy", ".75em")
	.attr("y",function(data){ return percentScale(data.percent+0.05);})
	.attr("x",function(d,i){return i*150+100 })
	.attr("font-size", "11px")
	.attr("fill", "black");

var group2 = svg2.append("g")


var xAxis2 = d3.svg.axis()
	.scale(xScale)
	.orient("bottom");

var yAxis2 = d3.svg.axis()
	.scale(percentScale)
	.orient("left")
	.tickFormat(d3.format(".0%"))
	.ticks(10);

svg2.append("g")
	.attr("class", "axis y-axis")
	.attr("transform", "translate(" + margin + ",0)")
	.call(yAxis2);

svg2.append("g")
	.attr("class", "axis x-axis")
	.attr("transform", "translate("+margin+"," + (height) + ")")
	.call(xAxis2);



// Load CSV file
d3.csv("data/zaatari-refugee-camp-population.csv", function(data){
	number = data.length;
	var format = d3.time.format("%Y-%m-%d");
	for (i=0;i<number;i++) {
		data[i].population=+data[i].population;
		data[i].date=format.parse(data[i].date)
	};

	// Analyze the dataset in the web console
	console.log(data);

	var group = svg.append("g");

	var PopScale = d3.scale.linear()
		.domain([d3.min(data, function(d) { return d.population; }), d3.max(data, function(d) { return d.population; })])
		.range([height-margin, margin]);

	var TimeScale = d3.time.scale()
		.domain([d3.min(data, function(d) { return d.date; }), d3.max(data, function(d) { return d.date; })])
		.range([margin, width-margin]);

	var xAxis = d3.svg.axis()
		.scale(TimeScale)
		.orient("bottom")
		.tickFormat(d3.time.format("%b %Y"));

	var yAxis = d3.svg.axis()
		.scale(PopScale)
		.orient("left")
		.ticks(10);

	svg.append("g")
		.attr("class", "axis y-axis")
		.attr("transform", "translate(" + margin + ",0)")
		.call(yAxis);

	svg.append("g")
		.attr("class", "axis x-axis")
		.attr("transform", "translate(0," + (height - margin) + ")")
		.call(xAxis)
		.selectAll("text")
		.attr("x",-28)
		.attr("y",-10)
		.attr("transform", "rotate(-45)")
		.attr("font-weight","bold");


	var area = d3.svg.area()
		.x(function(d) { return TimeScale(d.date);})
		.y0(height-margin)
		.y1(function(d) { return PopScale(d.population); });

	var path = svg.append("path")
		.datum(data)
		.attr("fill","none")
		.attr("class", "area")
		.attr("d", area);

	var bisectDate = d3.bisector(function(d) { return d.date; }).left;

	// Define the line
	var line = d3.svg.line()
		.x(function(d) { return TimeScale(d.date); })
		.y(function(d) { return PopScale(d.population); });

	var lineSvg = svg.append("g");

	var focus = svg.append("g")
		.style("display", "none");

	// Add the valueline path.
	lineSvg.append("path")
		.attr("fill","none")
		.attr("class", "line")
		.attr("d", line(data));

	svg.append("path")
		.datum(data)
		.attr("fill","none")
		.attr("class", "line")
		.attr("d", line);


	// append the circle at the intersection               // **********
	focus.append("circle")                                 // **********
		.attr("class", "y")                                // **********
		.style("fill", "steelblue")                             // **********
		.style("stroke", "steelblue")                           // **********
		.attr("r", 4);

	focus.append("text")
		.attr("x", 9)
		.attr("dy", ".35em");

	var parseDate = d3.time.format("%d-%b-%y").parse;

// append the rectangle to capture mouse
	svg.append("rect")
		.attr("width", width)
		.attr("height", height)
		.style("fill", "none")
		.style("pointer-events", "all")
		.on("mouseover", function() { focus.style("display", null); })
		.on("mouseout", function() { focus.style("display", "none"); })
		.on("mousemove", mousemove);

	function mousemove() {
		var x0 = TimeScale.invert(d3.mouse(this)[0]),
			i = bisectDate(data, x0, 1),
			d0 = data[i - 1],
			d1 = data[i],
			d = x0 - d0.date > d1.date - x0 ? d1 : d0;
		focus.attr("transform", "translate(" + TimeScale(d.date) + "," + PopScale(d.population) + ")");
		focus.select("text").text(d.population +" refugees on "+format(d.date));
	}

});
