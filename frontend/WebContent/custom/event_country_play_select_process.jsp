<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
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


  String[] country_ids = request.getParameterValues("f_id");
  String eventid = request.getParameter("f_eventid");
  Vector country_vector = new Vector();
  ausstage.Country  country = null;
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
    
  if(country_ids != null){
    
    for(int i = 0; i < country_ids.length; i++){
      country = new ausstage.Country(db_ausstage);
      country.load(Integer.parseInt(country_ids[i]));

      // set the vector here
      country_vector.addElement(country);
    }
    pageFormater.writeText (out, "Linking national origin play country and events was successful.<br>Click the tick button to continue.");
  }else{
    pageFormater.writeText (out, "Linking national origin play country and events was unsuccessful.<br>Please try again later.");
  }
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "event_addedit.jsp#event_country_play_select", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();

  // get the EVENT object from session
  ausstage.Event eventObj = new ausstage.Event(db_ausstage);
  eventObj = (ausstage.Event) session.getAttribute("eventObj");
  
  // set the EVENT the vector member
  eventObj.setPlayOrigins(country_vector);

  // reset/set the state of the EVENT object
  session.setAttribute("eventObj",eventObj);
%>

<jsp:include page="../templates/admin-header.jsp" />