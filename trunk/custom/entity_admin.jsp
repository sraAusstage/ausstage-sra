<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
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
  Statement              stmt          = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Entity        entity        = new ausstage.Entity (db_ausstage);
  String f_referrer                    = request.getParameter("f_from");
  String coll_id                       = request.getParameter("coll_id");
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);%>
  <form action='entity_addedit.jsp' name='content_form' id='content_form' method='post'><%
  if(f_referrer != null){
    out.println("<input type=\"hidden\" name=\"f_from\" value='" + f_referrer + "'>");
    out.println("<input type=\"hidden\" name=\"coll_id\" value='" + coll_id + "'>");
  }

  pageFormater.writeHelper(out, "Entity Maintenance", "helpers_no1.gif");
  rset = entity.getEntities (stmt);

  if (rset.next ())
  {
    pageFormater.writeTwoColTableHeader(out, "Entity");%>
    <select name='f_id' class='line250' size='15'><%
    // We have at least one entity
    do
    {%>
      <option value='<%=rset.getString ("entity_id")%>'><%=rset.getString ("name")%></option><%
    }
    while (rset.next ());%>
    </select><%
    pageFormater.writeTwoColTableFooter(out);
  }

  pageFormater.writeTwoColTableHeader(out, "");%>
  <input type='button' name='submit_button' value='Add' onclick="Javascript:location.href='entity_addedit.jsp?f_from=<%=f_referrer%>&coll_id=<%=coll_id%>';">&nbsp;&nbsp;
  <input type='submit' name='submit_button' value='Edit/View'>&nbsp;&nbsp;
  <input type='button' name='submit_button' value='Delete' onclick="Javascript:content_form.action='entity_del_confirm.jsp?f_from=<%=f_referrer%>&coll_id=<%=coll_id%>';content_form.submit();"><%
  pageFormater.writeTwoColTableFooter(out);
  rset.close ();
  stmt.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />