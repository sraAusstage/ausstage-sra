<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "ausstage.Database, java.sql.*, sun.jdbc.rowset.*, java.util.Date, ausstage.PrimaryGenre, ausstage.State"%>
<%@ page import = "ausstage.Status, ausstage.SecondaryGenre, ausstage.PrimaryContentInd, ausstage.AusstageCommon, ausstage.Country, ausstage.LookupCode"%>

<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%admin.AppConstants ausstage_search_appconstants_for_form = new admin.AppConstants(request);%>
<%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%>
<jsp:useBean id="admin_db_for_result" class="admin.Database" scope="application">
<%admin_db_for_result.connDatabase(ausstage_search_appconstants_for_result.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_result.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean>
<%@ include file="../../../public/common.jsp"%>

<cms:include property="template" element="head" />
<%
  ausstage.Database db_ausstage_for_result = new ausstage.Database ();
  db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt                        = db_ausstage_for_result.m_conn.createStatement ();
  CachedRowSet crset                    = null;
  State state                           = new State(db_ausstage_for_result);
  PrimaryGenre primGenre                = new PrimaryGenre(db_ausstage_for_result);
  SecondaryGenre secoGenre              = new SecondaryGenre(db_ausstage_for_result);
  PrimaryContentInd primContInd         = new PrimaryContentInd(db_ausstage_for_result);
  Country country                       = new Country(db_ausstage_for_result);
  LookupCode lookupCode                 = new LookupCode(db_ausstage_for_result);
  Status status                         = new Status(db_ausstage_for_result);

%>

<form class="search-form" name="advancedSearchForm" id="advancedSearchForm" Method = "POST" onsubmit="return checkFields();" action="results/" >
<style>


/* prevent a FOUC */
.js {display: none;}
.hideMe {display: none;}

</style>
<table class='search-form-table'>

  <tr>
    <th class='search-form-label b-90 bold'><img src='../../../resources/images/icon-event.png' class='box-icon' >Event Name</th>
    <td class='search-form-value'><input class='search-form-input-text' size='60' value='' type='text'  name="f_event_name" id="f_event_name"></td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>Event ID</th>
    <td class='search-form-value'><input class='search-form-input-number' type='text' size='10' value='' name="f_event_id" id="f_event_id"></td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>First Date</th>
    <td class='search-form-value'>
      <select name="f_betweenfrom_dd" id="f_betweenfrom_dd">
        <option value=''>Day</option>
	<option value='1'>1</option>
	<option value='2'>2</option>
	<option value='3'>3</option>
	<option value='4'>4</option>
	<option value='5'>5</option>
	<option value='6'>6</option>
	<option value='7'>7</option>
	<option value='8'>8</option>
	<option value='9'>9</option>
	<option value='10'>10</option>
	<option value='11'>11</option>
	<option value='12'>12</option>
	<option value='13'>13</option>
	<option value='14'>14</option>
	<option value='15'>15</option>
	<option value='16'>16</option>
	<option value='17'>17</option>
	<option value='18'>18</option>
	<option value='19'>19</option>
	<option value='20'>20</option>
	<option value='21'>21</option>
	<option value='22'>22</option>
	<option value='23'>23</option>
	<option value='24'>24</option>
	<option value='25'>25</option>
	<option value='26'>26</option>
	<option value='27'>27</option>
	<option value='28'>28</option>
	<option value='29'>29</option>
	<option value='30'>30</option>
	<option value='31'>31</option>
      </select>
      <select name="f_betweenfrom_mm" id="f_betweenfrom_mm">
	<option value=''>Month</option>
	<option value='1'>January</option>
	<option value='2'>February</option>
	<option value='3'>March</option>
	<option value='4'>April</option>
	<option value='5'>May</option>
	<option value='6'>June</option>
	<option value='7'>July</option>
	<option value='8'>August</option>
	<option value='9'>September</option>
	<option value='10'>October</option>
	<option value='11'>November</option>
	<option value='12'>December</option>
      </select>
      Year
      <input type='text' size='4' value='' name="f_betweenfrom_yyyy" id="f_betweenfrom_yyyy">&nbsp;(yyyy)
    </td>
  </tr>
 
  <tr>
   
  </tr>
  <tr>
    <th class='search-form-label b-90'>Venue Name</th>
    <td class='search-form-value'><input class='search-form-input-text' type='text' size='60' value='' name='f_venue_name' id='f_venue_name'>&nbsp;</td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>Venue ID</th>
    <td class='search-form-value'><input class='search-form-input-number' type='text' size='10' value='' name='f_venue_id' id='f_venue_id'>&nbsp;</td>
    <td></td>
  </tr>
  <tr>
   <th class='search-form-label b-90'>State</th>
    <td class='search-form-value'>
      <select name="f_states">
      <% 
  	crset = state.getStates(stmt); 
  	if(crset != null && crset.next())
  	{
  	  out.println("<option value=\"\">State</option>");
    	  do
    	  {
     	    out.println("<option value='" + crset.getString("state") + "'>" + crset.getString("state") + "</option>");
    	  }
    	  while(crset.next());
  	}
 	else
	out.println("<option>No States</option>");
      %>
      </select>
    </td>
   
  </tr>
  <tr>
    <th class='search-form-label b-90'>Country</th>
    	<td class='search-form-value'>
    		<select name="f_countries">
    		<%
	  	  crset = country.getVenueCountries(stmt, "Australia");
 	  	if(crset != null && crset.next()) 
	 	  {
    		    out.println("<option value=\"\">Country</option>");
	    	    do
	    	    {
	      	      out.println("<option value='" + crset.getString("countryid") + "'>" + crset.getString("countryname") + "</option>");
	    	    }while(crset.next());
	  	  }
	  	  else
	    	  out.println("<option>No Countries</option>");
		%>
	        </select>
	</td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>Umbrella</th>
    <td class='search-form-value'><input class='search-form-input-text' type=text name='f_umbrella' id='f_umbrella' size='60'></td>
  </tr>
  <tr>
    
  </tr>
  <tr>
    <th class='search-form-label b-90'>Status</th>
    <td class='search-form-value'>
      <select name="f_status" Size=1 onChange="" >
        <%
	  crset = status.getStatuses (stmt);
	  if(crset != null && crset.next())
	  { 
	    out.println("<option value=\"\">Status</option>");
	    do
	    {
	      out.println("<option value='" + crset.getString("STATUSID") + "'>" + crset.getString("status") + "</option>");
   	    }while(crset.next());
  	  }
  	  else
    	  out.println("<option>No Statuses</option>");
	%>
      </select>
    </td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>Primary Genre</th>
    <td class='search-form-value'>
      <select name="f_primary_genre" Size=1 onChange="">
	<% 
	  crset = primGenre.getNames(); 
	  if(crset != null && crset.next())
	  {
	    out.println("<option value=\"\">Primary Genre</option>");
	    do
	    {
	      out.println("<option value='" + crset.getString("genreclass") + "'>" + crset.getString("genreclass") + "</option>");
   	    }while(crset.next());
  	  }
 	  else
   	  out.println("<option>No Primary Genre</option>");
        %>
      </select>
    </td>
  </tr>
  
  <tr>
    <th class='search-form-label b-90'>Secondary Genre</th>
    <td class='search-form-value'>
      <select name="f_secondary_genre" id="f_secondary_genre" Size=10 onChange="" multiple>
	<%
  	  crset = secoGenre.getNames(); 
  	  if(crset != null && crset.next())
  	  {    
  		  //out.println("<option value=\"\"></option>");
    	  do
    	  {
      	    out.println("<option value=\"" + crset.getString("genreclass") + "\">" + crset.getString("genreclass") + "</option>");
	      }while(crset.next());
  	  }
  	  else
    	out.println("<option>No Secondary Genre</option>");
  	%>
      </select>
    </td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>Subjects</th>
    <td class='search-form-value'><input class='search-form-input-text' type=text name='f_prim_cont_indi' id='f_prim_cont_indi' size='60'></td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>Origin of Text</th>
    <td class='search-form-value'>
      <select name="f_origin_of_text" Size='1' onChange="">
	<% 
  	  crset = country.getOriginOfTextCountries(stmt, "Australia");
  	  if(crset != null && crset.next())
  	  {
   	    out.println("<option value=\"\">Origin of Text</option>");
  	    do
  	    {
      	      out.println("<option value='" + crset.getString("countryid") + "'>" + crset.getString("countryname") + "</option>");
   	    }
   	    while(crset.next());
 	  }
	  else
	  out.println("<option>No Countries</option>");
        %>
      </select>
    </td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>Origin of Production</th>
    <td class='search-form-value'>
      <select name="f_origin_of_production" id="f_origin_of_production" Size='1' onChange="">
	<%
  	  crset = country.getOriginOfProductionCountries(stmt, "Australia");
 	  if(crset != null && crset.next()) 
 	  {
    	    out.println("<option value=\"\">Origin of Production</option>");
    	    do
    	    {
      	      out.println("<option value='" + crset.getString("countryid") + "'>" + crset.getString("countryname") + "</option>");
    	    }while(crset.next());
  	  }
  	  else
    	  out.println("<option>No Countries</option>");
	%>
      </select>
    </td>
  </tr>

  <tr>
   <th class='search-form-label b-90'>Organisation Name</th>
    <td class='search-form-value'><input class='search-form-input-text' type=text name='f_organisation_name' id='f_organisation_name' size='60'></td>
  </tr>

  <tr>
    <th class='search-form-label b-90'>Organisation Function</th>
    <td class='search-form-value'><input class='search-form-input-text' type=text name='f_organisation_function' id='f_organisation_function' size='60'></td>
  </tr>

  <tr>
    <th class='search-form-label b-90'>Organisation ID</th>
    <td class='search-form-value'><input class='search-form-input-text' type=text name='f_organisation_id' id='f_organisation_id' size='10'></td>
  </tr>
  <tr>
    <th class='search-form-label b-90'>Contributor Name</th>
    <td class='search-form-value'><input class='search-form-input-text' type=text name='f_contributor_name' id='f_contributor_name' size='60'></td>
  </tr>

  <tr>
    <th class='search-form-label b-90'>Contributor Function</th>
    <td class='search-form-value'><input class='search-form-input-text' type=text name='f_contributor_function' id='f_contributor_function' size='60'></td>
  </tr>

  <tr>
    <th class='search-form-label b-90'>Contributor ID</th>
    <td class='search-form-value'><input class='search-form-input-number' type=text name='f_contributor_id' id='f_contributor_id' size='10'></td>
  </tr>

  <tr>
    <th class='search-form-label b-90'>Display</th>
    <td class='search-form-value'>
      <select name='f_assoc_item' id='f_assoc_item'>      
        <option value='all'>All Events</option>
        <option value='resources'>Events with Resources</option>
        <option value='online resources'>Events with Online Resources</option>
      </select>
    </td>

    
  </tr>
  <tr>
  
    <th class='search-form-label b-90'>Number of results per page</th>
    <td class='search-form-value'>
      <select name='f_limit_by'>
        <option value='100'>100</option>
        <option value='75'>75</option>
        <option value='50'>50</option>
	<option value='20'>20</option>
      </select>

    </td>
    
  </tr>
  
  <tr>
    <th class='search-form-label b-90'>Sort results by</th>
    <td class='search-form-value'>
      <select name='f_order_by'>
	<option value='event_name'>Title</option>
	<option value='first_date'>Date</option>
	<option value='venue_name'>Venue</option>
	<option value='state'>State</option>
      </select>
    </td>
  </tr>
  
  <tr><th class='search-form-label b-90'></th><td class='search-form-value'><input type='submit' value='Search'><a class="helpIcon" target='_blank' href="/pages/static/help.html"></a></td></tr>
  

  
</table>
</form>
 
<% stmt.close(); %>
<script language="javascript">

var temp = 1;
var msg = "";
var form = document.advancedSearchForm;

function checkFields(){

  //all fields are empty
  if(form.f_event_id.value == "" && form.f_event_name.value == "" && form.f_betweenfrom_dd.value == ""
      && form.f_betweenfrom_mm.value == "" && form.f_betweenfrom_yyyy.value == "" 
      && form.f_venue_id.value == "" && form.f_venue_name.value == "" 
      && form.f_states.options[form.f_states.selectedIndex].value == "" 
      && form.f_countries.options[form.f_countries.selectedIndex].value == "" 
      && form.f_umbrella.value == ""
      && form.f_primary_genre.options[form.f_primary_genre.selectedIndex].value == ""
      && form.f_status.options[form.f_status.selectedIndex].value == ""
      && form.f_secondary_genre.selectedIndex ==-1
      && form.f_prim_cont_indi.value == ""
      && form.f_origin_of_text.options[form.f_origin_of_text.selectedIndex].value ==""
      && form.f_origin_of_production.options[form.f_origin_of_production.selectedIndex].value ==""
      && form.f_organisation_id.value == "" && form.f_organisation_name.value == "" && form.f_organisation_function.value == ""
      && form.f_contributor_id.value == "" && form.f_contributor_name.value == "" && form.f_contributor_function.value == ""){

    alert("At least one search field is required. Please press ok.");
    
    return (false);
  }
  //the user does not have to enter a date as long as they enter a full date or
  //just the month and year or just the year.
  msg = "";
  
  // check dates
  // FROM DATE
  // Check First Date
  if(document.advancedSearchForm.f_betweenfrom_dd.value != ""){
    // must have mm & yyyy as well
    if(document.advancedSearchForm.f_betweenfrom_mm.value == "" || document.advancedSearchForm.f_betweenfrom_yyyy.value == "")
      msg += "- First Date on - MM and YYYY are required as well\n";
  }
  else if(document.advancedSearchForm.f_betweenfrom_mm.value != ""){
     // must have yyyy as well
     if(document.advancedSearchForm.f_betweenfrom_yyyy.value == "")
       msg += "- First Date on - YYYY is required as well\n";
  }


  // Check for Integers
  if (!isBlank(form.f_event_id.value) && !isInteger(form.f_event_id.value)) {
    msg += "- Event Id must be a number\n";
  }
  if ((!isBlank(form.f_betweenfrom_yyyy.value) && !isInteger(form.f_betweenfrom_yyyy.value)) ||
     (!isBlank(form.f_betweenfrom_yyyy.value) && form.f_betweenfrom_yyyy.value.length != 4) ){
    msg += "- First date year must be a valid\n";
  }

  if (!isBlank(form.f_venue_id.value) && !isInteger(form.f_venue_id.value)) {
    msg += "- Venue Id must be a number\n";
  }
  if (!isBlank(form.f_organisation_id.value) && !isInteger(form.f_organisation_id.value)) {
    msg += "- Organisation Id must be a number\n";
  }
  if (!isBlank(form.f_contributor_id.value) && !isInteger(form.f_contributor_id.value)) {
    msg += "- Contributor Id must be a number\n";
  }
  
  if(msg != ""){
    alert("You have not entered the correct value(s) for\n" + msg + "Please press OK.");
    return(false);
  }
  else{
	  //System.out.println("Ajax check");
    return(ajaxFunction());
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

function isInteger (s){
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

function isDigit(c){
    return ((c >= "0") && (c <= "9"))
  }

function ajaxFunction(){

	var ajaxRequest;  // The variable that makes Ajax possible!
	
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
	// Create a function that will receive data sent from the server
	ajaxRequest.open("GET", "results/ajax.jsp?f_event_name=" + document.advancedSearchForm.f_event_name.value
				+ "&f_event_id=" + document.advancedSearchForm.f_event_id.value
				+ "&f_betweenfrom_dd=" + document.advancedSearchForm.f_betweenfrom_dd.value
				+ "&f_betweenfrom_mm=" + document.advancedSearchForm.f_betweenfrom_mm.value
				+ "&f_betweenfrom_yyyy=" + document.advancedSearchForm.f_betweenfrom_yyyy.value
				+ "&f_venue_name=" + document.advancedSearchForm.f_venue_name.value
				+ "&f_venue_id=" + document.advancedSearchForm.f_venue_id.value
				+ "&f_states=" + document.advancedSearchForm.f_states.value
				+ "&f_countries=" + document.advancedSearchForm.f_countries.value
				+ "&f_umbrella=" + document.advancedSearchForm.f_umbrella.value
				+ "&f_status=" + document.advancedSearchForm.f_status.value
				+ "&f_primary_genre=" + document.advancedSearchForm.f_primary_genre.value
				+ "&f_prim_cont_indi=" + document.advancedSearchForm.f_prim_cont_indi.value
				+ "&f_origin_of_text=" + document.advancedSearchForm.f_origin_of_text.value
				+ "&f_origin_of_production=" + document.advancedSearchForm.f_origin_of_production.value
				+ "&f_organisation_name=" + document.advancedSearchForm.f_organisation_name.value
				+ "&f_organisation_function=" + document.advancedSearchForm.f_organisation_function.value
				+ "&f_organisation_id=" + document.advancedSearchForm.f_organisation_id.value
				+ "&f_contributor_name=" + document.advancedSearchForm.f_contributor_name.value
				+ "&f_contributor_function=" + document.advancedSearchForm.f_contributor_function.value
				+ "&f_contributor_id=" + document.advancedSearchForm.f_contributor_id.value
				+ "&f_assoc_item=" + document.advancedSearchForm.f_assoc_item.value
				+ "&f_limit_by=" + document.advancedSearchForm.f_limit_by.value
				+ "&f_order_by=" + document.advancedSearchForm.f_order_by.value
				+ "&f_secondary_genre=" +$("#f_secondary_genre").val().join("&f_secondary_genre=") , false); 
	ajaxRequest.send(null); 

	if (ajaxRequest.responseText == "0") {
		alert("There were no results found for your search.");
		return false;
	} else {
		return true;
	}

}
</script>

<cms:include property="template" element="foot" />