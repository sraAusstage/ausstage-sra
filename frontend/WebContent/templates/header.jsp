<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%
String keywords = "";
 
if(request.getParameter("f_keyword") != null) { 
	keywords = request.getParameter("f_keyword");

} else if(request.getParameter("h_keyword") != null) { 
	keywords = request.getParameter("h_keyword");

}
// TODO: Fix this 
//String currentPage = menucms.getRequestContext().getUri();
String currentPage = "";
//String[] pageName = currentPage.split("pages/");
//currentPage = pageName[1];
boolean showSearch = true;

if (currentPage.contains("search/index.jsp") ||currentPage.contains("search/event/index.jsp")||currentPage.contains("search/resource/index.jsp")){
	showSearch = false;
}
%>
<html lang ="en">
    <head> 
	<title>AusStage</title>
	
	
	<link rel="stylesheet" href="${pageContext.request.contextPath}/pages/assets/jquery-ui/jquery-ui-1.8.6.custom.css"/>
	
	<link rel='stylesheet' href="${pageContext.request.contextPath}/resources/bootstrap-3.3.7/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap-toggle-master/css/bootstrap-toggle.min.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap-datepicker-1.6.4-dist/css/bootstrap-datepicker.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap-select-1.12.2/dist/css/bootstrap-select.min.css">
       <!-- <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400Roboto" rel="stylesheet"/>-->

	<!--[if lte IE 7]>
    	<link rel='stylesheet' href='/resources/style-frontend-ie.css'/>
	<![endif]-->
	<!--[if gte IE 8]>
    	<link rel='stylesheet' href='/resources/style-frontend.css'/>
	<![endif]-->
	<![if !IE]>
	<!-- this needs to be below bootstrap css to override some of the styles set in bootstrap -->
    	<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/style-frontend.css'/>	
 	<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/shared-style.css'/>	
    	<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/wysiwyg.css'/>	
	<![endif]>
	<link rel='stylesheet' href='${pageContext.request.contextPath}/pages/assets/ausstage-colours.css'/>
	<link rel='stylesheet' href='${pageContext.request.contextPath}/pages/assets/ausstage-background-colours.css'/>

	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/pages/assets/styles/bootstrap-override.css"/>
	
	
	<link rel='icon' href='${pageContext.request.contextPath}/resources/favicon2.ico'/>
	<%	
		if (!currentPage.contains("network/index.jsp") && 
		!currentPage.contains("exchange/index.jsp") && 
		!currentPage.contains("map/index.jsp") && 
		!currentPage.contains("analytics/index.jsp")) {
	%>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/bootstrap-3.3.7/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/pages/assets/javascript/libraries/jquery-ui-1.8.4.custom.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/bootstrap-toggle-master/js/bootstrap-toggle.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/jquery-show-hide-plugin/showHide.js"></script>
        <script src="${pageContext.request.contextPath}/resources/bootstrap-datepicker-1.6.4-dist/js/bootstrap-datepicker.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/bootstrap-select-1.12.2/dist/js/bootstrap-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/jQuery-Drag-drop-Sorting-Plugin-For-Bootstrap-html5sortable/jquery.sortable.min.js"></script>       
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
 	       <img src="${pageContext.request.contextPath}/resources/images/ausstage-logo.png" alt="default" border="0" class="header-logo"/>
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
      
      