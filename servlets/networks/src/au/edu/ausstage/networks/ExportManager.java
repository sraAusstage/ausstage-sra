/*
 * This file is part of the AusStage Navigating Networks Service
 *
 * The AusStage Navigating Networks Service is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * The AusStage Navigating Networks Service is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with the AusStage Navigating Networks Service.  
 * If not, see <http://www.gnu.org/licenses/>.
*/

package au.edu.ausstage.networks;

// import additional libraries
//jena
import com.hp.hpl.jena.query.*;
// general java
import java.util.*;
import java.io.*;

//xml
import org.w3c.dom.*;
import javax.xml.parsers.*; 
import javax.xml.transform.*; 
import javax.xml.transform.dom.*; 
import javax.xml.transform.stream.*;

import au.edu.ausstage.utils.*;
import au.edu.ausstage.networks.types.*;

/**
 * A class to manage the export of information
 */
public class ExportManager {

	// declare private class level variables
	private DataManager rdf = null;
	private DatabaseManager   db    = null;
	
	/**
	 * Constructor for this class
	 */
	public ExportManager(DataManager rdf) {	
		// store a reference to this DataManager for later
		this.rdf = rdf;
	} // end constructor
	
	public ExportManager(DatabaseManager db){
		this.db = db;
	}
	
	public ExportManager(DataManager rdf, DatabaseManager db){
		this.rdf = rdf;
		this.db = db;
	}
	
	/**
	 * A method to lookup the key collaborators for a contributor
	 *
	 * @param id          the unique id of the contributor
	 * @param formatType  the required format of the data
	 * @param radius      the required number of edges from the central contributor
	 * @param graphType   the type of graph to created, must be one of directed / undirected
	 * @param printWriter the output stream to use to stream the output to the client
	 */
	public void buildCollaboratorNetworkGraphml(String id, String formatType, int radius, String graphType, PrintWriter printWriter) {
	
		// check the parameters
		if(InputUtils.isValidInt(id) == false || InputUtils.isValid(formatType) == false || InputUtils.isValid(graphType) == false || printWriter == null) {
			throw new IllegalArgumentException("Error: All parameters to this method are required");
		}
		
		if(InputUtils.isValidInt(radius, ExportServlet.MIN_DEGREES, ExportServlet.MAX_DEGREES) == false) {
			throw new IllegalArgumentException("Error: the radius parameter must be between " + ExportServlet.MIN_DEGREES + " and " + ExportServlet.MAX_DEGREES);
		}
		
		if(formatType.equals("graphml") == true) {

			//create Document 
			Document egoDom = createXMLDoc("http://graphml.graphdrawing.org/xmlns", "graphml", null);
				
			ProtovisEgoCentricManager egoManager = new ProtovisEgoCentricManager(rdf);
			egoDom = egoManager.toGraphMLDOM(egoDom, id, radius, graphType);
		
			if (egoDom != null)
				domToXMLString(printWriter, egoDom);
			else
				throw new RuntimeException("Dom is  null !");
			
			//buildGraphml(network, graphType, printWriter);
			
		} else if(formatType.equals("debug")) {
			
			ProtovisEgoCentricManager egoManager = new ProtovisEgoCentricManager(rdf);
			TreeMap<Integer, Collaborator> network = egoManager.getRawCollaboratorData(id, radius);
			buildDebugFile(network, graphType, printWriter);
			
		}	
	}
	
	/**
	 * A method to lookup the ego centric network based on organisation
	 *
	 * @param id          the unique id of the organisation
	 * @param formatType  the required format of the data
	 * @param radius      the required number of edges from the central contributor
	 * @param graphType   the type of graph to created, must be one of directed / undirected
	 * @param printWriter the output stream to use to stream the output to the client
	 */
	public void buildCollaboratorNetworkByOrgGraphml(String id, String formatType, int radius, String graphType, PrintWriter printWriter) {
	
		// check the parameters
		if(InputUtils.isValidInt(id) == false || InputUtils.isValid(formatType) == false || InputUtils.isValid(graphType) == false || printWriter == null) {
			throw new IllegalArgumentException("Error: All parameters to this method are required");
		}
		
		if(InputUtils.isValidInt(radius, ExportServlet.MIN_DEGREES, ExportServlet.MAX_DEGREES) == false) {
			throw new IllegalArgumentException("Error: the radius parameter must be between " + ExportServlet.MIN_DEGREES + " and " + ExportServlet.MAX_DEGREES);
		}
	
	
		//create Document 
		Document egoDom = createXMLDoc("http://graphml.graphdrawing.org/xmlns", "graphml", null);

		// Create a new EgoCentricByOrgManager
		//Call toGraphMLDOM_org()
		EgoCentricByOrgManager egoManager = new EgoCentricByOrgManager(rdf, db);
		egoDom = egoManager.toGraphMLDOM_org(egoDom, id, radius, graphType);		
		domToXMLString(printWriter, egoDom);	
				
	}
	
	
	/**
	 * A method to output the export in the plain text format used for debugging
	 *
	 * @param collaborators the list of collaborators
	 * @param graphType  the type of graph to created, must be one of directed / undirected
 	 * @param printWirter the output stream to use to stream the output to the client
	 */
	private void buildDebugFile(java.util.TreeMap<Integer, Collaborator> collaborators, String graphType, PrintWriter printWriter) {
		
		// add some additional information
		printWriter.print("# Graph generated on: " + DateUtils.getCurrentDateAndTime() + "\n");
		printWriter.print("# Graph generated by: " + rdf.getContextParam("systemName") + " Version: " + rdf.getContextParam("systemVersion") + " Build: " + rdf.getContextParam("buildVersion") + "\n");
		printWriter.print("# Graph Type: " + graphType + "\n");
		
		// loop through the list of contributors
		Collection values   = collaborators.values();
		Iterator   iterator = values.iterator();
		
		while(iterator.hasNext()) {
		
			// get the collaborator
			Collaborator collaborator = (Collaborator)iterator.next();
			
			printWriter.print(collaborator.getId() + " - ");
			
			printWriter.print(java.util.Arrays.toString(collaborator.getCollaboratorsAsArray()).replaceAll("[\\]\\[]", "") + " - ");
			printWriter.print(collaborator.getCollaboratorsAsArray().length + "\n");
		}
		
		//return dataToReturn.toString();
	} // end the buildDebugFile	
	
	/**
	 * A method to output the export in the graphml format
	 *
	 * @param collaborators the list of collaborators
	 * @param graphType  the type of graph to created, must be one of directed / undirected
 	 * @param printWirter the output stream to use to stream the output to the client
	 */
	private void buildGraphml(java.util.TreeMap<Integer, Collaborator> collaborators, String graphType, PrintWriter printWriter) {
		Document               xmlDoc;
		Element                rootElement;
		Element                graph;
		Element                node;
		Element                edge;
		Element                data;
		
		// keep track of the nodes and edges we've created
		TreeSet<String> nodes = new TreeSet<String>();
		TreeSet<String> edges = new TreeSet<String>();
		
		// manage looping through the list of collaborators
		Collaborator collaborator;
		Collection values;
		Iterator   iterator;
		String[]   edgesToMake;		
		
		xmlDoc = createXMLDoc("http://graphml.graphdrawing.org/xmlns", "graphml", null);
				
		// get the root element
		rootElement = xmlDoc.getDocumentElement();
		
		// add schema namespace to the root element
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
		
		// add reference to the kml schema
		rootElement.setAttribute("xsi:schemaLocation", "http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd");
		
		// add some useful comments to the file
		rootElement.appendChild(xmlDoc.createComment("Graph generated on: " + DateUtils.getCurrentDateAndTime()));
//		rootElement.appendChild(xmlDoc.createComment("Graph generated by: " + rdf.getContextParam("systemName") + " Version: " + rdf.getContextParam("systemVersion") + " Build: " + rdf.getContextParam("buildVersion")));
		
		// add the graph element
		graph = xmlDoc.createElement("graph");
		graph.setAttribute("id", "ausstage-graph");
		graph.setAttribute("edgedefault", graphType);
		rootElement.appendChild(graph);
		
		// reset the edge and node variables
		node = null;
		data = null;
		
		// loop through the list of contributors
		values = collaborators.values();
		iterator = values.iterator();
		
		while(iterator.hasNext()) {
		
			// get the collaborator
			collaborator = (Collaborator)iterator.next();
			
			if(nodes.contains(collaborator.getId()) == false) {
			
				// add a node for this contributor
				node = xmlDoc.createElement("node");
				node.setAttribute("id", collaborator.getId());
				
				// add the node to the graph
				graph.appendChild(node);
				
				// store a reference to this contributor so we don't do a node for them
				nodes.add(collaborator.getId());
			}
			
			// get the edges from this contributor
			edgesToMake = collaborator.getCollaboratorsAsArray();
			
			// loop through the edges associated with this collaborator
			for(int i = 0; i < edgesToMake.length; i++) {
			
				if(nodes.contains(edgesToMake[i]) == false) {
					
					// add a node as we can't have an edge to a node that doesn't exist
					node = xmlDoc.createElement("node");
					node.setAttribute("id", edgesToMake[i]);
					graph.appendChild(node);
				
					// store a reference to this contributor so we don't do a node for them
					nodes.add(edgesToMake[i]);
				}
				
				// do not add self referential edges
				if(collaborator.getId().equals(edgesToMake[i]) == false) {
				
					// check to see if an edge already exists
					if(edges.contains(collaborator.getId() + edgesToMake[i]) == false && edges.contains(edgesToMake[i] + collaborator.getId()) == false) {
						// add this edge
						edge = xmlDoc.createElement("edge");
						edge.setAttribute("source", collaborator.getId());
						edge.setAttribute("target", edgesToMake[i]);
					
						graph.appendChild(edge);
				
						// store a reference for this edge
						edges.add(collaborator.getId() + edgesToMake[i]);
						edges.add(edgesToMake[i] + collaborator.getId());
					}
				}
			}			
		}
		
		// turn the XML into a string
		domToXMLString(printWriter, xmlDoc);
		
	}// end the buildGraphml method
	
	public Document createXMLDoc(String namespaceURI, String qualifiedName,  DocumentType doctype){
		
		// declare helper variables
		/* xml related */
		DocumentBuilderFactory factory;
		DocumentBuilder        builder;
		DOMImplementation      domImpl;
		Document               xmlDoc;
		
		// start the graphml
		// create the xml document builder factory object
		factory = DocumentBuilderFactory.newInstance();
		
		// set the factory to be namespace aware
		factory.setNamespaceAware(true);
		
		// create the xml document builder object and get the DOMImplementation object
		try {
			builder = factory.newDocumentBuilder();
		} catch (javax.xml.parsers.ParserConfigurationException ex) {
			throw new RuntimeException(ex);
		}
		
		domImpl = builder.getDOMImplementation();
		
		// create a document with the appropriare default namespace
		xmlDoc = domImpl.createDocument(namespaceURI, qualifiedName, doctype);
		return xmlDoc;
	}
	
	
	/**
	 * Writing a DOM Document to an XML File
	 * 
	 * @param printWriter the output stream to use to stream the output to the client
	 * @param xmlDoc	XML DOM Document
	 */
	public void domToXMLString(PrintWriter printWriter, Document xmlDoc){
		try {
			// create a transformer 
			TransformerFactory transFactory = TransformerFactory.newInstance();
			Transformer        transformer  = transFactory.newTransformer();
			
			// set some options on the transformer
			transformer.setOutputProperty(OutputKeys.ENCODING, "utf-8");
			//transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			
			// get a transformer and supporting classes
			//StringWriter writer = new StringWriter();
			StreamResult result = new StreamResult(printWriter);
			DOMSource    source = new DOMSource(xmlDoc);
			
			// transform the xml document into a string
			transformer.transform(source, result);
			
			printWriter.close();
		} catch (javax.xml.transform.TransformerException ex) {
			throw new RuntimeException("Unable to create the graphml");
		}
	} 
	
	/**
	 * A method to build and return a full edge list
	 *
	 * @param taskType the exact type of edge list to output
	 * @param printWriter the output stream to use to stream the output to the client
	 */
	public void getFullEdgeList(String taskType, PrintWriter printWriter) {
	
		// define helper variables
		String        queryString = null;
		QuerySolution row         = null;
		String        tmp         = null;
		String[]      tmps        = null;
		Integer       firstId     = 0;
		Integer       secondId    = 0;
	
		// determine what type fo query is required
		if(taskType.equals("full-edge-list-with-dups") == true || taskType.equals("full-edge-list-no-dups") == true) {
		
			queryString = "PREFIX foaf:       <http://xmlns.com/foaf/0.1/> "
						+ "PREFIX ausestage:  <http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#> "
						+ "  "
						+ "SELECT ?contributor ?givenName ?familyName ?collaborator ?collabGivenName ?collabFamilyName "
						+ "WHERE {  "
						+ "       ?contributor   foaf:givenName ?givenName ; "
						+ "                      foaf:familyName ?familyName; "
						+ "                      ausestage:hasCollaboration ?collaboration. "
						+ "       ?collaboration ausestage:collaborator ?collaborator. "
						+ "       ?collaborator  foaf:givenName ?collabGivenName; "
						+ "                      foaf:familyName ?collabFamilyName. "
						+ "       FILTER (?collaborator != ?contributor) "
						+ "}";
		} else {
		
			queryString = "PREFIX foaf:       <http://xmlns.com/foaf/0.1/> "
						+ "PREFIX ausestage:  <http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#> "
						+ "  "
						+ "SELECT ?contributor ?collaborator "
						+ "WHERE {  "
						+ "       ?contributor   ausestage:hasCollaboration ?collaboration. "
						+ "       ?collaboration ausestage:collaborator ?collaborator. "
						+ "       FILTER (?collaborator != ?contributor) "
						+ "}";
		}
		
		// get the data
		// execute the query
		ResultSet results = rdf.executeSparqlQuery(queryString);
		
		// output some additional information
		// add some additional information
		printWriter.print("# Data exported on: " + DateUtils.getCurrentDateAndTime() + "\n");
		printWriter.print("# Data exported by: " + rdf.getContextParam("systemName") + " Version: " + rdf.getContextParam("systemVersion") + " Build: " + rdf.getContextParam("buildVersion") + "\n");
		
		// output the data in the format required
		if(taskType.equals("full-edge-list-with-dups") == true) {
		
			// loop through the resultSet
			while (results.hasNext()) {
				// get a new row of data
				row = results.nextSolution();
				
				// first id
				tmp = row.get("contributor").toString().trim();
				tmps = tmp.split(":");
			
				printWriter.print(tmps[2] + "\t");
			
				// first givenName
				printWriter.print(row.get("givenName").toString().trim() + "\t");
			
				// first familyName
				printWriter.print(row.get("familyName").toString().trim() + "\t");
			
				// knows
				tmp = row.get("collaborator").toString().trim();
				tmps = tmp.split(":");
			
				printWriter.print(tmps[2] + "\t");
			
				// second GivenName
				printWriter.print(row.get("collabGivenName").toString().trim() + "\t");
			
				// second FamilyName
				printWriter.print(row.get("collabFamilyName").toString().trim() + "\n");
			}
			
		} else if(taskType.equals("full-edge-list-no-dups") == true) {
		
			// loop through the resultSet
			while (results.hasNext()) {
				// get a new row of data
				row = results.nextSolution();
				
				// first id
				tmp  = row.get("contributor").toString().trim();
				tmps = tmp.split(":");
			
				firstId = Integer.parseInt(tmps[2]);
			
				// second id
				tmp  = row.get("collaborator").toString().trim();
				tmps = tmp.split(":");
			
				secondId = Integer.parseInt(tmps[2]); 

				// determine if we need to add this line			
				if(firstId < secondId) {
				
					// output the data
					printWriter.print(firstId + "\t");
			
					// first givenName
					printWriter.print(row.get("givenName").toString().trim() + "\t");
		
					// first familyName
					printWriter.print(row.get("familyName").toString().trim() + "\t");
		
					// knows
					printWriter.print(secondId + "\t");
		
					// second GivenName
					printWriter.print(row.get("collabGivenName").toString().trim() + "\t");
		
					// second FamilyName
					printWriter.print(row.get("collabFamilyName").toString().trim() + "\n");
				}
			}			
		} else if(taskType.equals("full-edge-list-with-dups-id-only") == true) {
		
			// loop through the resultSet
			while (results.hasNext()) {
				// get a new row of data
				row = results.nextSolution();
				
				// first id
				tmp = row.get("contributor").toString().trim();
				tmps = tmp.split(":");
			
				printWriter.print(tmps[2] + "\t");
			
				// knows
				tmp = row.get("collaborator").toString().trim();
				tmps = tmp.split(":");
			
				printWriter.print(tmps[2] + "\n");
			}
			
		} else if(taskType.equals("full-edge-list-no-dups-id-only") == true) {
		
			// loop through the resultSet
			while (results.hasNext()) {
				// get a new row of data
				row = results.nextSolution();
				
				// first id
				tmp  = row.get("contributor").toString().trim();
				tmps = tmp.split(":");
			
				firstId = Integer.parseInt(tmps[2]);
			
				// second id
				tmp  = row.get("collaborator").toString().trim();
				tmps = tmp.split(":");
			
				secondId = Integer.parseInt(tmps[2]); 

				// determine if we need to add this line			
				if(firstId < secondId) {
				
					// output the data
					printWriter.print(firstId + "\t");
			
					// knows
					printWriter.print(secondId + "\n");
				}
			}
		}
		
		// play nice and tidy up
		rdf.tidyUp();	
	}
	

	/**
	 * A method to build and return a actor edge list
	 *
	 * @param taskType the exact type of edge list to output
	 * @param printWriter the output stream to use to stream the output to the client
	 */
	public void getActorEdgeList(String taskType, PrintWriter printWriter) {
	
		// define helper variables
		String        queryString = null;
		QuerySolution row         = null;
		String        tmp         = null;
		String[]      tmps        = null;
		Integer       firstId     = 0;
		Integer       secondId    = 0;
	
		// determine what type fo query is required
		if(taskType.equals("actor-edge-list-with-dups") == true || taskType.equals("actor-edge-list-no-dups") == true) {
		
			queryString = "PREFIX foaf:       <http://xmlns.com/foaf/0.1/>  "
						+ "PREFIX ausestage:  <http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#>  "
						+ "  "
						+ "SELECT DISTINCT ?contributor ?givenName ?familyName  ?gender ?collaborator ?collabGivenName ?collabFamilyName ?collabGender "
						+ "WHERE {  "
						+ "       ?contributor   foaf:givenName ?givenName ; "
						+ "                      foaf:familyName ?familyName; "
						+ "                      ausestage:hasCollaboration ?collaboration; "
						+ "                      ausestage:function ?function; "
						+ "                      foaf:gender ?gender.  "
						+ "       ?collaboration ausestage:collaborator ?collaborator.  "
						+ "       ?collaborator  foaf:givenName ?collabGivenName;  "
						+ "                      foaf:familyName ?collabFamilyName; "
						+ "                      ausestage:function ?collabFunction; "
						+ "                      foaf:gender ?collabGender.  "
						+ "       FILTER (?collaborator != ?contributor) "
						+ "       FILTER (?function = 'Actor and Singer' || ?function = 'Actor') "
						+ "       FILTER (?collabFunction = 'Actor and Singer' || ?collabFunction = 'Actor') "
						+ " "
						+ "}";
		} else {
		
			queryString = "PREFIX foaf:       <http://xmlns.com/foaf/0.1/> "
						+ "PREFIX ausestage:  <http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#> "
						+ "  "
						+ "SELECT DISTINCT ?contributor ?collaborator "
						+ "WHERE {  "
						+ "       ?contributor   ausestage:hasCollaboration ?collaboration; "
						+ "                      ausestage:function ?function. "
						+ "       ?collaboration ausestage:collaborator ?collaborator. "
						+ "       ?collaborator  ausestage:function ?collabFunction. "
						+ "       FILTER (?collaborator != ?contributor) "
						+ "       FILTER (?function = 'Actor and Singer' || ?function = 'Actor') "
						+ "       FILTER (?collabFunction = 'Actor and Singer' || ?collabFunction = 'Actor') "
						+ "}";
		}
		
		// get the data
		// execute the query
		ResultSet results = rdf.executeSparqlQuery(queryString);
		
		// output some additional information
		// add some additional information
		printWriter.print("# Data exported on: " + DateUtils.getCurrentDateAndTime() + "\n");
		printWriter.print("# Data exported by: " + rdf.getContextParam("systemName") + " Version: " + rdf.getContextParam("systemVersion") + " Build: " + rdf.getContextParam("buildVersion") + "\n");
		
		// output the data in the format required
		if(taskType.equals("actor-edge-list-with-dups") == true) {
		
			// loop through the resultSet
			while (results.hasNext()) {
				// get a new row of data
				row = results.nextSolution();
				
				// first id
				tmp = row.get("contributor").toString().trim();
				tmps = tmp.split(":");
			
				printWriter.print(tmps[2] + "\t");
			
				// first givenName
				printWriter.print(row.get("givenName").toString().trim() + "\t");
			
				// first familyName
				printWriter.print(row.get("familyName").toString().trim() + "\t");
				
				// gender
				printWriter.print(row.get("gender").toString().trim() + "\t");
				
				// knows
				tmp = row.get("collaborator").toString().trim();
				tmps = tmp.split(":");
			
				printWriter.print(tmps[2] + "\t");
			
				// second GivenName
				printWriter.print(row.get("collabGivenName").toString().trim() + "\t");
			
				// second FamilyName
				printWriter.print(row.get("collabFamilyName").toString().trim() + "\t");
				
				// second gender
				printWriter.print(row.get("collabGender").toString().trim() + "\n");
			}
			
		} else if(taskType.equals("actor-edge-list-no-dups") == true) {
		
			// loop through the resultSet
			while (results.hasNext()) {
				// get a new row of data
				row = results.nextSolution();
				
				// first id
				tmp  = row.get("contributor").toString().trim();
				tmps = tmp.split(":");
			
				firstId = Integer.parseInt(tmps[2]);
			
				// second id
				tmp  = row.get("collaborator").toString().trim();
				tmps = tmp.split(":");
			
				secondId = Integer.parseInt(tmps[2]); 

				// determine if we need to add this line			
				if(firstId < secondId) {
				
					// output the data
					printWriter.print(firstId + "\t");
			
					// first givenName
					printWriter.print(row.get("givenName").toString().trim() + "\t");
		
					// first familyName
					printWriter.print(row.get("familyName").toString().trim() + "\t");
					
					// gender
					printWriter.print(row.get("gender").toString().trim() + "\t");
		
					// knows
					printWriter.print(secondId + "\t");
		
					// second GivenName
					printWriter.print(row.get("collabGivenName").toString().trim() + "\t");
		
					// second FamilyName
					printWriter.print(row.get("collabFamilyName").toString().trim() + "\t");
					
					// gender
					printWriter.print(row.get("collabGender").toString().trim() + "\n");
				}
			}			
		} else if(taskType.equals("actor-edge-list-with-dups-id-only") == true) {
		
			// loop through the resultSet
			while (results.hasNext()) {
				// get a new row of data
				row = results.nextSolution();
				
				// first id
				tmp = row.get("contributor").toString().trim();
				tmps = tmp.split(":");
			
				printWriter.print(tmps[2] + "\t");
			
				// knows
				tmp = row.get("collaborator").toString().trim();
				tmps = tmp.split(":");
			
				printWriter.print(tmps[2] + "\n");
			}
			
		} else if(taskType.equals("actor-edge-list-no-dups-id-only") == true) {
		
			// loop through the resultSet
			while (results.hasNext()) {
				// get a new row of data
				row = results.nextSolution();
				
				// first id
				tmp  = row.get("contributor").toString().trim();
				tmps = tmp.split(":");
			
				firstId = Integer.parseInt(tmps[2]);
			
				// second id
				tmp  = row.get("collaborator").toString().trim();
				tmps = tmp.split(":");
			
				secondId = Integer.parseInt(tmps[2]); 

				// determine if we need to add this line			
				if(firstId < secondId) {
				
					// output the data
					printWriter.print(firstId + "\t");
			
					// knows
					printWriter.print(secondId + "\n");
				}
			}
		}
		
		// play nice and tidy up
		rdf.tidyUp();	
	}
	
	
	/**
	 * A method to build the event centric network
	 *
	 * @param id          the unique id of the central event
	 * @param radius      the required number of edges from the central event
	 * @param simplify	  true: with each of the 1st degree nodes, only events for those contributors involved in the central node are retrieved.
	 * 					  false: with each of the 1st degree nodes, events for all contributors are retrieved.  
	 * @param graphType   the type of graph to created, must be one of directed / undirected
	 * @param printWriter the output stream to use to stream the output to the client
	 */
	public void buildEvtNetworkGraphml(String id, int radius, boolean simplify, String graphType, PrintWriter printWriter){
			
		//create Document 
		Document evtDom = createXMLDoc("http://graphml.graphdrawing.org/xmlns", "graphml", null);
			
		ProtovisEventCentricManager manager = new ProtovisEventCentricManager(db);
		evtDom = manager.toGraphMLDOM(evtDom, id, radius, simplify, graphType);
		
		if (evtDom != null)
			domToXMLString(printWriter, evtDom);
		else
			throw new RuntimeException("Dom is  null !");

	}
	
	
	/**
	 * A method to build the event network based on organisation or venue
	 * 
	 * @param id:	organisation id or venue id
	 * @param type: organisation-based event network "o" / venue-based event network "v"  
	 * @param graphType:  directed/undirected
	 * @param printWriter the output stream to use to stream the output to the client
	 * 
	 */
	public void buildOrgOrVenueEvtNetworkGraphml(String id, String type, String graphType, PrintWriter printWriter){
				
		//create Document 
		Document dom = createXMLDoc("http://graphml.graphdrawing.org/xmlns", "graphml", null);
			
		EvtManager manager = new EvtManager(db, id, type, graphType);
		Network ntwk = manager.createOrgOrVenueEvtNetwork();		
		if (ntwk == null)
			throw new RuntimeException("Network node set is null !");			
			
		dom = manager.toGraphMLDOM(dom);
		
		if (dom != null)
			domToXMLString(printWriter, dom);
		else
			throw new RuntimeException("Dom is  null !");
		
	}
	
	/**
	 * A method to build the contributor network based on venue
	 * 
	 * @param id:	venue id
	 * @param graphType:  directed/undirected
	 * @param type: venue-based contribtor network "v"  
	 * @param printWriter the output stream to use to stream the output to the client
	 * 
	 */
	public void buildVenueConNetworkGraphml(String id, String type, String graphType, PrintWriter printWriter){
				
		//create Document 
		Document dom = createXMLDoc("http://graphml.graphdrawing.org/xmlns", "graphml", null);
			
		ContributorNetworkManager manager = new ContributorNetworkManager(db, id, type, graphType);
		Network ntwk = manager.createVenueConNetwork();		
		if (ntwk == null)
			throw new RuntimeException("Network node set is null !");			
			
		dom = manager.toGraphMLDOM(dom);
		
		if (dom != null)
			domToXMLString(printWriter, dom);
		else
			throw new RuntimeException("Dom is  null !");

		//System.out.println("\n Num of Nodes: " + ntwk.nodeSet.size());
	}
	
}
