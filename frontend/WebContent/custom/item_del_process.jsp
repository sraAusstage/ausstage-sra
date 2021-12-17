<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Item"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  Item            			itemObj        = new Item (db_ausstage);
  String                itemid;
  boolean               deleted         = false;
  String                error           = "";
  CachedRowSet          rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  itemid = request.getParameter ("f_itemid");

  itemObj.load (Integer.parseInt(itemid));
  

  deleted = itemObj.deleteItem ();
  if(deleted){
    pageFormater.writeText (out, "You have deleted the item.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "", "", "", "", "item_search.jsp", "tick.gif");
  }
  else{
    error = itemObj.getError();
    pageFormater.writeText (out, error);
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%><jsp:include page="../templates/admin-footer.jsp" />