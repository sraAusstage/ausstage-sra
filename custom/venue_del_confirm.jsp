<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.Venue      venueObj     = new ausstage.Venue (db_ausstage);
  String              venue_id;
  CachedRowSet        rset;

  String action = request.getParameter("act");
  
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  venue_id = request.getParameter ("f_selected_venue_id");

  %>
  <form action='venue_del_process.jsp?act=<%=action%>' method='post'>
  <%
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + venue_id + "\">");
  
  // Make sure that the user selected a record to delete
  if (venue_id != null && !venue_id.equals ("null"))
  {
    venueObj.load (Integer.parseInt(venue_id));
    // Need to make sure that the venue is not in use
    if (!venueObj.checkInUse (Integer.parseInt(venue_id)))
    {
      pageFormater.writeText (out, "Are you sure that you wish to delete the venue named <b>" + venueObj.getName () + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/custom/ausstage/welcome.jsp", "cross.gif", "submit", "next.gif");
    }
    else
    {
      pageFormater.writeText (out, "You are unable to remove this venue as it is in use.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/custom/ausstage/welcome.jsp", "cross.gif", "", "");
    }
  }
  else
  {
    pageFormater.writeText (out, "Please select a record to remove.");
    pageFormater.writePageTableFooter (out);
     pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
  }
  
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />