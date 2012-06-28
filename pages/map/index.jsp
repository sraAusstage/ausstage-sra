<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>

<cms:include property="template" element="head" />
	<link rel='stylesheet' href='/pages/assets/main-style.css'/>	
	<link rel='stylesheet' href='/resources/style.css'/>
	<link rel='icon' href='/resources/favicon2.ico'/>	
	<meta charset="utf-8" />
	<link rel="stylesheet" href="/pages/assets/jquery-ui/jquery-ui-1.8.6.custom.css"/>
	<link rel="stylesheet" href="/pages/assets/rangeslider/dev.css"/>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-1.6.1.min.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-ui-1.8.12.custom.min.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery.ajaxmanager-3.11.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery.validate-1.7.min.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery.cookie-1.0.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery.scrollto-1.4.2.js"></script>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.3&sensor=false"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/markerwithlabel-1.1.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/markerclusterer-1.0.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery.rangeslider-2.1.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery.daterangeslider-2.1.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery.throttle.1.1.js"></script>
	<!-- custom code -->
	<script type="text/javascript" src="/pages/assets/javascript/index.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/common.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/search.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/browse.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/mapping.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/map-legend.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/timeline.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/bookmark.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/download.js"></script>
	<!-- prevent a FOUC -->
	<script type="text/javascript">
		$('html').addClass('js');
	</script>
	<!-- Google analytics script -->
	<script type="text/javascript">
	var _gaq = _gaq || [];
	_gaq.push(['_setAccount', 'UA-30195874-1']);
	_gaq.push(['_trackPageview']);
	
	(function() {
	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	})();
	</script>
	
	<style>
	  #eventsearch, #resourcesearch {
	    padding-top:.6em;
	    color: white; 
	    font-weight: normal;
	  }
	  #eventsearch:hover, #resourcesearch:hover {
	    background-color: #bbbbbb;
	  }
	</style>
       	
       	<div id='sidebar1' class="sidebar1 b-186 f-184">
		<div class="peekaboo-tohide mainMenu">
		<p class='label bold large' >&nbsp;&nbsp;Map</p>  
		</div>
		<div class="mapControlsContainer js peejaboo-tohide">
	    		<div class="accordion" id="mapLegendPanAndZoomControls">
	      			<h3><a href="#" id="mapLegendPanAndZoomHeading">View</a></h3>				
	      			<div id="mapLegendPanAndZoom" class="mapLegendInnerContainer">	
	      			</div>
	    		</div>
	    		<div class="accordion" id="mapLegendAdvancedControls">
	      			<h3><a href="#" id="mapLegendAdvancedControlsHeading">Save</a></h3>
	      			<div class="mapLegendInnerContainer">
					<ul>
		 				<li class="map-bookmark-open clickable">Bookmark this map</li>
		  				<li class="map-kml-download clickable">Download this map as KML</li>
					</ul>
	      			</div>
 	    		</div>
	  	</div>
	  	<div class="mapLegendContainer js peekaboo-tohide">
	    		<div class="accordion">
	      			<h3><a href="#" id="mapLegendContributorHeading">Contributors</a></h3>
	      			<div id="mapLegendContributors" class="mapLegendInnerContainer">
	      		</div>
	    	</div>
	    	<div class="accordion">
	     	 		<h3><a href="#" id="mapLegendOrganisationHeading">Organisations</a></h3>
	      			<div id="mapLegendOrganisations" class="mapLegendInnerContainer">	
	      			</div>
	    	</div>
	    	<div class="accordion">
	      		<h3><a href="#" id="mapLegendVenueHeading">Venues</a></h3>
	      		<div id="mapLegendVenues" class="mapLegendInnerContainer">
	      		</div>
	    	</div>
	    	<div class="accordion">
	      		<h3><a href="#" id="mapLegendEventsHeading">Events</a></h3>
	      		<div id="mapLegendEvents" class="mapLegendInnerContainer">
	      		</div>
	    	</div>
	</div>
</div>
<div id='main1' class="main1 b-184 f-187">
  	<div id="tabs" class="tab-container" style="position: relative">
  		<ul class="fix-ui-tabs">
			<li style="position: relative; left:65px;"><a href="#tabs-1">Build</a></li>
			<li style="position: relative; left:68px;"><a href="#tabs-2">Regions</a></li>
			<li style="position: relative; left:-120px;"><a href="#tabs-3">Map</a></li> 
		</ul>
	<div>

  	<div id="tabs-1">     	
    		<p>Search the AusStage database</p>	
    		<form action="/mapping/" method="get" id="search" name="search">
     			 <table class="formTable" style="height: 60px;">
				<tbody>
	 				<tr>
	    					<td style="width: 50%">
	      						<input type="search" size="40" id="query" name="query" title="Enter a few search terms into this box"/> <input type="submit" name="submit" id="search_btn" value="Search"/> <span id="show_search_help" class="helpIcon clickable"></span>
	    					</td>
	    					<td style="width: 40%">
	      						<div id="search_messages" class="js">
	        						<div class="ui-state-highlight ui-corner-all search-status-messages" id="search_status_message">
	          							<p>
		    								<span class="ui-icon ui-icon-info status-icon"></span>
		    								<span id="search_message_text"></span>
	          							</p>
	        						</div>
	        						<div class="ui-state-error ui-corner-all search-status-messages" id="search_error_message"> 
		          						<p>
			    							<span class="ui-icon ui-icon-alert status-icon"></span> 
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
	  		<h3><a href="" id="contributor_heading">Contributors</a></h3>
	  		<div id="contributor_results">
	  		</div>
		</div>
		<div class="accordion">
	  		<h3><a href="#" id="organisation_heading">Organisations</a></h3>
	  		<div id="organisation_results">
	  		</div>
		</div>
		<div class="accordion">
	  		<h3><a href="#" id="venue_heading">Venues</a></h3>
	  		<div id="venue_results">
	  		</div>
		</div>
	  	<div class="accordion">
	  		<h3><a href="#" id="event_heading">Events</a></h3>
	  		<div id="event_results">
	  		</div>
		</div>
		<p>&nbsp;</p>
		<div class="accordion">
	  		<h3><a href="#" id="search_history_heading">Search History</a></h3>
	    		<table class="searchResults">
	      			<thead>
					<tr>
		  				<th>Query - click to repeat</th>
		  				<th>Link - right-click to bookmark</th>
		  				<th class="alignRight">Contributors</th>
		  				<th class="alignRight">Organisations</th>
		  				<th class="alignRight">Venues</th>
		  				<th class="alignRight">Events</th>
					</tr>
	      			</thead>
	    			<tbody id="search_history"></tbody>
	  		</table>
		</div>
	
      	</div>
				
      	<div id="tabs-2">
		<div style="max-width: 990px">
	  		<div id="browse_header" style="height: 30px; width=100%">
	    			<div style="float:left; width: 26%; height: 100%; padding-right: 10px;">
	     				<p style="font-weight: bold">Countries and States</p>
	    			</div>
	    			<div style="float:left; width: 32%; height: 100%; margin-left: 10px;">
	      				<p style="font-weight: bold">Cities, Suburbs and Localities</p>
	    			</div>
	    			<div style="float: right; width: 37%; height: 100%; padding-left: 10px;">
	     	 			<p style="font-weight: bold">Venues</p>
	    			</div>
	 	 	</div>
	  		<div id="browse_content" style="height: 380px;">
	    			<div id="browse_major_area" style="float: left; width: 26%; height: 100%; overflow: auto; border-right: 1px solid #000; padding-right: 10px;">
	    			</div>
	    			<div id="browse_suburb" style="float: left; width: 32%; height: 100%; overflow: auto; border-right: 1px solid #000; padding-right: 10px;">
	    			</div>
	    			<div id="browse_venue"  style="float: right; width: 37%; height: 100%; overflow: auto; padding-left: -10px;">
	    			</div>
	  		</div>
	  		<div id="browse_footer" style="height:50px; width=100%;">
	    			<div style="float:left; padding-top: 15px;" id="browse_messages">
	    			</div>
	    			<div style="float:right; padding-top: 15px;">
	    				<input type="button" id="browse_reset_btn" value="Reset Browse"/>
	    				<input type="button" id="browse_add_btn" value="Add To Map"/> 
	    				<span id="show_browse_help" class="helpIcon clickable"></span>
	    			</div>
	  		</div>
		</div>
      	</div>
				
      	<div id="tabs-3" style="width: 600px">
		<!--widths were both 100 -->
		<div id="map_container_div" style="width: 100%">
	  		<div id="map_div" style="height: 100%; width: 100%">
	  		</div>
	  		<div style="height: 25px;">
	  		</div>
	  		<div>
	    			<div class="timeSliderContainer" style="float: left; height: 30px; width: 100%">
	      				<div id="timeSlider">
	      				</div>
			  	</div>
	    			<div id="mapResetButtonContainer" style="float: right">
	      				<input type="button" name="btn_reset_map" id="btn_reset_map" value="Reset Map"/>
				</div>
	  		</div>
      		</div>
   
    	</div>
  	
  </div>
</div>
</div>
	
	<!------------------------------------------------>
	<!-- help divs -->
<div id="help_search_div" title="Help" class="dialogs">
	<h3>Searching the AusStage database</h3>
	<p>
		This search retrieves contributors, organisations, venues and events that match all your search terms. Records with matching alternate or previous names will also be retrieved. Please wait for the search to complete before exploring the results. 
	</p>
	<p>
		To search for an exact phrase enclose the phrase in double quotation marks. For example &quot;The Ugly One&quot;. Include only keywords or an exact phrase in a single search, not both. 
	</p>
	<p>
		A maximum of 25 search results will retrieved for each type of record. If you don't see what you're looking for, try refining your search terms. You could also try searching the main <a href="http://www.ausstage.edu.au/" title="AusStage homepage">AusStage</a> website.
	</p>
</div>
<div id="help_add_view_div" title="Help" class="dialogs">
	<h3>Adding Items to the Map</h3>
	<p>
		Select items by ticking the box next to the name. Click the Add to Map button to add the selected items to the map. The map will be displayed when the items have been added. 
	</p>
	<p>
		Switch between the Search, Browse and Map tabs across the top to continue searching, browsing and adding items to the map.
	</p>
</div>
<div id="help_browse_div" title="Help" class="dialogs">
	<h3>Browsing for Venues</h3>
	<p>
		Browse for venues by clicking on the countries or states to reveal cities, suburbs and localities. Click on cities, suburbs and localities to reveal venues. Tick the box next to a name to select items at the next level down.
	</p>
	<p>
		Click the Add to Map button to add venues to the map. The map will be displayed when the venues have been added. 
	</p>
	<p>
		Switch between the Search, Browse and Map tabs across the top to continue searching, browsing and adding items to the map.
	</p>
</div>

<div id="map_legend_confirm_delete" title="Confirm Delete" class="dialogs">
	<h3>Do you want to delete this marker from the map?</h3>
	<div id="map_legend_confirm_delete_text">
	</div>
</div>
<div id="map_legend_confirm_reset" title="Confirm Reset" class="dialogs">
	<h3>Do you want to reset the map?</h3>
	<p>
		If you reset the map, all icons will be deleted, the legend will be emptied and the map will be re-centered. Your search history will remain available on the Search tab.
	</p>
</div>
<div id="map_legend_clustering_error" title="Clustering" class="dialogs">
	<h3>Unable to disable clustering</h3>
	<p>
		Clustering is automatically enabled when <span class="mlce_max"></span> markers are added to the map (including hidden markers). You currently have <span class="mlce_current"></span> markers added to the map. To disable clustering, remove some markers from the map and try again. If you feel the limit is too low, please <a href="http://beta.ausstage.edu.au/?tab=contacts" title="Contact information">contact us</a>.
	</p>
</div>
<div id="map_bookmark_div" title="Bookmark" class="dialogs">
	<h3>Save a bookmark for this map</h3>
	<p>
		<a href="" title="Bookmark this Map" id="map_bookmark_link">AusStage Map Bookmark</a> - Add this link as a bookmark to your browser. The bookmark will retrieve the latest data from AusStage each time you reload your map. The map includes all the contributors, organisations, venues and events you have added. Hidden markers will be visible and the time-slider will be maximised.
	</p>
</div>
<div id="map_bookmark_error_div" title="Bookmark" class="dialogs">
	<h3>Save a bookmark for this map</h3>
	<p>
		Bookmarks are only available when the map contains less than <span class="mlce_max"></span> markers (including hidden markers). You currently have <span class="mlce_current"></span> markers added to the map. Delete some markers and then try again.
	</p>
</div>
<div id="map_bookmark_loading_div" title="Loading Map from Bookmark" class="dialogs">
	<h3>Loading Map Data</h3>
	<div class="ui-state-highlight ui-corner-all search-status-messages" id="status_message">
		<p>
			<span class="ui-icon ui-icon-info status-icon"></span>
			 Loading data for the map, please wait...
		</p>
	</div>
</div>
	<!------------------------------------------------>
	
	
	<!-- always at the bottom of the content -->
	
	<div class="push"></div></div>

	<cms:include property="template" element="foot" />
