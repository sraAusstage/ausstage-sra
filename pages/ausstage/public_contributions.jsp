<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import="ausstage.AusstageCommon"%>
<%@ page import="admin.SendMail"%>
<%admin.AppConstants publicCommentsConst = new admin.AppConstants(request);%>
<html>
<head>
<link rel="stylesheet" href="../../resources/style-frontend.css"
	type="text/css">
</head>
<body>

	<%
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  String type     = request.getParameter("type");
  
  String bodyText = "Type:               " + type + "\n";
  String userName = "";
  boolean valid = false;
  if ("resource".equals(type)) {
	  valid = true;
	  bodyText +=   "Sub Type:           " + request.getParameter("sub_types") + "\n" +
	  				"Title:              " + request.getParameter("title") + "\n" +
					"Creator:            " + request.getParameter("creator") + "\n" +
					"Source:             " + request.getParameter("source") + "\n" +
					"Date:               " + request.getParameter("firstdate_dd") + "/" + request.getParameter("firstdate_mm") + "/" + request.getParameter("firstdate_yyyy") + "\n" +
					"Description:\n" + request.getParameter("description") + "\n" +
					"Publisher:          " + request.getParameter("publisher") + "\n" +
					"Format:             " + request.getParameter("format") + "\n" +
					"Identifier:         " + request.getParameter("identifier") + "\n" +
					"Work:               " + request.getParameter("work") + "\n" +
					"Event:              " + request.getParameter("event") + "\n" +
					"Contributor:        " + request.getParameter("contributor") + "\n" +
					"Organisation:       " + request.getParameter("organisation") + "\n" +
					"Venue:              " + request.getParameter("venue") + "\n" +
					"Further Information:\n" + request.getParameter("further_info") + "\n" +
					"Action Request:     " + request.getParameter("request_type") + " " + request.getParameter("ID") + "\n" +
					"==========================================\n" +
					"Name:               " + request.getParameter("Name:") + "\n" +
					"Email:              " + request.getParameter("Email");
	  userName = request.getParameter("Name:");
  } else if ("event".equals(type)) {
	  valid = true;
	  bodyText +=   "Event Name:         " + request.getParameter("event_name") + "\n" +
		"Umbrella:           " + request.getParameter("umbrella") + "\n" +
		"Venue:              " + request.getParameter("venue") + "\n" +
		"Location:           " + request.getParameter("suburb_state") + "\n" + request.getParameter("State") + "\n" + request.getParameter("venue_country") + "\n" +
		"First Date:         " + request.getParameter("first_date") + "\n" +
		"Last Date:          " + request.getParameter("last_date") + "\n" +
		"Opening Date:       " + request.getParameter("openingnight") + "\n" +
		"Part of Tour:       " + request.getParameter("part_of_tour") + "\n" +
		"World Premiere:     " + request.getParameter("world_premier") + "\n" +
		"Status:             " + request.getParameter("Status") + "\n" +
		"Primary Genre:      " + request.getParameter("primary_genre") + "\n" +
		"Secondary Genre:    " + request.getParameter("secondary_genre") + "\n" +
		"Companies:          " + request.getParameter("Organisation") + "\n" +
		"Contributors:       " + request.getParameter("Contributor") + "\n" +
		"Description:\n" + request.getParameter("description") + "\n" +
		"Further Information:\n" + request.getParameter("further_info") + "\n" +
		"Action Request:     " + request.getParameter("request_type") + " " + request.getParameter("ID") + "\n" +
		"==========================================\n" +
		"Name:               " + request.getParameter("Name:") + "\n" +
		"Email:              " + request.getParameter("Email");
	  userName = request.getParameter("Name:");
  } else if ("register".equals(type)) {
	  valid = true;
	  bodyText =   "Name:               " + request.getParameter("name") + "\n" +
		"Organisation:       " + request.getParameter("organisation") + "\n" +
		"Email:              " + request.getParameter("email") + "\n" +
		"Message:\n" + request.getParameter("message") + "\n";
	  userName = request.getParameter("name");
  }
  
  if (valid) {
	  SendMail mailer = new SendMail ();
	  mailer.sendEmail(publicCommentsConst.EMAIL_FORM_SENDER_ADDRESS, ("register".equals(type)?"Registration Request from ":"Public Contribution from User ") + userName, bodyText, publicCommentsConst.EMAIL_FORM_SENDER_ADDRESS);
  }
 
%>
	<p class="general_heading">
		<br>Thank you for submitting your contribution to the AusStage
		administrator.<BR>You will be contacted shortly.
	</p>
	<a href="#" onclick="Javascript:window.close();">Close Window</a>
</body>
</html>