<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Work"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Works Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  Work            			workObj        = new Work (db_ausstage);
  String                workid;
  boolean               deleted         = false;
  String                error           = "";
  CachedRowSet          rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  workid = request.getParameter ("f_workid");

  workObj.load (Integer.parseInt(workid));
  
  deleted = workObj.deleteWork ();
  if(deleted){
    pageFormater.writeText (out, "You have deleted the work named <b>" + workObj.getWorkTitle() + "</b>.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "", "", "", "", "work_search.jsp", "tick.gif");
  }
  else{
    error = workObj.getErrorMessage();
    pageFormater.writeText (out, error);
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
<jsp:include page="../templates/admin-footer.jsp" />