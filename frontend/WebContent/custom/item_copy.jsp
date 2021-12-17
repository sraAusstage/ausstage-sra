<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "ausstage.Item"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String itemid = request.getParameter("f_itemid");
  
  if(itemid == null || itemid.equals("")){
    // return back to the search page
    out.println("You have not selected an Item to Copy.<br>Please click the back button to return to the Search page.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", "");  

  }else{
    // write the confirmation message
    Item itemObj = new Item(db_ausstage);
    out.println("You are about to Copy <b>" + itemObj.getCitation((Integer.parseInt(itemid))) + "</b>.<br>If this is correct, press the tick button to continue.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "BACK", "cross.gif", "", "", "item_copy_process.jsp?f_itemid=" + itemid , "tick.gif");
    
  }

  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>

<jsp:include page="../templates/admin-footer.jsp" />
