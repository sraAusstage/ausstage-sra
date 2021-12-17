<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

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
  
  ausstage.AusstageInputOutput primary_content_ind = new ausstage.PrimaryContentInd(db_ausstage);
  
  String primarycontentind = request.getParameter("f_primarycontindid");

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  // set the id state of the object here
  primary_content_ind.setId(Integer.parseInt(primarycontentind));
  
  if(primary_content_ind.delete()){
    if(primary_content_ind.isInUse())
      pageFormater.writeText(out, "Could not delete Subject because it has an association with the Events table!.<br>Click the tick button to continue.");
    else
      pageFormater.writeText(out, "Delete Subjects process was successful.<br>Click the tick button to continue.");
  }else{
    pageFormater.writeText(out, "Delete Subjects process was unsuccessful.<br>Please try again later.");
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "primary_content_ind_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();

%><jsp:include page="../templates/admin-footer.jsp" />
