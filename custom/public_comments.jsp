<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import = "admin.SendMail"%>
<cms:include property="template" element="head" />

<%admin.AppConstants publicCommentsConst = new admin.AppConstants(request);%>
<html>
<head>
  <link rel="stylesheet" href="/css/default.css" type="text/css">
</head>
<body bgcolor="#E7E7E6">
<%
  String objectId     = request.getParameter("f_object_id");
  String objectType   = request.getParameter("f_object_type");
  String objectName   = request.getParameter("f_object_name");
  String userName     = request.getParameter("f_public_users_name");
  String userEmail    = request.getParameter("f_public_users_email");
  String userComments = request.getParameter("f_public_users_comments");

  //System.out.println("****"+publicCommentsConst.EMAIL_FORM_SENDER_ADDRESS);
  
  SendMail mailer = new SendMail ();
  String body_text;
  
  body_text = "Object Id:     " + objectId + "\n" +
              "Object Type:   " + objectType + "\n" +
              "Object Name:   " + objectName + "\n" +
              "User Name:     " + userName + "\n" +
              "User Email:    " + userEmail + "\n\n" +
              "Comments:\n" + userComments + "\n";

  mailer.sendEmail(publicCommentsConst.EMAIL_FORM_SENDER_ADDRESS, "Public Comment from User " + userName, body_text, publicCommentsConst.EMAIL_FORM_SENDER_ADDRESS);

  //mailer.sendEmail("sirbrad@hotmail.com", "Public Comment from User " + userName, body_text, "sirbrad@hotmail.com");
%>
<p class="general_heading"><br>Thank you for submitting you comments to the Ausstage administrator.<BR>You will be contacted shortly.</p>
<a href="#" onclick="Javascript:window.close();">Close Window</a>
</body>
</html>
  <cms:include property="template" element="foot" />