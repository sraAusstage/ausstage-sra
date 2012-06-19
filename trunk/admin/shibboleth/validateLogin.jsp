<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.sql.*,sun.jdbc.rowset.*"%>
<% CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
	
	String user = request.getHeader("AJP_givenName") + request.getHeader("AJP_sn");
	
	// Here we need code to get the ID from shibboleth into shibbolethId
	
	try {
		CmsObject cmsObject = cms.getCmsObject();
		/*cmsObject.loginUser(user);
		CmsProject cmsproject = cmsObject.readProject("Offline");
		cmsObject.getRequestContext().setCurrentProject(cmsproject);
		cmsObject.getRequestContext().setSiteRoot("/sites/default/");*/
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
	
	} catch (Exception e) {
		response.sendRedirect("/admin/login.jsp?shib=failed");
	}
	response.sendRedirect("/admin/login.jsp?shib=failed");
%>
