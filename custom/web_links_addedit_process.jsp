<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.WebLinks, java.util.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login          = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater   = (admin.FormatPage)    session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage    = new ausstage.Database ();
  ausstage.WebLinks   webLinksObj    = new ausstage.WebLinks (db_ausstage);
  ausstage.Collection collectionObj  = new ausstage.Collection (db_ausstage);
  String              collectionMode = (String)session.getAttribute("collectionMode");
  String              web_links_id   = null;
  CachedRowSet        rset           = null;
  boolean             error_occurred = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  Vector allWebLinks = null;
  collectionObj = (ausstage.Collection)session.getAttribute("collectionObj");
  if (collectionMode.equals("add"))
  {
    allWebLinks = (Vector)session.getAttribute("allWebLinks");
  }
  
  web_links_id = request.getParameter ("f_id");

  // if editing set the object to the selected record
  if (web_links_id != null && !web_links_id.equals ("") && !web_links_id.equals ("null"))
  {
    if (collectionMode.equals("edit"))
      webLinksObj.load (Integer.parseInt(web_links_id));
    else
      webLinksObj = (WebLinks)allWebLinks.get(Integer.parseInt(web_links_id));
  }
  
  webLinksObj.setCollectionId(request.getParameter("f_collection_id"));
  webLinksObj.setWebLinksName(request.getParameter("f_web_links_name"));
  webLinksObj.setWebLinksDescription(request.getParameter("f_web_links_description"));

  // if editing
  if (web_links_id != null && !web_links_id.equals ("") && !web_links_id.equals ("null"))
  {
    if (collectionMode.equals("edit"))
      error_occurred = !webLinksObj.update();
    else
      allWebLinks.set(Integer.parseInt(web_links_id), webLinksObj);
  }
  else // Adding
  {
    if (collectionMode.equals("edit"))
      error_occurred = !webLinksObj.add();
    else
      allWebLinks.add(webLinksObj);
  }

  // Error
  if (error_occurred)
     pageFormater.writeText(out, webLinksObj.getError());
  else
     pageFormater.writeText(out, "The Web Links record <b>" + webLinksObj.getWebLinksName() + "</b> was successfully saved");

  if (collectionMode.equals("add"))
    session.setAttribute("allWebLinks", allWebLinks);

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "", "", "", "", "web_links_admin.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />