<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.WebLinks, java.util.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
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

  String collectionMode = (String)session.getAttribute("collectionMode");

  if (collectionMode.equals("edit"))
  {
    webLinksObj.load (Integer.parseInt(web_links_id));
    // Need to make sure that the web_links is not in use
    if (!webLinksObj.checkInUse (Integer.parseInt(web_links_id)))
    {
      webLinksObj.delete ();
      pageFormater.writeText (out, "You have deleted the Web Link named <b>" + webLinksObj.getWebLinksName () + "</b>.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "", "", "", "", "web_links_admin.jsp", "tick.gif");
    }
    else
    {
      pageFormater.writeText (out, "You are unable to remove this Web Links record as it is in use.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
    }
  }
  else
  {
    Vector allWebLinks = (Vector)session.getAttribute("allWebLinks");
    int webLinksId     = Integer.parseInt(web_links_id);
    webLinksObj        = (WebLinks)allWebLinks.remove(webLinksId);
    session.setAttribute("allWebLinks", allWebLinks);
    
    pageFormater.writeText (out, "You have deleted the Web Link named <b>" + webLinksObj.getWebLinksName () + "</b>.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "", "", "", "", "web_links_admin.jsp", "tick.gif");
  }
  
  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />