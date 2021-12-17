<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Primary Genre Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
%>
  <form name='content_form' id='content_form' method='post'>
<%
  pageFormater.writeHelper(out, "Primary Genre Maintenance", "helpers_no1.gif");
  ausstage.PrimaryGenre primary_genre = new ausstage.PrimaryGenre(db_ausstage);
  CachedRowSet rset = primary_genre.getNames();
  if (rset.next())
  {
    pageFormater.writeTwoColTableHeader(out, "Primary Genre");
%>
    <select name='f_selected_primary_genre_id' class='line250' size='15'>
<%
    // We have at least one primary genre
    do
    {
%>
      <option value='<%=rset.getString ("GENRECLASSID")%>'><%=rset.getString ("GENRECLASS")%></option>
<%
    }
    while (rset.next ());
%>
    </select>
<%
    pageFormater.writeTwoColTableFooter(out);
  }
  pageFormater.writeTwoColTableHeader(out, "");
%>
  <input type='button' name='submit_button' value='Add' onclick="Javascript:location.href='primary_genre_addedit.jsp?act=add';">&nbsp;&nbsp;
  <input type='button' name='submit_button' value='Edit/View' onclick="Javascript:content_form.action='primary_genre_addedit.jsp?act=edit';content_form.submit();">&nbsp;&nbsp;
  <input type='button' name='submit_button' value='Delete' onclick="Javascript:content_form.action='primary_genre_del_confirm.jsp';content_form.submit();">
  </form>
<%
  pageFormater.writeTwoColTableFooter(out);
  rset.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<jsp:include page="../templates/admin-footer.jsp" />