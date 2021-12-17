<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Collection Information Access Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  
  String        sqlString;
  CachedRowSet  rset;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement              stmt          = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.EntityType    entityTypeObj = new ausstage.EntityType (db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);%>
  <form action='entity_type_addedit.jsp' name='content_form' id='content_form' method='post'><%

  pageFormater.writeHelper(out, "Entity Type Maintenance", "helpers_no1.gif");
  rset = entityTypeObj.getEntityTypes (stmt);

  if (rset.next ())
  {
    pageFormater.writeTwoColTableHeader(out, "Entity Type Name");%>
    <select name='f_id' class='line250' size='15'><%
    // We have at least one entity type
    do
    {%>
      <option value='<%=rset.getString ("entity_type_id")%>'><%=rset.getString ("type")%></option><%
    }
    while (rset.next ());%>
    </select><%
    pageFormater.writeTwoColTableFooter(out);
  }

  pageFormater.writeTwoColTableHeader(out, "");%>
  <input type='button' name='submit_button' value='Add' onclick="Javascript:location.href='entity_type_addedit.jsp';">&nbsp;&nbsp;
  <input type='submit' name='submit_button' value='Edit'>&nbsp;&nbsp;
  <input type='button' name='submit_button' value='Delete' onclick="Javascript:content_form.action='entity_type_del_confirm.jsp';content_form.submit();"><%
  pageFormater.writeTwoColTableFooter(out);
  rset.close ();
  stmt.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<jsp:include page="../templates/admin-footer.jsp" />