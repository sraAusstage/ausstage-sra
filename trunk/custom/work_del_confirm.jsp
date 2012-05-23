<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Work"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage   = new ausstage.Database ();
  Work                workObj = new ausstage.Work (db_ausstage);
  String              workid;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  workid = request.getParameter ("f_workid");

  // Make sure that the user selected a record to delete
  if (workid != null && !workid.equals ("null"))
  {
    workObj.load (Integer.parseInt(workid));
    
    out.println("<form action='work_del_process.jsp' method='post'>");
    out.println("<input type=\"hidden\" name=\"f_workid\" value=\"" + workid + "\">");
    if(workObj.isInUse()){
      out.println("Can not delete <b>" + workObj.getWorkTitle() + "</b> because it has an association with the Events or Resource table.<br>Click the back button to continue.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/custom/ausstage/welcome.jsp", "cross.gif");
      
    }
    else{
      pageFormater.writeText (out, "Are you sure that you wish to delete the work named <b>" + workObj.getWorkTitle() + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/custom/ausstage/welcome.jsp", "cross.gif", "submit", "next.gif");
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