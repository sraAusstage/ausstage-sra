<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Collection Information Access Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage    pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage   = new ausstage.Database ();
  ausstage.EntityType entityTypeObj = new ausstage.EntityType (db_ausstage);
  String              entity_type_id;
  CachedRowSet        rset;
  boolean             error_occurred = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  entity_type_id = request.getParameter ("f_id");
  
  // if editing set the object to the selected record
  if (entity_type_id != null && !entity_type_id.equals ("") && !entity_type_id.equals ("null"))
    entityTypeObj.load (Integer.parseInt(entity_type_id));

  entityTypeObj.setName(request.getParameter("f_name"));

  // if editing
  if (entity_type_id != null && !entity_type_id.equals ("") && !entity_type_id.equals ("null"))
    error_occurred = !entityTypeObj.update();
  else // Adding
    error_occurred = !entityTypeObj.add();

  // Error
  if (error_occurred)
    pageFormater.writeText (out,entityTypeObj.getError());
  else
    pageFormater.writeText (out,"The entity type <b>" + entityTypeObj.getName() + "</b> was successfully saved");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "", "", "", "", "entity_type_admin.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>

<jsp:include page="../templates/admin-footer.jsp" />