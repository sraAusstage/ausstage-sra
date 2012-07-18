<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue, ausstage.VenueVenueLink, admin.Common, java.util.*, ausstage.LookupCode"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  Statement stmt1 = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator  htmlGenerator        = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Venue      venueObj     = new ausstage.Venue (db_ausstage);
  ausstage.State      stateObj     = new ausstage.State (db_ausstage);
  ausstage.Country    countryObj   = new ausstage.Country(db_ausstage);
  String              venue_id = request.getParameter ("f_selected_venue_id");
  String              countryLeadingSubString = "", countryTrailingSubString = "";
  String              stateLeadingSubString = "", stateTrailingSubString = "";
  Vector                  temp_display_info;
  CachedRowSet        rset;
  String              action       = request.getParameter("action");
  Common              common       = new Common();
  String                  currentUser_authId = session.getAttribute("authId").toString();
  Hashtable                    hidden_fields = new Hashtable();
  Vector venue_name_vec		= new Vector();
  Vector<VenueVenueLink> venue_link_vec		= new Vector<VenueVenueLink>();
  
  String isPreviewForVenueVenue  = request.getParameter("isPreviewForVenueVenue");
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  if(venue_id == null) venue_id = "";
  //use a new Venue object that is not from the session.
  if(action != null && action.equals("add")){
		 //System.out.println("Insert");
	    action = "add";
	    venue_id = "";	    
  }
  else if (action != null && action.equals("edit")){ //editing existing Venue
    if (venue_id != null && !venue_id.equals("") && !venue_id.equals("null")) {  
      venueObj.load(Integer.parseInt(venue_id));
    }
  }
  else{ //use the venue object from the session.
	venueObj = (Venue)session.getAttribute("venueObj");
	venue_id  = venueObj.getVenueId();
  }
	
  if (isPreviewForVenueVenue == null || isPreviewForVenueVenue.equals("null")) 
	  isPreviewForVenueVenue = "";
  if(isPreviewForVenueVenue.equals("true") || (action != null && action.equals("ForVenueForVenue")))
    action = "ForVenue";
  
  
  // get the initial state of the object(s) associated with this venue
  venue_link_vec	        = venueObj.getVenueVenueLinks();
  Venue venueTemp 			= null;
  
 
  %>
  
<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDG86QjLMzgi1z0l5ztQtiFlCwZfn5LjL0&sensor=false" type="text/javascript"></script>
<script type="text/javascript">

var map = null;
var geocoder = null;
var marker = null;
function load() {
	geocoder = new google.maps.Geocoder();
}

function checkMandatoryFields(){
    //all fields are empty
    if(document.venue_addedit_form.f_street.value == ""){      
      alert("Please enter street and suburb details.");
      return (false);
    }   
    msg = "";
  }

function showAddress() {
	
	if(document.venue_addedit_form.f_street.value == ""){      
	      alert("Please enter street name.");
	      return (false);
	    }   
	    msg = "";
	    
	    if(document.venue_addedit_form.f_suburb.value == ""){      
		      alert("Please enter suburb name.");
		      return (false);
		    }   
		    msg = "";
	    
	var address = document.venue_addedit_form.f_street.value + " " + document.venue_addedit_form.f_suburb.value + " " + document.venue_addedit_form.f_postcode.value + " " + document.venue_addedit_form.f_state_id.options[document.venue_addedit_form.f_state_id.selectedIndex].text + " " + document.venue_addedit_form.f_country.options[document.venue_addedit_form.f_country.selectedIndex].text;
	
	geocoder.geocode({'address':address}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			var point = results[0].geometry.location;
			document.venue_addedit_form.f_latitude.value = Math.round(point.lat()*1000000)/1000000;
			document.venue_addedit_form.f_longitude.value = Math.round(point.lng()*1000000)/1000000;
		}
	});
	return false;
}

document.body.onload=function(){load();};
</script>
  
  
  <%
  if (action != null && action.equals("ForVenue") || isPreviewForVenueVenue.equals("true")){
      out.println("<form name='venue_addedit_form' id='venue_addedit_form' action='venue_addedit_process.jsp?action=" + action +  "' method='post'>\n");
      out.println("<input type='hidden' name='isPreviewForVenueVenue' value='true'>");
      out.println("<input type='hidden' name='ForVenue' value='true'>");
  }
  else{
      out.println("<form name='venue_addedit_form' id='venue_addedit_form' action='venue_addedit_process.jsp' method='post'>");
  }
  
  
  // Data Entry variables
  pageFormater.writeHelper(out, "Enter the Venue Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_venue_id\" value=\"" + venue_id + "\">");
  out.println("<input type='hidden' name='f_from_venue_add_edit_page' value='true'>");
  
  pageFormater.writeTwoColTableHeader(out, "ID");
  if(venue_id != null && !venue_id.equals(""))
    out.println(venue_id);
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "Venue Name");
  out.println("<input type=\"text\" name=\"f_venue_name\" size=\"60\" class=\"line150\" maxlength=60 value=\"" + venueObj.getName() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // Display Dates
  pageFormater.writeTwoColTableFooter(out);
 // pageFormater.writeHelper(out, "Dates", "helpers_no2.gif");
  
  pageFormater.writeTwoColTableHeader(out, "First Date");
  out.println("<input type=\"text\" name=\"f_first_date_day\" size=\"2\" class=\"line25\" maxlength=2 value=\"" + venueObj.getDdfirstDate() + "\">");
  out.println("<input type=\"text\" name=\"f_first_date_month\" size=\"2\" class=\"line25\" maxlength=2 value=\"" + venueObj.getMmfirstDate() + "\">");
  out.println("<input type=\"text\" name=\"f_first_date_year\" size=\"4\" class=\"line35\" maxlength=4 value=\"" + venueObj.getYyyyfirstDate() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Last Date");
  out.println("<input type=\"text\" name=\"f_last_date_day\" size=\"2\" class=\"line25\" maxlength=2 value=\"" + venueObj.getDdlastDate() + "\">");
  out.println("<input type=\"text\" name=\"f_last_date_month\" size=\"2\" class=\"line25\" maxlength=2 value=\"" + venueObj.getMmlastDate() + "\">");
  out.println("<input type=\"text\" name=\"f_last_date_year\" size=\"4\" class=\"line35\" maxlength=4 value=\"" + venueObj.getYyyylastDate() + "\">");
  pageFormater.writeTwoColTableFooter(out);
 
  pageFormater.writeTwoColTableHeader(out, "Address");
  out.println("<input type=\"text\" name=\"f_street\" size=\"60\" class=\"line150\" maxlength=130 value=\"" + venueObj.getStreet() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Suburb");
  out.println("<input type=\"text\" name=\"f_suburb\" size=\"40\" class=\"line150\" maxlength=40 value=\"" + venueObj.getSuburb() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // Postcode
  pageFormater.writeTwoColTableHeader(out, "Postcode");
  out.println("<input type=\"text\" name=\"f_postcode\" size=\"10\" class=\"line50\" maxlength=10 value=\"" + venueObj.getPostcode() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // State
  pageFormater.writeTwoColTableHeader(out, "State");
  out.println("<select name=\"f_state_id\" size=\"1\" class=\"line50\">");
  rset = stateObj.getStates (stmt);

  // Display all of the states
  while (rset.next()){
  String selected = "";
    if (venueObj.getState().equals(rset.getString("stateid")))//therefore editing existing state
        selected = "selected";
     
    if(!rset.getString("state").toLowerCase().equals("unknown")){
      stateTrailingSubString += "<option " + selected + " value='" + rset.getString ("stateid") + "'" +
                                    ">" + rset.getString ("state") + "</option>\n";
    }else{
       stateLeadingSubString = "<option " + selected + " value='" + rset.getString ("stateid") + "'>" + rset.getString ("state") + "</option>\n";
    }
  }
  rset.close ();
  stmt.close ();
  out.print(stateLeadingSubString + stateTrailingSubString);
  out.println("</select>");
  pageFormater.writeTwoColTableFooter(out);
 
  pageFormater.writeTwoColTableHeader(out, "Capacity");
  out.println("<input type=\"text\" name=\"f_capacity\" size=\"5\" class=\"line50\" maxlength=40 value=\"" + venueObj.getCapacity() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Name");
  out.println("<input type=\"text\" name=\"f_contact\" size=\"40\" class=\"line150\" maxlength=40 value=\"" + venueObj.getContact() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Phone");
  out.println("<input type=\"text\" name=\"f_phone\" size=\"40\" class=\"line150\" maxlength=40 value=\"" + venueObj.getPhone() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Fax");
  out.println("<input type=\"text\" name=\"f_fax\" size=\"40\" class=\"line150\" maxlength=40 value=\"" + venueObj.getFax() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Email");
  out.println("<input type=\"text\" name=\"f_email\" size=\"40\" class=\"line150\" maxlength=40 value=\"" + venueObj.getEmail() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Web Link");
  out.println("<input type=\"text\" name=\"f_web_links\" size=\"40\" class=\"line300\" maxlength=2048 value=\"" + venueObj.getWebLinks() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // Countries
  pageFormater.writeTwoColTableHeader(out, "Country");
  out.println("<select name=\"f_country\" size=\"1\" class=\"line150\">");
  rset = countryObj.getCountries (stmt);

  // Display all of the Countries
  while (rset.next())
  {
    String selected = "";
    if (venue_id != null && !venue_id.equals("") && venueObj.getCountry().equals(rset.getString ("countryid")))
      selected = "selected";
        
    if(!rset.getString ("countryname").toLowerCase().equals("australia")){
      countryTrailingSubString += "<option " + selected + " value='" + rset.getString ("countryid") + "'" +
                                  ">" + rset.getString ("countryname") + "</option>\n";
    }else{
      countryLeadingSubString = "<option " + selected + " value='" + rset.getString ("countryid") + "'>" + rset.getString ("countryname") + "</option>\n";
    }
  }
  rset.close ();
  out.print(countryLeadingSubString + countryTrailingSubString);
    
  out.println("</select>");
  pageFormater.writeTwoColTableFooter(out);

  // Longitude
  pageFormater.writeTwoColTableHeader(out, "Longitude");
  out.println("<input type=\"text\" name=\"f_longitude\" size=\"15\" class=\"line150\" maxlength=15 value=\"" + venueObj.getLongitude() + "\">");
  %><input value="Look up co-ordinates" type="submit" onclick="showAddress(); return false"><%
  pageFormater.writeTwoColTableFooter(out);

  // Latitude
  pageFormater.writeTwoColTableHeader(out, "Latitude");
  out.println("<input type=\"text\" name=\"f_latitude\" size=\"15\" class=\"line150\" maxlength=15 value=\"" + venueObj.getLatitude() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // Radius
  pageFormater.writeTwoColTableHeader(out, "Radius");
  out.println("<input type=\"text\" name=\"f_radius\" size=\"15\" class=\"line150\" maxlength=15 value=\"" + venueObj.getRadius() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // Elevation
  pageFormater.writeTwoColTableHeader(out, "Elevation");
  out.println("<input type=\"text\" name=\"f_elevation\" size=\"15\" class=\"line150\" maxlength=15 value=\"" + venueObj.getElevation() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Notes");
  out.println("<textarea name=\"f_notes\" rows=\"5\" cols=\"43\" class=\"line300\">" + venueObj.getNotes() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
  
  /***************************
  Venue Association/s
  ****************************/
  pageFormater.writeHelper(out, "Venue Association/s", "helpers_no2.gif");
  hidden_fields.clear();

  LookupCode lc = new LookupCode(db_ausstage);
  for(int i=0; i < venue_link_vec.size(); i++ ){
    venueTemp = new Venue(db_ausstage);
    
    venueTemp.load(Integer.parseInt(venue_link_vec.get(i).getChildId())); 
	 if (venue_link_vec.get(i).getFunctionId() != null) {
		lc.load(Integer.parseInt(venue_link_vec.get(i).getFunctionId()));
		venue_name_vec.add(venueTemp.getName() + " (" + lc.getDescription() + ")");
	 } else {
		venue_name_vec.add(venueTemp.getName());
	 }
   }
	
	out.println (htmlGenerator.displayLinkedItem("",
	       "8",
	       "venue_venues.jsp",
	       "venue_addedit_form",
	       hidden_fields,
	       "Associated with venue(s):",
	       venue_name_vec,
	       1000));
	  
	  
  /***************************
  Data Entry Information
  ****************************/
  pageFormater.writeHelper(out, "Data Entry Information", "helpers_no3.gif");
  pageFormater.writeTwoColTableHeader(out, "VenueId:");
  out.print(venueObj.getVenueId());
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Created By User:");
  out.print(venueObj.getEnteredByUser());
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Date Created:");
  out.print(common.formatDate(venueObj.getEnteredDate(), AusstageCommon.DATE_FORMAT_STRING));
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Updated By User:");
  out.print(venueObj.getUpdatedByUser());
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Date Updated:");
  out.print(common.formatDate(venueObj.getUpdatedDate(), AusstageCommon.DATE_FORMAT_STRING));
  pageFormater.writeTwoColTableFooter(out);

  /**************************************************/
  
  
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);
  
//reset/set the state of the work object
  session.setAttribute("venueObj",venueObj);
  
  stmt.close();
  stmt1.close();
  db_ausstage.disconnectDatabase();
%>
</form><cms:include property="template" element="foot" />