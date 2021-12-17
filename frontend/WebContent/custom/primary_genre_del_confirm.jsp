<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Primary Genre Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String primarygenreid = request.getParameter("f_selected_primary_genre_id");
  
  if(primarygenreid == null || primarygenreid.equals("")){
    // return back to the search page
    
    pageFormater.writeText (out, "You have not selected a Primary Genre to delete.<br>Please click the back button to return to the List page.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "primary_genre_list.jsp", "prev.gif", "", "", "", "");  

  }else{
    ausstage.AusstageInputOutput primary_genre = new ausstage.PrimaryGenre(db_ausstage);
    primary_genre.load(Integer.parseInt(primarygenreid));
    
    if(primary_genre.isInUse()){
      pageFormater.writeText (out, "Can not delete <b>" + primary_genre.getName() + "</b> because it has an association with the Events table!.<br>Click the back button to continue.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "primary_genre_list.jsp", "prev.gif", "", "", "", "");  
    }else{
      // write the confirmation message
      pageFormater.writeText (out, "Are you sure you want to delete the <b>" + primary_genre.getName() + "</b> primary genre?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "primary_genre_list.jsp", "cross.gif", "", "", "primary_genre_del_confirm_process.jsp?f_primarygenreid=" + primarygenreid , "tick.gif");
    }
  }

  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><jsp:include page="../templates/admin-footer.jsp" />
