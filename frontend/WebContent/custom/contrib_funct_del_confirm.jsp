<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Contributor Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String contfunct_id = request.getParameter("f_selected_contfunct_id");
  
  if(contfunct_id == null || contfunct_id.equals("")){
    // return back to the search page
    
    pageFormater.writeText (out,"You have not selected a Contributor Function to delete.<br>Please click the back button to return to the Search page.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "contrib_funct_search.jsp", "prev.gif", "", "", "", "");  

  }else{

    ausstage.AusstageInputOutput contfunct = new ausstage.ContributorFunction(db_ausstage);
    contfunct.load(Integer.parseInt(contfunct_id));
    
    if(contfunct.isInUse()){
      pageFormater.writeText (out,"Can not delete <b>" + contfunct.getName() + "</b> because it has an association with the Contributor table!.<br>Click the tick button to continue.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "contrib_funct_search.jsp", "prev.gif", "", "", "", ""); 
    }else{
      // write the confirmation message
      pageFormater.writeText (out,"Are you sure you want to delete the <b>" + contfunct.getName() + "</b> contributor function?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "contrib_funct_search.jsp", "cross.gif", "", "", "contrib_funct_del_confirm_process.jsp?f_contfunct_id=" + contfunct_id , "tick.gif");
    }
  }

  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>

<jsp:include page="../templates/admin-footer.jsp" />