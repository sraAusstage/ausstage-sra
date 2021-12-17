<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
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

  datasourceObj.load (Integer.parseInt(datasource_id));
  
  // Need to make sure that the datasource is not in use
  if (!datasourceObj.checkInUse (Integer.parseInt(datasource_id)))
  {
    datasourceObj.delete ();
    pageFormater.writeText (out, "You have deleted the data source named <b>" + datasourceObj.getName () + "</b>.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "", "", "", "", "datasource_admin.jsp", "tick.gif");
  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this data source as it is in use.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
  }
  
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%><jsp:include page="../templates/admin-footer.jsp" />