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
  boolean               deleted         = false;
  CachedRowSet rset;
  String error="";
  

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Datasource    datasource    = new ausstage.Datasource (db_ausstage);
  
  
 
	   
	  username=request.getParameter ("f_username");
	  userObj.load(username);
	  if(username!=null &&!username.equals("")){
		  deleted = userObj.delete (); 
		  if(deleted){
		      pageFormater.writeText (out, "You have deleted the user named <b>" + userObj.getFirstName() + " " + userObj.getLastName() +"</b>.");
		      pageFormater.writePageTableFooter (out);
		      pageFormater.writeButtons(out, "", "", "", "", "user_search.jsp", "tick.gif");
		    }
		    else{
		      error = userObj.getError();
		      pageFormater.writeText (out, error);
		    }
	  
	  }else{
		  response.sendRedirect("/custom/user_search.jsp" );
		  return;
	  }
	 
	  
	  
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />