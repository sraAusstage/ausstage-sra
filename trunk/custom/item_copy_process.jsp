<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "ausstage.Item"%>
<cms:include property="template" element="head" />
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
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
    //response.sendRedirect("/custom/ausstage/item_addedit.jsp?f_itemid=" + itemObj.getItemId());
  }else{
    pageFormater.writeText(out,itemObj.getError());
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "", "", "", "", "item_search.jsp", "tick.gif");
  }


  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>

<cms:include property="template" element="foot" />