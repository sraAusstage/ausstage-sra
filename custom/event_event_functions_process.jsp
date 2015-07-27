<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.EventEventLink, ausstage.Event"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
	admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
	admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
	ausstage.Database db_ausstage = new ausstage.Database ();
	db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
	
	Event eventObj = (Event) session.getAttribute("eventObj");
	String eventId = eventObj.getEventid();
	Vector<EventEventLink> eventEventLinks = eventObj.getEventEventLinks();
	Vector<EventEventLink> tempEventEventLinks = new Vector<EventEventLink>();
	String error_msg = "";

	String notes = "";
	String childNotes = "";
	String childEventId = "";
	String linkEventId = "";
	String relationLookupId = "";
	String isParent = "";
	
	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);
	System.out.println("");
	System.out.println("loading event_event_functions_process...");
	try {
		for (int i=0; i < eventEventLinks.size(); i++) {
			EventEventLink eventEventLink = new EventEventLink(db_ausstage);
			// get data from the request object
			childEventId = request.getParameter("f_child_event_id_" + i);
						
			linkEventId = request.getParameter("f_link_event_id_" + i);

			String [] lookupAndPerspective = request.getParameter("f_relation_lookup_id_" + i).split("_", 2);

			System.out.println(Arrays.toString(lookupAndPerspective));
			relationLookupId = lookupAndPerspective[0];

			System.out.println(relationLookupId);
			isParent = lookupAndPerspective[1];

			System.out.println(isParent);						
			notes = request.getParameter("f_notes_" + i);
			childNotes = request.getParameter("f_child_notes_" + i);
			
			if (isParent.equals("parent")){ 
				eventEventLink.setChildId(linkEventId);
				eventEventLink.setEventId(eventId);
				eventEventLink.setNotes(notes);
				eventEventLink.setChildNotes(childNotes);
			} 
			else {	eventEventLink.setEventId(linkEventId);
				eventEventLink.setChildId(eventId);
				eventEventLink.setNotes(childNotes);
				eventEventLink.setChildNotes(notes);				
			}
			
			eventEventLink.setRelationLookupId(relationLookupId);
			//eventEventLink.setNotes(notes);
			
			tempEventEventLinks.insertElementAt(eventEventLink, i);
		}
	} catch(Exception e) {
		error_msg = "Error: Event to Event links process NOT successful."+e.toString();
	}

	if (error_msg.equals("")) {
		System.out.println("event_event_functions_process message : event object event id = "+eventObj.getEventid());
		eventObj.setEventEventLinks(tempEventEventLinks);
		session.setAttribute("eventObj", eventObj);
		pageFormater.writeText(out, "Event to event process successful.");
	} else {
		pageFormater.writeText(out, error_msg);
	}
	
	pageFormater.writePageTableFooter (out);
	//pageFormater.writeButtons(out, "", "", "", "", "event_addedit.jsp#event_event_link", "next.gif");
	pageFormater.writeButtons(out, "", "", "", "", "event_addedit.jsp#event_events", "next.gif");
	pageFormater.writeFooter(out);
	db_ausstage.disconnectDatabase();
%>
<cms:include property="template" element="foot" />