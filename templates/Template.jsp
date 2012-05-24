<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<cms:template element="head">
  <html>
    <head> 
	<title>AusStage</title>
	<link rel='stylesheet' href='/resources/style.css'/>
	<link rel='icon' href='/resources/favicon2.ico'/>	
	<meta charset="utf-8" />
	<link rel="stylesheet" href="/pages/assets/main-style.css"/>
	<link rel="stylesheet" href="/pages/assets/ausstage-colours.css"/>
	<link rel="stylesheet" href="/pages/assets/ausstage-background-colours.css"/>
	<link rel="stylesheet" href="/pages/assets/jquery-ui/jquery-ui-1.8.6.custom.css"/>
	<link rel="stylesheet" href="/pages/assets/rangeslider/dev.css"/>
    </head>
    
    <body topmargin="0" leftmargin="0" bgproperties="fixed" bgcolor="#333333">
      <div class="wrapper">
        <div id="header" class="b-187">
          <a href="/pages/search/"><img src="/resources/images/ausstagehomebrand.gif" alt="default" border="0" id="headerLogo"/></a>
          <h1 id="headerText">Researching live performance in Australia</h1>
        </div>
    
        <div id="loginBar1" class="b-186">  
 	  <% if (session.getAttribute("loginOK") == null || session.getAttribute("loginOK").equals("false")) {%>
          <form id="aform">
	    <select id="mymenu" size="1">
	      <option value="nothing" selected="selected">Login</option>
	      <option value="/admin/shibboleth/validateLogin.jsp">AAF credentials</option>
	      <option value="/admin/login.jsp">AusStage Login</option>
	    </select>
          </form>

	  <script type="text/javascript">
		var selectmenu=document.getElementById("mymenu")
		selectmenu.onchange=function(){ //run some code when "onchange" event fires
		 var chosenoption=this.options[this.selectedIndex] //this refers to "selectmenu"
		 if (chosenoption.value!="nothing"){
		  window.open(chosenoption.value, "", "") //open target site (based on option's value attr) in new window
		 }
		}
  	  </script> 
	  <%
	  } else {
	  %>     
	  <a href="/custom/welcome.jsp"><%=session.getAttribute("fullUserName")%></a>
	  <% } %>  
        </div>
      
        <div id='sidebar1' class="sidebar1 b-186 f-184">
	  <div class="peekaboo-tohide mainMenu">
	  <% CmsJspActionElement cms = new CmsJspActionElement(pageContext, request, response); %>
          <a class="<%=(cms.getRequestContext().getUri().endsWith("pages/map/"))?"current ":""%>family_links_current" href="/pages/map/">Search</a>
  
	  <%@ include file="DynamicMenu.jsp"%>
	</div>
	<div class="mapControlsContainer js peejaboo-tohide">
	  <hr style="width: 95%; margin-top: 5px;" class="f-184 b-184"/>
	    <div class="accordion" id="mapLegendPanAndZoomControls">
	      <h3><a href="#" id="mapLegendPanAndZoomHeading">View</a></h3>				
	      <div id="mapLegendPanAndZoom" class="mapLegendInnerContainer">	</div>
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
	      <div id="mapLegendOrganisations" class="mapLegendInnerContainer">	</div>
	    </div>
	    <div class="accordion">
	      <h3><a href="#" id="mapLegendVenueHeading">Venues</a></h3>
	      <div id="mapLegendVenues" class="mapLegendInnerContainer"></div>
	    </div>
	    <div class="accordion">
	      <h3><a href="#" id="mapLegendEventsHeading">Events</a></h3>
	      <div id="mapLegendEvents" class="mapLegendInnerContainer"></div>
	    </div>
	  </div>
	</div>
	</cms:template>

    <cms:template element="body">
      <cms:include element="body" editable="true"/>
    </cms:template>

    <cms:template element="foot">	
  
    </body>
</html>

</cms:template>