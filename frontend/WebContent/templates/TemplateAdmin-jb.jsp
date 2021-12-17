<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page session="true" import="java.lang.String, java.util.*" %>
<!DOCTYPE HTML
    PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<cms:template element="head">
  <html>
    <head>
      <title>AusStage</title> 
	<link rel='stylesheet' href='/resources/style-admin.css'/>
	<link rel='stylesheet' href='/resources/shared-style.css'/>
	<link rel='stylesheet' href='/pages/assets/ausstage-colours.css'/>
	<link rel='stylesheet' href='/pages/assets/ausstage-background-colours.css'/>
	<link rel='stylesheet' href='/resources/wysiwyg.css'/>	
	<link rel='icon' href='/resources/favicon2.ico'/>
	
	<script type="text/javascript" src="/resources/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="/resources/bootstrap-3.3.7/js/bootstrap.min.js"></script>

    </head>
     
    <body>
    
<div class="wrapper">
    <div class='header-wrapper'>	
    	<div id="header" class="b-187" style="display:flex; flex-wrap:nowrap">
    		<div style="width:141px">
	    	<a href="/pages/browse/"><img src="/resources/images/ausstage-logo-admin.png" alt="default" border="0" class="header-logo"/></a>
	    	</div>
<!-- insert header-search form here if required -->
	 <div style="width:100%; display: flex; align-items: center;
	    color: #c5c5c5;font-size: 23px;font-family: sans-serif;">
		  <span>
		  The Australian Live Performance Database
		  </span>
		  </div>
	</div> 
	<div class="navigation">
		<div id="loginBar">
		<% if (session.getAttribute("loginOK") == null || session.getAttribute("loginOK").equals("false")) {%>
        		<form id="aform">
				<select id="mymenu" size="1">
					<option value="nothing" selected="selected">Login</option>
					<!-- <option value="/admin/shibboleth/validateLogin.jsp">AAF Login</option> -->
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
	<a href="/custom/welcome.jsp" style="padding:2px 10px 2px 0px;"><%=session.getAttribute("fullUserName")%></a>

	<% } %>
		</div>
			<ul class="navigation label">
				<li><a href="/pages/browse/">Browse</a></li>
				<li><a href="/pages/search/">Search</a></li>
				<li><a href="/pages/learn/">Learn</a></li>
				<li><a href="/pages/learn/donate/">Donate</a></li>
			</ul>

	</div>
</div>

<div id="sidebar" class="page-menu b-175">

<ul class="page-menu-list">

<%
List<String> groupNames = new ArrayList();
if (session.getAttribute("loginOK") != null && !session.getAttribute("loginOK").equals("false")){
  //CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
  //CmsObject cmsObject = cms.getCmsObject();
  List<Object> userGroups = new ArrayList();
  for(Object group:userGroups) {
     //groupNames.add(group.getName());
  }
}



// if (request.getRequestURI().indexOf("event_search") >=0) response.getOutputStream().print("curr "); -- to display "curr " in the list of classes 
if (groupNames.contains("Administrators") || groupNames.contains("Event Editor")) {
%><li><a class="family_links_current" href="/custom/event_search.jsp">Add, Edit or Copy Events</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Resource Editor")) {
%><li><a class="family_links_current" href="/custom/item_search.jsp">Add/Edit Resources</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Works Editor")) {
%><li><a class="family_links_current" href="/custom/work_search.jsp">Works Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Contributor Editor")) {
%><li><a class="family_links_current" href="/custom/contrib_search.jsp">Contributor Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Country Editor")) {
%><li><a class="family_links_current" href="/custom/country_admin.jsp">Country Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Contributor Function Editor")) {
%><li><a class="family_links_current" href="/custom/contrib_funct_search.jsp">Contributor Function Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("DataSource Editor")) {
%><li><a class="family_links_current" href="/custom/datasource_admin.jsp">DataSource Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Organisation Editor")) {
%><li><a class="family_links_current" href="/custom/organisation_search.jsp">Organisation Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Primary Genre Editor")) {
%><li><a class="family_links_current" href="/custom/primary_genre_list.jsp">Primary Genre Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Secondary Genre Editor")) {
%><li><a class="family_links_current" href="/custom/second_genre_search.jsp">Secondary Genre Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Content Indicator Editor")) {
%><li><a class="family_links_current" href="/custom/primary_content_ind_search.jsp">Subjects Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Venue Editor")) {
%><li><a class="family_links_current" href="/custom/venue_search.jsp">Venue Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Exhibition Editor")) {
%><li><a class="family_links_current" href="/custom/exhibition_manage.jsp">Exhibition Maintenance</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("SQL Editor")) {
%><li><a class="family_links_current" href="/custom/ausstage_sql_interface.jsp">SQL Interface</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Record Count Editor")) {
%><li><a class="family_links_current" href="/custom/record_count.jsp">Record Count Report</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Lookups Editor")) {
%><li><a class="family_links_current" href="/custom/lookuptype_search.jsp">Lookups</a></li><%
}
if (groupNames.contains("Administrators") || groupNames.contains("OpenCMS Editor")) {
%><li><a class="family_links_current" target="_blank" href="/system/login">OpenCMS Login</a></li><%
}
%>

<li><a class="family_links_current" href="/admin/logout.jsp">Logout</a></li>

</ul>

</div>
<div class="page-content">
</cms:template>


<cms:template element="body">
	<cms:include element="body" editable="true"/>
</cms:template>


<cms:template element="foot">	
</div>
		
<div id="footer" class="footer">
 
<div class="footer-left">
<span class="label"><a href="/pages/browse/">AusStage</a> &bull; Researching Australian live performance</span>
<br><span class="label small"><a href="/pages/learn/about/">About</a> | <a href="/pages/learn/contact/accessibility.html">Accessibility</a> | <a href="/pages/learn/contact/">Contact</a> | <a href="/pages/learn/contact/cultural-advice.html">Cultural Advice</a> | <a href="/pages/learn/help.html">Help</a> | <a href="/pages/learn/contact/privacy.html">Privacy</a> | <a href="/pages/learn/contact/terms-of-use.html">Terms of Use</a></span>
</div>

<div class="footer-right label small">
Copyright &copy; AusStage and contributors, 2003<script type="text/javascript">var d=new Date();d=d.getFullYear();document.write("-"+d);</script>.<br>Licensed for use <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY-NC-SA 4.0</a>.
</div>

</div>

</body>

</html>

</cms:template>