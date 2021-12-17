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
  
  String second_genre_id    = request.getParameter("f_second_genre_id");
  String second_genre_name  = request.getParameter("f_second_genre_name");
  String second_genre_desc  = request.getParameter("f_second_genre_desc");
  String exist_pref_term_id = request.getParameter("f_existing_pref_term");
  String new_pref_term      = request.getParameter("f_new_pref_term");
  String pref_term_opt      = request.getParameter("f_pref_term");
 // int cont_funct_id         = Integer.parseInt();

  // lets get the contfunct object that we stored in the request object on the previuos page
  //ausstage.ContributorFunction contfunct = (ausstage.ContributorFunction) request.getAttribute("f_contfunct");

  ausstage.AusstageInputOutput secondary_genre = new ausstage.SecondaryGenre(db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
    
  if(second_genre_id != null && !second_genre_id.equals("")){

    // load data to its members
    secondary_genre.load(Integer.parseInt(second_genre_id));

    // test the option radio button & set the object state accordingly
    if(pref_term_opt != null && pref_term_opt.equals("existing") && !exist_pref_term_id.equals("0")){
      secondary_genre.setPrefId(Integer.parseInt(exist_pref_term_id));
      secondary_genre.setNewPrefName("");
    }else{
      secondary_genre.setPrefId(0);
      secondary_genre.setNewPrefName(new_pref_term);
    }
    secondary_genre.setName(second_genre_name);
    secondary_genre.setDescription(second_genre_desc);

  
    if(secondary_genre.update()){
      pageFormater.writeText (out, "Edit Secondary Genre process was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText (out, "Edit Secondary Genre process was unsuccessful.<br>Please try again later.");
    }
  }else{
    // add section
    
    // test the option radio button & set the object state accordingly
    if(pref_term_opt != null && pref_term_opt.equals("existing") && !exist_pref_term_id.equals("0")){
      secondary_genre.setPrefId(Integer.parseInt(exist_pref_term_id));
      secondary_genre.setNewPrefName("");
    }else{
      secondary_genre.setPrefId(0);
      secondary_genre.setNewPrefName(new_pref_term);
    }
    secondary_genre.setName(second_genre_name);
    secondary_genre.setDescription(second_genre_desc);
  
    if(secondary_genre.add()){
      pageFormater.writeText (out, "Add Secondary Genre process was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText (out, "Add Secondary Genre process was unsuccessful.<br>Please try again later.");
    }
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "second_genre_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<jsp:include page="../templates/admin-footer.jsp" />