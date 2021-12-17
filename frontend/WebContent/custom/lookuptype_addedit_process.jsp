<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Lookups Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.LookupType    lookupTypeObj   = new ausstage.LookupType (db_ausstage);
  String              id;
  CachedRowSet        rset;
  boolean             error_occurred = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  id = request.getParameter("f_id");

  // if editing set the object to the selected record
  if (id != null && !id.equals ("") && !id.equals ("null"))
    lookupTypeObj.load(Integer.parseInt(id));

  lookupTypeObj.setCodeType(request.getParameter("f_code_type"));
  lookupTypeObj.setDescription(request.getParameter("f_description"));
  
  lookupTypeObj.setSystemFlag(request.getParameter("f_system_flag"));


  // if editing
  if (id != null && !id.equals ("") && !id.equals ("null"))
    error_occurred = !lookupTypeObj.update();
  else // Adding
    error_occurred = !lookupTypeObj.add();

  // Error
  if (error_occurred)
    pageFormater.writeText (out, lookupTypeObj.getError());
  else
    pageFormater.writeText (out, "The Lookup Type <b>" + lookupTypeObj.getCodeType() + "</b> was successfully saved");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  if (error_occurred) {
    pageFormater.writeButtons(out, "back", "prev.gif", "", "", "", "");
  }
  else {
    pageFormater.writeButtons(out, "", "", "", "", "lookuptype_search.jsp", "tick.gif");
  }
  
  pageFormater.writeFooter(out);
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />