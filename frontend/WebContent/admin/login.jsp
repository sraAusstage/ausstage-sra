<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page session="true" import="java.lang.String, java.util.*"%>
<jsp:include page="../templates/header.jsp" />
<% 
	if("true".equals(session.getAttribute("loginOK"))){
		response.sendRedirect("/custom/welcome.jsp");
	}
	HashMap<String,String> result = new HashMap<String,String>();
	
	String user = request.getParameter("user");
	String password = request.getParameter("password");
	String url = request.getParameter("url");
	admin.Authentication cms = new admin.Authentication(new admin.AppConstants(request));
	

	if (url == null || url.length() == 0 || url.equalsIgnoreCase("null")) url = "";
	
	boolean loginFailed = false;
	
	//form was submitted => try to log in and redirect to given URl
	if ((user != null) && (user.length() != 0)) {
		try {
			
			String userLowerCase = user.toLowerCase();
			
			if(session.getAttribute("count"+userLowerCase)==null){
				session.setAttribute("count"+userLowerCase,0);
				
			} 
			
			int count = (int) session.getAttribute("count"+userLowerCase);
			if (count <3){
				result = cms.login(user,password);
				if(result.get("status").equals("loginfailed")){
					
					out.println("<spam style= 'padding:10px'>"+result.get("message")+"</spam>");
					
					int temp = (int)session.getAttribute("count"+userLowerCase);
					temp++;
					session.setAttribute("count"+userLowerCase,temp);
					loginFailed= true;
					
				} else if(result.get("status").equals("loginSuccess")){
					// create login logic
					//out.println(result.get("message"));
					//out.println(cms.getFullName(user));
					
					
					admin.Database db;
					admin.AppConstants AppConstants = new admin.AppConstants();
			
					if (session.getAttribute("db") == null) {
						db = new admin.Database();
						session.setAttribute("db", db);
					} else {
						db = (admin.Database) session.getAttribute("db");
					}
					
					admin.FormatPage pageFormater = new admin.FormatPage(db);
					session.setAttribute("pageFormater", pageFormater);
			
					session.setAttribute("userName", user);
					session.setAttribute("fullUserName", cms.getFullName(user));
					session.setAttribute("authId", cms.getFullName(user));
					session.setAttribute("isAdmin", "true");
					session.setAttribute("loginOK", "true");
					
					ArrayList<String> userRoleList = cms.getUserRoles(user);
					String userRoles="";
					for(String role:userRoleList) {
						userRoles += role + ", ";
			        }
					session.setAttribute("permissions", userRoles);

					//login successful - redirect to given URL
					response.sendRedirect("/custom/welcome.jsp");
					
				}
			} else {
				//change account_locked_flag to Y
				if(cms.lockAccount(user)){
					out.println("You have attempted to login too many times and your account is now locked. Please contact the administrator");
					loginFailed= true;
				} else {
					out.println("Please contact the administrator");
					loginFailed= true;
				}
				
			}
			
			
			
			/* result = cms.login(user,password);
			if(result.get("status").equals("loginfailed")){
				out.println(result.get("message"));
			} else if(result.get("status").equals("loginSuccess")){
				out.println(result.get("message"));
			} */
			
			/*CmsObject cmsObject = cms.getCmsObject();
			cmsObject.loginUser(user, password);
			CmsProject cmsproject = cmsObject.readProject("Offline");
			cmsObject.getRequestContext().setCurrentProject(cmsproject);
			cmsObject.getRequestContext().setSiteRoot("/sites/default/");
			CmsUser login = cmsObject.readUser(user);*/
	
			//admin.Database db;
			//admin.AppConstants AppConstants = new admin.AppConstants();
	
			//if (session.getAttribute("db") == null) {
			//	db = new admin.Database();
			//	session.setAttribute("db", db);
			// } else {
			//	db = (admin.Database) session.getAttribute("db");
			// }
			
			//admin.FormatPage pageFormater = new admin.FormatPage(db);
			//session.setAttribute("pageFormater", pageFormater);
	
			//session.setAttribute("userName", user);
			//session.setAttribute("fullUserName", login.getFullName());
			//session.setAttribute("authId", login.getFullName());
			//session.setAttribute("isAdmin", "true");
			//session.setAttribute("loginOK", "true");
			/*List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(user, true);
			String groupNames = "";
			for(CmsGroup group:userGroups) {
			   groupNames += group.getName() + ", ";
			}*/
			//session.setAttribute("permissions", groupNames);

			//login successful - redirect to given URL
			//response.sendRedirect("/custom/welcome.jsp");
	
		} catch (Exception e) {
			loginFailed = true;
		}
	}
	
	
	//no user submitted or login failed => show login form
	if (user == null || user.length() == 0 || loginFailed) {
		%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
		<html>
		<head>
		<title>Login</title>
		</head>
		<body onload="document.forms[0].elements[0].focus()">
		<%
		if (loginFailed) {
			%>
			<em><font color='red'>Login failed!</font></em>
			<%
		}
		//if ((shib != null) && shib.equals("failed"))
		//	out.println("Your account is not listed as an Ausstage administrator.");
		//	%>
			<h2>AusStage Login</h2>
			<form method="post" action="?">
				<input type="hidden" name="url" value="<%=url%>" />
				<table border="0" cellspacing="0" cellpadding="3">
				<tr>
					<td align="right">Username:</td><td><input name="user" /></td>
				</tr>
				<tr>
					<td align="right">Password:</td><td><input name="password" type="password" /></td>
				</tr>
				<tr>
					<td></td><td><input type="submit" value="Log in" /></td>
				</tr>
				</table>
			</form>
		</body>
		</html>
		<%
	}
%>
<jsp:include page="../templates/footer.jsp" />
