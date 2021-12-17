<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  	admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
    if (!session.getAttribute("permissions").toString().contains("DataSource Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
		response.sendRedirect("/custom/welcome.jsp" );
		return;
	}
  admin.FormatPage    pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage   = new ausstage.Database ();
  ausstage.Datasource datasourceObj = new ausstage.Datasource (db_ausstage);
  String              datasource_id;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  datasource_id = request.getParameter ("f_id");

  // if editing
  if (datasource_id != null)
    datasourceObj.load (Integer.parseInt(datasource_id));%>
  <form action='datasource_addedit_process.jsp' method='post' name="ContentForm" id="ContentForm">
  <%
  pageFormater.writeHelper(out, "Enter the Data Source Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + datasource_id + "\">");
  
  if (datasource_id != null){
    pageFormater.writeTwoColTableHeader(out, "ID");
    out.println(datasource_id);
    pageFormater.writeTwoColTableFooter(out);
  }
  pageFormater.writeTwoColTableHeader(out, "Data Source Name");
  out.println("<input type=\"text\" name=\"f_name\" size=\"40\" class=\"line150\" maxlength=40 value=\"" + datasourceObj.getName() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Description");
  out.println("<textarea name=\"f_description\" rows=\"10\" cols=\"50\" class=\"line250\">" + datasourceObj.getDescription() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "Javascript:vaildateForm()", "next.gif");
  pageFormater.writeFooter(out);
%>
</form>

<script language="Javascript">
function vaildateForm()
{
  if (document.ContentForm.f_name.value == '')
    alert ("Please enter a Data Source Name");
  else
    document.ContentForm.submit();
}
</script>
<jsp:include page="../templates/admin-footer.jsp" />