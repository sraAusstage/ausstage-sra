<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage   = new ausstage.Database ();
  ausstage.EntityType entityTypeObj = new ausstage.EntityType (db_ausstage);
  String              entity_type_id;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  entity_type_id = request.getParameter ("f_id");

  %>
  <form action='entity_type_del_process.jsp' method='post'>
  <%
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + entity_type_id + "\">");

  // Make sure that the user selected a record to delete
  if (entity_type_id != null && !entity_type_id.equals ("null"))
  {
    entityTypeObj.load (Integer.parseInt(entity_type_id));
    // Need to make sure that the entity type is not in use
    if (!entityTypeObj.checkInUse (Integer.parseInt(entity_type_id)))
    {
      pageFormater.writeText (out, "Are you sure that you wish to delete the entity type named <b>" + entityTypeObj.getName () + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
    }
    else
    {
      pageFormater.writeText (out, "You are unable to remove this entity type as it is in use.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
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
</form><cms:include property="template" element="foot" />