<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Item"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage    pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage   = new ausstage.Database ();
  Item               itemObj = new ausstage.Item (db_ausstage);
  String              itemid;
  CachedRowSet        rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  itemid = request.getParameter ("f_itemid");

  // Make sure that the user selected a record to delete
  if (itemid != null && !itemid.equals ("null"))
  {
    itemObj.load (Integer.parseInt(itemid));
    out.println("<form action='item_del_process.jsp' method='post'>");
    out.println("<input type=\"hidden\" name=\"f_itemid\" value=\"" + itemid + "\">");
    // Need to make sure that the item is not in use
    
    if(itemObj.isInUse()){
      pageFormater.writeText (out,"Can not delete <b>" + itemObj.getCitation() + "</b> because it has an association with another resource.<br>Click the back button to continue.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif");
      
    }
    else{
      pageFormater.writeText (out, "Are you sure that you wish to delete the resource named <b>" + itemObj.getCitation() + "</b>?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
    }
  }
  else
  {
    pageFormater.writeText (out, "Please select a record to remove.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />