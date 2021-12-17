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
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Collection collection       = new ausstage.Collection (db_ausstage);

  session.removeAttribute("collectionObj"); // Kept in session in case Web Links editted.
  session.removeAttribute("collectionMode"); // Indicates if adding or editting a Collection.
  session.removeAttribute("allWebLinks");   // Kept in session when collectionMode = add.

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
%>
  <form action='collection_addedit.jsp?mode=edit' name='content_form' id='content_form' method='post'><%

  pageFormater.writeHelper(out, "Collection Maintenance", "helpers_no1.gif");


  rset = collection.getCollectionsWithEntity();

  if (rset.next ())
  {
    pageFormater.writeTwoColTableHeader(out, "Collection");%>
    <select name='f_id' class='line350' size='15'><%
    // We have at least one collection
    do
    {%>
      <option value='<%=rset.getString ("collection_information_id")%>'><%=rset.getString ("collection_name")%>, <%=rset.getString ("name")%></option><%
    }
    while (rset.next ());%>
    </select><%
    pageFormater.writeTwoColTableFooter(out);
  }

  pageFormater.writeTwoColTableHeader(out, "");%>
  <input type='button' name='submit_button' value='Add' onclick="Javascript:location.href='collection_addedit.jsp?mode=add';">&nbsp;&nbsp;
  <input type='submit' name='submit_button' value='Edit/View'>&nbsp;&nbsp;
  <input type='button' name='submit_button' value='Delete' onclick="Javascript:content_form.action='collection_del_confirm.jsp';content_form.submit();"><%
  pageFormater.writeTwoColTableFooter(out);
  rset.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%><jsp:include page="../templates/admin-footer.jsp" />
