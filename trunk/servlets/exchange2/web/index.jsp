<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%
/*
 * This file is part of the AusStage Data Exchange Service
 *
 * AusStage Data Exchange Service is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * AusStage Data Exchange Service is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with AusStage Data Exchange Service.  
 * If not, see <http://www.gnu.org/licenses/>.
 */
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>Aus-e-Stage Data Exchange</title>
	<link rel="stylesheet" href="assets/main-style.css"/>
	<link rel="stylesheet" href="assets/ausstage-colours.css"/>
	<link rel="stylesheet" href="assets/ausstage-background-colours.css"/>
	<link rel="stylesheet" href="assets/jquery-ui/jquery-ui-1.8.6.custom.css"/>
	<jsp:include page="analytics.jsp"/>
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
</head>
<body>
<div class="wrapper" id="top">
	<div class="header b-187"><h1>Data Exchange</h1></div>
	<div class="sidebar b-186 f-184">
		<!-- side bar content -->
		<div class="mainMenu">
			<ul>
				<li>&nbsp;</li>
				<li><a href="http://www.ausstage.edu.au" title="AusStage Website homepage">AusStage Website</a></li>
				<li><a href="http://beta.ausstage.edu.au/" title="Aus-e-Stage Project homepage">Aus-e-Stage Project</a></li>
				<li><a href="http://code.google.com/p/aus-e-stage/wiki/StartPage" title="Project Wiki homepage">Project Wiki</a></li>
				<li><a href="http://beta.ausstage.edu.au/?tab=contacts" title="Contact information">Contact Us</a></li>
			</ul>
		</div>
	</div>
	<div class="main b-184 f-187">
		<!-- main content -->
		<div id="tabs" class="tab-container">
			<ul class="fix-ui-tabs">
				<li><a href="#tabs-1">Exchange Overview</a></li>
				<li><a href="#tabs-2">Embed Code</a></li>
				<li><a href="#tabs-3">Secondary Genres</a></li>
				<li><a href="#tabs-4">Content Indicators</a></li>
				<li><a href="#tabs-5">Resource Sub-Types</a></li>
			</ul>
			<div>
				<div id="tabs-1" class="tab-content">
					<h2>Access AusStage data for your website</h2>
					<p>
						The AusStage Data Exchange service is a way for members of the AusStage user community to include AusStage data in their websites using specially crafted URLs.
					</p>
					<p> 
					You can use the <a href='/exchange/?tab=embed'>Code Generator</a> to create code that can be pasted into any web page.
					</p>
					<p>
						AusStage data can be included in a website dynamically by using <a href="http://en.wikipedia.org/wiki/JavaScript" title="Wikipedia article on this topic">JavaScript</a>, importing the <a href="http://en.wikipedia.org/wiki/RSS" title="Wikipedia article on this topic">RSS feed</a> into your content management system, or in the case of performance feedback collected using the <a href="http://beta.ausstage.edu.au/mobile/mobile-vis/" title="Researching Audiences service homepage">Researching Audiences</a> service an iFrame.
					</p>
					<p>
						There are three different types of record that can be retrieved using this service. They are:
					</p>
					<ul>
						<li><span class="clickable" id="event-link">Event Records</span></li>
						<li><span class="clickable" id="resource-link">Resource Records</span></li>
						<li><span class="clickable" id="performance-link">Performance Feedback</span></li>
					</ul>
					<p>
						More information about retrieving records is outlined below.
					</p>
					<p>
						If you have any feedback, questions or queries about the Data Exchange service, please <a href="http://beta.ausstage.edu.au/?tab=contacts" title="Contact information">contact us</a>.
					</p>						
					<h3 id="event">Event Records</h3><span class="clickable top-link">Back to top</span>
					<p>
						Event records associated with contributors, organisations, venues, <a href="/exchange/?tab=secgenre" title="secondary genre list">secondary genres</a>, <a href="/exchange/?tab=contentindicator" title="content indicator list">content indicators</a> and works can be retrieved using this service. For example to retrieve event data about organisations it is necessary to know the unique Organisation Identifier for the organisation, or organisations, that are of interest. These numbers are displayed at the bottom of the record details page in the <a href="http://www.ausstage.edu.au" title="AusStage homepage">AusStage</a> website. 
					</p>
					<p>
						Lists of <a href="/exchange/?tab=secgenre" title="secondary genre list">secondary genre</a> identifiers and <a href="/exchange/?tab=contentindicator" title="content indicator list">content indicator</a> identifiers is availble on this website.
					</p>
					<p>
						The event records are retrieved by constructing a URL with two required attributes and four optional attributes. These are outlined in the table below. If an optional attribute is missing the default value will be used. 
					</p>
					<p>
						The start of the URL is always the same and it is: http://beta.ausstage.edu.au/exchange/events?
					</p>
					<p>
						Event records are always sorted in reverse chronological order (most recent first) before any record limits are applied and the data is returned.
					</p>
					<table class="identifiers">
						<thead>
							<tr>
								<th>Attribute Name</th>
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
										<li>contentindicator</li>
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
							Retrieve a list of 10 event records for the organisation with identifier 102, leaving all other attributes at thier defaults.<br/>
							<a href="http://beta.ausstage.edu.au/exchange/events?type=organisation&id=102" rel="nofollow">http://beta.ausstage.edu.au/exchange/events?type=organisation&amp;id=102</a>
						</li>
						<li>
							Retrieve the same list of event records as before, except using the XML output type<br/>
							<a href="http://beta.ausstage.edu.au/exchange/events?type=organisation&id=102&output=xml" rel="nofollow">http://beta.ausstage.edu.au/exchange/events?type=organisation&amp;id=102&amp;output=xml</a>
						</li>
						<li>
							Retrieve a list of event records for the organisations with id 102 and 11898 in the default format and with a limit of 20 records.<br/>
							<a href="http://beta.ausstage.edu.au/exchange/events?type=organisation&id=102,11898&limit=20" rel="nofollow">http://beta.ausstage.edu.au/exchange/events?type=organisation&amp;id=102,11898&amp;limit=20</a>
						</li>
						<li>
							Retrieve a list of events records for the contributor 6139 in the rss format<br/>
							<a href="http://beta.ausstage.edu.au/exchange/events?type=contributor&id=6139&output=rss" rel="nofollow">http://beta.ausstage.edu.au/exchange/events?type=contributor&amp;id=6139&amp;output=rss</a>
						</li>
					</ul>
					<p>
						&nbsp;
					</p>
					<h3 id="resource">Resource Records</h3><span class="clickable top-link">Back to top</span>
					<p>
						Resource records associated with contributors, organisations, venues, <a href="/exchange/?tab=secgenre" title="secondary genre list">secondary genres</a>, <a href="/exchange/?tab=contentindicator" title="content indicator list">content indicators</a>, works and <a href="http://beta.ausstage.edu.au/exchange/?tab=ressubtype" title="resource sub type list">resource sub-types</a> can be retrieved using this service. For example to retrieve resource data about organisations it is necessary to know the unique Organisation Identifier for the organisation, or organisations, that are of interest. These numbers are displayed at the bottom of the record details page in the <a href="http://www.ausstage.edu.au" title="AusStage homepage">AusStage</a> website. 
					</p>
					<p>
						Lists of <a href="/exchange/?tab=secgenre" title="secondary genre list">secondary genre</a> identifiers, <a href="/exchange/?tab=contentindicator" title="content indicator list">content indicator</a> identifiers and and <a href="http://beta.ausstage.edu.au/exchange/?tab=ressubtype" title="resource sub type list">resource sub-types</a> are availble on this website.
					</p>
					<p>
						The resource records are retrieved by constructing a URL with two required attributes and three optional attributes. These are outlined in the table below. If an optional attribute is missing the default value will be used. 
					</p>
					<p>
						The start of the URL is always the same and it is: http://beta.ausstage.edu.au/exchange/resources?
					</p>
					<table class="identifiers">
						<thead>
							<tr>
								<th>Attribute Name</th>
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
										<li>contentindicator</li>
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
							<tr  class="odd">
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
							Retrieve a list of 10 resource records for the organisation with identifier 102, leaving all other attributes at thier defaults.<br/>
							<a href="http://beta.ausstage.edu.au/exchange/resources?type=organisation&id=102" rel="nofollow">http://beta.ausstage.edu.au/exchange/resources?type=organisation&amp;id=102</a>
						</li>
						<li>
							Retrieve the same list of resource records as before, except using the XML output type<br/>
							<a href="http://beta.ausstage.edu.au/exchange/resources?type=organisation&id=102&output=xml" rel="nofollow">http://beta.ausstage.edu.au/exchange/resources?type=organisation&amp;id=102&amp;output=xml</a>
						</li>
						<li>
							Retrieve a list of resource records for the organisations with id 102 and 11898 in the default format and with a limit of 20 records.<br/>
							<a href="http://beta.ausstage.edu.au/exchange/resources?type=organisation&id=102,11898&limit=20" rel="nofollow">http://beta.ausstage.edu.au/exchange/resources?type=organisation&amp;id=102,11898&amp;limit=20</a>
						</li>
						<li>
							Retrieve a list of resource records for the contributor 6139 in the rss format<br/>
							<a href="http://beta.ausstage.edu.au/exchange/resources?type=contributor&id=6139&output=rss" rel="nofollow">http://beta.ausstage.edu.au/exchange/resources?type=contributor&amp;id=6139&amp;output=rss</a>
						</li>
					</ul>
					<p>
						&nbsp;
					</p>
					<h3 id="feedback">Feedback Records</h3><span class="clickable top-link">Back to top</span>
					<p>
						Feedback records are pieces of feedback collected by the <a href="http://beta.ausstage.edu.au/mobile/mobile-vis/" title="Researching Audiences homepage">Researching Audiences Service</a> and are associated with a performance record. A performance record is a record in the database that identifies a unique performance that has used the researching audiences service to collect feedback. 
					</p>
					<p>
						The feedback records are retrieved by constructing a URL with two required attributes and four optional attributes. These are outlined in the table below. If an optional attribute is missing the default value will be used. 
					</p>
					<p>
						The start of the URL is always the same and it is: http://beta.ausstage.edu.au/exchange/feedback?
					</p>
					<table class="identifiers">
						<thead>
							<tr>
								<th>Attribute Name</th>
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
						Listed below is a sample URL that demonstrate how the URL for feenack records can be constructed.
					</p>
					<ul>
						<li>
							Retrieve a list of the 10 most recent items of feedback for the performance with identifier 90, leaving all other attributes at thier defaults.<br/>
							<a href="http://beta.ausstage.edu.au/exchange/feedback?type=performance&id=90" rel="nofollow">http://beta.ausstage.edu.au/exchange/feedback?type=performance&amp;id=90</a>
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
						Below is a list of secondary genre identifiers that can be used with the Data Exchange service. <a href="/exchange/?tab=secgenre" title="Persistent link to this tab">Persistent Link</a> to this tab.
					</p>
					<table class="identifiers">
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
						Below is a list of content indicator identifiers that can be used with the Data Exchange service. <a href="/exchange/?tab=contentindicator" title="Persistent link to this tab">Persistent Link</a> to this tab.
					</p>
					<table class="identifiers">
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
											<span class="ui-icon ui-icon-info status-icon"></span>Loading content indicator list, please wait...
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
						Below is a list of resource sub type identifiers that can be used with the Data Exchange service. <a href="/exchange/?tab=ressubtype" title="Persistent link to this tab">Persistent Link</a> to this tab.
					</p>
					<table class="identifiers">
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
								<span class="ui-icon ui-icon-info status-icon"></span>Loading content indicator list, please wait...
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
								<span class="ui-icon ui-icon-info status-icon"></span>Loading content indicator list, please wait...
							</p>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- always at the bottom of the content -->
	<div class="push"></div>
</div>
<jsp:include page="footer.jsp"/>
</body>
</html>
