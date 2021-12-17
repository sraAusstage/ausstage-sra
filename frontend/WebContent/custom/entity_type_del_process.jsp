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

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  entity_type_id = request.getParameter ("f_id");

  entityTypeObj.load (Integer.parseInt(entity_type_id));
  
  // Need to make sure that the entity type is not in use
  if (!entityTypeObj.checkInUse (Integer.parseInt(entity_type_id)))
  {
    entityTypeObj.delete ();
    pageFormater.writeText (out, "You have deleted the entity type named <b>" + entityTypeObj.getName () + "</b>.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "", "", "", "", "entity_type_admin.jsp", "tick.gif");
  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this entity type as it is in use.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
  }
  
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%><jsp:include page="../templates/admin-footer.jsp" />