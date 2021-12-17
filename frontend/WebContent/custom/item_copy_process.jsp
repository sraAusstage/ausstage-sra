<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "ausstage.Item"%>
<jsp:include page="../templates/admin-header.jsp" />
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
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String itemid = request.getParameter("f_itemid");
  Item itemObj = new Item(db_ausstage);
  itemObj.load(Integer.parseInt(itemid));

  // set this bean in copy mode
  itemObj.setIsInCopyMode(true);
  
  if(itemObj.addItem()){
   pageFormater.writeText(out, "The Item <b>" + itemObj.getCitation() +
                 "</b> was successfully copied.");
    pageFormater.writePageTableFooter (out);
    response.sendRedirect("/custom/item_addedit.jsp?action=edit&f_itemid=" + itemObj.getItemId());
  }else{
    pageFormater.writeText(out,itemObj.getError());
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "", "", "", "", "item_search.jsp", "tick.gif");
  }


  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>

<jsp:include page="../templates/admin-footer.jsp" />