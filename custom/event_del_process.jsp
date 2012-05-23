<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Event"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  Event            			eventObj        = new Event (db_ausstage);
  String                eventid;
  boolean               deleted         = false;
  String                error           = "";
  CachedRowSet          rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  eventid = request.getParameter ("f_eventid");

  eventObj.load (Integer.parseInt(eventid));

  // Need to make sure that the event is not in use
  if (!eventObj.checkInUse (Integer.parseInt(eventid)))
  {
    deleted = eventObj.delete ();
    if(deleted){
      pageFormater.writeText (out, "You have deleted the event named <b>" + eventObj.getEventName () + "</b>.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "", "", "", "", "event_search.jsp", "tick.gif");
    }
    else{
      error = eventObj.getError();
      pageFormater.writeText (out, error);
    }
  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this event as it is in use.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%><cms:include property="template" element="foot" />