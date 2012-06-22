<!DOCTYPE HTML
    PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import="org.opencms.jsp.*,com.opencms.file.*,java.util.*" %>
<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-1.6.1.min.js"></script>
<%
CmsJspActionElement menucms = new CmsJspActionElement(pageContext, request, response);
String currentPage = menucms.getRequestContext().getUri();
String[] pageName = currentPage.split("pages/");
currentPage = pageName[1];
boolean showSearch = true;
	
if (currentPage.contains("search/index.jsp") ||currentPage.contains("search/event/index.jsp")||currentPage.contains("search/resource/index.jsp")){
	showSearch = false;
}

%>


    
<cms:template element="head">
  <html>
    <head> 
	<title>AusStage</title>
	<link rel='stylesheet' href='/resources/style-frontend.css'/>
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

		<form name="header-search-form" id="header-search-form" method="post" action="/pages/browse/" onSubmit="return updateHeader();"> 

			<input id="header-search-keywords" type="text" class="" style="width: 140px;" value=<%if(request.getParameter("f_keyword") != null) { out.print(request.getParameter("f_keyword"));}%>>
			<input class="hidden_fields" type="hidden" name="f_keyword" id="f_keyword" value="" />
		 	<input class="" type="submit" value="Search">

		</form>

	</div> 
	<%}%> 
   
</div>
      
<div class="navigation">

<ul class="navigation label">

<li><a href="/pages/browse/">Browse</a></li>
<li><a href="/pages/search/">Search</a></li>
<li><a href="/pages/learn/index.html">Learn</a></li>
</ul>

<div id="loginBar">  
    
 <% if (session.getAttribute("loginOK") == null || session.getAttribute("loginOK").equals("false")) {%>
        <form id="aform">
<select id="mymenu" size="1">
<option value="nothing" selected="selected">Login</option>
<option value="/admin/shibboleth/validateLogin.jsp">AAF credentials</option>
<option value="/admin/login.jsp">AusStage Login</option>
</select>
</form>
<%
} else {
%>     
<a href="/custom/welcome.jsp" style="padding:2px 10px 2px 0px;"><%=session.getAttribute("fullUserName")%></a>

<% } %>
<script type="text/javascript">
function updateHeader(){
	$("#header-search-form #f_keyword").attr('value',$("#header-search-form #header-search-keywords").val());
	console.log($("#header-search-form #f_keyword"));
	return true;
}


var selectmenu=document.getElementById("mymenu")
selectmenu.onchange=function(){ //run some code when "onchange" event fires
 var chosenoption=this.options[this.selectedIndex] //this refers to "selectmenu"
 if (chosenoption.value!="nothing"){
  window.open(chosenoption.value, "", "") //open target site (based on option's value attr) in new window
 }
}
  </script>    
    
    </div>

</div>      
      
      
 
</cms:template>

<cms:template element="body">
	<cms:include element="body" editable="true"/>
</cms:template>

<cms:template element="foot">	
  	

 <div id="footer">
 
 <div class="footer-left">
<span class="label"><a href="">AusStage</a> &bull; Researching Australian live performance</span>
<br><span class="label small"><a href="">About</a> | <a href="">Contact</a> | <a href="">Accessibility</a> | <a href="">Cultural Advice</a> | <a href="">Privacy</a> | <a href="">Terms of Use</a> | <a href="">User License</a></span>
</div>

<div class="footer-right label small">
Copyright &copy; AusStage and contributors, 2003-2012.<br>Licensed under Creative Commons <a href="http://creativecommons.org/licenses/by-nc-sa/3.0/au/">CC BY-NC-SA 3.0 Aus</a>.
</div>

 
 </div>
 </div>
</body>
</html>

</cms:template>