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
  if (!session.getAttribute("permissions").toString().contains("Contributor Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String contributorid = request.getParameter("f_contributor_id");
  String process_type  = request.getParameter("process_type");
  String action        = request.getParameter("act"); 

  if(action == null)
    action = "";
  
  if(contributorid == null || contributorid.equals("")){
    // return back to the search page
    
    out.println("You have not selected a Contributor to delete.<br>Please click the back button to return to the Contributor Search page.");
    pageFormater.writePageTableFooter (out);
    if(process_type != null && process_type.equals("add_article"))
      pageFormater.writeButtons (out, "event_articles_add_contrib.jsp", "prev.gif", "", "", "", ""); 
    else
      pageFormater.writeButtons (out, "contrib_search.jsp", "prev.gif", "", "", "", "");  

  }else{

    ausstage.Contributor contributor = new ausstage.Contributor(db_ausstage);
    contributor.load(Integer.parseInt(contributorid));
    
    if(contributor.isInUse()){
      pageFormater.writeText (out,"Can not delete <b>" + contributor.getLastName() + " " + contributor.getName() + "</b> because it has an association with Event!.<br>Please click the back button to return to the Contributor Search page.");
      pageFormater.writePageTableFooter (out);
      if(process_type != null && process_type.equals("add_article"))
        pageFormater.writeButtons (out, "event_articles_add_contrib.jsp", "prev.gif", "", "", "", ""); 
      else
        pageFormater.writeButtons (out, "contrib_search.jsp", "prev.gif", "", "", "", "");  
    }else{
      // write the confirmation message
      pageFormater.writeText (out,"Are you sure you want to delete the <b>" + contributor.getLastName() + " " + contributor.getName() + "</b> contributor?");
      pageFormater.writePageTableFooter (out);
      if(process_type != null && process_type.equals("add_article"))
        pageFormater.writeButtons (out, "event_articles_add_contrib.jsp?act=" + action , "cross.gif", "", "", "contrib_del_confirm_process.jsp?f_contributor_id=" + contributorid + "&process_type=" + process_type + "&act=" + action, "tick.gif");
      else
      pageFormater.writeButtons (out, "contrib_search.jsp", "cross.gif", "", "", "contrib_del_confirm_process.jsp?f_contributor_id=" + contributorid , "tick.gif");
    }
  }

  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>

<jsp:include page="../templates/admin-footer.jsp" />