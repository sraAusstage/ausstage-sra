<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ page session="true" import="org.opencms.main.*,org.opencms.jsp.*,org.opencms.file.*,java.lang.String"%>
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
		%>
		
		<body onload="document.forms[0].elements[0].focus()">

		
<span class="box b-175">
<span class="box-label">AusStage</span>
	<form method="post" action="?">
	<input type="hidden" name="url" value="<%=url%>" />
<p align="right" class="label">Username: </td><td><input name="user" /></p>
<p align="right" class="label">Password: </td><td><input name="password" type="password" /></p>
<p align="right"><input type="submit" value="Login"/></p></form>
<%
		if (loginFailed) {
			%>
			Login unsuccessful. Try again...
			<%
		}
		if ((shib != null) && shib.equals("failed"))
			out.println("Your account is not listed as an AusStage administrator.");
			%>
</span>	


	
<br>				
<span class="box b-105 label" style="cursor:pointer;" onmouseover="this.className='box b-106 label';" onmouseout="this.className='box b-105 label';">Login through the <a href="" >Australian Access Federation</a> using your institutional username and password.<span class="box-label">AAF</span></span>
<br>
<span class="box b-90 label" style="cursor:pointer;" onmouseover="this.className='box b-91 label';" onmouseout="this.className='box b-90 label';">Contact the <a href="../pages/learn/contact/"  class="bold">AusStage Project Manager</a> if you have trouble logging in.</span>					

		
		<%
	}
%>
<cms:include property="template" element="foot" />
