<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.User"%>

<%@ include file="../admin/content_common.jsp"%>
<%  if ( !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  } %>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
 
  admin.FormatPage    pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage   = new ausstage.Database ();
  User               userObj = new ausstage.User (db_ausstage);
  String       username = "";
  CachedRowSet rset;
  String       mode= "";
  mode = request.getParameter ("mode");

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Datasource    datasource    = new ausstage.Datasource (db_ausstage);
  
  
  if (mode.equals("delete")) { 
	  String result = request.getParameter ("f_username");
	  
	  if(result!=null &&!result.equals("")){
		  username=result.substring(0, result.indexOf(","));
		  userObj.load(username);
		  if(!username.equals(session.getAttribute("userName").toString())){
		  out.println("<form action='user_del_process.jsp' method='post'>");
		  out.println("<input type=\"hidden\" name=\"f_username\" value=\"" + username + "\">");
		  pageFormater.writeText (out, "Are you sure that you wish to delete the user named <b>" + userObj.getFirstName() + " " + userObj.getLastName() +"</b>?");
	      pageFormater.writePageTableFooter (out);
	      pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
	      }
		  else{
			  	pageFormater.writeText (out, "Cannot Delete Own Account");
			    pageFormater.writePageTableFooter (out);
			    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
		  }
	  
	  }else{
		  
			  pageFormater.writeText (out, "Please select a record to remove.");
			    pageFormater.writePageTableFooter (out);
			    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
		  
		  	
	  }
	 
	  }
	  else {
		  	pageFormater.writeText (out, "Please select a record to remove.");
		    pageFormater.writePageTableFooter (out);
		    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
	  }
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />