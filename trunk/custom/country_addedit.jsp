<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.Country      countryObj     = new ausstage.Country (db_ausstage);
  String              country_id;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  country_id = request.getParameter ("f_id");

  // if editing
  if (country_id != null && !country_id.equals("null"))
    countryObj.load (Integer.parseInt(country_id));%>
  <form action='country_addedit_process.jsp' method='post'>
  <%
  pageFormater.writeHelper(out, "Enter the Country Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + country_id + "\">");

  if (country_id != null && !country_id.equals("null"))
  {
    pageFormater.writeTwoColTableHeader(out, "ID");
    out.println(country_id);
    pageFormater.writeTwoColTableFooter(out);
  }
  pageFormater.writeTwoColTableHeader(out, "Country Name");
  out.println("<input type=\"text\" name=\"f_name\" size=\"20\" class=\"line150\" maxlength=100 value=\"" + countryObj.getName() + "\">");
  pageFormater.writeTwoColTableFooter(out);
  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);
%>
</form><cms:include property="template" element="foot" />