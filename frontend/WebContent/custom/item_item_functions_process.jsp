<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.ItemItemLink, ausstage.Item"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Item   itemObj       = (Item)session.getAttribute("item");
  String itemId        = itemObj.getItemId();
	Vector<ItemItemLink> itemItemLinks = itemObj.getItemItemLinks();
  String error_msg   = "";
  String relationLookupId   = "";
  String notes        	= "";
  String childNotes   	= "";
  String linkItemId  	= "";
  String isParent	= "";

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	for(int i=0; i < itemItemLinks.size(); i++) {
		ItemItemLink itemItemLink = new ItemItemLink(db_ausstage);
      
	     	// get data from the request object
      		linkItemId  = request.getParameter("f_link_item_id_" + i);
      		notes       = request.getParameter("f_notes_" + i);
      		childNotes  = request.getParameter("f_child_notes_" + i);

		//get the relation lookup id and the perspective (ie parent or child) 
		String [] lookupAndPerspective = request.getParameter("f_relation_lookup_id_" + i).split("_", 2);
		relationLookupId = lookupAndPerspective[0];
		isParent = lookupAndPerspective[1];

		if (isParent.equals("parent")){
			itemItemLink.setChildId(linkItemId);
			itemItemLink.setItemId(itemId);
			itemItemLink.setNotes(notes);
			itemItemLink.setChildNotes(childNotes);
		} else {
			itemItemLink.setChildId(itemId);
			itemItemLink.setItemId(linkItemId);
			itemItemLink.setNotes(childNotes);
			itemItemLink.setChildNotes(notes);		
		}
		itemItemLink.setRelationLookupId(relationLookupId);
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
%><jsp:include page="../templates/admin-footer.jsp" />