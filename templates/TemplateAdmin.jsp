<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" %>
<!DOCTYPE HTML
    PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<cms:template element="head">
  <html>
    <head>
    <meta name="IDENTIFIER" content="http://www.ausstage.edu.au/default.jsp?xcid=27">
    <meta name="TITLE" content="Search">
    <meta name="DC.Title" content="AusStage: Gateway to the Australian Performing Arts">
    <meta name="DC.Creator" content="Jenny White">
    <meta name="DC.Creator" content="Joh Hartog">
    <meta name="DC.Subject" content="Australian Performing Arts, Theatre History, Research, Resources,  Performing Arts Links">
    <meta name="DC.Subject" content="Australian Dance, Drama, Opera, Circus, Venues, Companies, Actors, Directors">
    <meta name="DC.Description" content="AusStage: Gateway to the Australian Performing Arts.  Extensive Australasian Performing Arts Links and detailed information about Performing Arts Events, Artists, Organisations and Venues, as well as a Directory of Performing Arts resources.">
    <meta name="DC.Publisher" content="Flinders University of South Australia">
    <meta name="DC.Format" content="text / html">
    <meta name="DC.Identifier" content="http://www.ausstage.edu.au">
    <!--<link rel="stylesheet" href="<cms:link>/resources/css/default.css</cms:link>" type="text/css">-->
      <title>AusStage</title> 
	<link rel='stylesheet' href='/resources/style.css'/>
	<link rel='stylesheet' href='/pages/assets/ausstage-colours.css'/>
	<link rel='stylesheet' href='/pages/assets/ausstage-background-colours.css'/>
	<link rel='icon' href='/resources/favicon2.ico'/>
    </head>
    
    <body topmargin="0" leftmargin="0" bgproperties="fixed" bgcolor="#333333">
    <div class="wrapper">
    <div id="header" class="b-187">
    	<a href="/pages/browse/"><img src="/resources/images/ausstagehomebrand.gif" alt="default" border="0" id="headerLogo"/></a>
    </div>
    
    <div id="sidebarAdmin" class="sidebarAdmin b-186">
  
   
<%
CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
CmsObject cmsObject = cms.getCmsObject();
List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
List<String> groupNames = new ArrayList();
for(CmsGroup group:userGroups) {
   groupNames.add(group.getName());
}


// if (request.getRequestURI().indexOf("event_search") >=0) response.getOutputStream().print("curr "); -- to display "curr " in the list of classes 
if (groupNames.contains("Administrators") || groupNames.contains("Event Editor")) {
%><a class="family_links_current" href="/custom/event_search.jsp">Add, Edit or Copy Events</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Resource Editor")) {
%><a class="family_links_current" href="/custom/item_search.jsp">Add/Edit Resources</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Works Editor")) {
%><a class="family_links_current" href="/custom/work_search.jsp">Works Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Contributor Editor")) {
%><a class="family_links_current" href="/custom/contrib_search.jsp">Contributor Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Country Editor")) {
%><a class="family_links_current" href="/custom/country_admin.jsp">Country Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Contributor Function Editor")) {
%><a class="family_links_current" href="/custom/contrib_funct_search.jsp">Contributor Function Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("DataSource Editor")) {
%><a class="family_links_current" href="/custom/datasource_admin.jsp">DataSource Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Organisation Editor")) {
%><a class="family_links_current" href="/custom/organisation_search.jsp">Organisation Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Primary Genre Editor")) {
%><a class="family_links_current" href="/custom/primary_genre_list.jsp">Primary Genre Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Secondary Genre Editor")) {
%><a class="family_links_current" href="/custom/second_genre_search.jsp">Secondary Genre Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Content Indicator Editor")) {
%><a class="family_links_current" href="/custom/primary_content_ind_search.jsp">Subjects Maintenance</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Venue Editor")) {
%><a class="family_links_current" href="/custom/venue_search.jsp">Venue Maintenance</a><%
}

if (groupNames.contains("Administrators") || groupNames.contains("SQL Editor")) {
%><a class="family_links_current" href="/custom/ausstage_sql_interface.jsp">SQL Interface</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Record Count Editor")) {
%><a class="family_links_current" href="/custom/record_count.jsp">Record Count Report</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("Lookups Editor")) {
%><a class="family_links_current" href="/custom/lookuptype_search.jsp">Lookups</a><%
}
if (groupNames.contains("Administrators") || groupNames.contains("OpenCMS Editor")) {
%><a class="family_links_current" target="_blank" href="/system/login">OpenCMS Login</a><%
}


%>

    </div>
  </div>
	<div id="mainAdmin" class="mainAdmin b-172">
</cms:template>


<cms:template element="body">
	<cms:include element="body" editable="true"/>
</cms:template>


<cms:template element="foot">	
	
	
         <div id="footer">&nbsp; </div>
     </div>
     </div>
</body>
</html>

</cms:template>