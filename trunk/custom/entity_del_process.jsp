<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Entity"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.Entity     entityObj    = new ausstage.Entity (db_ausstage);
  String              entity_id;
  CachedRowSet        rset;
  String f_referrer                = request.getParameter("f_from");
  String coll_id                   = request.getParameter("coll_id");

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  entity_id = request.getParameter ("f_id");

  entityObj.load (Integer.parseInt(entity_id));

  // Need to make sure that the entity is not in use
  if (!entityObj.checkInUse (Integer.parseInt(entity_id)))
  {
    entityObj.delete ();
    pageFormater.writeText (out, "You have deleted the entity named <b>" + entityObj.getName () + "</b>.");
    pageFormater.writePageTableFooter (out);
    if (f_referrer == null || f_referrer.equals ("null"))
      pageFormater.writeButtons(out, "", "", "", "", "entity_admin.jsp" , "tick.gif");
    else
    {
      if(coll_id != null && !coll_id.equals(""))
        pageFormater.writeButtons(out, "", "", "", "", "collection_addedit.jsp?mode=edit&f_id=" + coll_id , "tick.gif");
      else
        pageFormater.writeButtons(out, "", "", "", "", "collection_addedit.jsp?mode=add" , "tick.gif");
    }
  }
  else
  {
    pageFormater.writeText (out, "You are unable to remove this entity as it is in use.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/admin/content_main_menu.jsp", "cross.gif", "", "");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%><cms:include property="template" element="foot" />