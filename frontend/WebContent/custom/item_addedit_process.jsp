<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Item"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  Item                  item            = null;            
  boolean               error_occurred  = false;
  CachedRowSet          rset;
  String                itemid;
  String                action          = request.getParameter("action");
  String                catalogueID     = request.getParameter("f_catalogue_id");       

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
 
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
  //get the item object out of the session.
  item = (Item)session.getAttribute("item");
  // Update with new data from form
  item.setItemAttributes(request); 
   
  //The entered user is only set on insert and the updated user is only updated on update. This is controlled in the item.java
  item.setEnteredByUser((String)session.getAttribute("fullUserName"));
  item.setUpdatedByUser((String)session.getAttribute("fullUserName"));
  /*System.out.println("*********");
  System.out.println(request.getParameter("f_item_article"));*/
  itemid = request.getParameter ("f_itemid");

  if (itemid == null || itemid.equals("0") || itemid.equals("null")){
    //therefore adding a item, no id has been assigned yet.
    itemid = "-1";
  }
  
  session.setAttribute("item", item);
  item.setDatabaseConnection(db_ausstage); // Refresh connection
 
  // adding a item
  if (itemid.equals ("-1"))
  {
    error_occurred = !item.addItem();
  }
  //deleting a item
  else if(action != null && !action.equals("") && action.equals("delete")){
    error_occurred = !item.deleteItem();
  }
  else // Editing a item
  {
    if(action != null && !action.equals("") && action.equals("copy"))
      error_occurred = !item.addItem();
    else
      error_occurred = !item.updateItem();
  }

  // Error
  if (error_occurred){
    out.println (item.getError());
  }
 
  else{
    if(action != null && !action.equals("") && action.equals("delete"))
      //out.println ("The resource <b>" + item.getCitation() +
      //             "</b> was successfully deleted");
      pageFormater.writeText (out, "The resource <b>" + item.getCitation() +
                   "</b> was successfully deleted");
    else
     // out.println ("The resource <b>" + item.getCitation() +
     //              "</b> was successfully saved");
      pageFormater.writeText (out, "The resource <b>" + item.getCitation() +
                   "</b> was successfully saved");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  if (error_occurred)
    pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", "");  
  else if(action != null && !action.equals("") && action.equals("copy"))
     pageFormater.writeButtons(out, "", "", "", "", "/custom/ausstage/item_addedit.jsp?action=copy&f_catalogue_id=Copy of " + catalogueID, "tick.gif");
  else
    pageFormater.writeButtons(out, "", "", "", "", "/custom/item_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>
</form>

<jsp:include page="../templates/admin-footer.jsp" />