<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<!DOCTYPE HTML
    PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<cms:template element="head">
  <html>
    <head>
    <title>AusStage</title> 
    <link rel='stylesheet' href='/resources/style-admin.css'/>
    <link rel='stylesheet' href='/pages/assets/ausstage-colours.css'/>
    <link rel='stylesheet' href='/pages/assets/ausstage-background-colours.css'/>
    <link rel='icon' href='/resources/favicon2.ico'/>
     </head>
    
    <body>
    <div class="wrapper">
    <div class="header-wrapper">
    	<div id="header" class="b-187">
    		<a href="/pages/browse/"><img src="/resources/images/ausstage-logo-admin.png" alt="default" border="0" class="header-logo"/></a>
    	
    	</div>
    	
    	  	
    	<div class="navigation">
  
		<div id="loginBar"></div>

		<ul class="navigation label">
		<li><a href="/pages/browse/">Browse</a></li>
		<li><a href="/pages/search/">Search</a></li>
		<li><a href="/pages/learn/">Learn</a></li>
		</ul>

	</div>
      </div>
	
	<div class="boxes b-172">
</cms:template>


<cms:template element="body">
	<cms:include element="body" editable="true"/>
</cms:template>


<cms:template element="foot">	

<div id="footer" class="footer">
 
	<div class="footer-left">
	<span class="label"><a href="/pages/browse/">AusStage</a> &bull; Researching Australian live performance</span>
	<br><span class="label small"><a href="/pages/learn/about/">About</a> | <a href="/pages/learn/contact/accessibility.html">Accessibility</a> | <a href="/pages/learn/contact/">Contact</a> | <a href="/pages/learn/contact/cultural-advice.html">Cultural Advice</a> | <a href="/pages/learn/help.html">Help</a> | <a href="/pages/learn/contact/privacy.html">Privacy</a> | <a href="/pages/learn/contact/terms-of-use.html">Terms of Use</a></span>
	</div>

	<div class="footer-right label small">
Copyright &copy; AusStage and contributors, 2003-2012.<br>Licensed under <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY-NC-SA 4.0</a>.
	</div>
	
         </div>
     </div>
</body>
</html>

</cms:template>
