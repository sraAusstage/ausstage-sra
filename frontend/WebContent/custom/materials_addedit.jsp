<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Materials"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.Materials  materialsObj = new ausstage.Materials (db_ausstage);
  String              material_id;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  material_id = request.getParameter ("f_id");
  // if editing
  if (material_id != null)
    materialsObj.load (Integer.parseInt(material_id));%>
  <form action='materials_addedit_process.jsp' method='post'>
  <%
  pageFormater.writeHelper(out, "Enter the Materials Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + material_id + "\">");
  pageFormater.writeTwoColTableHeader(out, "ID");
  out.println(material_id);
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "Materials");
  out.println("<input type=\"text\" name=\"f_materials\" size=\"20\" class=\"line150\" maxlength=50 value=\"" + materialsObj.getMaterials() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />