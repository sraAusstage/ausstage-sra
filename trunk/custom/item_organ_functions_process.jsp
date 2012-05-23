<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.ItemOrganLink, ausstage.Organisation, ausstage.Item"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Item   itemObj         = (Item)session.getAttribute("item");
  String itemId          = itemObj.getItemId();
  String error_msg       = "";
	String orderBy         = "";
  String organisationId  = "";
  String creator         = request.getParameter("Creator");
  String functionId      = "";
  
  Vector itemOrganLinks;
  if(creator.equals("FALSE"))
    itemOrganLinks= itemObj.getAssociatedOrganisations();
  else
    itemOrganLinks= itemObj.getAssociatedCreatorOrganisations();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	  for(int i=0; i < itemOrganLinks.size(); i++) {
	    ItemOrganLink itemOrganLink = new ItemOrganLink(db_ausstage);
      
      // get data from the request object
      organisationId = request.getParameter("f_organisation_id_" + i);
      orderBy       = request.getParameter("f_orderBy_" + i);
      functionId    = request.getParameter("f_function_id_" + i);

      itemOrganLink.setOrganisationId(organisationId);
      itemOrganLink.setOrderBy(orderBy);
      itemOrganLink.setFunctionId(functionId);

      itemOrganLinks.set(i, itemOrganLink);
    }
  }
  catch(Exception e) {
    error_msg = "Error: Resource to Organisation links process NOT successful.";
  }

  if(error_msg.equals("")) {
		
    if(creator.equals("FALSE"))
      itemObj.setItemOrgLinks(itemOrganLinks);
    else
      itemObj.setItemCreatorOrgLinks(itemOrganLinks);
    
		session.setAttribute("item", itemObj);
    pageFormater.writeText (out, "Resource to Organisation process successful.");
  }
  else {
    pageFormater.writeText (out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
  if(creator.equals("TRUE"))
    pageFormater.writeButtons (out, "", "", "", "", "item_addedit.jsp#item_creator_organisations_link", "next.gif");
  else
    pageFormater.writeButtons (out, "", "", "", "", "item_addedit.jsp#item_organisations_link", "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />