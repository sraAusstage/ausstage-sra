<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Entity"%>
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
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.Entity     entityObj    = new ausstage.Entity (db_ausstage);
  String              entity_id;
  CachedRowSet        rset;
  String f_referrer                = request.getParameter("f_from");
  String coll_id                   = request.getParameter("coll_id");
  
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  entity_id = request.getParameter ("f_id");

  // Make sure that the user selected a record to delete
  if (entity_id != null && !entity_id.equals ("null"))
  {
    entityObj.load (Integer.parseInt(entity_id));
    out.println("<form action='entity_del_process.jsp' method='post'>");
    out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + entity_id + "\">");
    
    if(f_referrer != null){
      out.println("<input type=\"hidden\" name=\"f_from\" value=\"" + f_referrer + "\">");
      out.println("<input type=\"hidden\" name=\"coll_id\" value=\"" + coll_id + "\">");
    }
    
    // Need to make sure that the entity is not in use
    if (!entityObj.checkInUse (Integer.parseInt(entity_id)))
    {
      pageFormater.writeText (out, "Are you sure that you wish to delete the entity named <b>" + entityObj.getName () + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
    }
    else
    {
      pageFormater.writeText (out, "You are unable to remove this entity as it is in use.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
    }
  }
  else
  {
    pageFormater.writeText (out, "Please select a record to remove.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
  }
 
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
</form><jsp:include page="../templates/admin-footer.jsp" />