<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Content Indicator Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String primarycontentind = request.getParameter("f_primary_cont_ind_id");
  
  if(primarycontentind == null || primarycontentind.equals("")){
    // return back to the search page
    
    out.println("You have not selected a Subject to delete.<br>Please click the back button to return to the Search page.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "primary_content_ind_search.jsp", "prev.gif", "", "", "", "");  

  }else{
    ausstage.AusstageInputOutput primary_content_ind = new ausstage.PrimaryContentInd(db_ausstage);
    primary_content_ind.load(Integer.parseInt(primarycontentind));
    
    if(primary_content_ind.isInUse()){
      pageFormater.writeText (out,"Can not delete <b>" + primary_content_ind.getName() + "</b> because it has an association with the Events table!.<br>Click the back button to continue.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "primary_content_ind_search.jsp", "prev.gif", "", "", "", "");  
    }else{
      // write the confirmation message
      pageFormater.writeText (out,"Are you sure you want to delete the <b>" + primary_content_ind.getName() + "</b> Subject?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "BACK", "prev.gif", "primary_content_ind_search.jsp", "cross.gif", "primary_content_ind_del_confirm_process.jsp?f_primarycontindid=" + primarycontentind , "tick.gif");
    }
  }

  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<jsp:include page="../templates/admin-footer.jsp" />