﻿﻿<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />
<%@ include file="../../templates/MainMenu.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
<!-- AddThis Button END -->
    <tr bgcolor="#FFFFFF">
      <td width="10px" background='ausstagebgside.gif'>&nbsp;</td>
      <td>     
      <%  
      //test
  String search_within_search_for_form = request.getParameter("f_search_within_search");  
  String m_sql_switch                  = request.getParameter("f_sql_switch");
  String m_table_to_search_from        = request.getParameter("f_search_from");
  String m_sort_by                     = request.getParameter("f_sort_by");

  // set variables
  if(search_within_search_for_form == null){search_within_search_for_form = "";}
  if(m_sql_switch == null){m_sql_switch =  "";}
  if(m_table_to_search_from == null){m_table_to_search_from = "";}
  if(m_sort_by == null){m_sort_by = "";}

  ///////////////////////////////////
  //    DISPLAY SEARCH PAGE
  //////////////////////////////////

%>
  <form name="searchform" id="searchform" method="post" action ="/pages/search/results/" onsubmit="return checkFields();">  
<%
  if(!search_within_search_for_form.equals(""))
    out.println("<input type='hidden' name='f_search_within_search' value='"+ search_within_search_for_form + "'>");  
%>

<style>

.search_text
{
  font-family:Verdana;
  font-size:11px;
  color:#FFFFFF;
  font-weight:normal;
  text-decoration:none;
  font-style:normal;
}
.search_11text { font-family:Verdana; font-size:11px; color:#666666; font-weight:normal; text-decoration:none; font-style:normal; }

.fsearch {
	padding:0px;
	padding-left:0px;
	font-size: 10px;
	color: #000;
	border-left: 1px solid #5D9149;
	border-right: 1px solid #629047;
	border-bottom: 1px solid #648F48;
	border-top: 1px solid #639148;
}
a.help{
color : black;
}
</style>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="550">
  <tr>
    <td align="left" valign="top" bgcolor="#FFFFFF">
    <%
  if(!search_within_search_for_form.equals(""))
    out.println("<br><p style='font-family:verdana;color:#FFFFFF;font-size:11'>Note: You are now performing search within the previous result(s)</p>");
    %>        
        </font></b>
    </td>
  </tr>
  <tr>
        <td align="left">    
	  <table border="0" cellpadding="3" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
	    <tr>
	      <td>&nbsp;</td>
	    </tr>
	      <tr>
	      <td>&nbsp;</td>
	      <td>
		<input type="text" size="40" name='f_keyword' id='f_keyword'  <%if(request.getParameter("f_keyword") != null) { out.print("value=\"" + request.getParameter("f_keyword") + "\"");}%>>&nbsp;
	      </td>
	      <td>
		<select name="f_search_from" id='f_search_from' onchange='javascript:enableDisableSorts()'>
		  <option value="all">All Records</option>
		  <option value="event"        <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("event")) { out.print(" selected ");}%> >Events</option>
		  <option value="contributor"  <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("contributor")) { out.print(" selected 		");}%>>Contributors</option>
		  <option value="organisation" <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("organisation")) { out.print(" selected 		");}%>>Organisations</option>
	  	  <option value="venue"        <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("venue")) { out.print(" selected ");}%>>Venues</option>
		  <option value="resource"     <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("resource")) { out.print(" selected ");}%>>Resources</option>
	  	  <option value="work"         <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("work")) { out.print(" selected 		");}%>>Works</option>
		</select>
	      </td>
	      <td align="center"><input type="submit" value="Search"></td>
	    </tr>
	    <tr>
	      <td>&nbsp;</td>
	    </tr>
	    <tr>
	      <td>&nbsp;</td>
	      <td class="general_heading_white" align="right">Search words using &nbsp;</td>
	      <td>
		<select name="f_sql_switch" id ="f_sql_switch">
		  <option value="and"   <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("and")) { out.print(" selected ");}%> >And</option>
		  <option value="or"    <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("or")) { out.print(" selected ");}%> >Or</option>
		  <option value="exact" <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("exact")) { out.print(" selected ");}%> >Exact Phrase</option>
		</select>
	      </td>
	    </tr>
	    <tr>
	      <td>&nbsp;</td>
	      <td class="general_heading_white" align="right">Sort results by &nbsp;</td>
	      <td>
		<select name="f_sort_by" id="f_sort_by">
		  <option value="alphab_frwd" <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("alphab_frwd")) { out.print(" selected ");}%> >Name</option>
		  <option value="date"        <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("date"))        { out.print(" selected ");}%> >Date</option>
		  <option value="venue"       <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("venue"))       { out.print(" selected ");}%> >Venue</option>
		  <option value="state"       <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("state"))       { out.print(" selected ");}%> >State</option>
		</select>
	      </td>
	    </tr>
	    <tr>
	      <td>&nbsp;</td>
	      <td align="right" class="general_heading_white">Restrict by year &nbsp;</td>
	      <td class="general_heading_white" colspan="2">
		<input type="text" size="9" maxlength="9" name='f_year' id='f_year' <%if(request.getParameter("f_year") != null) { out.print("value=\"" + request.getParameter("f_year") + "\"");}%> >(1999, 1876-2006)
	      </td>
	    </tr>

	  </table>
	</td>
        <td align="left" valign="top" bgcolor="#FFFFFF"></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</form>
<cms:include property="template" element="foot" />
<script language="javascript">
    var temp = 1;
    var msg = "";
    var form = document.searchform;

    function checkFields(){
      msg = "";
      //all fields are empty
      if(form.f_keyword.value == ""){      
        alert("You have not entered the correct value(s) for keyword. Please press OK.");
        return (false);
      } 
      
      //check date 
      if(!validateDate(form.f_year)){
      	alert("Please enter a valid year");
      	return false;
      }
           
      //if (msg!=""){alert(msg);return (false);}
      
      return (ajaxFunction(form.f_search_from.value));
      
    }

    function ajaxFunction(search_from){
    //added by Brad - copied the same process used in other pages to show no results returned before navigating to another page.
    	var ajaxRequest;  // The variable that makes Ajax possible!
        var url;
    	try{
    		// Opera 8.0+, Firefox, Safari
    		ajaxRequest = new XMLHttpRequest();
    	} catch (e){
    		// Internet Explorer Browsers
    		try{
    			ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
    		} catch (e) {
    			try{
    				ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
    			} catch (e){
    				// Something went wrong, return true to go to the next page
    				return true;
    			}
    		}
    	}
    	//check the search_from value to determine which tables we need to check
    	switch (search_from){
    		case 'all' :		url = "results/all_ajax.jsp?";
    					break;
    				
    		case 'event' :  	url = "results/event_ajax.jsp?";
    					break;
    				
    		case 'contributor' : 	url = "results/contrib_ajax.jsp?";
    				     	break;
    		
    		case 'organisation' : 	url = "results/org_ajax.jsp?";
    				     	break;
    		
    		case 'venue' : 		url = "results/venue_ajax.jsp?";
    				     	break;
    				     	
    		case 'resource' : 	url = "results/resource_ajax.jsp?";
    				     	break;
    		
    		case 'work' : 		url = "results/work_ajax.jsp?";
    				     	break;	
    	}
    	
    	ajaxRequest.open("GET", url + "f_keyword="+form.f_keyword.value
    							+ "&f_search_from="+form.f_search_from.value
    							+ "&f_sql_switch="+form.f_sql_switch.value
    							+ "&f_sort_by="+form.f_sort_by.value
    							+ "&f_year="+form.f_year.value, false);
    	ajaxRequest.send(null);
    	
    	if (ajaxRequest.responseText == "0") {
    		alert("There were no results found for your search.");
    		return false;
    	} else {
    		return true;
    	}
    }

    
    function isBlank(s) {
        if((s == null)||(s == "")) 
         return true;
        for(var i=0;i<s.length;i++) {
         var c=s.charAt(i);
         if((c != ' ') && (c !='\n') && (c != '\t')) return false;
        }
        return true;
      }

     function isInteger(s){
       var i;
       var c;

         // Search through string's characters one by one
         // until we find a non-numeric character.
         // When we do, return false; if we don't, return true.
         for (i = 0; i < s.length; i++){   
             // Check that current character is number.
             c = s.charAt(i);
             if (!isDigit(c)) 
               return false;
         }
         // All characters are numbers.
         return true;
     }

     function isDigit (c){
       return ((c >= "0") && (c <= "9"))
     }
     
     //check date format - can be yyyy or yyyy-yyyy
     function validateDate(c_date){
    	 switch (c_date.value.length){
    	 	case 0: return true;
    	 		break;
    	 	case 4: if(!isInteger(c_date.value))
    	 			return false;
    	 		break;
    	 	case 9: var years = c_date.value.split("-");
    	 		if(years.length!=2) {
    	 			return false;
    	 		}else {
    	 			if(!isInteger(years[0])|| years[0].length !=4 || !isInteger(years[1]) || years[1].length !=4  ){
    	 				return false;}
    	 		}
    	 		break;
    	 	default: return false;
    	 		break;
    	 	}
    	 return true;
    }
     
  //-->
  </script>