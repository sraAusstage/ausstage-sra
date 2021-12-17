<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Materials"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
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
  boolean             error_occurred = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  material_id = request.getParameter ("f_id");

  // if editing set the object to the selected record
  if (material_id != null && !material_id.equals ("") && !material_id.equals ("null"))
    materialsObj.load (Integer.parseInt(material_id));

  materialsObj.setMaterials(request.getParameter("f_materials"));

  // if editing
  if (material_id != null && !material_id.equals ("") && !material_id.equals ("null"))
    error_occurred = !materialsObj.update();
  else // Adding
    error_occurred = !materialsObj.add();

  // Error
  if (error_occurred)
    pageFormater.writeText(out, materialsObj.getError());
  else
    pageFormater.writeText(out, "The materials <b>" + materialsObj.getMaterials() + "</b> was successfully saved");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "", "", "", "", "materials_admin.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />