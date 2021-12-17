<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Country"%>
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
  ausstage.LookupCode lookupCodeObj   = new ausstage.LookupCode (db_ausstage);
  String              lookupCode_id;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  lookupCode_id = request.getParameter ("f_id");

  %>
  <form action='lookupcode_del_process.jsp' method='post'>
  <%
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + lookupCode_id + "\">");

  // Make sure that the user selected a record to delete
  if (lookupCode_id != null && !lookupCode_id.equals ("null"))
  {
    lookupCodeObj.load (Integer.parseInt(lookupCode_id));
    // Need to make sure that the lookup type is not in use
    if (!(lookupCodeObj.getSystemCode()))
    {
      pageFormater.writeText (out, "Are you sure that you wish to delete the Lookup Code named <b>" + lookupCodeObj.getShortCode() + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "lookuptype_search.jsp", "cross.gif", "submit", "next.gif");
    }
    else
    {
      pageFormater.writeText (out, "You are unable to remove this lookup type as it is in use.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "lookuptype_search.jsp", "cross.gif", "", "");
    }
  }
  else
  {
    pageFormater.writeText (out, "Please select a record to remove.");
    pageFormater.writePageTableFooter (out);
     pageFormater.writeButtons(out, "back", "prev.gif", "lookuptype_search.jsp", "cross.gif", "", "");
  }
  
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />