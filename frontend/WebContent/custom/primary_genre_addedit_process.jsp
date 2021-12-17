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

  int primarygenreid        = 0;
  String primary_genre_name = request.getParameter("f_primary_genre_name");
  String primary_genre_desc = request.getParameter("f_primary_genre_desc");
  
  // lets get the contfunct object that we stored in the request object on the previuos page
  //ausstage.ContributorFunction contfunct = (ausstage.ContributorFunction) request.getAttribute("f_contfunct");

  ausstage.AusstageInputOutput primary_genre = new ausstage.PrimaryGenre(db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
    
  if(request.getParameter("f_primary_genre_id") != null && !request.getParameter("f_primary_genre_id").equals("")){
    primarygenreid = Integer.parseInt(request.getParameter("f_primary_genre_id"));

    // load some data to its members
    primary_genre.load(primarygenreid);

    // modify the state of the obejct  
    primary_genre.setName(primary_genre_name);
    primary_genre.setDescription(primary_genre_desc);

    // edit the database
    if(primary_genre.update()){
      pageFormater.writeText (out, "Edit Primary Genre process was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText (out, "Edit Primary Genre process was unsuccessful.<br>Please try again later.");
    }
  }else{
    // set the state of the obejct  
    primary_genre.setName(primary_genre_name);
    primary_genre.setDescription(primary_genre_desc);

    // add into the database
    if(primary_genre.add()){
      pageFormater.writeText (out, "Add Primary Genre process was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText (out, "Add Primary Genre process was unsuccessful.<br>Please try again later.");
    }
  }
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "primary_genre_list.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<jsp:include page="../templates/admin-footer.jsp" />