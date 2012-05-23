<%@ page pageEncoding="UTF-8" %><%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ page import = "java.sql.*, admin.Common, java.util.*, ausstage.State, ausstage.Database"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ include file="../public/common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<cms:include property="template" element="head" />

<table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
  <tr bgcolor="#FFFFFF">
    <td>
      <%admin.AppConstants ausstage_search_appconstants_for_form = new admin.AppConstants(request);%>
      <form name="searchform" id="searchform" method="post" action ="<%= AusstageCommon.queries_search_result_page%>" onsubmit="return checkFileds();">

	<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="550">
  	  <tr>
    	    <td align="left" valign="top" bgcolor="#FFFFFF">
    	        
    	      <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
      	        <tr>
        	  <td rowspan="2" align="left" valign="top"><img border="0" src="../resources/images/spacer.gif" width="20" height="20"></td>
        	  <td align="left"  valign='top'  colspan="2">Select Login  </td>
        	  <td class='general_heading_white' valign='centre'  >
        	      
        	    
  			
  			<form id="aform">
<select id="mymenu" size="1">
<option value="nothing" selected="selected"> Please select a login</option>
<option value="../admin/shibboleth/validateLogin.jsp">AAF credentials</option>
<option value="../admin/content_login.jsp">Ausstage Login</option>

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
        	      
        	      
        	   
        	        
        	</td>
      	      </tr>
            </table>
    		
    	  </td>
	</tr>
      </table>
	  
    </td>
  </tr>
</table>

<cms:include property="template" element="foot" />