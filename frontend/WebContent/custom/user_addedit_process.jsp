<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.util.*,java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.User"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.Role"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if ( !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }

  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  User                 userObj        = null;
  CachedRowSet          rset;
  boolean               error_occurred  = false;
  Vector<Role> roles = new Vector();

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
  String mode = request.getParameter ("mode");
  String role_ids    = request.getParameter("delimited_role_ids");
  //System.out.println(role_ids);
  
  //using delimiter list of country ids make a Vector of user roles
  if(mode==null || mode.equals("")){
	  pageFormater.writeText (out, "Please select a record to add.");
	    pageFormater.writePageTableFooter (out);
	    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "", "");
  }
  else{
   
	for (String role: role_ids.split(",")){
	   	if(role != null && !role.equals("") && !role.equals(" ") && !role.equals("[]")){
	   		Role r = new Role(db_ausstage);	
	   		r.m_role_id=role;
	   		r.m_role_name="";
	   		roles.addElement(r);
			
		}
	  }
  
  userObj = (User)session.getAttribute("userObj");
  //System.out.println(userObj.getUserName());
  if(mode.equals("add")){
	  userObj.setUserAddAttributes(request,roles);  // Update with new data
  }
  else if(mode.equals("edit")){
	  //System.out.println(request.getParameter("f_username"));
	  userObj.setUserUpdateAttributes(request,userObj.getUserName(),roles); 
  }
  

  
  
 
  //Only used on Insert NOT update
  userObj.setEnteredByUser((String)session.getAttribute("fullUserName"));
  session.setAttribute("userObj", userObj);

  userObj.setDatabaseConnection(db_ausstage); // Refresh connection

  // if editing
 if(mode.equals("add")){
	 error_occurred =  !userObj.add();
 }else if(mode.equals("edit")){

		System.out.println();
	 error_occurred = !userObj.update();
 }

  // Error
  if (error_occurred)
    //out.println (eventObj.getError());
    pageFormater.writeText (out, userObj.getError());
  else
    //out.println ("The event <b>" + eventObj.getEventName() +
    //             "</b> was successfully saved");
    pageFormater.writeText (out, "The User <b>" + userObj.getUserName() +
                 "</b> was successfully saved");
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  if(error_occurred){
    pageFormater.writeButtons(out, "back", "prev.gif", "", "", "", "");
  }else {
    pageFormater.writeButtons(out, "", "", "", "", "user_search.jsp", "tick.gif");
  }
  pageFormater.writeFooter(out);
  }
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />