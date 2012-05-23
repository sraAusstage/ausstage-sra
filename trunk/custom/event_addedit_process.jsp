<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Event"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin   login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  Event                 eventObj        = null;
  CachedRowSet          rset;
  boolean               error_occurred  = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  eventObj = (Event)session.getAttribute("eventObj");
  eventObj.setEventAttributes(request);  // Update with new data

  String eventid = request.getParameter ("f_eventid");
  if (eventid == null || eventid.equals("0") || eventid.equals("null"))
  {
    eventid = "-1";
    
  }
  //Only used on Insert NOT update
  eventObj.setEnteredByUser((String)session.getAttribute("fullUserName"));
  session.setAttribute("eventObj", eventObj);
  
  eventObj.setDatabaseConnection(db_ausstage); // Refresh connection

  // if editing
  if (!eventid.equals ("-1"))
  {
    error_occurred = !eventObj.update();
  }
  else // Adding
  {
    error_occurred = !eventObj.add();
  }

  // Error
  if (error_occurred)
    //out.println (eventObj.getError());
    pageFormater.writeText (out, eventObj.getError());
  else
    //out.println ("The event <b>" + eventObj.getEventName() +
    //             "</b> was successfully saved");
    pageFormater.writeText (out, "The event <b>" + eventObj.getEventName() +
                 "</b> was successfully saved");
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "", "", "", "", "event_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />