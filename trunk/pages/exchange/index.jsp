<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ include file="../../public/common.jsp"%>
<cms:include property="template" element="head" />

<%
String url = request.getServerName();
%>
	<!-- <link rel="stylesheet" href="/pages/exchange/assets/main-style.css"/> -->
	<!-- <link rel="stylesheet" href="/pages/ausstage/assets/jquery-ui/jquery-ui-1.8.6.custom.css"/> -->
	<!-- libraries -->
	<script type="text/javascript" src="assets/javascript/libraries/jquery-1.6.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery-ui-1.8.12.custom.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.ajaxmanager-3.0.9.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.scrollto-1.4.2.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.jsonp-2.1.4.min.js"></script>		
	<script type="text/javascript" src="assets/javascript/libraries/jquery.selectboxes-2.2.4.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.validate-1.7.min.js"></script>			
	<!-- custom code -->
	<script type="text/javascript" src="assets/javascript/index.js"></script>
	<script type="text/javascript" src="assets/javascript/code_generator.js"></script>
	<script type="text/javascript" src="assets/javascript/aus_exchange.js"></script>		
	<script type="text/javascript" src="assets/javascript/tab-selector.js"></script>
	<!-- vertical tab styles -->
	<style>
  .ui-tabs-vertical { width: 100%; }
  .ui-tabs-vertical .ui-tabs-nav { padding: .2em .1em .2em .2em; float: left; width: 12em; }
  .ui-tabs-vertical .ui-tabs-nav li { clear: left; width: 100%; border-bottom-width: 1px !important; border-right-width: 0 !important; margin: 0 -1px .2em 0; }
  .ui-tabs-vertical .ui-tabs-nav li a { display:block; }
  .ui-tabs-vertical .ui-tabs-nav li.ui-tabs-active { padding-bottom: 0; padding-right: .1em; border-right-width: 1px; border-right-width: 1px; }
  .ui-tabs-vertical .ui-tabs-panel { padding: 1em; float: left; margin-left: 12em; }
  .tabs-vertical-spacer { clear:left; background-color: white; padding-top:10px !important; }
  #footer { position: fixed !important; }
  </style>
		<!-- main content -->
	<div class="page b-172">

		<div id="tabs" class="tab-container" style="height:auto !important; margin:0px; margin-top: 15px; margin-bottom: 60px; padding:0px; border-width:0px;">
		  <div style="float:left; width:12em; ">
				<ul class="fix-ui-tabs" style="padding: 0px;">
					<li><a href="#tabs-1">Data Exchange</a></li>
					<li class="tabs-vertical-spacer"></li>
					<li><a href="#tabs-2">Generate Code</a></li>
					<li class="tabs-vertical-spacer"></li>
					<li><a href="#tabs-3">Genres</a></li>
					<li class="tabs-vertical-spacer"></li>
					<li><a href="#tabs-4">Subjects</a></li>
					<li class="tabs-vertical-spacer"></li>
					<li><a href="#tabs-5">Resources</a></li>
				</ul>
			</div>
			<div id="top" style="float:left; margin-left: -12em; width:100%;">
				<div id="tabs-1" class="tab-content">
					<h2>Access AusStage data for your website</h2>
					<p>					
					You can use the Data Exchange service to embed AusStage data in a website using specially created URLs. 
					Artists, companies and researchers can record information about their work in AusStage and then display that information in their own web pages.
					</p>
					<p>
					AusStage data can be embedded in a website dynamically by using <a href="http://en.wikipedia.org/wiki/JavaScript" title="Wikipedia article on this topic">JavaScript</a>, 
					by importing the <a href="http://en.wikipedia.org/wiki/RSS" title="Wikipedia article on this topic">RSS feed</a> into your content management system, 
					or in the case of performance feedback collected by using the <a href="http://beta.ausstage.edu.au/mobile/mobile-vis/" title="Researching Audiences service homepage">Researching Audiences</a> service and iFrame.
					</p>
					<p>
					Use the <a href='/pages/exchange/?tab=embed'>Code Generator</a> to create code that can be embedded into a web page. Up-to-date data is drawn live from the database each time the web page is viewed. 
					You can choose which records you want displayed. Three types of record can be retrieved using this service:
					</p>
					<ul>
						<li><a href="#event-records">Event Records</a></li>
						<li><a href="#resource-records">Resource Records</a></li>
						<li><a href="#feedback-records">Performance Feedback</a></li>
					</ul>
					<p>
						More information about retrieving records is outlined below.
					</p>
					<p>
						If you have any feedback, questions or queries about the Data Exchange service, please <a href="http://beta.ausstage.edu.au/?tab=contacts" title="Contact information">contact us</a>.
					</p>						
					<h2 id="event-records">Event Records</h2><a href="#top">Back to top</a>
					<p>
						Event records associated with contributors, organisations, venues, <a href="?tab=secgenre" title="secondary genre list">secondary genres</a>, <a href="?tab=subjects" title="subjects list">subjects</a> and works can be retrieved using this service. For example to retrieve event data about organisations it is necessary to know the unique Organisation Identifier for the organisation, or organisations, that are of interest. These numbers are displayed at the bottom of the record details page in the <a href="http://www.ausstage.edu.au" title="AusStage homepage">AusStage</a> website. 
					</p>
					<p>
						Lists of <a href="?tab=secgenre" title="secondary genre list">secondary genre</a> identifiers and <a href="?tab=subjects" title="subjects list">subjects</a> identifiers is availble on this website.
					</p>
					<p>
						The event records are retrieved by constructing a URL with two required attributes and four optional attributes. These are outlined in the table below. If an optional attribute is missing the default value will be used. 
					</p>
					<p>
						The start of the URL is always the same and it is: http://<%=url%>/exchange/events?
					</p>
					<p>
						Event records are always sorted in reverse chronological order (most recent first) before any record limits are applied and the data is returned.
					</p>
					<table class="page-table" >
						<thead>
							<tr class="b-186">
								<th>Attribute</th>
								<th>Description</th>
								<th>Value</th>
								<th>Required</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>type</td>
								<td>The type of unique identifier that is being used</td>
								<td>
									<ul style="padding-left:1em;">
										<li>contributor</li>
										<li>organisation</li>
										<li>venue</li>
										<li>secgenre</li>
										<li>subjects</li>
										<li>work</li>
									</ul>
								</td>
								<td>
									Yes
								</td>
							</tr>
							<tr class="odd">
								<td>
									id
								</td>
								<td>
									A unique identifier, or list of unique identifiers, for records matching the specified type
								</td>
								<td>
									Up to ten unique numeric identifiers
								</td>
								<td>
									Yes
								</td>
							</tr>
							<tr>
								<td>
									output
								</td>
								<td>
									The type of output used to format the data
								</td>
								<td>
									<ul style="padding-left:1em;">
										<li>html (default)</li>
										<li>json</li>
										<li>xml</li>
										<li>rss</li>
									</ul>
								</td>
								<td>
									No
								</td>
							</tr>
							<tr class="odd">
								<td>
									limit
								</td>
								<td>
									The number of records to be returned
								</td>
								<td>
									<ul style="padding-left:1em;">
										<li>10 (default)</li>
										<li>all (all records)</li>
										<li>an arbitary number</li>
									</ul>
								</td>
								<td>
									No
								</td>
							</tr>
							<tr>
								<td>
									sort
								</td>
								<td>
									The way records are sorted. <strong>Note: </strong> records are sorted before the record limit is applied
								</td>
								<td>
									<ul style="padding-left:1em;">
										<li>firstdate (event first date)</li>
										<li>createdate (the date the event record was created)</li>
										<li>updatedate (the date the event record was updated)</li>
									</ul>
								</td>
								<td>
									No
								</td>
							</tr>
							<tr class="odd">
								<td>
									callback
								</td>
								<td>
									The name of the JavaScript function used to enclose the data<br/>
									Most commonly used with the <a href="http://en.wikipedia.org/wiki/JSON" title="Wikipedia article on this topic">json</a> output attribute as part of using the <a href="http://en.wikipedia.org/wiki/JSONP" title="Wikipedia article on this topic">JSONP</a> technique for <a href="http://en.wikipedia.org/wiki/Ajax_%28programming%29" title="Wikipedia article on this topic">AJAX</a> requests
								</td>
								<td>
									Any valid JavaScript function name
								</td>
								<td>
									No
								</td>
							</tr>							
						</tbody>
					</table>
					<p>
						<strong>Example URLs</strong>
					</p>
					<p>
						Listed below are some sample URLs that demonstrate how the URL for event records can be constructed.
					</p>
					<ul>
						<li>
							Retrieve a list of 10 event records for the organisation with identifier 102, leaving all other attributes at their defaults.<br/>
							<a href="/exchange/events?type=organisation&id=102" rel="nofollow">http://<%=url%>/exchange/events?type=organisation&amp;id=102</a>
						</li>
						<li>
							Retrieve the same list of event records as before, except using the XML output type<br/>
							<a href="/exchange/events?type=organisation&id=102&output=xml" rel="nofollow">http://<%=url%>/exchange/events?type=organisation&amp;id=102&amp;output=xml</a>
						</li>
						<li>
							Retrieve a list of event records for the organisations with id 102 and 11898 in the default format and with a limit of 20 records.<br/>
							<a href="/exchange/events?type=organisation&id=102,11898&limit=20" rel="nofollow">http://<%=url%>/exchange/events?type=organisation&amp;id=102,11898&amp;limit=20</a>
						</li>
						<li>
							Retrieve a list of events records for the contributor 6139 in the rss format<br/>
							<a href="/exchange/events?type=contributor&id=6139&output=rss" rel="nofollow">http://<%=url%>/exchange/events?type=contributor&amp;id=6139&amp;output=rss</a>
						</li>
					</ul>
					<p>
						&nbsp;
					</p>
					<h2 id="resource-records">Resource Records</h2><a href="#top">Back to top</a>
					<p>
						Resource records associated with contributors, organisations, venues, <a href="?tab=secgenre" title="secondary genre list">secondary genres</a>, <a href="?tab=subjects" title="subjects list">subjects</a>, works and <a href="?tab=ressubtype" title="resource sub type list">resource sub-types</a> can be retrieved using this service. For example to retrieve resource data about organisations it is necessary to know the unique Organisation Identifier for the organisation, or organisations, that are of interest. These numbers are displayed at the bottom of the record details page in the <a href="http://www.ausstage.edu.au" title="AusStage homepage">AusStage</a> website. 
					</p>
					<p>
						Lists of <a href="?tab=secgenre" title="secondary genre list">secondary genre</a> identifiers, <a href="?tab=subjects" title="subjects list">subjects</a> identifiers and and <a href="?tab=ressubtype" title="resource sub type list">resource sub-types</a> are availble on this website.
					</p>
					<p>
						The resource records are retrieved by constructing a URL with two required attributes and three optional attributes. These are outlined in the table below. If an optional attribute is missing the default value will be used. 
					</p>
					<p>
						The start of the URL is always the same and it is: http://<%=url%>/exchange/resources?
					</p>
					<table class="page-table" >
						<thead>
							<tr>
								<th>Attribute</th>
								<th>Description</th>
								<th>Value</th>
								<th>Required</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>type</td>
								<td>The type of unique identifier that is being used</td>
								<td>
									<ul style="padding-left:1em;">
										<li>contributor</li>
										<li>organisation</li>
										<li>venue</li>
										<li>secgenre</li>
										<li>subjects</li>
										<li>work</li>
										<li>ressubtype</li>
									</ul>
								</td>
								<td>
									Yes
								</td>
							</tr>
							<tr class="odd">
								<td>
									id
								</td>
								<td>
									A unique identifier, or list of unique identifiers, for records matching the specified type
								</td>
								<td>
									Up to ten unique numeric identifiers
								</td>
								<td>
									Yes
								</td>
							</tr>
							<tr>
								<td>
									output
								</td>
								<td>
									The type of output used to format the data
								</td>
								<td>
									<ul style="padding-left:1em;">
										<li>html (default)</li>
										<li>json</li>
										<li>xml</li>
										<li>rss</li>
									</ul>
								</td>
								<td>
									No
								</td>
							</tr>
							<tr class="odd">
								<td>
									limit
								</td>
								<td>
									The number of records to be returned
								</td>
								<td>
									<ul style="padding-left:1em;">
										<li>10 (default)</li>
										<li>all (all records)</li>
										<li>an arbitary number</li>
									</ul>
								</td>
								<td>
									No
								</td>
							</tr>
							<tr>
								<td>
									sort
								</td>
								<td>
									The way records are sorted. <strong>Note: </strong> records are sorted before the record limit is applied
								</td>
								<td>
									<ul style="padding-left:1em;">
										<li>createdate (the date the event record was created)</li>
										<li>updatedate (the date the event record was updated)</li>
									</ul>
								</td>
								<td>
									No
								</td>
							</tr>
							<tr  class="b-185">
								<td>
									callback
								</td>
								<td>
									The name of the JavaScript function used to enclose the data<br/>
									Most commonly used with the <a href="http://en.wikipedia.org/wiki/JSON" title="Wikipedia article on this topic">json</a> output attribute as part of using the <a href="http://en.wikipedia.org/wiki/JSONP" title="Wikipedia article on this topic">JSONP</a> technique for <a href="http://en.wikipedia.org/wiki/Ajax_%28programming%29" title="Wikipedia article on this topic">AJAX</a> requests
								</td>
								<td>
									Any valid JavaScript function name
								</td>
								<td>
									No
								</td>
							</tr>							
						</tbody>
					</table>
					<p>
						<strong>Example URLs</strong>
					</p>
					<p>
						Listed below are some sample URLs that demonstrate how the URL for resource records can be constructed.
					</p>
					<ul>
						<li>
							Retrieve a list of 10 resource records for the organisation with identifier 102, leaving all other attributes at their defaults.<br/>
							<a href="/exchange/resources?type=organisation&id=102" rel="nofollow">http://<%=url%>/exchange/resources?type=organisation&amp;id=102</a>
						</li>
						<li>
							Retrieve the same list of resource records as before, except using the XML output type<br/>
							<a href="/exchange/resources?type=organisation&id=102&output=xml" rel="nofollow">http://<%=url%>/exchange/resources?type=organisation&amp;id=102&amp;output=xml</a>
						</li>
						<li>
							Retrieve a list of resource records for the organisations with id 102 and 11898 in the default format and with a limit of 20 records.<br/>
							<a href="/exchange/resources?type=organisation&id=102,11898&limit=20" rel="nofollow">http://<%=url%>/exchange/resources?type=organisation&amp;id=102,11898&amp;limit=20</a>
						</li>
						<li>
							Retrieve a list of resource records for the contributor 6139 in the rss format<br/>
							<a href="/exchange/resources?type=contributor&id=6139&output=rss" rel="nofollow">http://<%=url%>/exchange/resources?type=contributor&amp;id=6139&amp;output=rss</a>
						</li>
					</ul>
					<p>
						&nbsp;
					</p>
					<h2 id="feedback-records">Feedback Records</h2><a href="#top">Back to top</a>
					<p>
						Feedback records are pieces of feedback collected by the <a href="http://beta.ausstage.edu.au/mobile/mobile-vis/" title="Researching Audiences homepage">Researching Audiences Service</a> and are associated with a performance record. A performance record is a record in the database that identifies a unique performance that has used the researching audiences service to collect feedback. 
					</p>
					<p>
						The feedback records are retrieved by constructing a URL with two required attributes and four optional attributes. These are outlined in the table below. If an optional attribute is missing the default value will be used. 
					</p>
					<p>
						The start of the URL is always the same and it is: http://<%=url%>/exchange/feedback?
					</p>
					<table class="page-table" >
						<thead>
							<tr>
								<th>Attribute</th>
								<th>Description</th>
								<th>Value</th>
								<th>Required</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>type</td>
								<td>The type of unique identifier that is being used</td>
								<td>
									<ul style="padding-left:1em;">
										<li>performance</li>
									</ul>
								</td>
								<td>
									Yes
								</td>
							</tr>
							<tr class="odd">
								<td>
									id
								</td>
								<td>
									A unique identifier, or list of unique identifiers, for records matching the specified type
								</td>
								<td>
									Up to ten unique numeric identifiers
								</td>
								<td>
									Yes
								</td>
							</tr>
							<tr>
								<td>
									output
								</td>
								<td>
									The type of output used to format the data<br/>
									Unlike the other record types feedback can be retieved using the special "iframe" output type. This output wraps the html output in a complete set of HTML tags so that it can be used as the source for an <a href="http://www.w3schools.com/tags/tag_iframe.asp" title="More information on this tag">iframe</a>
								</td>
								<td>
									<ul style="padding-left:1em;">
										<li>html (default)</li>
										<li>json</li>
										<li>xml</li>
										<li>rss</li>
										<li>iframe</li>
									</ul>
								</td>
								<td>
									No
								</td>
							</tr>
							<tr class="odd">
								<td>
									limit
								</td>
								<td>
									The number of records to be returned
								</td>
								<td>
									<ul style="padding-left:1em;">
										<li>10 (default)</li>
										<li>all (all records)</li>
										<li>an arbitary number</li>
									</ul>
								</td>
								<td>
									No
								</td>
							</tr>
							<tr>
								<td>
									callback
								</td>
								<td>
									The name of the JavaScript function used to enclose the data<br/>
									Most commonly used with the <a href="http://en.wikipedia.org/wiki/JSON" title="Wikipedia article on this topic">json</a> output attribute as part of using the <a href="http://en.wikipedia.org/wiki/JSONP" title="Wikipedia article on this topic">JSONP</a> technique for <a href="http://en.wikipedia.org/wiki/Ajax_%28programming%29" title="Wikipedia article on this topic">AJAX</a> requests
								</td>
								<td>
									Any valid JavaScript function name
								</td>
								<td>
									No
								</td>
							</tr>
							<tr class="odd">
								<td>
									css
								</td>
								<td>
									Used in conjunction with the iframe parameter to specify the fully qualified URL of a <a href="http://en.wikipedia.org/wiki/Cascading_Style_Sheets" title="More information on this topi">CSS</a> file that is used to style the content contained in the iframe
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									No
								</td>
							</tr>							
						</tbody>
					</table>
					<p>
						<strong>Example URLs</strong>
					</p>
					<p>
						Listed below is a sample URL that demonstrate how the URL for feedback records can be constructed.
					</p>
					<ul>
						<li>
							Retrieve a list of the 10 most recent items of feedback for the performance with identifier 90, leaving all other attributes at their defaults.<br/>
							<a href="/exchange/feedback?type=performance&id=90" rel="nofollow">http://<%=url%>/exchange/feedback?type=performance&amp;id=90</a>
						</li>
					</ul>
				</div>
				<!--Code generator-->
				<div id="tabs-2" class="tab-content">
				
					<h2>Embed Ausstage Data in Your Website</h2>
					<p>This page helps you generate code that will dynamically show data from the Ausstage database.</p>
					<p>The code is able to be copied and pasted directly into a web page.
					</p>			
					<table class="formTable">
						<tbody>
							<tr>
								<th scope="row">
									<label id="task_label" for="task">Records: </label>
								</th>
								<td>
									<select id="type" name="type" title="Choose between events or resources">
									</select>
								</td>
							</tr>
						
							<tr>
								<th scope="row">
									<label id="task_label" for="task">Associated with: </label>
								</th>
								<td>
									<select id="task" name="task" title="Choose the entity associated with the events or resources">
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">
									<label id="id_label" for="id">ID: </label>
								</th>
								<td>
									<ul id="selectedIds" class="noBullets">
									</ul>
									<span id="addEntity" class="contributorAddIcon ui-icon ui-icon-plus clickable" style="display: inline-block;" title="add a record"></span>
								</td>
								<td id="idError" class="error"></td>
							</tr>
							<tr>
								<th scope="row">
									<label id="limit_label" for="limit">Record Limit: </label>
								</th>
								<td>
									<input type="radio" name="limitGroup" title="Return all records" value="all" id="noLimit" checked/>
									<label id="userLimit_label" for="noLimit">All</label><br/>

									<input type="radio" name="limitGroup" title="Enter number of records returned" value="userEnter"/>
									<label id="userLimit_label" for="userLimit">Select:</label>
									<input type="text" id="userLimit" title="Enter the desired number of records returned" disabled />					
								</td>
								<td id="limitError" class="error"></td>
							</tr>	
							<tr>
								<th scope="row">
									<label id="sort_by_label" for="sortBy">Sort By: </label>
								</th>
								<td>
									<select size="1" id="sortBy" name="SortBy" title="Select how returned records are sorted">
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">
								</th>
								<td>
									<input type="button" value='Get Code' id="getCode">
									<label id="styleOn_label" for="styleOn">Ausstage style on</label>								
									<input type="radio" name="styleGroup" title="Ausstage style on" value="true" id="styleOn" checked/>
									<label id="styleOff_label" for="styleOff">off</label>
									<input type="radio" name="styleGroup" title="off" value="false" id="styleOff"/>	
								</td>

							</tr>											
						</tbody>				
					</table>
					<div id="viewer">
						<div id='previewDiv'>
							<p class='center'><strong>Preview</strong></p>
							<div id='preview'></div>						
						</div>
						<div id='embedDiv' class="center">
							<p>Copy the code below and paste it into your website</p>
							<textarea id="embedText" readonly></textarea>
						</div>
					</div>
	
				
				</div>
				
				<div id="tabs-3" class="tab-content">
					<p>
						Below is a list of secondary genre identifiers that can be used with the Data Exchange service. <a href="?tab=secgenre" title="Persistent link to this tab">Persistent Link</a> to this tab.
					</p>
					<table class="page-table" >
						<thead>
							<tr>
								<th>Identifier</th>
								<th>Description</th>
								<th class="alignRight">Event Count</th>
								<th class="alignRight">Resource Count</th>
							</tr>
						</thead>
						<tbody id="secgenre-table">
							<tr>
								<td colspan="4">
									<div class="ui-state-highlight ui-corner-all search-status-messages">
										<p>
											<span class="ui-icon ui-icon-info status-icon"></span>Loading secondary genre list, please wait...
										</p>
									</div>
								</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td>Identifier</td>
								<td>Description</td>
								<td class="alignRight">Event Count</td>
								<td class="alignRight">Resource Count</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div id="tabs-4" class="tab-content">
					<p>
						Below is a list of subject identifiers that can be used with the Data Exchange service. <a href="?tab=subjects" title="Persistent link to this tab">Persistent Link</a> to this tab.
					</p>
					<table class="page-table" >
						<thead>
							<tr>
								<th>Identifier</th>
								<th>Description</th>
								<th class="alignRight">Event Count</th>
								<th class="alignRight">Resource Count</th>
							</tr>
						</thead>
						<tbody id="contentindicator-table">
							<tr>
								<td colspan="4">
									<div class="ui-state-highlight ui-corner-all search-status-messages">
										<p>
											<span class="ui-icon ui-icon-info status-icon"></span>Loading subjects list, please wait...
										</p>
									</div>
								</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td>Identifier</td>
								<td>Description</td>
								<td class="alignRight">Event Count</td>
								<td class="alignRight">Resource Count</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div id="tabs-5" class="tab-content">
					<p>
						Below is a list of resource sub type identifiers that can be used with the Data Exchange service. <a href="?tab=ressubtype" title="Persistent link to this tab">Persistent Link</a> to this tab.
					</p>
					<table class="page-table" >
						<thead>
							<tr>
								<th>Identifier</th>
								<th>Description</th>
								<th class="alignRight">Resource Count</th>
							</tr>
						</thead>
						<tbody id="ressubtype-table">
							<tr>
								<td colspan="4">
									<div class="ui-state-highlight ui-corner-all search-status-messages">
										<p>
											<span class="ui-icon ui-icon-info status-icon"></span>Loading resource sub-type list, please wait...
										</p>
									</div>
								</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td>Identifier</td>
								<td>Description</td>
								<td class="alignRight">Resource Count</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
		<div id="search_div" title="Search">
		<p>Enter a name, or part of a name, and click the search button</p>
		<p>Select an entity by clicking the 'choose' button on the right of the record. You can continue searching and add up to 10 entities.
		Click the close button when you have finished.</p>
		<form method="get" id="search_form" name="search_form">
			<input type="hidden" name="task" id="task" value="collaborator"/>
			<input type="hidden" name="limit" id="limit" value="5"/>
			<input type="hidden" name="sort" id="sort" value="name"/>
			<table class="formTable">
				<tbody>
				<tr>
					<th scope="row">
						<label id="search_name_label" for="name">Contributor Name: </label>
					</th>
					<td>
						<input type="text" size="40" id="query" name="query" title="Enter the contributor name, or part of their name, and click the search button"/>
					</td>
				</tr>
				</tbody>
			</table>
		</form>
		<table id="search_results" class="searchResults">
			<thead>
				<tr>
					<th>Contributor Name</th>
					<th>Event Dates</th>
					<th>Functions</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody id="search_results_body">
			</tbody>
		</table>
		<table id="search_results_org" class="searchResults">
			<thead>
				<tr>
					<th>Organisation Name</th>
					<th>Address</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody id="search_results_body_org">
			</tbody>			
		</table>
		<table id="search_results_venue" class="searchResults">
			<thead>
				<tr>
					<th>Venue Name</th>
					<th>Address</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody id="search_results_body_venue">
			</tbody>			
		</table>


		<div id="search_waiting">
			<p style="text-align: center;">
				<img src="assets/images/ajax-loader.gif" width="220" height="19" alt=" "/>
				<br/>Loading Search Results...
			</p>
		</div>
		<div id="error_message">
		</div>
		<p>
		 <strong>Note: </strong>Search results are limited to 5 records. If you do not see the results that you expected, please refine your search.
		</p>
	</div>
	
	<div id="secgenre_select_div">
		<table>
			<thead>
				<tr>
					<th>Description</th>
					<th class="alignRight">Event Count</th>
					<th class="alignRight"></th>
				</tr>
			</thead>		
			<tbody id="secgenre-select-table">
				<tr>
					<td colspan="4">
						<div class="ui-state-highlight ui-corner-all search-status-messages">
							<p>
								<span class="ui-icon ui-icon-info status-icon"></span>Loading secondary genre list, please wait...
							</p>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div id="contentindicator_select_div">
		<table>
			<thead>
				<tr>
					<th>Description</th>
					<th class="alignRight">Event Count</th>
					<th class="alignRight"></th>
				</tr>
			</thead>		
			<tbody id="contentindicator-select-table">
				<tr>
					<td colspan="4">
						<div class="ui-state-highlight ui-corner-all search-status-messages">
							<p>
								<span class="ui-icon ui-icon-info status-icon"></span>Loading subjects list, please wait...
							</p>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
		<div id="ressubtype_select_div">
		<table>
			<thead>
				<tr>
					<th>Description</th>
					<th class="alignRight">Event Count</th>
					<th class="alignRight"></th>
				</tr>
			</thead>		
			<tbody id="ressubtype-select-table">
				<tr>
					<td colspan="4">
						<div class="ui-state-highlight ui-corner-all search-status-messages">
							<p>
								<span class="ui-icon ui-icon-info status-icon"></span>Loading subjects list, please wait...
							</p>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- always at the bottom of the content -->
	<div class="push"></div>
	
	<cms:include property="template" element="foot" />

	</div> <!-- wrapper div -->