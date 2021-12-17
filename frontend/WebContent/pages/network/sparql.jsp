<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="java.sql.*" %>

<jsp:include page="../../templates/header.jsp" />
		<h2>Navigating Networks SPARQLer</h2>
		<p>
			Use the form below to execute <a href="http://en.wikipedia.org/wiki/SPARQL" title="Wikipedia article on this topic">SPARQL</a> queries using the Navigating Networks dataset. 
			More information about the dataset is available <a href="http://code.google.com/p/aus-e-stage/wiki/NavigatingNetworksDataset" title="Information on what is contained in the datset">in our Wiki</a>
			as are a small number of <a href="http://code.google.com/p/aus-e-stage/wiki/NavigatingNetworksSparql" title="List of sample queries in our Wiki">sample queries</a>.
		</p>
		<p>
			<strong>Please Note:</strong> This interface should be use for simple queries that return a reasonable number of results. It should not be used for exports or large datasets.
			Completed exports of the datasets are made periodically and made <a href="http://code.google.com/p/aus-e-stage/downloads/list" title="Aus-e-Stage project download library">available here</a>. 
		</p>
		<form action="http://rdf.csem.flinders.edu.au/joseki/networks" method="get">
			<p>
				<!-- text area for the query -->
				Enter the query in the text area below. <br/>
				<textarea name="query" cols="120" rows="20"></textarea> <br/>
				Output XML: <input type="radio" name="output" value="xml" checked/>
				with XSLT style sheet (leave blank for none): 
				<input name="stylesheet" size="25" value="xml-to-html.xsl" /> <br/>
				or JSON output: <input type="radio" name="output" value="json"/> <br/>
				or text output: <input type="radio" name="output" value="text"/> <br/>
				Force the accept header to <tt>text/plain</tt> regardless 
				<input type="checkbox" name="force-accept" value="text/plain"/>	<br/>
				<input type="submit" value="Execute Query" />
			</p>
		</form>		
	</div>
<jsp:include page="../../templates/footer.jsp" />
