<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import="org.opencms.jsp.*,com.opencms.file.*,java.util.*" %>
<%
CmsJspActionElement menucms = new CmsJspActionElement(pageContext, request, response);
String currentPage = menucms.getRequestContext().getUri();
String[] pageName = currentPage.split("pages/");
currentPage = pageName[1];

String menumapping = ",map/index.jsp";
String menusearch = ",search/index.jsp,search/results/index.jsp,search/event/index.jsp,search/event/results/index.jsp,search/resource/index.jsp,search/resource/results/index.jsp";
String menubrowse = ",browse/index.jsp,browse/contributors/index.jsp,browse/subjects/index.jsp,browse/functions/index.jsp,browse/events/index.jsp,browse/genres/index.jsp,browse/organisations/index.jsp,browse/venues/index.jsp,browse/works/index.jsp,browse/resources/index.jsp";
String menunetworks = ",network/index.jsp";
String menurecord = ",contributor/index.jsp,subject/index.jsp,function/index.jsp,event/index.jsp,genre/index.jsp,organisation/index.jsp,venue/index.jsp,work/index.jsp,resource/index.jsp,resourcetype/index.jsp";
String menuexchange = ",exchange/index.jsp";
String menumobile   = ",mobile/index.jsp,mobile/,mobile/send/index.jsp,mobile/view/index.jsp,mobile/view/list.jsp,mobile/view/tagcloud.jsp";
String menuanalytics = ",analytics/index.jsp";

String category = "";
if (menumapping.contains(","+currentPage)) category = "mapping";
if (menusearch.contains(","+currentPage)) category = "search";
if (menubrowse.contains(","+currentPage)) category = "browse";
if (menunetworks.contains(","+currentPage)) category = "networks";
if (menuexchange.contains(","+currentPage)) category = "exchange";
if (menurecord.contains(","+currentPage)) category = "record";
if (menumobile.contains(","+currentPage)) category = "mobile";
if (menuanalytics.contains(","+currentPage)) category = "analytics";

%>
<div id="topbar2" class="b-194">
  <a <%=category.equals("search")?"style=\"background-color:#333333;\" ":""%>href="/pages/search/" title="Search">Search</a>
  <a <%=category.equals("browse")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/contributors/" title="Browse">Browse</a>
  <a <%=category.equals("mapping")?"style=\"background-color:#333333;\" ":""%>href="/pages/map/" title="Mapping">Mapping</a>
  <a <%=category.equals("networks")?"style=\"background-color:#333333;\" ":""%>href="/pages/network/" title="Networks">Network</a>
  <a <%=category.equals("mobile")?"style=\"background-color:#333333;\" ":""%>href="/pages/mobile/" title="Mobile">Mobile</a>
  <a <%=category.equals("exchange")?"style=\"background-color:#333333;\" ":""%>href="/pages/exchange/" title="Exchange">Exchange</a>
  <a <%=category.equals("analytics")?"style=\"background-color:#333333;\" ":""%>href="/pages/analytics/index.jsp" title="Analytics">Analytics</a>
  <%=category.equals("record")?"<span style=\"background-color:#333333;\">Record</span>":""%>
</div>
<%
if (category.equals("mapping")) {
%>
<ul class="fix-ui-tabs">
  <li><a href="#tabs-3">Map</a></li> 
  <li><a href="#tabs-1">Build</a></li>
  <li><a href="#tabs-2">Regions</a></li>
   
</ul>
<%
} else if (category.equals("search")) {
%>
<div id="topbar" class="b-186">
  <a <%=(currentPage.startsWith("search/index.jsp") || currentPage.startsWith("search/results/"))?"style=\"background-color:#333333;\" ":""%>href="/pages/search/" title="Basic Search">Basic</a> 
  <a <%=currentPage.startsWith("search/event/")?"style=\"background-color:#333333;\" ":""%>href="/pages/search/event/" title="Event Search">Event</a> 
  <a <%=currentPage.startsWith("search/resource/")?"style=\"background-color:#333333;\" ":""%>href="/pages/search/resource/" title="Resource Search">Resource</a>
</div>   
<%
}else if (category.equals("browse")) {
%>
<div id="topbar" class="b-186">
  <a <%=currentPage.equals("browse/contributors/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/contributors/" title="Contributors">Contributors</a>
  <a <%=currentPage.equals("browse/events/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/events/" title="Events">Events</a>
  <a <%=currentPage.equals("browse/organisations/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/organisations/" title="Organisations">Organisations</a>
  <a <%=currentPage.equals("browse/venues/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/venues/" title="Venues">Venues</a>
  <a <%=currentPage.equals("browse/subjects/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/subjects/" title="Subjects">Subjects</a>
  <a <%=currentPage.equals("browse/functions/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/functions/" title="Functions">Functions</a>
  <a <%=currentPage.equals("browse/genres/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/genres/" title="Genres">Genres</a> 
  <a <%=currentPage.equals("browse/resources/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/resources/" title="Resources">Resources</a>
  <a <%=currentPage.equals("browse/works/index.jsp")?"style=\"background-color:#333333;\" ":""%>href="/pages/browse/works/" title="Works">Works</a>
</div>
<%
} else if (category.equals("networks")) {
%>
<ul class="fix-ui-tabs" id="fix-ui-tabs">
  <li><a href="#tabs-0">Search</a></li>
  <li><a href="#tabs-1">Network</a></li>				
</ul>
<%
} else if (category.equals("analytics")) {
%>
<div id="tabs-2" class="tab-content" style="border-width:0px;">
  <div id="analytics-tabs" style="border-width:0px;">
    <ul class="fix-ui-tabs">
      <li><a href="#analytics-1">Mapping Service</a></li>
      <li><a href="#analytics-2">Networks Service</a></li>
      <li><a href="#analytics-3">Mobile Service</a></li>
      <li><a href="#analytics-4">AusStage Website</a></li>
      <li><a href="#analytics-5">AusStage Database</a></li>
      <li><a href="#analytics-6">Data Exchange Service</a></li>
    </ul>
<%
}
%>