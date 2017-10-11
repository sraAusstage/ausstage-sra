<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue, ausstage.VenueVenueLink, admin.Common, java.util.*, ausstage.LookupCode, ausstage.RelationLookup"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<script type="text/javascript" src="../pages/assets/javascript/libraries/jquery-1.6.min.js"></script>
<script type="text/javascript" src="../pages/assets/javascript/libraries/jquery-ui-1.8.12.custom.min.js"></script>
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
  Vector              temp_display_info;
  CachedRowSet        rset;
  String              action1       = request.getParameter("action");
  if (action1 == null) action1 = "";
  String action = request.getParameter("act");
  if (action == null) action = action1;
  Common              common       = new Common();
  String                  currentUser_authId = session.getAttribute("authId").toString();
  Hashtable                    hidden_fields = new Hashtable();
  Vector venue_name_vec		= new Vector();
  Vector<VenueVenueLink> venue_link_vec		= new Vector<VenueVenueLink>();
  

  //PAGE NAVIGATION STUFF - dont necessarily agree with the approach, but following an existing convention....
 // Event eventObj = null;
    boolean finishButton = false;
  boolean placeOfBirthButton = false;
  boolean placeOfDeathButton = false;
  boolean placeOfOriginButton = false;
  boolean placeOfDemiseButton = false;
  
  if (request.getParameter("place_of_birth") != null) {
    placeOfBirthButton = true;
  } else if (request.getParameter("place_of_death") != null) {
    placeOfDeathButton = true;
  } else if (request.getParameter("place_of_origin") != null) {
    placeOfOriginButton = true;
  } else if (request.getParameter("place_of_demise") != null) {
    placeOfDemiseButton = true;    
  }/** else if (request.getParameter("f_eventid") != null) {
    eventObj = (Event)session.getAttribute("eventObj"); // Get the Event object.
    if (eventObj == null)                               // Make sure it exists
      eventObj = new Event(db_ausstage);
    eventObj.setEventAttributes(request);               // Update it with the request data.
    session.setAttribute("eventObj", eventObj);         // And put it back into the session.
    finishButton = true;                                // Need a Finish Button for the user.
  } else {
    eventObj = (Event)session.getAttribute("eventObj"); // Do we need a Finish Button anyway?
    if (eventObj != null)
      finishButton = true;
  }*/
  
  
  
  String isPreviewForVenueVenue  = request.getParameter("isPreviewForVenueVenue");
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  if(venue_id == null) venue_id = "";
  //use a new Venue object that is not from the session.
  if(action1 != null && (action1.equals("add") || action1.equals("AddForItem") )){
	    venue_id = "";	    
  }
  else if (action1 != null && action1.equals("edit")|| action1.equals("EditForItem")){ //editing existing Venue
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
  if(isPreviewForVenueVenue.equals("true") || (action1 != null && action1.equals("ForVenueForVenue")))
    action1 = "ForVenue";
  
  
  // get the initial state of the object(s) associated with this venue
  venue_link_vec	        = venueObj.getVenueVenueLinks();
  Venue venueTemp 			= null;
  
 
  %>
  

<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDG86QjLMzgi1z0l5ztQtiFlCwZfn5LjL0" type="text/javascript"></script>
<script type="text/javascript">

//add listener to the country and state select lists
$(document).ready(function(){
	//if country selected is not australia set state to O/S
	//if Australia and state is O/S set to [Unknown]
	$("[name=f_country]").change(function(){
		if ($("[name=f_country] option:selected").text() != 'Australia'){
			//set state to O/S
			$("[name=f_state_id] option:contains('O/S')").prop('selected', true);
		}else {
			//set state to unknown
			$("[name=f_state_id] option:contains('[Unknown]')").prop('selected', true);
		}
	});
	//if state selected is not O/S make country Australia
	$("[name=f_state_id]").change(function(){
		if ($("[name=f_state_id] option:selected").text() != 'O/S'){
		console.log("country should reset");
			//set Country to Australia
			$("[name=f_country] option:contains('Australia')").prop('selected', true);
		}	
	});
});


var map = null;
var geocoder = null;
var marker = null;
function load() {
	geocoder = new google.maps.Geocoder();
}

function checkMandatoryFields(){

  if(!validateUrl( $('input[name=f_web_links]'))) return false;
  if(!checkStateCountry())return false;

  return true;
    
  }
  
function checkStateCountry(){
	var state = $("[name=f_state_id] option:selected").text();
	var country = $("[name=f_country] option:selected").text();
	var returnVal = true;
	if ((state == "O/S") && (country =="Australia")){alert("If the State is O/S, the Country can not be Australia. Please ensure the data is entered correctly and try again."); returnVal = false;}
	if ((state != "O/S") && (country != "Australia")){alert("If the Country is not Australia, the State must be O/S. Please ensure the data is entered correctly and try again."); returnVal = false;}
	return returnVal;
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
			initializeMap();
		}
		else {
			alert("An error occurred using the Google GeoCode API. Please report the following error code : "+status);
		}
	});
	return false;
}

function initializeMap(){
  var pointLatlng = new google.maps.LatLng(document.venue_addedit_form.f_latitude.value,document.venue_addedit_form.f_longitude.value);
  var myOptions = {
          zoom: 14,
          center: pointLatlng,
          mapTypeControl: true,
          mapTypeControlOptions: {
           mapTypeIds: [google.maps.MapTypeId.ROADMAP, 
                                google.maps.MapTypeId.SATELLITE, 
                                google.maps.MapTypeId.HYBRID, 
                                google.maps.MapTypeId.TERRAIN, 
                                'ausstage']
          }
  }
  var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  
  var mapStyle = [ { featureType: "all", elementType: "all", stylers: [ { visibility: "off" } ]},
    { featureType: "water", elementType: "geometry", stylers: [ { visibility: "on" }, { lightness: 40 }, { saturation: 0 } ] },
    { featureType: "landscape", elementType: "geometry", stylers: [ { visibility: "on" }, { saturation: -100 } ]},
    { featureType: "road", elementType: "geometry", stylers: [ { visibility: "on" }, { saturation: -100 }, { lightness: 40 } ] },
    { featureType: "transit", elementType: "geometry", stylers: [ { saturation: -100 }, { lightness: 40 } ] } 
    ];
  
  var styledMapOptions = {map: map, name: "AusStage", alt: 'Show AusStage styled map' };
  var ausstageStyle    = new google.maps.StyledMapType(mapStyle, styledMapOptions);
  
  map.mapTypes.set('ausstage', ausstageStyle);
  //map.setMapTypeId('ausstage');
  
  var address = document.venue_addedit_form.f_street.value + " " + document.venue_addedit_form.f_suburb.value + " " + 
  document.venue_addedit_form.f_postcode.value + " " + document.venue_addedit_form.f_state_id.options[document.venue_addedit_form.f_state_id.selectedIndex].text + " " + 
  document.venue_addedit_form.f_country.options[document.venue_addedit_form.f_country.selectedIndex].text;
  
  var marker = new google.maps.Marker({
    position: pointLatlng,
    map: map,
    title:  address,
    icon: "/pages/assets/images/iconography/venue-arch-134-pointer.png"
  });
  document.getElementById("map_container").style.display = "block";
}

document.body.onload=function(){load();};
</script>
  
  
  <%
  if (action1 != null && action1.equals("ForVenue") || isPreviewForVenueVenue.equals("true")){
      out.println("<form name='venue_addedit_form' id='venue_addedit_form' action='venue_addedit_process.jsp?action=" + action1 +  "' method='post' >\n");
      out.println("<input type='hidden' name='isPreviewForVenueVenue' value='true'>");
      out.println("<input type='hidden' name='ForVenue' value='true'>");
  }
  else if (placeOfBirthButton){
  	out.println("<form name='venue_addedit_form' id='venue_addedit_form' action='venue_addedit_process.jsp?place_of_birth=1' method='post'>");
  }
  else if (placeOfDeathButton){
  	out.println("<form name='venue_addedit_form' id='venue_addedit_form' action='venue_addedit_process.jsp?place_of_death=1' method='post'>");
  }
  else if (placeOfOriginButton){
  	out.println("<form name='venue_addedit_form' id='venue_addedit_form' action='venue_addedit_process.jsp?place_of_origin=1' method='post'>");
  }
  else if (placeOfDemiseButton){
  	out.println("<form name='venue_addedit_form' id='venue_addedit_form' action='venue_addedit_process.jsp?place_of_demise=1' method='post'>");
  }      
  else{
      out.println("<form name='venue_addedit_form' id='venue_addedit_form' action='venue_addedit_process.jsp?act="+action+"' method='post' onsubmit='return checkMandatoryFields();'>");
  }
  
  
  // Data Entry variables
  pageFormater.writeHelper(out, "Enter the Venue Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_venue_id\" value=\"" + venue_id + "\">");
  out.println("<input type='hidden' name='f_from_venue_add_edit_page' value='true'>");
  
  pageFormater.writeTwoColTableHeader(out, "ID");
  if(venue_id != null && !venue_id.equals(""))
    out.println(venue_id);
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "Venue Name *");
  out.println("<input type=\"text\" name=\"f_venue_name\" size=\"60\" class=\"line150\" maxlength=60 value=\"" + venueObj.getName() + "\">");
  pageFormater.writeTwoColTableFooter(out);

pageFormater.writeTwoColTableHeader(out, "Other names");
  out.println("<input type=\"text\" name=\"f_other_names1\" size=\"60\" class=\"line150\" maxlength=60 value=\"" + venueObj.getOtherNames1() + "\">");  
  out.println("<input type=\"text\" name=\"f_other_names2\" size=\"60\" class=\"line150\" maxlength=60 value=\"" + venueObj.getOtherNames2() + "\">");
  out.println("<input type=\"text\" name=\"f_other_names3\" size=\"60\" class=\"line150\" maxlength=60 value=\"" + venueObj.getOtherNames3() + "\">");
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
     
    if(!rset.getString("state").toLowerCase().equals("unknown") && !rset.getString("state").toLowerCase().equals("[unknown]")){
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
  out.println("<input type=\"text\" name=\"f_web_links\" size=\"40\"  class=\"line300\" maxlength=2048 value=\"" + venueObj.getWebLinks() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // Longitude
  pageFormater.writeTwoColTableHeader(out, "Longitude");
  out.println("<input type=\"text\" name=\"f_longitude\" size=\"15\" class=\"line150\" maxlength=15 value=\"" + venueObj.getLongitude() + "\">");
  %><input value="Look up co-ordinates" type="button" onclick="showAddress(); return false"><%
  pageFormater.writeTwoColTableFooter(out);

  // Latitude
  pageFormater.writeTwoColTableHeader(out, "Latitude");
  out.println("<input type=\"text\" name=\"f_latitude\" size=\"15\" class=\"line150\" maxlength=15 value=\"" + venueObj.getLatitude() + "\">");
  pageFormater.writeTwoColTableFooter(out);
  %>
  <div id="map_container" style="clear:both; padding: 2.5%;  display:none;">
    <div id="map_canvas" style="width:100%;height:300px;"></div>
  </div>
  <%
    if (AusstageCommon.hasValue(venueObj.getLatitude()) && AusstageCommon.hasValue(venueObj.getLongitude())) {
  %>
    <script type="text/javascript">
      initializeMap();
    </script>
  <%
    }
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
  hidden_fields.put("act", action);

  //LookupCode lc = new LookupCode(db_ausstage);
  RelationLookup lc = new RelationLookup(db_ausstage);
  for(int i=0; i < venue_link_vec.size(); i++ ){
    venueTemp = new Venue(db_ausstage);
    boolean isParent = venue_id.equals(venue_link_vec.get(i).getVenueId());
    venueTemp.load(Integer.parseInt((isParent)?venue_link_vec.get(i).getChildId():venue_link_vec.get(i).getVenueId())); 
	 if (venue_link_vec.get(i).getRelationLookupId() != null) {
		lc.load(Integer.parseInt(venue_link_vec.get(i).getRelationLookupId()));
		venue_name_vec.add(venueTemp.getName() + " (" + ((isParent)?lc.getParentRelation():lc.getChildRelation()) + ")");
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
if (venueObj.getEnteredByUser() != null && !venueObj.getEnteredByUser().equals("")) {
  pageFormater.writeTwoColTableHeader(out, "Created By User:");
  out.print(venueObj.getEnteredByUser());
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Date Created:");
  out.print(common.formatDate(venueObj.getEnteredDate(), AusstageCommon.DATE_FORMAT_STRING));
  pageFormater.writeTwoColTableFooter(out);
}
if (venueObj.getUpdatedByUser() != null && !venueObj.getUpdatedByUser().equals("")) {
  pageFormater.writeTwoColTableHeader(out, "Updated By User:");
  out.print(venueObj.getUpdatedByUser());
  pageFormater.writeTwoColTableFooter(out);


  pageFormater.writeTwoColTableHeader(out, "Date Updated:");
  out.print(common.formatDate(venueObj.getUpdatedDate(), AusstageCommon.DATE_FORMAT_STRING));
  pageFormater.writeTwoColTableFooter(out);
}
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