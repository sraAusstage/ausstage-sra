<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.CollInfoAccess"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin     login             = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage        pageFormater      = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database          db_ausstage       = new ausstage.Database ();
  ausstage.CollInfoAccess collInfoAccessObj = new ausstage.CollInfoAccess (db_ausstage);
  String                  collection_info_access_id;
  CachedRowSet            rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  collection_info_access_id = request.getParameter ("f_id");

  collInfoAccessObj.load (Integer.parseInt(collection_info_access_id));

  // Need to make sure that the collection info access record is not in use
  if (!collInfoAccessObj.checkInUse (Integer.parseInt(collection_info_access_id)))
  {
    collInfoAccessObj.delete ();
    pageFormater.writeText (out, "You have deleted the Collection Information Access record named <b>" + collInfoAccessObj.getCollAccess () + "</b>.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "", "", "", "", "coll_info_access_admin.jsp", "tick.gif");
  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this Collection Information Access record as it is in use.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%><cms:include property="template" element="foot" />