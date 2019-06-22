package com.dub.spring.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dub.spring.undirectedComponents.DFSGraph;
import com.dub.spring.undirectedComponents.GraphInitRequest;
import com.dub.spring.undirectedComponents.GraphServices;
import com.dub.spring.undirectedComponents.JSONEdge;
import com.dub.spring.undirectedComponents.JSONSnapshot;
import com.dub.spring.undirectedComponents.JSONVertex;
import com.dub.spring.undirectedComponents.SearchRequest;
import com.dub.spring.undirectedComponents.StepResult;


@Controller
public class DFSController {
	
	// using a service layer
	@Autowired
	private GraphServices graphServices;
	
	/** Initialize graph for both automatic and stepwise search */
	@RequestMapping(value="initGraph")
	@ResponseBody
	public StepResult initGraph(@RequestBody GraphInitRequest message, 
				HttpServletRequest request) 
	{	
		List<JSONEdge> jsonEdges = message.getJsonEdges();
		List<JSONVertex> jsonVertices = message.getJsonVertices();
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("graph") != null) {
			session.removeAttribute("graph");
		}
	
		System.out.println("initGraph begin");
	
		
		DFSGraph graph = graphServices.jsonToDFS(jsonEdges, jsonVertices);
	
		graph.display();
		
		session.setAttribute("graph", graph);
			
		StepResult result = new StepResult();
		result.setStatus(StepResult.Status.INIT);
	
		result.setSnapshot(graphServices.dfsToJSON(graph));
		
		System.out.println("new graph constructed");
		
		graph.display2();
			
		// here the graph is ready for the search loop
	
		System.out.println("initGraph completed");
			
		return result;
	}
	
	@RequestMapping(value="dfsStep")
	@ResponseBody
	public StepResult dfsStep(@RequestBody SearchRequest message, 
				HttpServletRequest request) 
	{	
		// retrieve graph from session context
		HttpSession session = request.getSession();
		DFSGraph graph = (DFSGraph)session.getAttribute("graph");
		
		graph.searchStep();
		
		JSONSnapshot snapshot = graphServices.dfsToJSON(graph);
	
		StepResult result = new StepResult();
		
		result.setSnapshot(snapshot);
		if (graph.isFinished()) {
			result.setStatus(StepResult.Status.FINISHED);
			System.out.println("controller: FINISHED");
		} else {
			result.setStatus(StepResult.Status.STEP);
		}
		
		return result;
	}
	
}
