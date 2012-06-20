<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.ItemItemLink, ausstage.Item"%>
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

  Item   itemObj       = (Item)session.getAttribute("item");
  System.out.println("Item Object:" + itemObj);
  String itemId        = itemObj.getItemId();
  System.out.println("Item Id:" + itemId);
	Vector<ItemItemLink> itemItemLinks = itemObj.getItemItemLinks();
  String error_msg   = "";
	String functionId   = "";
	String notes        = "";
  String childItemId  = "";

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	  for(int i=0; i < itemItemLinks.size(); i++) {
	    ItemItemLink itemItemLink = new ItemItemLink(db_ausstage);
      
      // get data from the request object
      childItemId = request.getParameter("f_child_item_id_" + i);
      functionId  = request.getParameter("f_function_lov_id_" + i);
      notes       = request.getParameter("f_notes_" + i);

      itemItemLink.setChildId(childItemId);
      itemItemLink.setFunctionLovId(functionId);
      itemItemLink.setNotes(notes);


      itemItemLinks.set(i, itemItemLink);
    }
  }
  catch(Exception e) {
    error_msg = "Error: Resource to resource links process NOT successful.";
  }

  if(error_msg.equals("")) {
		itemObj.setItemItemLinks(itemItemLinks);
		session.setAttribute("item", itemObj);
    pageFormater.writeText (out,"Resource to resource process successful.");
  }
  else {
    pageFormater.writeText (out,error_msg);
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "item_addedit.jsp#item_item_link", "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />