<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "ausstage.Event"%>
<jsp:include page="../templates/admin-header.jsp" />
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
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String eventid = request.getParameter("f_eventid");
  Event eventObj = new Event(db_ausstage);
  eventObj.load(Integer.parseInt(eventid));
  eventObj.setEnteredByUser((String)session.getAttribute("fullUserName"));

  // set this bean in copy mode
  eventObj.setIsInCopyMode(true);
  
  if(eventObj.add()){
    pageFormater.writeText (out,"The event <b>" + eventObj.getEventName() +
                 "</b> was successfully copied.");
    pageFormater.writePageTableFooter (out);
    response.sendRedirect ( "/custom/event_addedit.jsp?mode=edit&f_eventid=" + eventObj.getEventid());
  }else{
    pageFormater.writeText (out,eventObj.getError());
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "", "", "", "", "event_search.jsp", "tick.gif");
  }


  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>

<jsp:include page="../templates/admin-footer.jsp" />