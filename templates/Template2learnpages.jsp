<!DOCTYPE HTML >
<!-- PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" -->
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import="org.opencms.jsp.*,com.opencms.file.*,java.util.*" %>
<%
CmsJspActionElement menucms = new CmsJspActionElement(pageContext, request, response);
String keywords = "";

if(request.getParameter("f_keyword") != null) { 
	keywords = request.getParameter("f_keyword");
} else if(request.getParameter("h_keyword") != null) { 
	keywords = request.getParameter("h_keyword");
}

String currentPage = menucms.getRequestContext().getUri();
String[] pageName = currentPage.split("pages/");
currentPage = pageName[1];
boolean showSearch = true;

if (currentPage.contains("search/index.jsp") ||currentPage.contains("search/event/index.jsp")||currentPage.contains("search/resource/index.jsp")){
	showSearch = false;
}

if (!currentPage.contains("network/index.jsp") && 
	!currentPage.contains("exchange/index.jsp") && 
	!currentPage.contains("map/index.jsp") && 
	!currentPage.contains("analytics/index.jsp")) {
%>
<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-1.6.1.min.js"></script>
<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-ui-1.8.4.custom.min.js"></script>
<%
}
%>


    
<cms:template element="head">
  <html>
    <head> 
	<title>AusStage</title>
	
	<!--[if lte IE 7]>
    	<link rel='stylesheet' href='/resources/style-frontend-ie.css'/>
	<![endif]-->
	<!--[if gte IE 8]>
    	<link rel='stylesheet' href='/resources/style-frontend.css'/>
	<![endif]-->
	<![if !IE]>
    	<link rel='stylesheet' href='/resources/style-frontend.css'/>	
	<![endif]>
	<link rel="stylesheet" href="/pages/assets/jquery-ui/jquery-ui-1.8.6.custom.css"/>
	<link rel='stylesheet' href='/pages/assets/ausstage-colours.css'/>
	<link rel='stylesheet' href='/pages/assets/ausstage-background-colours.css'/>
	<link rel='icon' href='/resources/favicon2.ico'/>
   </head>
    
<body>

  <div class="wrapper">

    <div id="header" class="b-184">

      <a href="/pages/browse/">
        <img src="/resources/images/ausstage-logo.png" alt="default" border="0" class="header-logo"/>
      </a>
	<%if (showSearch){%>
	<div class="header-search">

		<form name="header-search-form" id="header-search-form" method="post" action="/pages/browse/"><!-- onSubmit="return updateHeader();"> -->

			<input id="header-search-keywords" type="text" class="" style="width: 140px;" value=<% out.print("\""+keywords+"\""); %>>
			<input class="hidden_fields" type="hidden" name="h_keyword" id="h_keyword" value="" />
		 	
		 	<input id="header-search-button" type="button" onclick="headerSearch();" value="Search">

		</form>

	</div> 
	<%}%> 
   
</div>
      
<div class="navigation">



<div id="loginBar">  
    
 <% if (session.getAttribute("loginOK") == null || session.getAttribute("loginOK").equals("false")) {%>
        <form id="aform">
<select id="mymenu" size="1">
<option value="nothing" selected="selected">Login</option>
<option value="/admin/shibboleth/validateLogin.jsp">AAF Login</option>
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
</ul>
</div>

<div id="sidebar" class="page-menu b-175">
	<ul class="page-menu-list">
		<% 
		CmsJspActionElement cms = new CmsJspActionElement(pageContext, request, response);
		%>
		<%@ include file="DynamicMenu.jsp"%>
	</ul>
</div>
<div class="staticpage">
</cms:template>

<cms:template element="body">
	<cms:include element="body" editable="true"/>
</cms:template>

<cms:template element="foot">	
</div>
<!--added class=footer for mapping-->
<div id="footer" class="footer"> 

<div class="footer-left">
<span class="label"><a href="/pages/browse/">AusStage</a> &bull; Researching Australian live performance</span>
<br><span class="label small"><a href="/pages/learn/about/">About</a> | <a href="/pages/learn/contact/accessibility.html">Accessibility</a> | <a href="/pages/learn/contact/">Contact</a> | <a href="/pages/learn/contact/cultural-advice.html">Cultural Advice</a> | <a href="/pages/learn/help.html">Help</a> | <a href="/pages/learn/contact/privacy.html">Privacy</a> | <a href="/pages/learn/contact/terms-of-use.html">Terms of Use</a></span>
</div>

<div class="footer-right label small">
Copyright &copy; AusStage and contributors, 2003<script type="text/javascript">var d=new Date();d=d.getFullYear();document.write("-"+d);</script>.<br>Licensed for use <a href="http://creativecommons.org/licenses/by-nc-sa/3.0/au/">CC BY-NC-SA 3.0 Aus</a>.
</div>
 
 </div>
 </div>
</body>
</html>
<script type="text/javascript">

function headerSearch (){

	$('#header-search-form #h_keyword').attr('value',$("#header-search-keywords").val());
	$('#header-search-form').submit();
}

$(document).ready(function() {

	$("#header-search-form").keypress(function(event) {
	console.log('keypress');
  		if ( event.which == 13 ) {
  		console.log('enter');
     			event.preventDefault(); headerSearch();
   		}
   	});				
});

</script>
</cms:template>