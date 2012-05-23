<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Entity"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login          = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater   = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage    = new ausstage.Database ();
  ausstage.Entity     entityObj      = new ausstage.Entity (db_ausstage);
  ausstage.State      stateObj       = new ausstage.State (db_ausstage);
  String              entity_id;
  String              f_referrer     = request.getParameter("f_from");
  String              coll_id        = request.getParameter("coll_id");
  CachedRowSet        rset;
  boolean             error_occurred = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  entity_id = request.getParameter ("f_id");

  // if editing set the object to the selected record
  if (entity_id != null && !entity_id.equals ("") && !entity_id.equals ("null"))
    entityObj.load (Integer.parseInt(entity_id));

  entityObj.setInputPerson((String)session.getAttribute("fullUserName"));

  entityObj.setType(request.getParameter("f_type"));
  entityObj.setName(request.getParameter("f_name"));
  entityObj.setAddress(request.getParameter("f_address"));
  entityObj.setCitySuburb(request.getParameter("f_city_suburb"));
  entityObj.setStateid(request.getParameter("f_stateid"));
  entityObj.setPostcode(request.getParameter("f_postcode"));
  entityObj.setContacts(request.getParameter("f_contacts"));
  entityObj.setPhone(request.getParameter("f_phone"));
  entityObj.setFax(request.getParameter("f_fax"));
  entityObj.setEmail(request.getParameter("f_email"));
  entityObj.setWWW(request.getParameter("f_www"));

  // if editing
  if (entity_id != null && !entity_id.equals ("") && !entity_id.equals ("null"))
    error_occurred = !entityObj.update();
  else // Adding
    error_occurred = !entityObj.add();

  // Error
  if (error_occurred)
    pageFormater.writeText (out,entityObj.getError());
  else
    pageFormater.writeText (out,"The entity <b>" + entityObj.getName() + "</b> was successfully saved");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);

  if (f_referrer == null || f_referrer.equals ("null"))
    pageFormater.writeButtons(out, "", "", "", "", "entity_admin.jsp", "tick.gif");
  else
  {
    if(coll_id != null && !coll_id.equals(""))
      pageFormater.writeButtons(out, "", "", "", "", "collection_addedit.jsp?mode=edit&f_id=" + coll_id , "tick.gif");
    else
      pageFormater.writeButtons(out, "", "", "", "", "collection_addedit.jsp?mode=add" , "tick.gif");
  }
  pageFormater.writeFooter(out);
%>
</form><cms:include property="template" element="foot" />