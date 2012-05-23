<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.CollInfoAccess"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin     login             = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage        pageFormater      = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database          db_ausstage       = new ausstage.Database ();
  ausstage.CollInfoAccess collInfoAccessObj = new ausstage.CollInfoAccess (db_ausstage);
  String                  collection_info_access_id;
  CachedRowSet            rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  collection_info_access_id = request.getParameter ("f_id");
  // if editing
  if (collection_info_access_id != null)
    collInfoAccessObj.load (Integer.parseInt(collection_info_access_id));

  out.println("<form action='coll_info_access_addedit_process.jsp' method='post'>");

  pageFormater.writeHelper(out, "Enter the Collection Information Access Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + collection_info_access_id + "\">");

  // Coll Access
  pageFormater.writeTwoColTableHeader(out, "ID");
  if(collection_info_access_id != null)
    out.println(collection_info_access_id);
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "Collection Access");
  out.println("<input type='text' name='f_coll_access' size='20' class='line150' maxlength=50 value='" +
              collInfoAccessObj.getCollAccess() + "'>");
  pageFormater.writeTwoColTableFooter(out);

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", "coll_info_access_admin.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />
