<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.Event, ausstage.ConEvLink, ausstage.Contributor"%>
<%@ page import= "ausstage.ContributorFunction, ausstage.ContFunctPref"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }

  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Event  eventObj    = (Event)session.getAttribute("eventObj");
  String eventid     = eventObj.getEventid();
	Vector conEvLinks  = eventObj.getConEvLinks();
  String warning_msg = "";
  String error_msg   = "";

  ConEvLink           conEvLink     = null;
  Contributor         contributor   = null;
  ContributorFunction contFunct     = null;
  ContFunctPref       contFunctPref = new ContFunctPref(db_ausstage);

	String functionId   = "";
	String functionDesc = "";
	String notes        = "";

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try
  {
	  for(int i=0; i < conEvLinks.size(); i++)
	  {
	    conEvLink   = (ConEvLink)conEvLinks.get(i);
	    contributor = conEvLink.getContributorBean();
	    contFunct   = conEvLink.getContFunctBean();
      // get data from the request object
      functionId = request.getParameter("f_function_id_" + i);
      notes      = request.getParameter("f_notes_" + i);
      contFunctPref.load(functionId);
      functionDesc = contFunctPref.getPreferredTerm();

      conEvLink.setFunction(functionId);
      conEvLink.setFunctionDesc(functionDesc);
      conEvLink.setNotes(notes);

      for(int j=0; j < i; j++) // Make sure the user hasn't entered any duplicate ConEvLinks.
      {
        if (conEvLink.sameContributorAndFunction((ConEvLink)conEvLinks.get(j)))
          warning_msg = "Warning: Duplicate Contributor Links.";
      }
      if (error_msg.length() == 0)
        conEvLinks.set(i, conEvLink);
    }
  }
  catch(Exception e)
  {
    error_msg = "Error: Contributor Link Properties process NOT successful.";
  }

  if(error_msg.equals(""))
  {
		eventObj.setConEvLinks(conEvLinks);
		session.setAttribute("eventObj", eventObj);
    if (warning_msg.length() == 0)
      pageFormater.writeText (out, "Contributor Link Properties process successful.");
    else
      pageFormater.writeText (out, warning_msg);
  }
  else
  {
    pageFormater.writeText (out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "event_addedit.jsp#event_contributors", "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<jsp:include page="../templates/admin-footer.jsp" />