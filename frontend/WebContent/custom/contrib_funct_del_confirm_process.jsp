<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

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
  ausstage.AusstageInputOutput contfunct = new ausstage.ContributorFunction(db_ausstage);
  
  String contfunct_id = request.getParameter("f_contfunct_id");
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  contfunct.setId(Integer.parseInt(contfunct_id));
  
  if(contfunct.delete()){
    if(contfunct.isInUse())
      pageFormater.writeText (out,"Could not delete Contributor Function because it has an association with the Contributor table!.<br>Click the tick button to continue.");
    else
      pageFormater.writeText (out,"Delete Contributor Function process was successful.<br>Click the tick button to continue.");
  }else{
    pageFormater.writeText (out,"Delete Contributor Function process was unsuccessful.<br>Please try again later.");
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "contrib_funct_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();

%>
<jsp:include page="../templates/admin-footer.jsp" />