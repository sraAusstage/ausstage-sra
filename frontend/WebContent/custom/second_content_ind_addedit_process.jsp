<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
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
  
  String second_content_ind_id    = request.getParameter("f_second_content_ind_id");
  String second_content_ind_name  = request.getParameter("f_second_content_ind_name");
  String second_content_ind_desc  = request.getParameter("f_second_content_ind_desc");
  String exist_pref_term_id       = request.getParameter("f_existing_pref_term");
  String new_pref_term            = request.getParameter("f_new_pref_term");
  String pref_term_opt            = request.getParameter("f_pref_term");
  ausstage.AusstageInputOutput secondary_content_ind = new ausstage.SecondaryContentInd(db_ausstage);

  if (second_content_ind_desc == null)
    second_content_ind_desc = "";

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
    
  if(second_content_ind_id != null && !second_content_ind_id.equals("")){

    // load data to its members
    secondary_content_ind.load(Integer.parseInt(second_content_ind_id));

    // test the option radio button & set the object state accordingly
    if(pref_term_opt != null && pref_term_opt.equals("existing") && !exist_pref_term_id.equals("0")){
      secondary_content_ind.setPrefId(Integer.parseInt(exist_pref_term_id));
      secondary_content_ind.setNewPrefName("");
    }else{
      secondary_content_ind.setPrefId(0);
      secondary_content_ind.setNewPrefName(new_pref_term);
    }
    secondary_content_ind.setName(second_content_ind_name);
    secondary_content_ind.setDescription(second_content_ind_desc);

  
    if(secondary_content_ind.update()){
      pageFormater.writeText(out, "Edit Secondary Subjects process was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText(out, "Edit Secondary Subjects process was unsuccessful.<br>Please make sure that you are not duplicating another entry.");
    }
  }else{
    // add section
    
    // test the option radio button & set the object state accordingly
    if(pref_term_opt != null && pref_term_opt.equals("existing") && !exist_pref_term_id.equals("0")){
      secondary_content_ind.setPrefId(Integer.parseInt(exist_pref_term_id));
      secondary_content_ind.setNewPrefName("");
    }else{
      secondary_content_ind.setPrefId(0);
      secondary_content_ind.setNewPrefName(new_pref_term);
    }
    secondary_content_ind.setName(second_content_ind_name);
    secondary_content_ind.setDescription(second_content_ind_desc);

  
    if(secondary_content_ind.add()){
      pageFormater.writeText(out, "Add Secondary Subjects process was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText(out, "Add Secondary Subjects process was unsuccessful.<br>Please make sure that you are not adding a duplicate.");
    }
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "second_content_ind_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<jsp:include page="../templates/admin-footer.jsp" />