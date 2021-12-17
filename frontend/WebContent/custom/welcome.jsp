<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<jsp:include page="../templates/admin-header.jsp" />

<br>
<br>
Welcome, <b><%
	String name = session.getAttribute("fullUserName") == null ? "" : session.getAttribute("fullUserName").toString() ;
	if(name == null || name.equals("")){
		response.sendRedirect("/admin/login.jsp");
	}else {
    out.println(name);
	}
 /*   out.println(request.getAttribute("Shib-Identity-Provider") + "<br/>");
    out.println(request.getAttribute("Shib-Authentication-Instant") + "<br/>");
    out.println(request.getAttribute("Shib-Authentication-Method") + "<br/>");
    
    out.println(request.getAttribute("Shib-Application-ID") + "<br/>");
    out.println(request.getAttribute("Shib-Session-ID") + "<br/>");
    out.println(request.getAttribute("Shib-AuthnContext-Class") + "<br/>");
    out.println(request.getAttribute("Shib")+"<br/>");
    
    out.println(request.getAttribute("eduPersonPrincipalName"));
    out.println(request.getAttribute("displayName"));
    out.println(request.getAttribute("givenName"));
    out.println(request.getAttribute("cn"));
    out.println(request.getAttribute("sn"));
    out.println(request.getAttribute("mail"));
    out.println(request.getAttribute("persistent-id"));
*/
%></b>!<br>
Please use the links on the left to navigate.


<jsp:include page="../templates/admin-footer.jsp" />