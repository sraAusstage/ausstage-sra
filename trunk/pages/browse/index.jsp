<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "ausstage.SearchCount, admin.Common"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*, ausstage.Database, admin.AppConstants, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>

<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-1.6.1.min.js"></script>

<cms:include property="template" element="head" />

<%@ include file="../../public/common.jsp"%>

<!--
Javascript to handle the dynamic content.
Should probably put this in a seperate .js file 
-->
<script language="javascript">
	//function that gets counts.  
	function getCounts(){
    		var ajaxRequest;  
        	var url;
        	
	   	try{// Opera 8.0+, Firefox, Safari
    			ajaxRequest = new XMLHttpRequest();
    		} catch (e){// Internet Explorer Browsers
    			try{
    				ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
    			} catch (e) {
    				try{
    					ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
    				} catch (e){
	    				// Something went wrong
	   				return false;
	   			}
 			}
	    	}
    		
	    	//check the search_from value to determine which tables we need to check
		//url = "index_ajax.jsp?f_keyword="+$("#header-search-keywords").val()+"&f_search_from=";	    	
	    	
	    	//if there are search terms
	    	if ($('#header-search-keywords').val().trim().length>0){
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
	    	
	    	}
	    	ajaxRequest.open("GET", eventUrl , false);			
	    	ajaxRequest.send(null);
	    	updateCount("event",$.trim(ajaxRequest.responseText))
	    		
	    	ajaxRequest.open("GET", contribUrl, false);			
	    	ajaxRequest.send(null);
	    	updateCount("contrib",$.trim(ajaxRequest.responseText))
	    		
	    	ajaxRequest.open("GET", venueUrl, false);
	    	ajaxRequest.send(null);
	    	updateCount("venue",$.trim(ajaxRequest.responseText));
	    		
	    	ajaxRequest.open("GET", orgUrl, false);
	    	ajaxRequest.send(null);
	    	updateCount("org",$.trim(ajaxRequest.responseText));
	 		
	 	ajaxRequest.open("GET", genreUrl, false);
	    	ajaxRequest.send(null);
	    	updateCount("genre",$.trim(ajaxRequest.responseText));
	 		
	 	ajaxRequest.open("GET", functUrl, false);
	    	ajaxRequest.send(null);
	    	updateCount("function",$.trim(ajaxRequest.responseText));
	    		
	    	ajaxRequest.open("GET", subjUrl, false);
	    	ajaxRequest.send(null);
	    	updateCount("subject",$.trim(ajaxRequest.responseText));
	    		
	    	ajaxRequest.open("GET", workUrl, false);
	    	ajaxRequest.send(null);
	    	updateCount("works",$.trim(ajaxRequest.responseText));
	    		
	    	ajaxRequest.open("GET", resUrl, false);
	    	ajaxRequest.send(null);
	    	updateCount("resource",$.trim(ajaxRequest.responseText));
	    	
	    	updateLinks();	
    		return false;
  
    	}
    	
    	//function to replace the loading symbol with the number,
    	function updateCount(field, value){
    		$('#'+field+"-count").empty().append(value).show();
    		$('#'+field+"-count-load").hide();	
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
    	
    	//update the links. IF no search terms each box links to the associated browse. 
    	//otherwise link to search results using search terms
    	function updateLinks(){
    		
    		//if search terms
    	    	if ($('#header-search-keywords').val().trim().length>0){
    	    		var boxesToChange = $('.box');
    	    		//check the url hasn't already been changed
    	    		$.each($('.box'), function(){
    	    			if ( $(this).attr('id') !='map'){
    	    				if($(this).attr('onclick')){
    	    					$(this).attr( "onclick", "submitSearch('"+$(this).attr("id")+"');" );
    	    				}
    	    			}
    	    		})
    	    	}
    	    	//otherwise set to the browse 
    	    	else {
    	    		$.each($('.box'), function(){
    	    		    	if ( $(this).attr('id') !='map'){
    	    		    		if($(this).attr('onclick')){
    	    					$(this).attr( "onclick", "location.href='" +$(this).attr("id")+ "s/'" );
    	    				}
    	    			}
    	    		})	
    	    	}
    	    	//finally if results are 0 disable the link
    	    	$.each($('.box'), function(){
    	    		if($(this).children('.box-count').text()=="0"){
    	    		$(this).attr( "onclick", "null" );}
    	    	})	
    	}
    	
    	function submitSearch(searchType){
    		if (searchType == 'genre'){
    			$('#genreSearchform #f_keyword').attr('value',$("#header-search-keywords").val());
    			$('#genreSearchForm').submit();
    		}else if (searchType == 'function'){
    			$('#functionSearchform #f_keyword').attr('value',$("#header-search-keywords").val());
    			$('#functionSearchForm').submit();
    		}else if (searchType == 'subject'){
    			$('#subjectSearchform #f_keyword').attr('value',$("#header-search-keywords").val());
    			$('#subjectSearchForm').submit();
    		}
    		else if (searchType != 'noResult') {
    			$('#searchform #f_keyword').attr('value',$("#header-search-keywords").val());
    			$('#searchform #f_search_from').attr('value',searchType);
    			$('#searchForm').submit();
    		}
    	}   	 	
	
	$(document).ready(function() {
		
		//set the action for the search header (will be different for different pages)
		$("#header-search-form").attr("action","/pages/browse/");
		$("#header-search-form").attr("onsubmit","clearAll();return getCounts()");
		//clearAll();
		getCounts();
	});	
	
</script>


<div class="boxes">

<span id="event" class="box b-90" onclick="location.href='events/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-91';" onmouseout="this.className='box b-90 ';">
<img src="../../resources/images/icon-event.png" class="box-icon"> 
<span id="event-count" class="box-count"></span>
<span id="event-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label"><a href="event/index.jsp">Events</a> </span> </span>

<span id="contributor" class="box b-105 " onclick="location.href='contributors/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-106 ';" onmouseout="this.className='box b-105 ';">
<img src="../../resources/images/icon-contributor.png" class="box-icon">
<span id="contrib-count" class="box-count"></span> 
<span id="contrib-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label"><a href="contributors/index.jsp">Contributors</a> </span> </span>

<span id="venue" class="box b-134 " onclick="location.href='venues/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-135 ';" onmouseout="this.className='box b-134 ';">
<img src="../../resources/images/icon-venue.png" class="box-icon"> 
<span id="venue-count" class="box-count"></span>
<span id="venue-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span> 
<span class="box-label"><a href="">Venues</a> </span> </span>

<span id="organisation" class="box b-121 " onclick="location.href='organisations/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-122 ';" onmouseout="this.className='box b-121 ';"> 
<img src="../../resources/images/icon-organisation.png" class="box-icon"> 
<span id="org-count" class="box-count"></span> 
<span id="org-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label"> <a href="">Organisations</a> </span> </span>

<span id="genre" class="box b-90" onclick="location.href='genres/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-91';" onmouseout="this.className='box b-90 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon"> 
<span id="genre-count" class="box-count"></span> 
<span id="genre-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label"><a href="">Genres</a> </span> </span>

<span id="function" class="box b-105 " onclick="location.href='functions/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-106 ';" onmouseout="this.className='box b-105 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon">
<span id="function-count" class="box-count"></span>
<span id="function-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label"><a href="">Functions</a> </span> </span>

<span class="box b-134 " id='map' onclick="location.href='../map/#tabs-3';" style="cursor:pointer;" onmouseover="this.className='box b-135 ';" onmouseout="this.className='box b-134 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon"> 

<span class="box-label"><a href="">Map</a> </span> </span>

<span class="box b-186" style="background-image:url('../../resources/images/box-picture-1.jpg');"></span>

<span id="subject" class="box b-90" onclick="location.href='subjects/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-91';" onmouseout="this.className='box b-90 ';">
<img src="../../resources/images/icon-blank.png" class="box-icon"> 
<span id="subject-count" class="box-count"></span> 
<span id="subject-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label"><a href="">Subjects</a> </span> </span>

<span class="box b-186" style="background-image:url('../../resources/images/box-picture-2.jpg');"></span>

<span id="work" class="box b-153" onclick="location.href='works/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-154';" onmouseout="this.className='box b-153 ';">
<img src="../../resources/images/icon-work.png" class="box-icon"> 
<span id="works-count" class="box-count"></span>
<span id="works-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span> 
<span class="box-label"><a href="">Works</a> </span> </span>

<span id="resource" class="box b-153" onclick="location.href='resources/index.jsp';" style="cursor:pointer;" onmouseover="this.className='box b-154';" onmouseout="this.className='box b-153 ';">
<img src="../../resources/images/icon-resource.png" class="box-icon"> 
<span id="resource-count" class="box-count"></span> 
<span id="resource-count-load" class="box-count-load"><img src="../../resources/images/loader.gif"> </span>
<span class="box-label"><a href="">Resources</a> </span> </span>

</div>
<!---------------------------------------------------------------->
<!--hidden forms-->
<form name="functionSearchForm" id="functionSearchForm" Method = "POST" action="../search/function/results/" >	
	<input class="hidden_fields" type="hidden" name="f_keyword" id="f_keyword" value="" />
</form>
<form name="genreSearchForm" id="genreSearchForm" Method = "POST" action="../search/genre/results/" >	
	<input class="hidden_fields" type="hidden" name="f_keyword" id="f_keyword" value="" />
</form>
<form name="subjectSearchForm" id="subjectSearchForm" Method = "POST" action="../search/subject/results/" >	
	<input class="hidden_fields" type="hidden" name="f_keyword" id="f_keyword" value="" />
</form>
<form name="searchForm" id="searchForm" Method = "POST" action="../search/results/" >	
	<input class="hidden_fields" type="hidden" name="f_keyword" id="f_keyword" value="" />
	<input class="hidden_fields" type="hidden" name="f_search_from" id="f_search_from" value="" />
	<input class="hidden_fields" type="hidden" name="f_sql_switch" id="f_sql_switch" value="and" />
	<input class="hidden_fields" type="hidden" name="f_sort_by" id="f_sort_by" value="alphab_frwd" />
	<input class="hidden_fields" type="hidden" name="f_year" id="f_year" value="" />
</form>

<cms:include property="template" element="foot" />