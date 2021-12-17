<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
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
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String secondarygenreid = request.getParameter("f_selected_second_genre_id");
  
  if(secondarygenreid == null || secondarygenreid.equals("")){
    // return back to the search page
    
    out.println("You have not selected a Secondary Genre to delete.<br>Please click the back button to return to the Secondary Genre Search page.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "second_genre_search.jsp", "prev.gif", "", "", "", "");  

  }else{

    ausstage.AusstageInputOutput secondary_genre = new ausstage.SecondaryGenre(db_ausstage);
    secondary_genre.load(Integer.parseInt(secondarygenreid));
    
    if(secondary_genre.isInUse()){
      pageFormater.writeText (out, "Can not delete <b>" + secondary_genre.getName() + "</b> because it has an association with the Events table!.<br>Click the back button to continue.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", "");
    }else{
      // write the confirmation message
      pageFormater.writeText (out, "Are you sure you want to delete the <b>" + secondary_genre.getName() + "</b> socondary genre?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "BACK", "prev.gif", "second_genre_search.jsp", "cross.gif", "second_genre_del_confirm_process.jsp?f_secondarygenreid=" + secondarygenreid , "tick.gif");
    }
  }

  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>

<jsp:include page="../templates/admin-footer.jsp" />