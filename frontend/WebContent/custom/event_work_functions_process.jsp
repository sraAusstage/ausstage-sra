<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.WorkEvLink, ausstage.Event"%>
<jsp:include page="../templates/admin-footer.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Works Editor") && !session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
	admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
	ausstage.Database db_ausstage = new ausstage.Database ();
	db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
	
	Event eventObj = (Event) session.getAttribute("eventObj");
	String eventId = eventObj.getEventid();
	Vector eventWorkLinks = eventObj.getWorks();
	Vector tempEventWorkLinks = new Vector();
	
	String error_msg = "";

	String orderby = "";
	String workId = "";
	
	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);

	try {
		for (int i=0; i < eventWorkLinks.size(); i++) {
			WorkEvLink eventWorkLink = new WorkEvLink(db_ausstage);
			// get data from the request object
			
			orderby = request.getParameter("f_orderby_" + i);							
			workId = request.getParameter("f_workId_" + i);							
			
			eventWorkLink.setOrderby(orderby);
			eventWorkLink.setEventId(eventId);
			eventWorkLink.setWorkId(workId);

			tempEventWorkLinks.insertElementAt(eventWorkLink, i);
		}
	} catch(Exception e) {
		error_msg = "Error: Linking works to event process NOT successful."+e.toString();
	}

	if (error_msg.equals("")) {
		eventObj.setWorks(tempEventWorkLinks);
		session.setAttribute("eventObj", eventObj);
		pageFormater.writeText(out, "Linking works to event process successful.");
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