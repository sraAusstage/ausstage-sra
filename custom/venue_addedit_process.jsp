<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater   = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage    = new ausstage.Database ();
  ausstage.Venue      venueObj       = null;
  String              venue_id;
  CachedRowSet        rset;
  boolean             error_occurred = false;
  String              action         = request.getParameter("act");

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  venue_id = request.getParameter ("f_venue_id");
  
  // if editing set the object to the selected record
  if (session.getAttribute("venueObj") != null) {
	  venueObj = (Venue) session.getAttribute("venueObj");
	  venueObj.setDb(db_ausstage);
  } else if (venue_id != null && !venue_id.equals ("") && !venue_id.equals ("null")) {
    venueObj = new Venue(db_ausstage);
	  venueObj.load (Integer.parseInt(venue_id));
  }

  venueObj.setName(request.getParameter("f_venue_name"));
  venueObj.setOtherNames1(request.getParameter("f_other_names1"));
  venueObj.setOtherNames2(request.getParameter("f_other_names2"));
  venueObj.setOtherNames3(request.getParameter("f_other_names3"));
  venueObj.setStreet(request.getParameter("f_street"));
  venueObj.setSuburb(request.getParameter("f_suburb"));
  venueObj.setPostcode(request.getParameter("f_postcode"));
  venueObj.setState(request.getParameter("f_state_id"));
  venueObj.setCapacity(request.getParameter("f_capacity"));
  venueObj.setContact(request.getParameter("f_contact"));
  venueObj.setPhone(request.getParameter("f_phone"));
  venueObj.setFax(request.getParameter("f_fax"));
  venueObj.setEmail(request.getParameter("f_email"));
  venueObj.setWebLinks(request.getParameter("f_web_links"));
  venueObj.setCountry(request.getParameter("f_country"));
  venueObj.setNotes(request.getParameter("f_notes"));
  venueObj.setLongitude(request.getParameter("f_longitude"));
  venueObj.setLatitude(request.getParameter("f_latitude"));
  venueObj.setRadius(request.getParameter("f_radius"));
  venueObj.setElevation(request.getParameter("f_elevation"));
  venueObj.setNotes(request.getParameter("f_notes"));
  venueObj.setDdfirstDate(request.getParameter("f_first_date_day"));
  venueObj.setMmfirstDate(request.getParameter("f_first_date_month"));
  venueObj.setYyyyfirstDate(request.getParameter("f_first_date_year"));
  venueObj.setDdlastDate(request.getParameter("f_last_date_day"));
  venueObj.setMmlastDate(request.getParameter("f_last_date_month"));
  venueObj.setYyyylastDate(request.getParameter("f_last_date_year"));
  venueObj.setEnteredByUser((String)session.getAttribute("fullUserName"));
  venueObj.setUpdatedByUser((String)session.getAttribute("fullUserName"));
  
  //PAGE NAVIGATION STUFF
  //Event eventObj = null;
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
  

  // if editing
  if (venue_id != null && !venue_id.equals ("") && !venue_id.equals ("null"))
    error_occurred = !venueObj.update();
  else // Adding
    error_occurred = !venueObj.add();

  // Error
  if (error_occurred)
  {
    pageFormater.writeText (out, venueObj.getError());
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "BACK", "prev.gif", "", "", "", "");
  }
  else
  {
    pageFormater.writeText (out, "The venue <b>" + venueObj.getName() + "</b> was successfully saved");
    pageFormater.writePageTableFooter (out);
    if(action != null && (action.equals("PreviewForItem") || action.equals("AddForItem") || action.equals("EditForItem")))
      pageFormater.writeButtons(out, "", "", "", "", "item_venues.jsp", "tick.gif");
    else if (placeOfBirthButton){
      pageFormater.writeButtons(out, "", "", "", "", "venue_search.jsp?act="+action+"&mode=edit&place_of_birth=1", "tick.gif");
    }
    else if (placeOfDeathButton){
      pageFormater.writeButtons(out, "", "", "", "", "venue_search.jsp?act="+action+"&mode=edit&place_of_death=1", "tick.gif");
    }
    else if (placeOfOriginButton){
      pageFormater.writeButtons(out, "", "", "", "", "venue_search.jsp?act="+action+"&mode=edit&place_of_origin=1", "tick.gif");
    }
    else if (placeOfDemiseButton){
      pageFormater.writeButtons(out, "", "", "", "", "venue_search.jsp?act="+action+"&mode=edit&place_of_demise=1", "tick.gif");
    }
    else if (action.contains("ForEvent")){
      pageFormater.writeButtons(out, "", "", "", "", "venue_search.jsp?act="+action+"&mode=edit", "tick.gif");
    }
    else
      pageFormater.writeButtons(out, "", "", "", "", "venue_search.jsp", "tick.gif");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />