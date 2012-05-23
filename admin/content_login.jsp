<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
><%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />
<%
admin.AppConstants AppConstants = new admin.AppConstants(request);
AppConstants.loadFromIniFile (request);
admin.Database db;

if (session.getAttribute("db") == null) {
  db = new admin.Database();
}
else {
  db = (admin.Database) session.getAttribute("db");
}
session.setAttribute("db",db);

// Remove the session attributes manually.
session.removeAttribute ("userName");
session.removeAttribute ("fullUserName");
session.removeAttribute ("authId");
session.removeAttribute ("isAdmin");
session.removeAttribute ("loginOK");


String fun_count = "";
int fun_count_int = 0;

if (session.getAttribute("fun_count") != null) {
    fun_count = session.getAttribute("fun_count").toString();
    fun_count_int = Integer.parseInt(fun_count);
    for(int i = 0; (i < fun_count_int); i++) {
            session.removeAttribute ("fun_id_" + i);
            session.removeAttribute ("fun_name_" + i);
            session.removeAttribute ("fun_url_" + i);
            session.removeAttribute ("fun_cat_" + i);
    }
    session.removeAttribute ("fun_count");
}

if (AppConstants.SSO_ENABLED && request.getParameter ("login") == null)
{
  response.sendRedirect("../sso/single_sign_on.jsp");
  return;
}
%>
<html>
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link rel="stylesheet" type="text/css" href="admin.css">
<title>Administration :: Login</title>
</head>
  <body onLoad="onLoad();" bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
    <form name="ContentForm" method="post" action="validateLogin.jsp">

<div style="position: relative; width: 400px; height: 150px; background-color: #b7b7b7;">

<img style="display: block; position: absolute; left: 10px; top: 10px;" src="<%=AppConstants.IMAGE_DIRECTORY%>/clite_login_account_header.gif" WIDTH="209" HEIGHT="35">
<img style="display: block; position: absolute; left: 10px; top: 50px;" src="<%=AppConstants.IMAGE_DIRECTORY%>/clite_login_u_p.gif" WIDTH="65" HEIGHT="70">

<input style="display: block; position: absolute; left: 100px; top: 50px;" value= "" type="text" class="line150" name="user_name" size="20" tabindex="1" >
<input style="display: block; position: absolute; left: 100px; top: 80px;" value= "" type="password" name="user_password" class="line150" size="20" tabindex="2">

<input style="display: block; position: absolute; bottom: 40px; right: 10px;" type="image" border="0" src="<%=AppConstants.IMAGE_DIRECTORY%>/clite_login_but1.gif" WIDTH="65" HEIGHT="25" id=image2 name=image2>
<div style="display: block; position: absolute; bottom: 5px; left: 10px; color: #ffffff;">
<%
 if (request.getParameter ("login") != null)
      {
        if (request.getParameter ("login").equals("1"))
          out.print("I'm sorry, I couldn't log you on. Invalid Login");
        else if (request.getParameter ("login").equals("2"))
          out.print("Login Timed Out.");
        else
          out.print(request.getParameter ("login"));
    }
%>
</div>
</div>

    </form>
      <script language="Javascript">
        <!--
        function onLoad()
        {
          ContentForm.user_name.focus();
        }
        //-->
      </script>
  </body>
</html>
<cms:include property="template" element="foot" />
