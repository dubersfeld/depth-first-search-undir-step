<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    												pageEncoding="UTF-8" %>
<!doctype html>

<html lang="en">
<head>
<meta charset="utf-8">
<title>Depth First Search on undirected graph</title>

<link rel="stylesheet"
              href="<c:url value="/resources/stylesheet/bfsDemo.css" />" />

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>


<script>
"use strict";


var Debugger = function() { };// create  object
  	Debugger.log = function(message) {
  	try {
    	console.log(message);
  	} catch(exception) {
    	return;
  	}
}

function canvasSupport() {
  	return !!document.createElement('canvas').getContext;
} 

function canvasApp() {

  	function Vertex(name) {
    	this.mName = name;
    	this.mColor = "black";
    	this.md = 0;
    	this.mf = 0;
    	this.mComp = null;// comp number
  	}// Vertex

  	// Vertex augmentation
  	function DisplayVertex(name) {
    	Vertex.call(this, name);
  	}// DisplayVertex

  	DisplayVertex.prototype = new Vertex();
  	DisplayVertex.prototype.mRadius = 20;
  	DisplayVertex.prototype.xPos = 0;
  	DisplayVertex.prototype.yPos = 0;
  	DisplayVertex.prototype.yConnU = 0;
  	DisplayVertex.prototype.yConnB = 0;
  	DisplayVertex.prototype.xConnL = 0;
  	DisplayVertex.prototype.xConnR = 0;
  	// 4 connection points, bottom, up, left, right
  	DisplayVertex.prototype.mNx = 0;
  	DisplayVertex.prototype.mNy = 0;
 
  	DisplayVertex.prototype.updateGeometry = function() {  
    	this.yConnU = this.yPos - this.mRadius;
    	this.yConnB = this.yPos + this.mRadius;
    	this.xConnL = this.xPos - this.mRadius;
    	this.xConnR = this.xPos + this.mRadius;
  	};

  
  	function Edge() {
	  	this.to;//adjacent vertex
  	}
  
 	
  	var geometry = 
  		{"a0": [0, 0], "b0": [1, 0], "c0": [2, 0], "d0": [3, 0], "e0": [4, 0], "f0": [5, 0], "g0": [6, 0],
		 "a1": [0, 1], "b1": [1, 1], "c1": [2, 1], "d1": [3, 1], "e1": [4, 1], "f1": [5, 1], "g1": [6, 1],
		 "a2": [0, 2], "b2": [1, 2], "c2": [2, 2], "d2": [3, 2], "e2": [4, 2], "f2": [5, 2], "g2": [6, 2],  
		 "a3": [0, 3], "b3": [1, 3], "c3": [2, 3], "d3": [3, 3], "e3": [4, 3], "f3": [5, 3], "g3": [6, 3],
		 "a4": [0, 4], "b4": [1, 4], "c4": [2, 4], "d4": [3, 4], "e4": [4, 4], "f4": [5, 4], "g4": [6, 4]
  	};
  

  	// base class
  	function Graph(N) {// A Weighted Graph contains a vector of N vertices
    	this.mV = [];
    	this.mAdj = [];// indexes of adjacent vertices
    	this.mE = [];// all edges, array of arrays
    	this.init = function() {
      		for (var i = 0; i < N; i++) {
        		this.mAdj.push(new Array());
      		}
      		console.log("Graph.adj init completed");
    	}; 
    	// array of arrays of arrays format [[v,v,v],[]...[]]
    	// v = vertex number 
    	this.init();
    
  	}// Graph


  	// get canvas context
  	if (!canvasSupport) {
    	alert("canvas not supported");
    	return;
  	} else {
    	var theCanvas = document.getElementById("canvas");
    	var context = theCanvas.getContext("2d");
  	}// if

  	var xMin = 0;
  	var yMin = 0;
  	var xMax = theCanvas.width;
  	var yMax = theCanvas.height; 

  	var xPos = [50, 150, 250, 350, 450, 550, 650];
  	var yPos = [100, 200, 300, 400, 500];

  	var names = ["a", "b", "c", "d", "e", "f" ,"g"];
  	
  	var compColors = ["blue", "blueViolet", "brown", "burlyWood", 
                      "cadetBlue", "chartreuse", "forestGreen", "coral",
                      "darkCyan", "darkGoldenRod", "darkGray", "darkGreen", "magenta", "blue"];
   

  	var time;
  	var N = 35;
  	var Nedges = 20;
  
  	var result;

  	var graph = new Graph(N);// empty graph
  
  	function setTextStyle() {
    	context.fillStyle    = '#000000';
    	context.font         = '12px _sans';
  	}


  	function fillBackground() {
    	// draw background
    	context.fillStyle = '#ffffff';
    	context.fillRect(xMin, yMin, xMax, yMax);    
  	}// fillBackground

  	function drawVertex(vertex) {
	
  		if (vertex.mComp != null && vertex.mF != 0) { 
      		context.strokeStyle = compColors[vertex.mComp % compColors.length];  
    	} else {
      		context.strokeStyle = vertex.mColor; 
    	}
  		
    	context.beginPath();  
    	context.lineWidth = 2;
    	context.arc(vertex.xPos, vertex.yPos, vertex.mRadius, (Math.PI/180)*0, (Math.PI/180)*360, true); // draw full circle
    	context.stroke();
    	context.closePath();   
    	var roff = vertex.mRadius + 2;
    	var timestamp = "";
    	
    	if (vertex.mD != null) {
    		timestamp += vertex.mD;
    	} 
    	if (vertex.mF != null) {
    		timestamp += "/" + vertex.mF;
    	}
    	
    	if (vertex.mComp != null) {
      		timestamp +=  " " + vertex.mComp; 
    	}
    	context.fillText(vertex.mName, vertex.xPos, vertex.yPos);    
    	context.fillText(timestamp, vertex.xPos + roff, vertex.yPos - roff);
  	}// drawVertex

  
  	function drawLine(a, b, xoff, yoff) {// a and points 
  
    	var xa = a[0];
    	var ya = a[1];
    	var xb = b[0];
    	var yb = b[1];
   
    	context.beginPath();
    	context.moveTo(xa, ya);
    	context.lineTo(xb, yb);
    	context.stroke();
    	context.closePath();
    
   		// get midpoint
   		var xm = (xa + xb) / 2 + xoff;
   		var ym = (ya + yb) / 2 + yoff;
   		
	}// drawLine

  	function build(Nedges) {// build a graph but don't send any request yet 
    	// building an undirected graph
    	setTextStyle();

    	context.textBaseline = "middle";
    	context.textAlign = "center";

    	console.log("build begin " + (graph == undefined));
    	
    	var vertex;
    	
    	graph = new Graph(N);

    	for (var i = 0; i < 5; i++) {
      		for (var j = 0; j < 7; j++) {
        		vertex = new DisplayVertex(names[j] + i);
        		vertex.mNx = j;
        		vertex.mNy = i;
        		vertex.xPos = xPos[j];
        		vertex.yPos = yPos[i];
        		vertex.updateGeometry();        
        		graph.mV.push(vertex);
        		drawVertex(vertex);         
      		}
    	}// for

    	var indMax = 0;
    	var size = 0;
    	var res;
     
    	console.log("build sator");
    	// create initial graph  
    	randomizeUndir(graph, Nedges);
       
    	initDraw(graph);
    
    	console.log("build completed");
    
		var message;
	  
		var edgeArray = [];
		var vertexArray = [];
	  
		var count = 0;
		var edges;
		var vertices;
			
		for (var j = 0; j < N; j++) {// for each vertex
			vertexArray.push({"name":graph.mV[j].mName});
			for (var i = 0; i < graph.mAdj[j].length; i++) {// for each adjacent vertex		
				edgeArray.push({"from":j, "to":graph.mAdj[j][i]});
			}// i
		}// j
	  	  		  
		edges = {"jsonEdges":edgeArray};
		vertices = {"jsonVertices":vertexArray};
		
		
		message = {"jsonEdges":edgeArray, "jsonVertices":vertexArray};
	  
		$('#dfsStep').find(':submit')[0].disabled = true;
    	
    	$.ajax({
			type : "POST",
			contentType : "application/json",
			url : '<c:url value="/initGraph" />',
			data : JSON.stringify(message),
			dataType : 'json',
			timeout : 100000,
			
			success : function(data) {
				console.log("INIT SUCCESSFUL");
				
				if (data["status"] == "INIT") {
					
					result = data["snapshot"];
					
					update();
				
					console.log("redraw graph");
				
					$('#status').text('Ready to search');
					console.log("init completed");
				
				}// if
				
				$('#dfsStep').find(':submit')[0].disabled = false;
			},
			
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
	   
  	}// build

  	function update() {
  		var snapVertices = result["vertices"];
		var snapAdjacencies = result["adjacencies"];
			
		var forge;
	
		for (var i1 = 0; i1 < snapVertices.length; i1++) {		
			graph.mV[i1] = new DisplayVertex(snapVertices[i1]);
			graph.mV[i1].mName = snapVertices[i1].name;
			graph.mV[i1].mColor = snapVertices[i1].color;
			graph.mV[i1].mComp = snapVertices[i1].comp;
			graph.mV[i1].mD = snapVertices[i1].d;
			graph.mV[i1].mF = snapVertices[i1].f;
			graph.mV[i1].mComp = snapVertices[i1].comp;
			graph.mV[i1].mNx = geometry[snapVertices[i1].name][0];
			graph.mV[i1].mNy = geometry[snapVertices[i1].name][1];
			graph.mV[i1].xPos = xPos[graph.mV[i1].mNx];
			graph.mV[i1].yPos = yPos[graph.mV[i1].mNy];
			graph.mV[i1].updateGeometry();
			
			graph.mAdj[i1] = [];
		
			forge = snapAdjacencies[i1].adjacency;// weighted edge
	
			for (var k = 0; k < forge.length; k++) {
				var edge = new Edge();
		
				edge.to = forge[k]["to"];
				graph.mAdj[i1].push(edge);				
			}// for
	
		}// for

  	}// update
  
	function drawConnect(v1, v2) {  
  		// here v1 and v2 are vertices, not indices
  		context.strokeStyle = "black";
		
    	context.lineWidth = 2;
   
    	// discuss according to geometry
    	var xa, ya, xb, yb;

    	if (v1.mNx == v2.mNx) {
      		xa = v1.xPos;
      		ya = (v1.mNy < v2.mNy) ? v1.yConnB : v2.yConnB; 
      		xb = v1.xPos;
      		yb = (v1.mNy < v2.mNy) ? v2.yConnU : v1.yConnU;
    	} else if (v1.mNy == v2.mNy) {
      		ya = v1.yPos;
      		xa = (v1.mNx < v2.mNx) ? v1.xConnR : v2.xConnR; 
      		yb = v1.yPos;
      		xb = (v1.mNx < v2.mNx) ? v2.xConnL : v1.xConnL;
    	} else {
      		xa = (v1.mNx < v2.mNx) ? v1.xConnR : v2.xConnR; 
      		ya = (v1.mNx < v2.mNx) ? v1.yPos : v2.yPos;
      		xb = (v1.mNx < v2.mNx) ? v2.xConnL : v1.xConnL; 
      		yb = (v1.mNx < v2.mNx) ? v2.yPos : v1.yPos;
    	}
    		
     	context.beginPath();
    	context.moveTo(xa, ya);
    	context.lineTo(xb, yb);
    	context.stroke();
    	context.closePath();
    	
 	}// drawConnect


 	function redraw(graph) {// graph is weighted undirected
    	// only use mAdj for drawing connections
    	// clear canvas
    	fillBackground();

    	setTextStyle();

    	context.textBaseline = "middle";
    	context.textAlign = "center";

    	var Nvertices = graph.mV.length;

    	// draw all vertices
    	for (var i = 0; i < N; i++) {
      		drawVertex(graph.mV[i]);
    	}

    	// draw all connections
    	for (var i = 0; i < Nvertices; i++) {
      		var conn = graph.mAdj[i]; // all vertices connected to vertex i
      	
      		for (var k = 0; k < conn.length; k++) {
      			drawConnect(
    					graph.mV[i], 
    					graph.mV[conn[k].to] 
    			);
      			      			
      		}
    	}
    
 	}// redraw
 	
 	function initDraw(graph) {
    	// only use mAdj for drawing connections
    	// clear canvas
    	fillBackground();

    	setTextStyle();

    	context.textBaseline = "middle";
    	context.textAlign = "center";

    	var N = graph.mV.length;

    	// draw all vertices
    	for (var i = 0; i < N; i++) {
      		drawVertex(graph.mV[i]);
    	}

    	// draw all connections
    	for (var i = 0; i < N; i++) {
      		for (var k = 0; k < graph.mAdj[i].length; k++) {        
        		drawConnect(graph.mV[i], graph.mV[ graph.mAdj[i][k]]);        
      		}
    	}
 	}// initDrawgraph.mAdj[i]
 	
 	
  	function randomizeUndir(graph, Nedges) {
    	// undirected graph, adjacence matrix symmetric
    	var edges = 0;
  
    	var check = new Array(N);
    	for (var i = 0; i < N; i++) {
      		check[i] = new Array(N);
    	}

    	for (var i = 0; i < N; i++) {
      		for (var j = 0; j < N; j++) {
        		check[i][j] = 0;
      		}
    	}

    	var index1, index2;

    	// reset all vertices
    	for (var i = 0; i < graph.mV.length; i++) {
      		graph.mV[i].mColor = "black";
      		graph.mV[i].mComp = null;
      		graph.mV[i].md = 0;
      		graph.mV[i].mf = 0;
    	}

    	// remove all existing edges
    	for (var i = 0; i < graph.mAdj.length; i++) {
      		graph.mAdj[i] = [];
    	}

    	while (edges < Nedges) {
      		index1 = Math.floor(Math.random() * N);// range
      		index2 = index1;
      		while (index2 == index1) {
        		index2 = Math.floor(Math.random() * N);// range
      		}
      		var nX1 = graph.mV[index1].mNx;
      		var nY1 = graph.mV[index1].mNy;
      		var nX2 = graph.mV[index2].mNx;
      		var nY2 = graph.mV[index2].mNy;      
      		if ((Math.abs(nX1-nX2) <= 1) && (Math.abs(nY1-nY2) <= 1) ) {// allow edge      
        		// check edge already present
        		if (check[index1][index2] == 0 && check[index2][index1] == 0) {
          			graph.mAdj[index1].push(index2);// symmetry
          			check[index1][index2] = 1;// symmetry
          			graph.mAdj[index2].push(index1);
          			check[index2][index1] = 1;
          			edges++;
        		}        
      		}
    	}// while 
  
    		
    /*		
    graph.mAdj[0] = [8];
    graph.mAdj[1] = [9, 7 ];
    graph.mAdj[2] = [9];
    graph.mAdj[3] = [11, 10, 4 ];
    graph.mAdj[4] = [3 ];
    graph.mAdj[5] = [6, 12 ];
    graph.mAdj[6] = [5, 13 ];
    graph.mAdj[7] = [1, 15 ];
    graph.mAdj[8] = [0, 16, 9 ];
    graph.mAdj[9] = [1, 8, 2 ];
    graph.mAdj[10] = [18, 11, 3 ];//OK
    graph.mAdj[11] = [12, 10, 3 ];
    graph.mAdj[12] = [13, 18, 11, 5 ];
    graph.mAdj[13] = [12, 19, 20, 6 ];
    graph.mAdj[14] = [15 ];
    graph.mAdj[15] = [23, 14, 7 ];
    graph.mAdj[16] = [22, 8 ];
    graph.mAdj[17] = [];
    graph.mAdj[18] = [24, 12, 10 ];
    graph.mAdj[19] = [13 ];
    graph.mAdj[20] = [27, 13 ];//OK
    graph.mAdj[21] = [];
    graph.mAdj[22] = [16, 30 ];
    graph.mAdj[23] = [15 ];
    //graph.mAdj[24] = [30, 31, 18, 25 ];
    graph.mAdj[24] = [18];
    graph.mAdj[25] = [31, 33, 24 ];
    graph.mAdj[26] = [32 ];
    graph.mAdj[27] = [34, 20, 33 ];
    graph.mAdj[28] = [];
    graph.mAdj[29] = [30 ];
    graph.mAdj[30] = [22, 29];
    graph.mAdj[31] = [25, 32 ];
    graph.mAdj[32] = [26, 31 ];
    graph.mAdj[33] = [25, 27 ];
    graph.mAdj[34] = [27];
*/

/*
		for (var i1 = 0; i1 < 35; i1++) {
			console.log( graph.mAdj[i1]);
		}
		*/
	
		$('#status').text('Ready to search');
		$('#dfsStep').find(':submit')[0].disabled = false;
    	console.log("randomizeUndir completed");
 	}// randomizeUndir
 	
  	
  	function dfsStep() {
  		
  		var message = {"type" : "STEP"};
  		
		$('#dfsStep').find(':submit')[0].disabled = true;
  		
  		$.ajax({
			type : "POST",
			contentType : "application/json",
			url : '<c:url value="/dfsStep" />',
			data : JSON.stringify(message),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("SEARCH STEP SUCCESSFUL");
				if (data["status"] == "STEP" || data["status"] == "FINISHED") {
								
					result = data["snapshot"];
				
					update();
				
					console.log("redraw graph");
					redraw(graph);
					$('#status').text('Searching...');
					console.log("dfsStep completed");
				
				}// if
				
				if (data["status"] == "FINISHED") {
					$('#dfsStep').find(':submit')[0].disabled = true;
					console.log("Search completed");
					$('#status').text('Search completed');
				} else {	
					$('#dfsStep').find(':submit')[0].disabled = false;
				}
		  		console.log("dfsStep return");
			},
			
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
  	}
  	  
  	// create initial graph
  	build(Nedges);
 
	$("#dfsStep").submit(function(event) { dfsStep(); return false; });    
  	$("#initelem").submit(function(event) { build(Nedges); return false; });
	$('#initelem').find(':submit')[0].disabled = false;
}// canvasApp

$(document).ready(canvasApp);

</script>
</head>

<body id="all">

  <nav>   
  </nav>

  <header id="intro">
  <h1>Depth First Search Algorithm for undirected graph</h1>
  <p>I present here a Java based demonstration of the Depth First Search algorithm applied to an undirected graph.<br>
I closely follow the approach of Cormen in his classical textbook.</p>
  <h2>Explanations</h2>
  <p>An undirected graph is randomly created. Then the DFS algorithm is applied step-by-step.<br/>
  For each vertex the DFS results are displayed with the format:<br/>
  d/f c<br/>
  where d is the discovery time, f is the finishing time and c is the number of the vertex connected component.<br/>
  Each vertex is colored according to the component it belong to.
</p>
  </header>

  <section id="display">
    <canvas id="canvas" width="700" height="600">
      Your browser does not support HTML 5 Canvas
    </canvas>
    <footer>
      <p>Dominique Ubersfeld, Cachan, France</p>
    </footer> 
 
  </section>

  <section id="controls">
    <div id="DFS">
      <p>Click here for a DFS step</p>
      <form name="dfsStep" id="dfsStep">
        <input type="submit" name="DFS-btn" value="DFSStep">
      </form>
    </div>
    <div id="randomize">
      <p>Click here to randomize the graph edges</p>
      <form name="initialize" id="initelem">
        <input type="submit" name="randomize-btn" value="Randomize">
      </form>
    </div> 
    <div id="msg">
      <p id="status"></p>
    </div> 
    
    
  </section>

</body>

</html>