<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import = "admin.SendMail"%>
<%admin.AppConstants publicCommentsConst = new admin.AppConstants(request);%>
<html>
<head>
  <!--<link rel="stylesheet" href="/css/default.css" type="text/css">-->
  <link rel="stylesheet" href="../../resources/style-frontend.css" type="text/css">
</head>
<!--<body bgcolor="#E7E7E6">-->

<%
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
 // ausstage.Tag tagObj     = new ausstage.Tag (db_ausstage);
  String              tag_id;
  

  String objectId     = request.getParameter("f_object_id");
  String objectType   = request.getParameter("f_object_type");
  String objectName   = request.getParameter("f_object_name");
  String userName     = request.getParameter("f_public_users_name");
  String userEmail    = request.getParameter("f_public_users_email");
  String userComments = request.getParameter("f_public_users_comments");
  String tag	      = request.getParameter("f_tag");
  String textVeri	  = request.getParameter("f_text_veri");
  
 // tagObj.add(tag,objectType,objectId);
  
  SendMail mailer = new SendMail ();
  String body_text;
  
  body_text = "Object Id:     " + objectId + "\n" +
              "Object Type:   " + objectType + "\n" +
              "Object Name:   " + objectName + "\n" +
              "User Name:     " + userName + "\n" +
              "User Email:    " + userEmail + "\n\n" +
              "Comments:\n" + userComments + "\n";

  if(textVeri == null || textVeri.equals("")){
  	mailer.sendEmail(publicCommentsConst.EMAIL_FORM_SENDER_ADDRESS, "Public Comment from User " + userName, body_text, publicCommentsConst.EMAIL_FORM_SENDER_ADDRESS);
  }
  //mailer.sendEmail("jbrown@sra.com.au", "Public Comment from User " + userName, body_text, "mark@sra.com.au");

 
%>
<p class="general_heading"><br>Thank you for submitting your comments to the Ausstage administrator.<BR>You will be contacted shortly.</p>
<a href="#" onclick="Javascript:window.close();">Close Window</a>
</body>
</html>