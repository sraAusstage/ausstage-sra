<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />


    
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

<div class="boxes">

<span class="box b-175">
<img src="../../resources/images/icon-blank.png" class="box-icon"> 
<span class="box-label">Basic Search</span> 
</span>

<form class="search-basic-box" name="searchform" id="searchform" method="post" action ="/pages/search/results/index.jsp" onsubmit="return checkFields();">  
<%
  if(!search_within_search_for_form.equals(""))
    out.println("<input type='hidden' name='f_search_within_search' value='"+ search_within_search_for_form + "'>");  
%>

<table>
  <tr>
    <td>
    <%
  if(!search_within_search_for_form.equals(""))
    out.println("<br><p class='light'>Note: You are now performing search within the previous result(s)</p>");
    %>        
       
    </td>
  </tr>
 
  <tr>
        <td align="left">    

	    <tr>
	      <td>
		<input type="text" size="40" name='f_keyword' id='f_keyword'  <%if(request.getParameter("f_keyword") != null) { out.print("value=\"" + request.getParameter("f_keyword") + "\"");}%>>
	      </td>
	      <td>
		<select name="f_search_from" id='f_search_from' onchange='javascript:enableDisableSorts()'>
		  <!--<option value="all">All Records</option>-->
		  <option value="event"        <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("event")) { out.print(" selected ");}%>>Events</option>
		  <option value="contributor"  <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("contributor")) { out.print(" selected 		");}%>>Contributors</option>
		  <option value="organisation" <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("organisation")) { out.print(" selected 		");}%>>Organisations</option>
	  	  <option value="venue"        <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("venue")) { out.print(" selected ");}%>>Venues</option>
		  <option value="resource"     <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("resource")) { out.print(" selected ");}%>>Resources</option>
	  	  <option value="work"         <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("work")) { out.print(" selected 		");}%>>Works</option>
	  	</select>
	      </td>
	      <td><input type="submit" value="Search"></td>
	    </tr>
	<tr><td>&nbsp;</td></tr>
	      <td class="light" align="right">Search words using </td>
	      <td>
		<select name="f_sql_switch" id ="f_sql_switch">
		  <option value="and"   <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("and")) { out.print(" selected ");}%> >And</option>
		  <option value="or"    <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("or")) { out.print(" selected ");}%> >Or</option>
		  <option value="exact" <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("exact")) { out.print(" selected ");}%> >Exact Phrase</option>
		</select>
	      </td>
	    </tr>
	    <tr>
	      <td class="light" align="right">Sort results by </td>
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

	      <td align="right" class="light">Restrict by year </td>
	      <td class="light" colspan="2">
		<input type="text" size="9" maxlength="9" name='f_year' id='f_year' <%if(request.getParameter("f_year") != null) { out.print("value=\"" + request.getParameter("f_year") + "\"");}%> > yyyy | yyyy-yyyy 
	      </td>
</tr>
</table>
</form>


<br>
<span class="box b-90" onclick="location.href='event/';" style="cursor:pointer;" onmouseover="this.className='box b-91';" onmouseout="this.className='box b-90 ';">
<img src="../../resources/images/icon-event.png" class="box-icon"> 
<span class="box-label"><a href="event/">Event Search</a> </span> </span>
<br>
<span class="box b-153" onclick="location.href='resource/';" style="cursor:pointer; margin-top:0.3em;" onmouseover="this.className='box b-154';" onmouseout="this.className='box b-153 ';">
<img src="../../resources/images/icon-resource.png" class="box-icon"> 
<span class="box-label"><a href="resource/">Resource Search</a> </span> </span>

</div>

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