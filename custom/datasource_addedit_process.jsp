<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />


<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage   = new ausstage.Database ();
  ausstage.Datasource datasourceObj = new ausstage.Datasource (db_ausstage);
  String              datasource_id;
  CachedRowSet        rset;
  boolean             error_occurred = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  datasource_id = request.getParameter ("f_id");
  
  // if editing set the object to the selected record
  if (datasource_id != null && !datasource_id.equals ("") && !datasource_id.equals ("null"))
    datasourceObj.load (Integer.parseInt(datasource_id));

  datasourceObj.setName(request.getParameter("f_name"));
  datasourceObj.setDescription(request.getParameter("f_description"));

  // if editing
  if (datasource_id != null && !datasource_id.equals ("") && !datasource_id.equals ("null"))
    error_occurred = !datasourceObj.update();
  else // Adding
    error_occurred = !datasourceObj.add();

  // Error
  if (error_occurred)
    pageFormater.writeText (out,datasourceObj.getError());
  else
    pageFormater.writeText (out,"The data source <b>" + datasourceObj.getName() + "</b> was successfully saved");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "", "", "", "", "datasource_admin.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />