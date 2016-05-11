
var width = 800,
    height = 800;

var svg = d3.select("#chart-area").append("svg")
    .attr("width", width)
    .attr("height", height);


// 1) INITIALIZE FORCE-LAYOUT
var force = d3.layout.force()
    .size([width, height]);

var node = svg.selectAll(".node");

var edge = svg.selectAll(".links")

// Load data
d3.json("data/airports.json", function(data) {
    console.log(data)


    // 2a) DEFINE 'NODES' AND 'EDGES'


    // 2b) START RUNNING THE SIMULATION
    force
        .nodes(data.nodes)
        .links(data.links)
        .start()

    // 3) DRAW THE LINKS (SVG LINE)

    // Draw edges
    edge.data(data.links)
        .enter().append("line")
        .attr("class", "edge")
        .attr("stroke", "black");

    // 4) DRAW THE NODES (SVG CIRCLE)

    // Draw nodes
    node.data(data.nodes)
        .enter().append("circle")
        .attr("class", "node")
        .attr("r", 5)
        .attr("fill", function(d) {
            if(d.country=="United States"){
                return "blue"
            }
            else {
                return "red"
            }
        })
        .call(force.drag)
        .append("title")
        .text(function(d) { return d.name; });

    // 5) LISTEN TO THE 'TICK' EVENT AND UPDATE THE X/Y COORDINATES FOR ALL ELEMENTS

    force.on("tick", function () {
       svg.selectAll(".node")
            .attr("cx", function (d) {
                return d.x;
            })
            .attr("cy", function (d) {
                return d.y;
            });

        svg.selectAll("line")
            .attr("x1", function(d) {return d.source.x;})
            .attr("y1", function(d) {return d.source.y;})
            .attr("x2", function(d) {return d.target.x;})
            .attr("y2", function(d) {return d.target.y;})

    });

});