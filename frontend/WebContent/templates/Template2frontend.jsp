
<!DOCTYPE HTML >
<!-- TEMPLATE 2 FRONTEND START-->
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
%>


    
<cms:template element="head">
  <html lang ="en">
    <head> 
	<title>AusStage</title>
	
	
	<link rel="stylesheet" href="/pages/assets/jquery-ui/jquery-ui-1.8.6.custom.css"/>
	
	<link rel='stylesheet' href="/resources/bootstrap-3.3.7/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="/resources/bootstrap-toggle-master/css/bootstrap-toggle.min.css"> 
        <link rel="stylesheet" href="/resources/bootstrap-datepicker-1.6.4-dist/css/bootstrap-datepicker.min.css">
        <link rel="stylesheet" href="/resources/bootstrap-select-1.12.2/dist/css/bootstrap-select.min.css">
       <!-- <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400Roboto" rel="stylesheet"/>-->

	<!--[if lte IE 7]>
    	<link rel='stylesheet' href='/resources/style-frontend-ie.css'/>
	<![endif]-->
	<!--[if gte IE 8]>
    	<link rel='stylesheet' href='/resources/style-frontend.css'/>
	<![endif]-->
	<![if !IE]>
	<!-- this needs to be below bootstrap css to override some of the styles set in bootstrap -->
    	<link rel='stylesheet' href='/resources/style-frontend.css'/>	
 	<link rel='stylesheet' href='/resources/shared-style.css'/>	
    	<link rel='stylesheet' href='/resources/wysiwyg.css'/>	
	<![endif]>
	<link rel='stylesheet' href='/pages/assets/ausstage-colours.css'/>
	<link rel='stylesheet' href='/pages/assets/ausstage-background-colours.css'/>

	<link rel="stylesheet" type="text/css" href="/pages/assets/styles/bootstrap-override.css"/>
	
	
	<link rel='icon' href='/resources/favicon2.ico'/>
	<%	
		if (!currentPage.contains("network/index.jsp") && 
		!currentPage.contains("exchange/index.jsp") && 
		!currentPage.contains("map/index.jsp") && 
		!currentPage.contains("analytics/index.jsp")) {
	%>
	<script type="text/javascript" src="/resources/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="/resources/bootstrap-3.3.7/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-ui-1.8.4.custom.min.js"></script>
        <script src="/resources/bootstrap-toggle-master/js/bootstrap-toggle.min.js"></script>
        <script src="/resources/jquery-show-hide-plugin/showHide.js"></script>
        <script src="/resources/bootstrap-datepicker-1.6.4-dist/js/bootstrap-datepicker.min.js"></script>
        <script src="/resources/bootstrap-select-1.12.2/dist/js/bootstrap-select.min.js"></script>
        <script src="/resources/jQuery-Drag-drop-Sorting-Plugin-For-Bootstrap-html5sortable/jquery.sortable.min.js"></script>       
	<%
	}
	%>
		

   </head>   
<body >

<div class="wrapper">
    <div class="header-wrapper">	
	<div id="header" class="b-184" style="  display: flex;flex-wrap: nowrap; ">
	  <div style="width:141px;">	
		<a href="/pages/browse/">
 	       <img src="/resources/images/ausstage-logo.png" alt="default" border="0" class="header-logo"/>
	      </a>
	  </div>
	  <div  style="width:100%; display: flex; align-items: center;">
	  <div style="width:60%; display: flex; align-items: center; color: #7f7f7f;font-size: 23PX;font-family: sans-serif;">
	  <span>
	  The Australian Live Performance Database
	  </span>
	  </div>
	  
		<%if (showSearch){%>
	<div style="width :40%; display: flex;">
	<div class="header-search" >
		<form name="header-search-form" id="header-search-form" method="post" action="/pages/browse/">
			<input lang="en" id="header-search-keywords" type="text" style="width:141px; display:inline-flex;" value="<% out.print(keywords.replace("\"", "&quot;")); %>">
			<input class="hidden_fields" type="hidden" name="h_keyword" id="h_keyword" value="" />
		 	<input id="header-search-button" type="button" onclick="headerSearch();" value="Search">
		</form>
	
	</div> 
	</div>
	<%}%> 
	
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


/*function updateHeader(){
	$("#header-search-form #f_keyword").attr('value',$("#header-search-form #header-search-keywords").val());
	 console.log($("#header-search-form #f_keyword"));
	return true;
}*/




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
      
      
 
</cms:template>

<cms:template element="body">
	<cms:include element="body" editable="true"/>
</cms:template>

<cms:template element="foot">	
  	
<!--added class=footer for mapping-->
<div id="footer" class="footer">
 
<div class="footer-left">
<span class="footer-label"><a href="/pages/browse/">AusStage</a> &bull; Researching Australian live performance</span>
<br><span class="footer-label small"><a href="/pages/learn/about/">About</a> | <a href="/pages/learn/contact/accessibility.html">Accessibility</a> | <a href="/pages/learn/contact/">Contact</a> | <a href="/pages/learn/contact/cultural-advice.html">Cultural Advice</a> | <a href="/pages/learn/help.html">Help</a> | <a href="/pages/learn/contact/privacy.html">Privacy</a> | <a href="/pages/learn/contact/terms-of-use.html">Terms of Use</a></span>
</div>

<div class="footer-right label small">
Copyright &copy; AusStage and contributors, 2003<script type="text/javascript">var d=new Date();d=d.getFullYear();document.write("-"+d);</script>.<br>Licensed for use <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY-NC-SA 4.0</a>.
</div>

 
 </div>
 </div>
</body>
</html>
<script type="text/javascript">

function headerSearch (){
	console.log($("#header-search-keywords").val())	;
	$('#header-search-form #h_keyword').attr('value',$("#header-search-keywords").val());
	$('#header-search-form').submit();
}

$(document).ready(function() {

	$("#header-search-form").keypress(function(event) {
  		if ( event.which == 13 ) {
  			console.log("enter");
     			event.preventDefault(); headerSearch();
   		}
   		
   	});
   	
   	 //this is to handle chrome on mac render bug. see JIRA AUS-52
 	$(".scroll-table").scroll(function(){
		$("thead tr").hide().show(0);
		$("tfoot tr").hide().show(0);    
	});
				
});



</script>

<script type="text/javascript">

var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-10089663-1");
pageTracker._trackPageview();
} catch(err) {}</script>

<!-- TEMPLATE 2 FRONTEND END-->
</cms:template>