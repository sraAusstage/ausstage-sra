<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%
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
 * along with the AusStage Mapping Service.  
 * If not, see <http://www.gnu.org/licenses/>.
*/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" lang="en">
<head>
	<title>Navigating Networks</title>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/> 
	<meta http-equiv="content-script-type" content="text/javascript">
	<!-- css -->
	<link rel="stylesheet" href="assets/networks.css"/>
	<link rel="stylesheet" href="assets/zoom_slider.css"/>	
	<link rel="stylesheet" href="assets/ausstage-colours.css">
	<link rel="stylesheet" href="assets/ausstage-background-colours.css">
	<link rel="stylesheet" href="assets/jquery-ui/jquery-ui-1.8.6.custom.css" type="text/css" />
	<link rel="stylesheet" type="text/css" href="assets/jquery-ui/jquery.multiselect.css" />	
	<link rel="stylesheet" type="text/css" href="assets/jquery-ui/jquery.multiselect.filter.css" />	
	<link rel="stylesheet" href="assets/rangeslider/dev.css"/>	
	<link rel="stylesheet" href="assets/jquery-ui/common.css" type="text/css" />
	<!-- libraries --> 
    <script type="text/javascript" src="assets/javascript/libraries/protovis-r3.2.js"></script>
	<!--<script type="text/javascript" src="assets/javascript/libraries/jquery-1.4.2.min.js"></script>-->
	<script type="text/javascript" src="assets/javascript/libraries/jquery-1.6.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery-ui-1.8.4.custom.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.form-2.4.3.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.validate-1.7.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.selectboxes-2.2.4.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.tipsy-1.0.0a.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.scrollTo-min.js"></script>	
	<script type="text/javascript" src="assets/javascript/libraries/jquery.multiselect.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.multiselect.filter.js"></script>	
	<script type="text/javascript" src="assets/javascript/libraries/exclusivecheck.jquery.min.js"></script>	
	<script type="text/javascript" src="assets/javascript/libraries/jquery.jsonp-2.1.4.min.js"></script>			
	<script type="text/javascript" src="assets/javascript/libraries/jquery.icolor.js"></script>		
	<script type="text/javascript" src="assets/javascript/libraries/jquery.rangeslider-2.1.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.daterangeslider-2.1.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.throttle.1.1.js"></script>				
	<!-- custom code -->
	<script type="text/javascript" src="assets/javascript/networks.js"></script>	
	<script type="text/javascript" src="assets/javascript/common.js"></script>		
	<script type="text/javascript" src="assets/javascript/search.js"></script>
	<script type="text/javascript" src="assets/javascript/viewerControl.js"></script>		
	<script type="text/javascript" src="assets/javascript/eventViewer.js"></script>		
	<script type="text/javascript" src="assets/javascript/contributorViewer.js"></script>
	<script type="text/javascript" src="assets/javascript/timeline.js"></script>
	<script type="text/javascript" src="assets/javascript/slider.js"></script>
	<script type="text/javascript" src="assets/javascript/navigation.js"></script>					    
    <!-- Google Analytics Script -->
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-10089663-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

    
</head>

<body>

<span id="ruler"></span>

<div class="wrapper">
	<div class="header b-187"><h1>Navigating Networks</h1></div>

	<!-- Sidebar -->
	<div class="sidebar b-186 f-184">
		<div class="mainMenu">	
			<ul>
				<li>&nbsp;</li>
				<li><a href="http://www.ausstage.edu.au" title="AusStage Website homepage">AusStage Website</a></li>
				<li><a href="http://beta.ausstage.edu.au/" title="Aus-e-Stage Project homepage">Aus-e-Stage Project</a></li>
				<li><a href="index.jsp" title="Browse Contributor Network">Navigating Networks</a> </li>			
				<li><a href="#" id="about_networks_help" title="Networks Help">About Networks</a> </li>			
			</ul>
		</div>
		<div class="legendContainer">
		<div id="viewer_options_div">
		<hr style="width: 95%; margin-top: 5px;" class="f-184 b-184">			
			<div class="legendHeader" id="viewer_options_header" >Display</div>
			<div class="legendBody autoHeight" id="viewer_options_body">
				<!--ego centric labels-->
				<div id="contributor_options_div" width='250'>						
					<table>
						<tbody>
							<tr><th colspan='2'>Label Display</th></tr>
							<tr>
								<td><input type="checkbox" name="showAllNodeLabels" class="checkbox" id="show_all_node_labels_check" /></td>
								<td><label for="showAllNodeLabels">Show all contributor names</label></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="showRelatedNodeLabels" class="checkbox" id="show_related_node_labels_check" /></td>
								<td><label for="showRelatedNodeLabels">Show related contributor names</label></td>
							</tr>
							<tr><th colspan='2'>Node Display</th></tr>
							<tr>
								<td><input type="checkbox" name="showAllNodes" class="checkbox" id="show_all_nodes_check" checked='yes' /></td>
								<td><label for="showAll">Show all contributors</label></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="showRelatedNodes" class="checkbox" id="show_related_nodes_check" checked='yes'/></td>
								<td><label for="showRelatedNodes">Show related contributors</label></td>											
							</tr>				
							
							<tr><th colspan='2'>Edge Display</th></tr>
							<tr>
								<td><input type="checkbox" name="showAllEdges" class="checkbox" id="show_all_edges_check" checked='yes' /></td>
								<td><label for="showAll">Show all collaborations</label></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="showRelatedEdges" class="checkbox" id="show_related_edges_check" checked='yes'/></td>
								<td><label for="showRelatedEdges">Show related collaborations</label></td>													
							</tr>				
							<tr>
								<td colspan='2'>Min and max collaborations displayed</td>
							<tr>
							<tr>
								<td colspan='2'>&nbsp;</td>
							<tr>
								<td colspan='2'><div id="collabSlider"></div></td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- event centric labels -->
				<div id="event_options_div">
					<table>
						<tbody>
							<tr><th colspan='2'>Label Display</th></tr>
							<tr>
								<td><input type="checkbox" name="showAllEdgeLabelsEvt" class="checkbox" id="show_all_edge_labels_check" /></td>
								<td><label for="showContributors">Show all contributor names</label></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="showRelatedEdgeLabelsEvt" class="checkbox" id="show_related_edge_labels_check" /></td>
								<td><label for="showContributors">Show related contributor names</label></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="showAllNodeLabelsEvt" class="checkbox" id="show_all_node_labels_check" /></td>
								<td><label for="showContributors">Show all event names</label></td>
							</tr>
							<tr>
							 <td><input type="checkbox" name="showRelatedNodeLabelsEvt" class="checkbox" id="show_related_node_labels_check" /></td>
								<td><label for="showContributors">Show related event names</label></td>
							</tr>
							<tr><th colspan='2'>Node Display</th></tr>
							<tr>
								<td><input type="checkbox" name="showAllNodesEvt" class="checkbox" id="show_all_nodes_check" checked='yes' /></td>
								<td><label for="showAll">Show all events</label></td>
							</tr>
							<tr>
							 <td><input type="checkbox" name="showRelatedNodesEvt" class="checkbox" id="show_related_nodes_check" checked='yes'/></td>
								<td><label for="showRelatedNodes">Show related events</label></td>											
							</tr>
							<tr><th colspan='2'>Edge Display</th></tr>
							<tr>
								<td><input type="checkbox" name="showAllEdgesEvt" class="checkbox" id="show_all_edges_check" checked='yes' /></td>
								<td><label for="showAll">Show all contributors</label></td>
							</tr>
							<tr>
							 <td><input type="checkbox" name="showRelatedEdgesEvt" class="checkbox" id="show_related_edges_check" checked='yes'/></td>
								<td><label for="showRelatedEdges">Show related contributors</label></td>											
							</tr>				
											
							
					
						</tbody>
					</table>
				</div>
				<div id='custom_colors_div'>
					<table>
						<tbody>
							<tr><th colspan='3'>Custom Colours and Visibility</th></tr>
							<tr>
								<td><input type="checkbox" name="showCustColors" class="checkbox" id="show_cust_colors" checked="yes"/></td>
								<td><label for="showCustColors">Show custom colors</label></td>
								<td class='alignRight'>
									<input type="submit" name="submit" class="button" id="reset_cust_colors" value="Reset" />
								</td>
							<tr>
								<td><input type="checkbox" name="showCustVis" class="checkbox" id="show_cust_vis"/></td>
								<td><label for="showCustVis">Show hidden elements</label></td>
								<td class='alignRight'>
									<input type="submit" name="submit" class="button" id="reset_cust_vis" value="Reset" />
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div id="exportContainer">	
			<div class="accordion">
				<h3><a href="#" id="export_heading">Save</a></h3>
				<div id="export_network">
					<ul>
					<li id='bookmarkLink' class='clickable'>Bookmark this network</li>
					<li><a class="f-184" id='downloadLink' href="#" target="_blank">Download this network as GraphML</a></li>
					</ul>
				</div>
			</div>
		</div>

		<!--Network properties - displays information about the network as a whole -->						
		<div id="network_properties_div">
			<div class="legendHeader" id="network_properties_header" >Network</div>
			<div class="legendBody" id="network_properties_body"></div>
		</div>		
		<!--Legend/ info window for the network - displays information about the selected section of the graph -->
		<div id="network_details_div">
			<div class="legendHeader" id="selected_object_header" ></div>
			<div class="legendBody" id="selected_object_body"></div>
		</div>		
		<!-- faceted browsing div -->
		<div id="faceted_div">
			<div class="legendHeader" id="faceted_header">Facets</div>
			<div class="legendBody" id="faceted_body" >
				<div><input type="checkbox" name="showAllFaceted" class="checkbox" checked />
				<label for="showAllFaceted">Show all nodes</label></div>
				<a class="darkLink" id='facet_color_button' href='#'>Set color for selection</a>			
				<!--functions-->
				<div class="legendHeader legendSml" id="functions_header" >Contributor Functions</div>
				<div class="legendBody autoHeight scroll_checkboxes" id="functions_body"></div>
				<!--gender-->
				<div class="legendHeader legendSml" id="gender_header" >Contributor Gender</div>
				<div class="legendBody autoHeight scroll_checkboxes" id="gender_body"></div>
				<!--nationality-->					
				<div class="legendHeader legendSml" id="nationality_header" >Contributor Nationality</div>
				<div class="legendBody autoHeight scroll_checkboxes" id="nationality_body"></div>
				<!-- list the selected faceted criteria-->
				<div class="legendHeader legendSml" id="criteria_header" >Search Criteria</div>
				<div class="legendBody autoHeight" id="criteria_body"></div>	
				<br/>
			</div>
		</div>
		</div>
		<br>
	
	</div>

	<!--main display window. -->
	<div class="main2 b-184 f-187">
		<div id="tabs" class="tab-container"> 
			<ul class="fix-ui-tabs" id="fix-ui-tabs">
				<li><a href="#tabs-0">Search</a></li>
				<li><a href="#tabs-1">Network</a></li>				
			</ul>
			
			<!--search tab-->
			<div id="tabs-0">
				<p style="margin-bottom: -5px;">Search the AusStage database</p>
				<form name="search" action="">
					<table class="formTable" style="height: 60px;">
						<tbody>
							<tr>
								<td>
									<input type="search" size="40" id="query" name="query" /> 
									<input type="submit" name="search_btn" id="search_btn" value="Search"/> 
									<span id="show_search_help" class="helpIcon clickable" style="display: inline-block;"></span>
								</td>
								<td>
									<div id="search_messages" class="js">
										<div class="ui-state-highlight ui-corner-all search-status-messages" id="search_status_message">
											<p>
												<span class="ui-icon ui-icon-info status-icon"></span>
												<span id="search_status_text"></span>
											</p>
										</div>
										<div class="ui-state-error ui-corner-all search-status-messages" id="search_error_message"> 
											<p><span class="ui-icon ui-icon-alert status-icon"></span> 
											<span id="search_error_text"></span>
											</p>
										</div>										
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</form>

				<div class="accordion">
					<h3><a href="#" id="contributor_heading">Contributors</a></h3>
					<div id="contributor_results"></div>
				</div>
				<div class="accordion">
					<h3><a href="#" id="event_heading">Events</a></h3>
					<div id="event_results"></div>
				</div>
				<p class="space">
				&nbsp;
				</p>
				<div class="accordion">
					<h3><a href="#" id="event_heading">Search History</a></h3>
					<div>
						<table class="searchResults">
                        	<thead>
                            	<tr>
									<th>Query - click to repeat</th>
									<th>Link - right-click to bookmark</th>
									<th class="alignRight">Contributors</th>
									<th class="alignRight">Events</th>
                                </tr>
                           	</thead>
                        	<tbody id="search_history">
                     		</tbody>
                  		</table>
					</div>
				</div>
			</div>
			
	
			<!--network Browser-->
			<div id="tabs-1">
				<div id="viewerMsg"></div>
				<div id="navigation">
					<table class="nav_control">
						<tr>
							<td></td>
							<td class='nav_button'><span id="panUp" class="up clickable" title='pan up'></span></td>
							<td></td>
						</tr>
						<tr>
							<td class='nav_button'><span id="panLeft" class="left clickable" title='pan left'></span></td>
							<td class='nav_button'><span id="recentre" class="recentre clickable" title='re-centre network'></span></td>
							<td class='nav_button'><span id="panRight" class="right clickable" title='pan right'></span></td>
						</tr>
						<tr>
							<td></td>
							<td class='nav_button'><span id="panDown" class="down clickable" title='pan down'></span></td>
							<td></td>
						</tr>
						<tr><td colspan='3'>&nbsp;</td>
						<tr>
							<td></td>
							<td class='nav_button'><span id="zoomIn" class="zoomIn clickable" title='zoom in'></span></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td><div id="zoomslider"></div>	</td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td class='nav_button'><span id="zoomOut" class="zoomOut clickable" title='zoom out'></span></td>
							<td></td>
						</tr>
					</table>
				</div>
				<div id="viewer"></div>
				<!--date slider and facteded browsing form-->
				<div id="advanced_search_div"> 
				<!-- date slider -->
					<div class="timeSliderContainer">
						<div id="timeSlider">
						</div>
					</div> 
					<!-- custom context menu - opens on alt click or ctrl click-->
					<div id="custom_div">
						<div id="color_picker" class="color_picker"></div>
						<div id="custom_dialog_opts">
							<input type="submit" name="submit" class="button" id="remove_color" value="Remove custom color" />
							<input type="submit" name="submit" class="button" id="hide_element" value="Hide Element" />
						</div>
					</div>
				</div>	
			</div>						
		</div>	
	</div>
	<!-- always at the bottom of the content -->
	<div class="push"></div>
</div>
	<!-- include the footer -->
<jsp:include page="footer.jsp"/>

<!-- faceted color div-->
<div id="facet_color_div">
	<div id="facet_color_picker" class="color_picker"></div>
</div>


<!-- help divs -->
<div id="about_networks_div" class='dialogs' title="About Networks" style="font-size: 90%">
        <p>The Navigating Networks service provides an interactive interface for exploring and analysing networks of 
        artistic collaborations in the AusStage database.</p>
		<p>Network visualisation and analysis can reveal patterns of collaboration between artists which have previously been unrepresentable using
		 conventional text-based displays. This service presents existing data in new ways, allowing researchers to interrogate the collaborations 
		 that underpin creativity in the performing arts. </p>
		<p>Network graphs represents things and their relationships. A network graph is visualised as set of nodes linked by lines representing
		 their relationships. There are two ways we can look at the relationship between contributors and events in AusStage.</p>
		<h3>Contributor Network</h3>
		<p>We can visualise a network of contributors linked by the events they have collaborated on.
		 A contributor network is centred on one contributor. It shows all the contributors who have collaborated with the central contributor, and 
		 all of their collaborations with each other.</p>
		 <h3>Event Network</h3>
		 <p>We can also visualise a network of events linked by their contributors. An event network is centered on one event. 
		 It shows the events that contributors were working on before and after the central event.</p>
		 <p>There are three types of event network.</p>
		<ul>
		<li>1st Degree (default) retrieves a network which includes, for each contributor to the central event, their links to one event before and 
		one event after the central event.</li>
		<li>2nd Degree Simple retrieves a network which includes, for each contributor to the central event, 
		their links to two events before and two events after the central event.</li>
		<li>2nd Degree Complex retrieves a network which includes, for each contributor to the central event, 
		their links to events before and after, and then, for each contributor to those events, all their links to events before and after.</li>
		</ul>
		<p>These three types of event network reveal a progressively broader and more complex picture of who was collaborating on what 
		before and after the central event. The difference between the two types of networks at the second degree is that, for the simple network,
		 we only retrieve the events at the second degree if they involved contributors to the central event, whereas, for the complex network, we 
		 retrieve all events at the second degree which involve contributors from events at the first degree.</p>
</div>

<div id="help_search_div" class='dialogs' title="Help" style="font-size: 90%">
        <h3>Searching the AusStage database</h3>
        <p>This search retrieves contributors and events that match all your search terms. 
        Records with matching alternate or previous names will also be retrieved. 
        Please wait for the search to complete before exploring the results. 
        </p><p>
        Enclosing your search terms in double quotes will search for an exact match of the search terms.
        </p><p>
        At most 25 search results will retrieved for each type of record. 
		If you don't find what you're looking for, try refining your search terms. You could also try searching the main 
		<a href="http://www.ausstage.edu.au" title="AusStage Website homepage">AusStage</a> website.
        </p>
</div>
<div id="help_view_event_div" class='dialogs' title="Help" style="font-size: 90%">
        <h3>Viewing an Event Network</h3>
		<p>An event network is arranged chronologically to show the events which contributors were involved in before and after the central event.
		</p>
		<p>Click the <span class="ui-icon ui-icon-plus clickable" style="display: inline-block;"></span> icon to select an event. </p>
		<p>Choose a network type from the drop-down menu. There are three types of event network</p>
		<ul>
		<li> 1st Degree (default) retrieves a network which includes, 
		for each contributor to the central event, their links to one event before and one event after the central event.</li>

		<li>2nd Degree Simple retrieves a network which includes, for each contributor to the central event, 
		their links to two events before and two events after the central event. </li>
	
		<li>2nd Degree Complex retrieves a network which includes, for each contributor to the central event, 
		their links to events before and after, and then, for each contributor to those events, all their links to events before and after.</li>
		</ul>
        <p>Click the View Network button to see the network. </p>
        <p>Click the <span class="ui-icon ui-icon-close clickable" style="display: inline-block;"></span> icon to remove the event from your selection. </p>
</div>
<div id="help_view_contributor_div" class='dialogs' title="Help" style="font-size: 90%">
        <h3>Viewing a Contributor Network</h3>
        <p>A contributor network is centred on the selected contributor. It shows all the contributors who have collaborated with the central 	
        contributor, and all of their associations with each other.</p>
        <p>Click the <span class="ui-icon ui-icon-plus clickable" style="display: inline-block;"></span> icon to select a contributor.</p>
        <p>Click the View Network button to see the network. </p>
        <p>Click the <span class="ui-icon ui-icon-close clickable" style="display: inline-block;"></span>
         icon to remove the contributor from your selection. </p>
</div>
<div id="cust_colors_confirm_reset" title="Confirm Reset" class="dialogs">
        <h3>Do you want to reset the custom colours?</h3>
        <p>
                If you reset the custom colours, all customised colouring will be deleted.
        </p>
</div>
<div id="cust_vis_confirm_reset" title="Confirm Reset" class="dialogs">
        <h3>Do you want to reset the custom visibility?</h3>
        <p>
                If you reset the custom visibility, all hidden settings will be deleted.
        </p>
</div>
<div id="network_bookmark_div" title="Bookmark" class="dialogs">
        <h3>Save a bookmark for this network</h3>
        <p>
                <a href="" title="Bookmark this Network" id="network_bookmark_link">AusStage Network Bookmark</a> - Add this link as a bookmark to your browser. The bookmark will retrieve the latest data from AusStage each time you reload your network. Hidden elements and custom colors will be reset and the time-slider will be maximised.
        </p>
</div>

</body>
</html>
