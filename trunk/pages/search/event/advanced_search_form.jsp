<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "ausstage.Database, java.sql.*, sun.jdbc.rowset.*, java.util.Date, ausstage.PrimaryGenre, ausstage.State"%>
<%@ page import = "ausstage.Status, ausstage.SecondaryGenre, ausstage.PrimaryContentInd, ausstage.AusstageCommon, ausstage.Country, ausstage.LookupCode"%>
 
<%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%>
<jsp:useBean id="admin_db_for_result" class="admin.Database" scope="application">
<%admin_db_for_result.connDatabase(ausstage_search_appconstants_for_result.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_result.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean>

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

<form name="advancedSearchForm" id="advancedSearchForm" Method = "POST" onsubmit="return checkFields();" action="results/" >
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

.fsearchselect {
	padding:0px;
	padding-left:0px;
	font-size: 10px;
	color: #000;
	border-left: 1px solid #5D9149;
	border-right: 1px solid #629047;
	border-bottom: 1px solid #648F48;
	border-top: 1px solid #639148;
  width:182px;
}
.fsearchsmall {
	padding:0px;
	padding-left:0px;
	font-size: 10px;
	color: #000;
	border-left: 1px solid #5D9149;
	border-right: 1px solid #629047;
	border-bottom: 1px solid #648F48;
	border-top: 1px solid #639148;
  width:50px;
}
.fsearchlarge {
	padding:0px;
	padding-left:0px;
	font-size: 10px;
	color: #000;
	border-left: 1px solid #5D9149;
	border-right: 1px solid #629047;
	border-bottom: 1px solid #648F48;
	border-top: 1px solid #639148;
  width:182px;
}
a.help{
color : black;
}

/* Styles for the help icons */
.helpIcon {
        /* based on jQueryUi icons */
        width: 13px; 
        height: 16px; 
        display: inline-block; 
        /* blue icons */
        background-image: url(/pages/assets/jquery-ui/images/ui-icons_2e83ff_256x240.png);
        /* ui icon help */
        background-position: -48px -144px;
}

/* prevent a FOUC */
.js {display: none;}
.hideMe {display: none;}

</style>
<table border='0' cellpadding='3' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111'>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Event Name</td>
    <td><input type='text' size='60' value='' name="f_event_name" id="f_event_name">&nbsp;</td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Event ID</td>
    <td><input type='text' size='10' value='' name="f_event_id" id="f_event_id">&nbsp;</td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>First Date</td>
    <td class='general_heading_white'>
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
    <td align='right' class='general_heading_white'>Last Date</td>
    <td class='general_heading_white'>
      <select name='f_betweento_dd' id='f_betweento_dd'>
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
      <select name='f_betweento_mm' id='f_betweento_mm'>
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
      <input type='text' size='4' value='' name='f_betweento_yyyy' id='f_betweento_yyyy'>&nbsp;(yyyy)
    </td>
  </tr>
  <tr>
   <td>&nbsp;</td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Venue Name</td>
    <td><input type='text' size='60' value='' name='f_venue_name' id='f_venue_name'>&nbsp;</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Venue ID</td>
    <td><input type='text' size='10' value='' name='f_venue_id' id='f_venue_id'>&nbsp;</td>
    <td></td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>State</td>
    <td>
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
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Umbrella</td>
    <td><input type=text name='f_umbrella' id='f_umbrella' size='60'></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white' >Status</td>
    <td>
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
    <td align='right' class='general_heading_white'>Primary Genre</td>
    <td>
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
    <td align='right' class='general_heading_white' >Secondary Genre</td>
    <td>
      <select name="f_secondary_genre" Size=10 onChange="" multiple>
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
    <td align='right' class='general_heading_white'>Subjects</td>
    <td><input type=text name='f_prim_cont_indi' id='f_prim_cont_indi' size='60'></td>
  </tr>
  <tr>
    <td colspan='2'>&nbsp;</td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Origin of Text</td>
    <td>
      <select name="f_origin_of_text" Size='1' onChange="">
	<% 
  	  crset = country.getCountries(stmt);
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
    <td align='right' class='general_heading_white'>Origin of Production</td>
    <td>
      <select name="f_origin_of_production" id="f_origin_of_production" Size='1' onChange="">
	<%
  	  crset = country.getCountries(stmt);
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
    <td colspan='2'>&nbsp;</td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Organisation Name</td>
    <td><input type=text name='f_organisation_name' id='f_organisation_name' size='60'></td>
  </tr>

  <tr>
    <td align='right' class='general_heading_white'>Organisation Function</td>
    <td><input type=text name='f_organisation_function' id='f_organisation_function' size='60'></td>
  </tr>

  <tr>
    <td align='right' class='general_heading_white'>Organisation ID</td>
    <td><input type=text name='f_organisation_id' id='f_organisation_id' size='10'></td>
  </tr>

  <tr>
    <td colspan='2'>&nbsp;</td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Contributor Name</td>
    <td><input type=text name='f_contributor_name' id='f_contributor_name' size='60'></td>
  </tr>

  <tr>
    <td align='right' class='general_heading_white'>Contributor Function</td>
    <td><input type=text name='f_contributor_function' id='f_contributor_function' size='60'></td>
  </tr>

  <tr>
    <td align='right' class='general_heading_white'>Contributor ID</td>
    <td><input type=text name='f_contributor_id' id='f_contributor_id' size='10'></td>
  </tr>
  <tr>
    <td colspan='3'><br></td>
  </tr>
  <tr>
    <td align='right' class='general_heading_white'>Display</td>
    <td>
      <select name='f_assoc_item' id='f_assoc_item'>      
        <option value='all'>All Events</option>
        <option value='resources'>Events with Resources</option>
        <option value='online resources'>Events with Online Resources</option>
      </select>
    </td>

    
  </tr>
  <tr>
  
    <td class='general_heading_white' align='right'>Number of results per page &nbsp;</td>
    <td>
      <select name='f_limit_by'>
	<option value='20'>20</option>
	<option value='50'>50</option>
	<option value='75'>75</option>
	<option value='100'>100</option>
      </select>

    </td>
    
  </tr>
  
  <tr>
    <td class='general_heading_white' align='right'>Sort results by &nbsp;</td>
    <td>
      <select name='f_order_by'>
	<option value='event_name'>Title</option>
	<option value='first_date'>Date</option>
	<option value='venue_name'>Venue</option>
	<option value='state'>State</option>
      </select>
    </td>
  </tr>
  
  <tr><td></td><td align='left'><input type='submit' value='Search'><a class="helpIcon" target='_blank' href="/pages/static/help.html"></a></td></tr>
  
  <tr>
    <td colspan='3'><br></td>
  </tr>
  
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
      && form.f_betweento_dd.value == "" && form.f_betweento_mm.value == "" && form.f_betweento_yyyy.value == ""
      && form.f_venue_id.value == "" && form.f_venue_name.value == "" 
      && form.f_states.options[form.f_states.selectedIndex].value == "" && form.f_umbrella.value == ""
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

  // TO DATE
  if(document.advancedSearchForm.f_betweento_dd.value != ""){
    // must have mm & yyyy as well
    if(document.advancedSearchForm.f_betweento_mm.value == "" || document.advancedSearchForm.f_betweento_yyyy.value == "")
      msg += "- First Date on - MM and YYYY are required as well\n";
  }
  else if(document.advancedSearchForm.f_betweento_mm.value != ""){
     // must have yyyy as well
     if(document.advancedSearchForm.f_betweento_yyyy.value == "")
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
  if ((!isBlank(form.f_betweento_yyyy.value) && !isInteger(form.f_betweento_yyyy.value)) ||
     (!isBlank(form.f_betweento_yyyy.value) && form.f_betweento_yyyy.value.length != 4) ){
    msg += "- Last data year must be valid\n";
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
				+ "&f_betweento_dd=" + document.advancedSearchForm.f_betweento_dd.value
				+ "&f_betweento_mm=" + document.advancedSearchForm.f_betweento_mm.value
				+ "&f_betweento_yyyy=" + document.advancedSearchForm.f_betweento_yyyy.value
				+ "&f_venue_name=" + document.advancedSearchForm.f_venue_name.value
				+ "&f_venue_id=" + document.advancedSearchForm.f_venue_id.value
				+ "&f_states=" + document.advancedSearchForm.f_states.value
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
				+ "&f_order_by=" + document.advancedSearchForm.f_order_by.value , false); 
	ajaxRequest.send(null); 

	if (ajaxRequest.responseText == "0") {
		alert("There were no results found for your search.");
		return false;
	} else {
		return true;
	}

}
</script>