<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin   login           = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  ausstage.Organisation organisationObj = new ausstage.Organisation (db_ausstage);
  String                organisation_id;
  CachedRowSet          rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  organisation_id = request.getParameter ("f_organisation_id");

  organisationObj.load (Integer.parseInt(organisation_id));

  %>
  <form action='organisation_del_process.jsp' method='post'>
  <%
  out.println("<input type=\"hidden\" name=\"f_org_id\" value=\"" + organisation_id + "\">");
  
  // Need to make sure that the organisation is not in use
  if (!organisationObj.checkInUse (Integer.parseInt(organisation_id)))
  {
    pageFormater.writeText (out, "Are you sure that you wish to delete the organisation named <b>" + organisationObj.getName () + "</b>?");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this organisation as it is in use.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
  }
  
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
</form>

<cms:include property="template" element="foot" />