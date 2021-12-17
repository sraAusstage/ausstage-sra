<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

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

  ausstage.AusstageInputOutput primary_genre = new ausstage.PrimaryGenre(db_ausstage);
  String primary_genre_id = request.getParameter("f_selected_primary_genre_id");
  String action           = request.getParameter("act");
  String primarygenrename = "",   primarygenredesc = "";
  int primarygenreid      = 0;

  if(action == null){action = "";}
%>
  <form name="f_primary_genre_addedit" id="f_primary_genre_addedit" method="post" action="primary_genre_addedit_process.jsp" onsubmit="return checkFields();">
<%
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  pageFormater.writeHelper(out, "Enter the Primary Genre Details", "helpers_no1.gif");

  if(primary_genre_id != null && !primary_genre_id.equals("")){
    // load some data to its members
    primary_genre.load(Integer.parseInt(primary_genre_id));
    
    // lets add the contfunct object with its current state in the request object
    //request.setAttribute("f_contfunct", contfunct);

    primarygenreid   = primary_genre.getId();
    primarygenrename = primary_genre.getName();
    primarygenredesc = primary_genre.getDescription();
   // int primarygenreprefid  = primary_genre.getPrefId();
  
    if(primarygenreid   == 0)   {primarygenreid   = 0;}
    if(primarygenrename == null){primarygenrename = "";} 
    if(primarygenredesc == null){primarygenredesc = "";}
    

    pageFormater.writeTwoColTableHeader(out, "ID");
    out.println(primarygenreid); 
    pageFormater.writeTwoColTableFooter(out);  
 
    pageFormater.writeTwoColTableHeader (out, "Primary Genre Class");
  %>
    <input type="hidden" name="f_primary_genre_id" value="<%=primarygenreid%>">
    <input class="line200" type="text" name="f_primary_genre_name" size="40" maxlength="40" value="<%=primarygenrename%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Primary Genre Description");
  %>
    <input class="line200" type="text" name="f_primary_genre_desc" size="40" maxlength="300" value="<%=primarygenredesc%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "", "", "", "", "SUBMIT", "tick.gif");
  }else{
    if(!action.equals("")){ 
      // add section
 
      pageFormater.writeTwoColTableHeader (out, "Primary Genre Class");
%>
      <input class="line200" type="text" name="f_primary_genre_name" size="10" maxlength="40" value="">
<%
      pageFormater.writeTwoColTableFooter (out);
      pageFormater.writeTwoColTableHeader (out, "Primary Genre Description");
%>
      <input class="line200" type="text" name="f_primary_genre_desc" size="10" maxlength="300" value="">
<%
      pageFormater.writeTwoColTableFooter (out);
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "primary_genre_list.jsp", "cross.gif", "", "", "SUBMIT", "tick.gif");    
    }else{
      out.println("You have not selected a Primary Genre to edit.<br>Please click the back button to return to the Primary Genre Management page.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "primary_genre_list.jsp", "prev.gif", "", "", "", "");  
    }
  }
  pageFormater.writeFooter(out);
%>
  </form>
<%
  db_ausstage.disconnectDatabase();
%>

<script language="javascript">
<!--
  function checkFields(){

    if(document.f_primary_genre_addedit.f_primary_genre_name.value == "")
    {
      alert("Please enter the Primary Genre Class");
      return false;
    }else{
      return true;
    }
  }
//-->
</script>

<jsp:include page="../templates/admin-footer.jsp" />