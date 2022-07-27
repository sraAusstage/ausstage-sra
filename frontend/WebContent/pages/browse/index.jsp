<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "ausstage.SearchCount, admin.Common"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*, ausstage.Database, admin.AppConstants, sun.jdbc.rowset.*" %>

<!--<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-1.6.1.min.js"></script>-->

<jsp:include page="../../templates/header.jsp" />

<%@ include file="../../public/common.jsp"%>

<!--
Javascript to handle the dynamic content.
Should probably put this in a seperate .js file 
-->

<script language="javascript">
	function numberWithCommas(x) {
    		var parts = x.toString().split(".");
		parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    		return parts.join(".");
	}

	//function that gets counts.  
	function getCounts(){
	
    		var ajaxRequest;  
        	var url;
        	
                // set up the ajax queue
                var ajaxQueue = $.manageAjax.create("searchAjaxQueue", {
                	queue: false
                });
    		
	    	//if there are search terms
	    	//if ($('#header-search-keywords').val().trim().length>0){
	    	if ($.trim($('#header-search-keywords').val()).length>0){    	
	    	
	    		url = "../search/results/";
	    		var eventUrl = url + "event_ajax.jsp?f_keyword="+$("#header-search-keywords").val()
	    				+ "&f_search_from=event"
    					+ "&f_sql_switch=and"
    					+ "&f_sort_by=alphab_frwd"
    					+ "&f_year=";    					    					
    			var contribUrl = url + "contrib_ajax.jsp?f_keyword="+$("#header-search-keywords").val()
	    				+ "&f_search_from=contributor"
    					+ "&f_sql_switch=and"
    					+ "&f_sort_by=alphab_frwd"
    					+ "&f_year=";
    			var venueUrl = url + "venue_ajax.jsp?f_keyword="+$("#header-search-keywords").val()
	    				+ "&f_search_from=venue"
    					+ "&f_sql_switch=and"
    					+ "&f_sort_by=alphab_frwd"
    					+ "&f_year=";	
    			var orgUrl = url + "org_ajax.jsp?f_keyword="+$("#header-search-keywords").val()
	    				+ "&f_search_from=organisation"
    					+ "&f_sql_switch=and"
    					+ "&f_sort_by=alphab_frwd"
    					+ "&f_year=";
    			var genreUrl = 	"index_ajax.jsp?f_keyword=" + $("#header-search-keywords").val() +"&f_search_from=genre";
    			var functUrl = 	"index_ajax.jsp?f_keyword=" + $("#header-search-keywords").val() +"&f_search_from=function";	
	    		var subjUrl = 	"index_ajax.jsp?f_keyword=" + $("#header-search-keywords").val() +"&f_search_from=subject";
	    		var workUrl = 	url + "work_ajax.jsp?f_keyword="+$("#header-search-keywords").val()
	    				+ "&f_search_from=work"
    					+ "&f_sql_switch=and"
    					+ "&f_sort_by=alphab_frwd"
    					+ "&f_year=";
    			var resUrl = 	url + "resource_ajax.jsp?f_keyword="+$("#header-search-keywords").val()
	    				+ "&f_search_from=resource"
    					+ "&f_sql_switch=and"
    					+ "&f_sort_by=alphab_frwd"
    					+ "&f_year=";
   			var countryUrl = url + "country_ajax.jsp?f_keyword="+$("#header-search-keywords").val()
	    				+ "&f_search_from=country"
    					+ "&f_sql_switch=and"
    					+ "&f_sort_by=alphab_frwd";
    					    				
    				    						    			
	    	} else {
	    		url = "index_ajax.jsp?f_keyword="+$("#header-search-keywords").val()+"&f_search_from=";
	    		var eventUrl = 	url + "event";
    			var contribUrl = url + "contributor";
    			var venueUrl = 	url + "venue";	
    			var orgUrl = 	url + "organisation" ;
    			var genreUrl = 	url + "genre";
    			var functUrl = 	url + "function";	
	    		var subjUrl = 	url + "subject";
	    		var workUrl = 	url + "works";
    			var resUrl = 	url + "resource";	
		   	var countryUrl = url + "country";	
	    		    	
	    	}

	    	// queue this request
                ajaxQueue.add({
                	success: function(html){updateCount("event",$.trim(html))},
                        url: encodeURI(eventUrl)
                });
	    	
	    	ajaxQueue.add({
                	success: function(html){updateCount("contrib",$.trim(html))},
                        url: encodeURI(contribUrl)
                });
	    	
	    	ajaxQueue.add({
                	success: function(html){updateCount("venue",$.trim(html))},
                        url: encodeURI(venueUrl)
                });	

	    	ajaxQueue.add({
                	success: function(html){updateCount("org",$.trim(html))},
                        url: encodeURI(orgUrl)
                });	
	    	
	 	ajaxQueue.add({
                	success: function(html){updateCount("genre",$.trim(html))},
                        url: encodeURI(genreUrl)
                });
                	
	 	ajaxQueue.add({
                	success: function(html){updateCount("function",$.trim(html))},
                        url: encodeURI(functUrl)
                });
	 		
	 	ajaxQueue.add({
                	success: function(html){updateCount("subject",$.trim(html))},
                        url: encodeURI(subjUrl)
                });
	    		
	  	ajaxQueue.add({
                	success: function(html){updateCount("works",$.trim(html))},
                        url: encodeURI(workUrl)
                });
	    		
	    	ajaxQueue.add({
                	success: function(html){updateCount("resource",$.trim(html))},
                        url: encodeURI(resUrl)
                });
                ajaxQueue.add({
                	success: function(html){updateCount("country",$.trim(html))},
                        url: encodeURI(countryUrl)
                });
                
	    		
    		return false;
  
    	}
    	
    	//function to replace the loading symbol with the number,
    	function updateCount(field, value){
    		value = numberWithCommas(value);
    		$('#'+field+"-count").empty().append(value).show();
    		$('#'+field+"-count-load").hide();
    		//if (value == "0"){$('#'+field+"-count").hide();}
    	}
    	

    	//clear counts and display the loading icon
    	function clearAll(){
    	
		$('.box-count').queue(function(next){
    					$(this).hide();
    					next();
    					});    		
    		$('.box-count-load').queue(function(next){
    					$(this).show();
    					next();
    					});			
    					
    	}		
    	
    	function submitSearch(searchType){
    		if (searchType == 'genre'){
    			$('#search-form #f_keyword').attr('value',$("#header-search-keywords").val());
    			$('#search-form').attr('action', '../search/genre/results/');
    			$('#search-form').submit();
    		}else if (searchType == 'function'){
    			$('#search-form #f_keyword').attr('value',$("#header-search-keywords").val());
    			$('#search-form').attr('action', '../search/function/results/');
    			$('#search-form').submit();
    		}else if (searchType == 'subject'){
    			$('#search-form #f_keyword').attr('value',$("#header-search-keywords").val());
    			$('#search-form').attr('action', '../search/subject/results/');
    			$('#search-form').submit();
    		}
    		else if (searchType != 'noResult') {			
    			$('#search-form #f_keyword').attr('value',$("#header-search-keywords").val());
    			$('#f_search_from').attr('value',searchType);
   			$('#search-form').attr('action', '../search/results/');
    			$('#search-form').submit();
    		}
    	}  
    	
    	function doSearch(id){
    		//if keywords have been entered
    		if ($.trim($('#header-search-keywords').val()).length>0){
    		
    		 	if ($('#'+id).children('.box-count').text() == "0"){
    		 		return false;
    		 	}else {
    		 		submitSearch(id);
    		 	}
    		}
    		else if ($.trim($('#header-search-keywords').val()).length == 0){
    			if(id=="international"){
    				window.location.href = "countries/";
    			}
    			else
    				window.location.href = id+"s/";
    		}
    	
    	} 	 	
	
	//function to randomly select images for the page
	function getImages(){
		var imagePath = '../learn/about/assets/images/';
		var imageArray = [
		"tn003377d.jpg",
		"tnnewspix00157013.jpg",
		"tnimage001.jpg","tnnewspix00675058.jpg",
		"tnimage002.jpg","tnnewspix00840531.jpg",
		"tnrw007253.jpg","tnvn3719979.jpg"
		];
		
		var randomNum = Math.floor(Math.random() * imageArray.length);
		var randomNum2 = Math.floor(Math.random() * imageArray.length); 
		while (randomNum == randomNum2){
			//getting rendom number that isn't the same as the other. 
			randomNum2 = Math.floor(Math.random() * imageArray.length);
		}
		
		document.getElementById("RandomImage1").style = "background-image:url('"+imagePath+imageArray[randomNum]+"'); background-size:cover";
		document.getElementById("RandomImage2").style = "background-image:url('"+imagePath+imageArray[randomNum2]+"'); background-size :cover";
		
	}
	

	
	$(document).ready(function() {
		getImages();	
		//set the action for the search header (will be different for different pages)
		$("#header-search-form").attr("action","/pages/browse/");
		$("#header-search-form").attr("onsubmit","clearAll();return getCounts()");
		$("#header-search-button").click(function (){clearAll();
							     return getCounts();});
		//workaround for onsubmit Internet Explorer issue
		$("#header-search-keywords").keypress(function(event) {
  			if ( event.which == 13 ) {
     				event.preventDefault(); clearAll();return getCounts();
   			}
   		});
   		if ($.trim($('#header-search-keywords').val()).length>0){
   			clearAll();
			getCounts();
   		}
		
		$('.box-count-load').queue(function(next){
    					$(this).hide();
    					next();
    					});
    		
    			
	});	
	
</script>

<div class="boxes">

<a id="event" class="box b-90" href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-91';" onmouseout="this.className='box b-90 ';">
<img src="../../resources/images/icon-event.png" class="box-icon"> 
<span id="event-count" class="box-count"></span>
<span id="event-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label">Events</span> 
<span class="box-label box-help">The Event table in AusStage records distinct happenings, defined by title, date and venue; typically, a performance or series of performances at a venue.</span></a>



<a id="contributor" class="box b-105 " href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-106 ';" onmouseout="this.className='box b-105 ';">
<img src="../../resources/images/icon-contributor.png" class="box-icon">
<span id="contrib-count" class="box-count"></span> 
<span id="contrib-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label">Contributors</span>
<span class="box-label box-help">The Contributor table records information on individuals (human and non-human) who contribute in some capacity to the conception, production or presentation of an event.</span></a>

<a id="venue" class="box b-134 " href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-135 ';" onmouseout="this.className='box b-134 ';">
<img src="../../resources/images/icon-venue.png" class="box-icon"> 
<span id="venue-count" class="box-count"></span>
<span id="venue-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span> 
<span class="box-label">Venues</span>
<span class="box-label box-help">The Venue table records information on the place where an event happens, distinguished by its name and location. By definition, an event in AusStage can only occur at one venue; geographic coordinates for longitude and latitude may be recorded in decimal degrees for venues without conventional street addresses.</span></a>

<a id="organisation" class="box b-121 " href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-122 ';" onmouseout="this.className='box b-121 ';"> 
<img src="../../resources/images/icon-organisation.png" class="box-icon"> 
<span id="org-count" class="box-count"></span> 
<span id="org-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label">Organisations </span>
<span class="box-label box-help">The Organisation table records information on groups, companies or organisations involved in the conception, production or presentation of an event.</span></a>

<a id="genre" class="box b-90" href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-91';" onmouseout="this.className='box b-90 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon"> 
<span id="genre-count" class="box-count"></span> 
<span id="genre-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label">Genres</span>
<span class="box-label box-help">Categories indicating the kind of event, or aspects of an event, as defined by the style, content and mode of performance.</span></a>

<a id="function" class="box b-105 " href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-106 ';" onmouseout="this.className='box b-105 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon">
<span id="function-count" class="box-count"></span>
<span id="function-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label">Functions </span>
<span class="box-label box-help">A contributor’s contribution to an event is characterised by function: actor, director, designer, technician and so on.</span></a>

<a id="exhibition" class="box b-153" href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-154';" onmouseout="this.className='box b-153';">
<img src="../../resources/images/icon-exhibition.png" class="box-icon">
<!--<span id="exhibition-count" class="box-count"></span>
<span id="exhibition-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>-->
<span class="box-label">Exhibitions </span>
<span class="box-label box-help">Curated exhibitions of material showcasing Australia’s live performance heritage</span></a>

<a class="box b-134 " id='map' href='../map/#tabs-3' style="cursor:pointer;" onmouseover="this.className='box b-135 ';" onmouseout="this.className='box b-134 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon"> 

<span class="box-label">Map</span>
<span class="box-label box-help"></span></a>

<span id="RandomImage1" class="box b-186" style=""></span>

<a id="subject" class="box b-90" href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-91';" onmouseout="this.className='box b-90 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon"> 
<span id="subject-count" class="box-count"></span> 
<span id="subject-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label">Subjects </span>
<span class="box-label box-help">Categories indicating the subject matter or thematic content of the event.</span></a>

<span id="RandomImage2" class="box b-186" style=""></span>

<a id="work" class="box b-153" href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-154';" onmouseout="this.className='box b-153 ';">
<img src="../../resources/images/icon-work.png" class="box-icon"> 
<span id="works-count" class="box-count"></span>
<span id="works-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span> 
<span class="box-label">Works </span>
<span class="box-label box-help">A work is the abstract conception of an event, typically a play script or score.</span></a>

<a id="resource" class="box b-153" href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-154';" onmouseout="this.className='box b-153 ';">
<img src="../../resources/images/icon-resource.png" class="box-icon"> 
<span id="resource-count" class="box-count"></span> 
<span id="resource-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label">Resources </span>
<span class="box-label box-help">The Resource Directory is a data set of information on collections, items and resources related to Australia’s performing arts heritage.</span></a>

<a id="international" class="box b-90" href='#' onclick="doSearch($(this).attr('id'));" style="cursor:pointer;" onmouseover="this.className='box b-91';" onmouseout="this.className='box b-90 ';">
<img src="../../resources/images/icon-international.png" class="box-icon"> 
<span id="country-count" class="box-count"></span>
<span id="country-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span> 
<span class="box-label">International </span>
<span class="box-label box-help">Information on performances taking place at venues outside Australia and by International organisations within Australia.</span></a>

<a class="box b-175 " id='contribute' href='../learn/contribute/' style="cursor:pointer;" onmouseover="this.className='box b-176 ';" onmouseout="this.className='box b-175 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon"> 

<span class="box-label">How to contribute</span>
<span class="box-label box-help"></span></a>



</div>
<!---------------------------------------------------------------->
	<form name="search-form" id="search-form" method="post" action=""> 			
			<input class="hidden_fields" type="hidden" name="f_keyword" id="f_keyword" value="" />
		 	<input class="hidden_fields" type="hidden" name="f_search_from" id="f_search_from" value="" />
			<input class="hidden_fields" type="hidden" name="f_sql_switch" id="f_sql_switch" value="and" />
			<input class="hidden_fields" type="hidden" name="f_sort_by" id="f_sort_by" value="alphab_frwd" />
			<input class="hidden_fields" type="hidden" name="f_year" id="f_year" value="" />
	</form>

<jsp:include page="../../templates/footer.jsp" />
<script type="text/javascript" src="${pageContext.request.contextPath}/pages/assets/javascript/libraries/jquery.ajaxmanager-3.11.js"></script>