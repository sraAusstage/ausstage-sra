<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue, java.util.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin login          = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater   = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage    = new ausstage.Database ();
  ausstage.WebLinks   webLinksObj    = new ausstage.WebLinks (db_ausstage);
  ausstage.Collection collectionObj  = new ausstage.Collection (db_ausstage);
  String              web_links_id   = null;
  String              collectionId   = null;
  CachedRowSet        rset           = null;
  Vector              allWebLinks    = null;
  String              collectionMode = (String)session.getAttribute("collectionMode");
  
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  web_links_id = request.getParameter ("f_id");
  
  if (web_links_id == null) // Adding a Web Link record
  {
    collectionObj = (ausstage.Collection)session.getAttribute("collectionObj");    
    collectionId  = collectionObj.getCollectionInformationId();
    if (collectionMode.equals("add"))
    {
      // Set up an empty Vector for the Web Links, if there isn't one already
      allWebLinks   = (Vector)session.getAttribute("allWebLinks");
      if (allWebLinks == null)
      {
        allWebLinks = new Vector();
        session.setAttribute("allWebLinks", allWebLinks);
      }
    }
  }
  else // Editting a Web Link record
  {
    collectionObj = (ausstage.Collection)session.getAttribute("collectionObj");    
    collectionId  = collectionObj.getCollectionInformationId();
    if (collectionMode.equals("add"))
    {
      allWebLinks = (Vector)session.getAttribute("allWebLinks");
      webLinksObj = (ausstage.WebLinks)allWebLinks.get(Integer.parseInt(web_links_id));
    }
    else
    {
      webLinksObj.load (Integer.parseInt(web_links_id));
    }
  }

  out.println("<form action='web_links_addedit_process.jsp' method='post'>");
  pageFormater.writeHelper(out, "Enter the Web Links Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + web_links_id + "\">");
  out.println("<input type=\"hidden\" name=\"f_collection_id\" value=\"" + collectionId + "\">");

  pageFormater.writeTwoColTableHeader(out, "Web Link");
  out.println("<input type=\"text\" name=\"f_web_links_name\" size=\"20\" class=\"line150\" maxlength=500 value=\"" + webLinksObj.getWebLinksName() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Description");
  out.println("<textarea name=\"f_web_links_description\" rows='5' cols='10' class='line300'>" + webLinksObj.getWebLinksDescription() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />