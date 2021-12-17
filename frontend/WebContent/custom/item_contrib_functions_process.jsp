<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.ItemContribLink, ausstage.Contributor, ausstage.Item"%>
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
	Vector itemContribLinks ;
  String creator       = request.getParameter("Creator");
  if(creator.equals("FALSE"))
    itemContribLinks= itemObj.getAssociatedContributors();
  else
    itemContribLinks= itemObj.getAssociatedCreatorContributors();
    
  String error_msg   = "";
	String orderBy     = "";
  String contribId   = "";
  String functionId  = "";
  

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	  for(int i=0; i < itemContribLinks.size(); i++) {
	    ItemContribLink itemContribLink = new ItemContribLink(db_ausstage);
      
      // get data from the request object
      contribId     = request.getParameter("f_contrib_id_" + i);
      orderBy       = request.getParameter("f_orderBy_" + i);
      functionId    = request.getParameter("f_function_id_" + i);

      itemContribLink.setContribId(contribId);
      itemContribLink.setOrderBy(orderBy);
      itemContribLink.setFunctionId(functionId);

      itemContribLinks.set(i, itemContribLink);
    }
  }
  catch(Exception e) {
    error_msg = "Error: Resource to Contributor links process NOT successful.";
  }

  if(error_msg.equals("")) {

    if(creator.equals("FALSE"))
      itemObj.setItemConLinks(itemContribLinks);
    else
      itemObj.setItemCreatorConLinks(itemContribLinks);
      
      
		session.setAttribute("item", itemObj);
    pageFormater.writeText (out, "Resource to Contributor process successful.");
  }
  else {
    pageFormater.writeText (out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
  if(creator.equals("TRUE"))
    pageFormater.writeButtons (out, "", "", "", "", "item_addedit.jsp#item_creator_contributors_link", "next.gif");
  else
    pageFormater.writeButtons (out, "", "", "", "", "item_addedit.jsp#item_contributors_link", "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<jsp:include page="../templates/admin-footer.jsp" />