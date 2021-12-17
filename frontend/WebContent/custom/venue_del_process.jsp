<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Venue Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
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
  
  venue_id = request.getParameter ("f_id");

  venueObj.load (Integer.parseInt(venue_id));
  
  // Need to make sure that the venue is not in use
  if (!venueObj.checkInUse (Integer.parseInt(venue_id)))
  {
    venueObj.delete ();
    pageFormater.writeText (out, "You have deleted the venue named <b>" + venueObj.getName () + "</b>.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "", "", "", "", "venue_search.jsp?act="+action, "tick.gif");
  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this venue as it is in use.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
  }
  
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%><jsp:include page="../templates/admin-footer.jsp" />