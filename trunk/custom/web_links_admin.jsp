<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.Statement, ausstage.WebLinks, sun.jdbc.rowset.*, java.util.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();

  String        sqlString;
  CachedRowSet  rset;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement              stmt          = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.WebLinks      webLinksObj   = new ausstage.WebLinks (db_ausstage);
  ausstage.Collection    collectionObj = new ausstage.Collection (db_ausstage);

  String collectionId = request.getParameter("h_collection_id");
  String mode         = request.getParameter("mode");

  if (mode == null)
  {
    mode = (String)session.getAttribute("collectionMode");
    collectionObj = (ausstage.Collection)session.getAttribute("collectionObj");
  }
  else
  {
    session.setAttribute("collectionMode", mode);
    collectionObj.setCollectionInformationId
                                       (request.getParameter("h_collection_id"));
    collectionObj.setEntity            (request.getParameter("f_entity"));
    collectionObj.setCollectionName    (request.getParameter("f_collection_name"));
    collectionObj.setDescription       (request.getParameter("f_description"));
    collectionObj.setSize              (request.getParameter("f_size"));
    collectionObj.setLocation          (request.getParameter("f_location"));
    collectionObj.setAccess            (request.getParameter("f_access"));
    collectionObj.setAccessOtherDetail (request.getParameter("f_access_other_detail"));
    collectionObj.setRelatedSources    (request.getParameter("f_related_sources"));
    collectionObj.setComments          (request.getParameter("f_comments"));
    collectionObj.setMaterials         (request.getParameterValues("f_materials"));

    if (collectionObj.getAccess().length() == 0)
      collectionObj.setAccess("0");
    
    session.setAttribute("collectionObj", collectionObj);
  }
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  out.println("<form action='web_links_addedit.jsp' name='content_form' id='content_form' method='post'>");

  pageFormater.writeHelper(out, "Web Links Maintenance", "helpers_no1.gif");

  rset = webLinksObj.getAllWebLinks (stmt);
  int currentCollectionId = 0;
  int thisCollectionId    = 0;
  boolean gotOne = false;
  
  if (mode.equals("edit"))
  {
    while (rset.next ())
    {
      currentCollectionId = Integer.parseInt(collectionObj.getCollectionInformationId());
      thisCollectionId = Integer.parseInt(rset.getString("collection_information_id"));
      if (thisCollectionId == currentCollectionId)
      {
        gotOne = true;
        break;
      }
    }
    
    if (gotOne)
    {
      pageFormater.writeTwoColTableHeader(out, "Web Links");
      out.println("<select name='f_id' class='line250' size='15'>");
      // We have at least one web_links record
      do
      {
        thisCollectionId = Integer.parseInt(rset.getString("collection_information_id"));
        if (thisCollectionId != currentCollectionId) continue;
        out.println("<option value='" + rset.getString("www_id") + "'>" +
            rset.getString ("weblinks") + "</option>");
      } while (rset.next());
      out.println("</select>");
      pageFormater.writeTwoColTableFooter(out);
    }
  }
  else
  {
    WebLinks webLink;
    Vector allWebLinks = (Vector)session.getAttribute("allWebLinks");
    
    if (allWebLinks != null && allWebLinks.size() > 0)
    {
      pageFormater.writeTwoColTableHeader(out, "Web Links");
      out.println("<select name='f_id' class='line250' size='15'>");
      // We have at least one web_links record
      for (int i=0; i < allWebLinks.size(); i++)
      {
        webLink = (WebLinks)allWebLinks.get(i);
        out.println("<option value='" + i + "'>" + webLink.getWebLinksName() + "</option>");
      }
      out.println("</select>");
      pageFormater.writeTwoColTableFooter(out);
    }
  }
  pageFormater.writeTwoColTableHeader(out, "");
%>
  <input type='button' name='submit_button' value='Add' onclick="Javascript:location.href='web_links_addedit.jsp';">&nbsp;&nbsp;
  <input type='submit' name='submit_button' value='Edit'>&nbsp;&nbsp;
  <input type='button' name='submit_button' value='Delete' onclick="Javascript:content_form.action='web_links_del_confirm.jsp';content_form.submit();">
  <input type='button' name='submit_button' value='Finish' onclick="Javascript:content_form.action='collection_addedit.jsp';content_form.submit();">
<%
  pageFormater.writeTwoColTableFooter(out);
  rset.close ();
  stmt.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />