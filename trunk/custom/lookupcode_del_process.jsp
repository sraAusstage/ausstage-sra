<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Country"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.LookupCode    lookupCodeObj   = new ausstage.LookupCode (db_ausstage);
  String              lookupCode_id;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  lookupCode_id = request.getParameter ("f_id");

  lookupCodeObj.load (Integer.parseInt(lookupCode_id));
  
  // Need to make sure that the country is not in use

  
  if (!(lookupCodeObj.getSystemCode()))
  {
      lookupCodeObj.delete ();
      pageFormater.writeText (out, "You have deleted the Lookup Code named <b>" + lookupCodeObj.getShortCode() + "</b>.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "", "", "", "", "lookupcode_admin.jsp?f_code_type=" + lookupCodeObj.getCodeType(), "tick.gif");

  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this Lookup Code as the System Flag is set to true.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
  }
  
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />