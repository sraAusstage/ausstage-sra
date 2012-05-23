<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
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

  // if editing
  if (entity_type_id != null)
    entityTypeObj.load (Integer.parseInt(entity_type_id));%>
  <form action='entity_type_addedit_process.jsp' method='post'>
  <%
  pageFormater.writeHelper(out, "Enter the Entity Type Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + entity_type_id + "\">");
  pageFormater.writeTwoColTableHeader(out, "ID");
  if (entity_type_id != null && !entity_type_id.equals(""))
    out.println(entity_type_id);
  pageFormater.writeTwoColTableFooter(out);  
  pageFormater.writeTwoColTableHeader(out, "Entity Type Name");
  out.println("<input type=\"text\" name=\"f_name\" size=\"20\" class=\"line150\" maxlength=100 value=\"" + entityTypeObj.getName() + "\">");
  pageFormater.writeTwoColTableFooter(out);
  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);
%>
</form>

<cms:include property="template" element="foot" />
