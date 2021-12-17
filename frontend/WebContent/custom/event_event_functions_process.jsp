<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.EventEventLink, ausstage.Event"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
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
	String orderby = "";
	
	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);

	try {
		for (int i=0; i < eventEventLinks.size(); i++) {
			EventEventLink eventEventLink = new EventEventLink(db_ausstage);
			// get data from the request object
			childEventId = request.getParameter("f_child_event_id_" + i);
			orderby = request.getParameter("f_orderby_" + i);							
			linkEventId = request.getParameter("f_link_event_id_" + i);

			String [] lookupAndPerspective = request.getParameter("f_relation_lookup_id_" + i).split("_", 2);
			relationLookupId = lookupAndPerspective[0];
			isParent = lookupAndPerspective[1];				
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
			eventEventLink.setOrderby(orderby);
			//eventEventLink.setNotes(notes);
			
			tempEventEventLinks.insertElementAt(eventEventLink, i);
		}
	} catch(Exception e) {
		error_msg = "Error: Event to Event links process NOT successful."+e.toString();
	}

	if (error_msg.equals("")) {
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
<jsp:include page="../templates/admin-footer.jsp" />