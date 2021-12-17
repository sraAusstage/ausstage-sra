<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.CollInfoAccess"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
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
  ausstage.CollInfoAccess collInfoAccessObj = new ausstage.CollInfoAccess (db_ausstage);
  String                  collection_info_access_id;
  CachedRowSet            rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  collection_info_access_id = request.getParameter ("f_id");

  // Make sure that the user selected a record to delete
  if (collection_info_access_id != null && !collection_info_access_id.equals ("null"))
  {
    collInfoAccessObj.load (Integer.parseInt(collection_info_access_id));
    out.println("<form action='coll_info_access_del_process.jsp' method='post'>");
    out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + collection_info_access_id + "\">");
    // Need to make sure that the collection info access record is not in use
    if (!collInfoAccessObj.checkInUse (Integer.parseInt(collection_info_access_id)))
    {
      pageFormater.writeText (out, "Are you sure that you wish to delete the collection info access record named <b>" + collInfoAccessObj.getCollAccess () + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/custom/ausstage/coll_info_access_admin.jsp", "cross.gif", "submit", "next.gif");
    }
    else
    {
      pageFormater.writeText (out, "You are unable to remove this collection info access record as it is in use.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/custom/ausstage/coll_info_access_admin.jsp", "cross.gif", "", "");
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