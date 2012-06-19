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
	Vector eventEventLinks = eventObj.getAssociatedEvents();
	Vector tempEventEventLinks = new Vector();
	String error_msg = "";
	String functionId = "";
	String notes = "";
	String childEventId = "";
	
	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);
	
	try {
		for (int i=0; i < eventEventLinks.size(); i++) {
			EventEventLink eventEventLink = new EventEventLink(db_ausstage);
			// get data from the request object
			childEventId = request.getParameter("f_child_event_id_" + i);
			functionId = request.getParameter("f_function_lov_id_" + i);
			notes = request.getParameter("f_notes_" + i);
			
			eventEventLink.setChildId(childEventId);
			eventEventLink.setFunctionLovId(functionId);
			eventEventLink.setNotes(notes);
			
			tempEventEventLinks.insertElementAt(eventEventLink, i);
		}
	} catch(Exception e) {
		error_msg = "Error: Resource to resource links process NOT successful.";
	}

	if (error_msg.equals("")) {
		pageFormater.writeText(out, "Event to event process successful.");
	} else {
		pageFormater.writeText(out, error_msg);
	}
	
	pageFormater.writePageTableFooter (out);
	pageFormater.writeButtons(out, "", "", "", "", "event_addedit.jsp#event_event_link", "next.gif");
	pageFormater.writeFooter(out);
	db_ausstage.disconnectDatabase();
%>
<cms:include property="template" element="foot" />