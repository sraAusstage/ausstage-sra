<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="../admin/content_common.jsp"%>
<% if (!session.getAttribute("permissions").toString().contains("Administrators")) {
	//out.println("Not allowed");
	response.sendRedirect("/custom/welcome.jsp" );
	return;
	} %>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<%@ page import = "ausstage.AusstageCommon"%>
<jsp:include page="../templates/admin-header.jsp" />

<%@ include file="../custom/ausstage_common.jsp"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
	
	admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
	ausstage.Database   db_ausstage  = new ausstage.Database ();
	
	String        sqlString;
	CachedRowSet  rset;
	int           MAX_RESULTS_RETURNED = 1000;
	db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
	ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
	
	pageFormater.writeHeader(out);
	 pageFormater.writePageTableHeader (out,"", ausstage_main_page_link);
	
	  Vector filter_display_names       = new Vector ();
	  Vector filter_names               = new Vector ();
	  Vector order_display_names        = new Vector ();
	  Vector order_names                = new Vector ();
	  Vector textarea_db_display_fields = new Vector ();
	  Vector buttons_names              = new Vector ();
	  Vector buttons_actions            = new Vector ();
	  String list_name;
	  String list_db_sql="";
	  String order_statement="";
	  String list_db_field_id_name;
	  String filter_username, filter_first_name, filter_last_name, filter_email, filter_organization, filter_role;
	  
	  
	  filter_username         = request.getParameter ("f_user_name");
	  filter_first_name = request.getParameter ("f_first_name");
	  filter_last_name = request.getParameter ("f_last_name");
	  filter_email        = request.getParameter ("f_email");
	  filter_organization     = request.getParameter ("f_organization");
	 filter_role       = request.getParameter ("f_role");
	  
	  boolean exactFirstName = false;
	  boolean exactLastName  = false;

	

	  if (request.getParameter ("exactFirstName") != null) {
	    exactFirstName = true;
	  }
	  if (request.getParameter ("exactLastName") != null) {
	    exactLastName = true;
	  }
	  
	  filter_display_names.addElement ("Username");
	  filter_display_names.addElement ("First Name");
	  filter_display_names.addElement ("Last Name");
	  filter_display_names.addElement ("Email");
	  filter_display_names.addElement ("Organization");
	  //filter_display_names.addElement ("Role");
	  
	  filter_names.addElement ("f_user_name");
	  filter_names.addElement ("f_first_name");
	  filter_names.addElement ("f_last_name");
	  filter_names.addElement ("f_email");
	  filter_names.addElement ("f_organization");
	 // filter_names.addElement ("f_role");
	  
	  order_display_names.addElement ("First Name");
	  order_display_names.addElement ("Last name");
	  order_display_names.addElement ("Organization");
	  order_display_names.addElement ("Last Login");
	  
	  order_names.addElement ("first_name");
	  order_names.addElement ("last_name");
	  order_names.addElement ("organization");
	  order_names.addElement ("last_login");
	  
	  list_name             = "f_username";
	  list_db_field_id_name = "username";
	  
	  
	  textarea_db_display_fields.addElement ("username");
	  
	  if (session.getAttribute("permissions").toString().contains("Administrators")) {
		  buttons_names.addElement ("Add");
		  
		  buttons_names.addElement ("Edit/View");
		  

		 // buttons_names.addElement ("Copy");
		  buttons_names.addElement ("Delete");
		  buttons_actions.addElement ("Javascript:location.href='user_addedit.jsp?mode=add'");
		  buttons_actions.addElement ("Javascript:search_form.action='user_addedit.jsp?mode=edit';search_form.submit();");
		 // buttons_actions.addElement ("Javascript:search_form.action='event_copy.jsp?mode=copy';search_form.submit();");
		  buttons_actions.addElement ("Javascript:search_form.action='user_del_confirm.jsp?mode=delete';search_form.submit();");
		  }
	  
	  if (filter_username == null)
	  {
	    list_db_sql = "select Concat(username,', ',first_name,' ',last_name,', ',email,', ',ifnull(organization,''),', ',Date_format(useraccount.created_date,'%D %M %Y'),', ',ifnull(Date_format(useraccount.last_login_date,'%D %M %Y'),'')) as username from useraccount ";
	  }
	  else{
		  list_db_sql ="select Concat(useraccount.username,', ',useraccount.first_name,' ',useraccount.last_name,', ',useraccount.email,', ', ifnull(useraccount.organization,''),', ',Date_format(useraccount.created_date,'%D %M %Y'),', ', ifnull(Date_format(useraccount.last_login_date,'%D %M %Y'),'')) as username, role.name from ((role inner join userrole ON role.role_id = userrole.role_id) inner join useraccount on userrole.useraccount_id = useraccount.useraccount_id) where 1=1 ";
		  
		  if(request.getParameter("f_order_by").equals("last_name")) {
		    	order_statement = "order by useraccount.last_name";
		    } else if(request.getParameter("f_order_by").equals("organization")) {
		       	order_statement = "order by useraccount.organization";
		    } else if(request.getParameter("f_order_by").equals("last_login")) { 
		    	order_statement= "order by date_format(useraccount.last_login_date,'%M')";
		    }else{
		    	order_statement= "order by useraccount.first_name";
		    }
		  
		  if (!filter_username.equals ("")){
		      list_db_sql += "and LOWER(useraccount.username) like '%" + db_ausstage.plSqlSafeString(filter_username) + "%'";
		  }
		  if (!filter_first_name.equals ("")){
			  if (exactFirstName){
				  list_db_sql += "and LOWER(useraccount.first_name) = '" + db_ausstage.plSqlSafeString(filter_first_name) + "'";
			  }else{
		      	  list_db_sql += "and LOWER(useraccount.first_name) like '%" + db_ausstage.plSqlSafeString(filter_first_name) + "%'";
		      }
		  }
		  if (!filter_last_name.equals ("")){
			  if(exactLastName){
				  list_db_sql += "and LOWER(useraccount.last_name) = '" + db_ausstage.plSqlSafeString(filter_last_name) + "'";
			  }else{
		      	  list_db_sql += "and LOWER(useraccount.last_name) like '%" + db_ausstage.plSqlSafeString(filter_last_name) + "%'";
			  }
		 }
		 if (!filter_email.equals ("")){
		      list_db_sql += "and LOWER(useraccount.email) like '%" + db_ausstage.plSqlSafeString(filter_email) + "%'";
		      }
		 if (!filter_organization.equals ("")){
		      list_db_sql += "and LOWER(useraccount.organization) like '%" + db_ausstage.plSqlSafeString(filter_organization) + "%'";
		      }
		 if (!filter_role.equals ("")){
		      list_db_sql += "and role.name = '" + db_ausstage.plSqlSafeString(filter_role) + "'";
		      }
		 
		 
	  }
	  list_db_sql += "group by useraccount.username "+order_statement;
	  
	 	//list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
	  		String cbxExactHTML = "<br><br>Exact First Name <input type='checkbox' name='exactFirstName' value='true'><br>Exact Last Name<input type='checkbox' name='exactLastName' value='true'>";
			String secondHtml = "<tr><td valign='top' class='bodytext'>Role</td><td valign='top'><img src='/custom/images/spacer.gif' border='0' width='35' height='1'></td><td valign='top'><select name='f_role'  id='f_role'><option value=''></option><option value='Administrators'>Administrators</option><option value='Content Indicator Editor'>Content Indicator Editor</option><option value='Contributor Editor'>Contributor Editor</option><option value='Contributor Function Editor'>Contributor Function Editor</option><option value='Country Editor'>Country Editor</option><option value='DataSource Editor'>DataSource Editor</option><option value='Event Editor'>Event Editor</option><option value='Exhibition Editor'>Exhibition Editor</option><option value='Lookups Editor'>Lookups Editor</option><option value='Organisation Editor'>Organisation Editor</option><option value='Primary Genre Editor'>Primary Genre Editor</option><option value='Record Count Editor'>Record Count Editor</option><option value='Resource Editor'>Resource Editor</option><option value='Reviewers'>Reviewers</option><option value='SQL Editor'>SQL Editor</option><option value='Secondary Genre Editor'>Secondary Genre Editor</option><option value='Venue Editor'>Venue Editor</option><option value='Works Editor'>Works Editor</option></select></td>\n<td valign='top'><img src='/custom/images/spacer.gif' border='0' width='3' height='1'></td>\n</tr>\n";
	  		out.println (htmlGenerator.displaySearchFilter (request,"Select User ",
	                                        filter_display_names,
	                                        filter_names,
	                                        order_display_names,
	                                        order_names,
	                                        list_name,
	                                        list_db_sql,
	                                        list_db_field_id_name,
	                                        textarea_db_display_fields,
	                                        buttons_names,
	                                        buttons_actions,
	                                        false, 
	                                        MAX_RESULTS_RETURNED,cbxExactHTML,secondHtml));
	 db_ausstage.disconnectDatabase();
	 pageFormater.writePageTableFooter (out);
	 pageFormater.writeFooter(out);
%>
<script>
var exactFirstName = <%=exactFirstName%>;
var exactLastName = <%=exactLastName%>;
// reset both check boxes
if (exactFirstName) {
  search_form.exactFirstName.checked = false;
}

if (exactLastName) {
  search_form.exactLastName.checked = false;
}
</script>





<jsp:include page="../templates/admin-footer.jsp" />