<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ page session="true" import="org.opencms.main.*,org.opencms.jsp.*,org.opencms.file.*,java.lang.String, java.util.*"%>
<cms:include property="template" element="head" />
<% CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
	
	String user = request.getParameter("user");
	String password = request.getParameter("password");
	String url = request.getParameter("url");
	String shib = request.getParameter("shib");
	
	if (url == null || url.length() == 0 || url.equalsIgnoreCase("null")) url = "";
	
	boolean loginFailed = false;
	
	//form was submitted => try to log in and redirect to given URl
	if ((user != null) && (user.length() != 0)) {
		try {
			CmsObject cmsObject = cms.getCmsObject();
			cmsObject.loginUser(user, password);
			CmsProject cmsproject = cmsObject.readProject("Offline");
			cmsObject.getRequestContext().setCurrentProject(cmsproject);
			cmsObject.getRequestContext().setSiteRoot("/sites/default/");
			CmsUser login = cmsObject.readUser(user);
	
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
			session.setAttribute("fullUserName", login.getFullName());
			session.setAttribute("authId", login.getFullName());
			session.setAttribute("isAdmin", "true");
			session.setAttribute("loginOK", "true");
			List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(user, true);
			String groupNames = "";
			for(CmsGroup group:userGroups) {
			   groupNames += group.getName() + ", ";
			}
			session.setAttribute("permissions", groupNames);
			//login successful - redirect to given URL
			response.sendRedirect("/custom/welcome.jsp");
	
		} catch (CmsException e) {
			loginFailed = true;
		}
	}
	
	if ((shib != null) && shib.equals("failed"))
		loginFailed = true;
	
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
			<em>Login failed!</em>
			<%
		}
		if ((shib != null) && shib.equals("failed"))
			out.println("Your account is not listed as an Ausstage administrator.");
			%>
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
<cms:include property="template" element="foot" />
