<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Collection"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  ausstage.Collection   collectionObj   = new ausstage.Collection (db_ausstage);
  ausstage.WebLinks     webLinksObj     = new ausstage.WebLinks (db_ausstage);
  ausstage.MaterialLink materialLinkObj = new ausstage.MaterialLink (db_ausstage);
  String                collection_information_id;
  CachedRowSet          rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  collection_information_id = request.getParameter ("f_id");

  collectionObj.load (Integer.parseInt(collection_information_id));

  // Need to make sure that the collection is not in use
  if (!collectionObj.checkInUse (Integer.parseInt(collection_information_id)))
  {
    // First delete the Web Link records for the Collection
    webLinksObj.deleteWebLinksForCollection(Integer.parseInt(collection_information_id));
    // Now delete the Material Link records for the Collection
    materialLinkObj.deleteMaterialLinksForCollection(Integer.parseInt(collection_information_id));
    collectionObj.delete ();
    pageFormater.writeText (out, "You have deleted the collection named <b>" + collectionObj.getCollectionName () + "</b>.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "", "", "", "", "collection_admin.jsp", "tick.gif");
  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this collection as it is in use.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />