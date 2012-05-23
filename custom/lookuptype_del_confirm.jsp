<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Country"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.LookupType    lookupTypeObj   = new ausstage.LookupType (db_ausstage);
  String              lookupType_ID;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  lookupType_ID = request.getParameter ("f_lookuptype_id");

  %>
  <form action='lookuptype_del_process.jsp' method='post'>
  <%
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + lookupType_ID + "\">");

  // Make sure that the user selected a record to delete
  if (lookupType_ID != null && !lookupType_ID.equals ("null"))
  {
    lookupTypeObj.load (Integer.parseInt(lookupType_ID));
    // Need to make sure that the country is not in use
    if (!(lookupTypeObj.getSystemFlag()))
    {
      pageFormater.writeText (out, "Are you sure that you wish to delete the Lookup Code named <b>" + lookupTypeObj.getCodeType() + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
    }
    else
    {
      pageFormater.writeText (out, "You are unable to remove this Lookup Type as the System Flag is set to true.");
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
</form>
<cms:include property="template" element="foot" />