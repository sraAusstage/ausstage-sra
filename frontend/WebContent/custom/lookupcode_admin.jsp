<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Lookups Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
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
  ausstage.LookupCode lookupCode       = new ausstage.LookupCode (db_ausstage);
  String code_type = request.getParameter("f_code_type");

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
%>
  <form action='lookupcode_addedit.jsp' name='content_form' id='content_form' method='post'><%

    out.println("<input type=\"hidden\" name=\"f_code_type\" value=\"" + code_type + "\">");
    pageFormater.writeTwoColTableHeader(out, "Code Type");
    //pageFormater.writeHelper(out, "Code Type", "helpers_no1.gif");
    out.println(code_type);
    pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeHelper(out, "Lookup Codes", "helpers_no1.gif");
  rset = lookupCode.getLookupCodes(code_type);

  if (rset.next ())
  {
    pageFormater.writeTwoColTableHeader(out, "Lookup Code");%>
    <select name='f_id' class='line350' size='15'><%
    // We have at least one country
    do
    {%>
      <option value='<%=rset.getString ("code_lov_id")%>'><%=rset.getString ("short_code")%></option><%
    }
    while (rset.next ());%>
    </select><%
    pageFormater.writeTwoColTableFooter(out);
  }

  pageFormater.writeTwoColTableHeader(out, "");%>
  <input type='button' name='submit_button' value='Add' onclick="Javascript:location.href='lookupcode_addedit.jsp?f_code_type=<%=code_type%>';">&nbsp;&nbsp;
  <input type='submit' name='submit_button' value='Edit'>&nbsp;&nbsp;
  <input type='button' name='submit_button' value='Delete' onclick="Javascript:content_form.action='lookupcode_del_confirm.jsp';content_form.submit();"><%
  pageFormater.writeTwoColTableFooter(out);
  rset.close ();
  stmt.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<jsp:include page="../templates/admin-footer.jsp" />