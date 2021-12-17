<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.WebLinks, java.util.*"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
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
  ausstage.WebLinks   webLinksObj  = new ausstage.WebLinks (db_ausstage);
  String              web_links_id;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  web_links_id = request.getParameter ("f_id");

  // Make sure that the user selected a record to delete
  if (web_links_id != null && !web_links_id.equals ("null"))
  {
    webLinksObj.load (Integer.parseInt(web_links_id));
    out.println("<form action='web_links_del_process.jsp' method='post'>");
    out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + web_links_id + "\">");

    String collectionMode = (String)session.getAttribute("collectionMode");

    if (collectionMode.equals("edit"))
    {
      // Need to make sure that the web_links record is not in use
      if (!webLinksObj.checkInUse (Integer.parseInt(web_links_id)))
      {
        pageFormater.writeText (out, "Are you sure that you wish to delete the Web Link named <b>" + webLinksObj.getWebLinksName () + "</b>?");
        pageFormater.writePageTableFooter (out);
        pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
      }
      else
      {
        pageFormater.writeText (out, "You are unable to remove this Web Links record as it is in use.");
        pageFormater.writePageTableFooter (out);
        pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
      }
    }
    else
    {
      Vector allWebLinks = (Vector)session.getAttribute("allWebLinks");
      int webLinksId     = Integer.parseInt(web_links_id);
      webLinksObj        = (WebLinks)allWebLinks.get(webLinksId);
      pageFormater.writeText (out, "Are you sure that you wish to delete the Web Link named <b>" + webLinksObj.getWebLinksName () + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
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
</form>
<jsp:include page="../templates/admin-footer.jsp" />