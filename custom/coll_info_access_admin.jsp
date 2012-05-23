<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();

  String        sqlString;
  CachedRowSet  rset;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement               stmt           = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator  htmlGenerator  = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.CollInfoAccess collInfoAccess = new ausstage.CollInfoAccess (db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

%>
  <form action='coll_info_access_addedit.jsp' name='content_form' id='content_form' method='post'><%

  pageFormater.writeHelper(out, "Collection Information Access Maintenance", "helpers_no1.gif");
  rset = collInfoAccess.getCollInfoAccesses ();

  if (rset != null && rset.next ())
  {
    pageFormater.writeTwoColTableHeader(out, "Collection Information Access");%>
    <select name='f_id' class='line250' size='15'><%
    // We have at least one collection_info_access record
    do
    {%>
      <option value='<%=rset.getString ("collection_info_access_id")%>'><%=rset.getString ("coll_access")%></option><%
    }
    while (rset.next ());%>
    </select><%
    pageFormater.writeTwoColTableFooter(out);
  rset.close ();
  stmt.close ();
  }

  pageFormater.writeTwoColTableHeader(out, "");%>
  <input type='button' name='submit_button' value='Add' onclick="Javascript:location.href='coll_info_access_addedit.jsp';">&nbsp;&nbsp;
  <input type='submit' name='submit_button' value='Edit'>&nbsp;&nbsp;
  <input type='button' name='submit_button' value='Delete' onclick="Javascript:content_form.action='coll_info_access_del_confirm.jsp';content_form.submit();"><%
  pageFormater.writeTwoColTableFooter(out);
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%><cms:include property="template" element="foot" />
