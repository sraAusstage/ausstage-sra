<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Secondary Genre Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  ausstage.AusstageInputOutput secondary_genre = new ausstage.SecondaryGenre(db_ausstage);
  
  String secondarygenreid = request.getParameter("f_secondarygenreid");

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  // set the id state of the object here
  secondary_genre.setId(Integer.parseInt(secondarygenreid));

  if(secondary_genre.delete()){
    if(secondary_genre.isInUse())
      pageFormater.writeText (out, "Could not delete Secondary Genre because it has an association with the Events table!.<br>Click the tick button to continue.");
    else
      pageFormater.writeText (out, "Delete Secondary Genre process was successful.<br>Click the tick button to continue.");
  }else{
    pageFormater.writeText (out, "Delete Secondary Genre process was unsuccessful.<br>Please try again later.");
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "second_genre_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();

%>
<jsp:include page="../templates/admin-footer.jsp" />