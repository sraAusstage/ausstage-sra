<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" 
import="java.io.*"
import="java.util.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />
<br>
<br>
Welcome, <b><%
    out.println(session.getAttribute ("fullUserName"));
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


<cms:include property="template" element="foot" />