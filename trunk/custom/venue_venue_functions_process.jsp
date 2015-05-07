<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.VenueVenueLink, ausstage.Venue"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Venue   venueObj       	= (Venue)session.getAttribute("venueObj");
  //System.out.println("Venue Object:" + venueObj);
  //String venueId = request.getParameter("f_venue_id");
  String venueId        	= venueObj.getVenueId();
  //System.out.println("Venue Id:" + venueId        	);
  Vector<VenueVenueLink> venueVenueLinks 	= venueObj.getVenueVenueLinks();
  Vector<VenueVenueLink> tempVenueVenueLinks 	= new Vector();
  String error_msg   		= "";
  String functionId   		= "";
  String notes        		= "";
  String childVenueId  		= "";
  //System.out.println("Child Id:" + request.getParameter("f_child_venue_id_"));
  String action = request.getParameter("act");
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	for(int i=0; i < venueVenueLinks.size(); i++) {
	    VenueVenueLink venueVenueLink = new VenueVenueLink(db_ausstage);
            // get data from the request object
     	    childVenueId = request.getParameter("f_child_venue_id_" + i);
     	    //System.out.println("Child Id:" +childVenueId );
	    functionId  = request.getParameter("f_function_lov_id_" + i);
      	    notes       = request.getParameter("f_notes_" + i);

	    venueVenueLink.setChildId(childVenueId);
	    venueVenueLink.setFunctionLovId(functionId);
	    venueVenueLink.setNotes(notes);

	    //if (error_msg.length() == 0)
	    // BW venueVenueLinks.set(i, venueVenueLink);
	    tempVenueVenueLinks.insertElementAt(venueVenueLink, i); 
    }
  }
  catch(Exception e) {
    error_msg = "Error: Resource to resource links process NOT successful.";
  }

  if(error_msg.equals("")) {
	venueObj.setVenueVenueLinks(tempVenueVenueLinks);
	session.setAttribute("venueObj", venueObj);
    pageFormater.writeText(out, "Venue to venue process successful.");
  }
  else {
    pageFormater.writeText(out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "venue_addedit.jsp?#venue_venue_link&act="+action, "next.gif");
 // pageFormater.writeButtons (out, "", "", "", "", "venue_addedit.jsp?act="+action, "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />