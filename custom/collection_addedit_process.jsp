<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.util.Vector, ausstage.WebLinks, java.sql.Statement, sun.jdbc.rowset.*, ausstage.Collection"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin   login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  ausstage.Collection   collectionObj   = new ausstage.Collection (db_ausstage);
  ausstage.WebLinks     webLinksObj     = new ausstage.WebLinks (db_ausstage);
  ausstage.MaterialLink materialLinkObj = new ausstage.MaterialLink(db_ausstage);
  CachedRowSet          rset;
  boolean               error_occurred          = false;
  boolean               weblinks_error_occurred = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  // Get the collection information id first
  String collectionInformationId = request.getParameter ("f_id");
  if (collectionInformationId == null      ||
      collectionInformationId.equals("") ||
      collectionInformationId.equals("null"))
    collectionInformationId = "-1";

  // if editing set the object to the selected record
  if (!collectionInformationId.equals ("-1"))
    collectionObj.load (Integer.parseInt(collectionInformationId));

  collectionObj.setInputPerson((String)session.getAttribute("fullUserName"));
  
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

  // if editing
  if (!collectionInformationId.equals ("-1"))
  {
    error_occurred = !collectionObj.update();
    if (!error_occurred) // Need to insert all MaterialLinks into Table from String array
    {
      error_occurred = !materialLinkObj.update(collectionInformationId,
                                               collectionObj.getMaterialsArray());
    }
  }
  else // Adding
  {
    error_occurred = !collectionObj.add();
    collectionInformationId = collectionObj.getCollectionInformationId(); // Get the new record ID
    if (!error_occurred) // Need to insert all MaterialLinks into Table from String array
    {
      error_occurred = !materialLinkObj.add(collectionInformationId,
                                            collectionObj.getMaterialsArray());
      if (!error_occurred) // Need to insert all WebLinks into Table from Vector
      {
        Vector allWebLinks = (Vector)session.getAttribute("allWebLinks");
        for (int i=0; allWebLinks != null && i < allWebLinks.size() && !weblinks_error_occurred; i++)
        {
          webLinksObj = (WebLinks)allWebLinks.get(i);
          webLinksObj.setCollectionId(collectionInformationId);
          // Reconnect to database for this WebLinks object
          db_ausstage.disconnectDatabase();
          db_ausstage = webLinksObj.getDatabase();
          db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
          weblinks_error_occurred = !webLinksObj.add();
          // WebLinks Error
          if (weblinks_error_occurred)
            pageFormater.writeText (out,webLinksObj.getError());
          else
            //out.println ("The web links record <b>" + webLinksObj.getWebLinksName() +
            //             "</b> was successfully saved <br>");
            pageFormater.writeText (out,"The web links record <b>" + webLinksObj.getWebLinksName() +
                         "</b> was successfully saved <br>"); 
        }
      }
    }
  }
  
  // Error
  if (error_occurred)
    out.println (collectionObj.getError());
  else
    //out.println ("The collection <b>" + collectionObj.getCollectionName() +
    //             "</b> was successfully saved");
    pageFormater.writeText (out,"The collection <b>" + collectionObj.getCollectionName() +
                 "</b> was successfully saved");
                 
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "", "", "", "", "collection_admin.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>
</form><cms:include property="template" element="foot" />