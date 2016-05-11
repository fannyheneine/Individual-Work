/**
 * Created by macuser on 3/6/16.
 */
var width = 1000,
    height = 600;

var svg = d3.select("#map-area").append("svg")
    .attr("width", width)
    .attr("height", height);

var projection = d3.geo.orthographic()
    .scale([300])
    .translate([width / 2, height / 2])
    .rotate([-10,-10,5])
    .precision(.1);

// var edges = svg.selectAll("line");

// var force = d3.layout.force()
//    			   .size([width, height]);

var path = d3.geo.path()
    .projection(projection);

// Load data parallel
queue()
    .defer(d3.json, "data/atlas.json")
    .defer(d3.json, "data/airports.json")
    .await(Visualization);

function Visualization(error, data1, data2) {
    // Visualize data1 and data2
    console.log(data2)

    var atlas = topojson.feature(data1, data1.objects.countries).features


    // force
    //  .nodes(data2.nodes)
    //  .links(data2.links)
    //  .start();


    svg.selectAll("path")
        .data(atlas)
        .enter()
        .append("path")
        .attr("d", path)
        .style("fill", "#F5FFFA");

    svg.selectAll(".airport")
        .data(data2.nodes)
        .enter()
        .append("circle")
        .attr("class", "airport")
        .attr("fill", "#FFA500")
        .attr("r", 5)
        .attr("transform", function(d) {
            return "translate(" + projection([d.longitude, d.latitude]) + ")";
        });


};