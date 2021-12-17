<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Secondary Genre Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  Statement     stmt = db_ausstage.m_conn.createStatement();
  ausstage.AusstageInputOutput secondary_content_ind = new ausstage.SecondaryContentInd(db_ausstage);
  
  String        sqlString;
  CachedRowSet  rset;
  String second_content_ind_id = request.getParameter("f_selected_second_content_ind_id");
  String action                = request.getParameter("act");
  String secondcontentindname  = "",   secondcontentinddesc = "";
  int secondcontentindid       = 0, secondPrefid = 0;

  secondcontentindname         = request.getParameter("f_second_contentind_name");
  secondcontentinddesc         = request.getParameter("f_second_contentind_desc");
  String exist_pref_term_id    = request.getParameter("f_existing_pref_term");
  String new_pref_term         = request.getParameter("f_new_pref_term");
  String pref_term_opt         = request.getParameter("f_pref_term");

  if(secondcontentindname == null)
    secondcontentindname = "";

  if(secondcontentinddesc == null)
    secondcontentinddesc = "";
    
  if(exist_pref_term_id != null && !exist_pref_term_id.equals(""))
    secondPrefid = Integer.parseInt(exist_pref_term_id);

  if(new_pref_term == null)
    new_pref_term = "";

  if(pref_term_opt == null)
    pref_term_opt = "";    
    
  if(action == null){action = "";}  

%>
  <form name="f_second_content_ind_addedit" id="f_second_content_ind_addedit" method="post" action="second_content_ind_addedit_process.jsp" onsubmit="return checkFields();">
<%
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  if(second_content_ind_id != null && !second_content_ind_id.equals("")){
    // load some data to its members
    secondary_content_ind.load(Integer.parseInt(second_content_ind_id));
    
    secondcontentindid   = secondary_content_ind.getId();
    
    if(request.getParameter("f_mode") == null || request.getParameter("f_mode").equals("")){
      secondcontentindname = secondary_content_ind.getName();
      secondcontentinddesc = secondary_content_ind.getDescription();
      secondPrefid         = secondary_content_ind.getPrefId();
    }
  
    if(secondcontentindid == 0)     {secondcontentindid   = 0;}
    if(secondcontentindname == null){secondcontentindname = "";}
    if(secondcontentinddesc == null){secondcontentinddesc = "";}
    if(secondPrefid == 0)           {secondPrefid   = 0;}

    out.println("ID: " + secondcontentindid); 
    pageFormater.writeTwoColTableHeader (out, "Secondary Subjects");

%>
    <input type="hidden" name="f_second_content_ind_id" value="<%=secondcontentindid%>">
    <input class="line200" type="text" name="f_second_content_ind_name" size="10" maxlength="40" value="<%=secondcontentindname%>">
<%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Secondary Subjects Description");
%>
    <input class="line200" type="text" name="f_second_content_ind_desc" size="10" maxlength="300" value="<%=secondcontentinddesc%>">
<%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Select Existing Preferred Term");
%>
    <input checked type="radio" name="f_pref_term" value="existing">
<%
    sqlString = "select * from SECCONTENTINDICATORPREFERRED";
    rset = db_ausstage.runSQL(sqlString, stmt);
    if(rset.next()){                       
      out.println("\t<select name='f_existing_pref_term' class='line200'>\n");
      do{
        String selected = "";
        if(secondPrefid == rset.getInt("SECCONTENTINDICATORPREFERREDID"))
          selected = "selected";
        
        out.println("\t\t<option " + selected + " value='"+ rset.getString("SECCONTENTINDICATORPREFERREDID") +"'>" + rset.getString("PREFERREDTERM") + "</option>\n");
      }while(rset.next());
      out.println("\t</select>\n");  
    }else{
      out.println("\t<select name='f_existing_pref_term' class='line200'>\n");
      out.println("\t\t<option value='0'>No Preferred Term found.</option>\n");
      out.println("\t</select>\n"); 
    }
%>
    <a style='cursor:hand' onclick="Javascript:editDelPrefTerm(f_second_content_ind_addedit.f_existing_pref_term.options[f_second_content_ind_addedit.f_existing_pref_term.selectedIndex].value, f_second_content_ind_addedit.f_existing_pref_term.options[f_second_content_ind_addedit.f_existing_pref_term.selectedIndex].text, '<%=secondcontentindid%>', 'edit');"><img border='0' src='<%=AppConstants.IMAGE_DIRECTORY%>/edit.gif'></a>&nbsp;
    <a style='cursor:hand' onclick="Javascript:editDelPrefTerm(f_second_content_ind_addedit.f_existing_pref_term.options[f_second_content_ind_addedit.f_existing_pref_term.selectedIndex].value, f_second_content_ind_addedit.f_existing_pref_term.options[f_second_content_ind_addedit.f_existing_pref_term.selectedIndex].text, '<%=secondcontentindid%>', 'delete');"><img border='0' src='<%=AppConstants.IMAGE_DIRECTORY%>/delete.gif'></a>
<%
    pageFormater.writeTwoColTableFooter (out); 
    pageFormater.writeTwoColTableHeader (out, "Create new Preferred Term");
%>
    <input type="radio" name="f_pref_term" value="new">
    <input class="line200" type="text" name="f_new_pref_term" size="10" maxlength="300" value="<%=new_pref_term%>">
<%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "", "", "", "", "SUBMIT", "tick.gif");
  }else{
    if(action.equals("add")){
      out.println("ID: "); 
      pageFormater.writeTwoColTableHeader (out, "Secondary Subjects");

%>
      <input type="hidden" name="f_second_content_ind_id" value="">
      <input class="line200" type="text" name="f_second_content_ind_name" size="10" maxlength="40" value="<%=secondcontentindname%>">
<%
      pageFormater.writeTwoColTableFooter (out);
      pageFormater.writeTwoColTableHeader (out, "Secondary Subjects Description");
%>
      <input class="line200" type="text" name="f_second_content_ind_desc" size="10" maxlength="300" value="<%=secondcontentinddesc%>">
<%
      pageFormater.writeTwoColTableFooter (out);
      pageFormater.writeTwoColTableHeader (out, "Select Existing Preferred Term");
%>
      <input checked type="radio" name="f_pref_term" value="existing">
<%
      sqlString = "select * from SECCONTENTINDICATORPREFERRED";
      rset = db_ausstage.runSQL(sqlString, stmt);
      if(rset.next()){                       
        out.println("\t<select name='f_existing_pref_term' class='line200'>\n");
        do{
          String selected = "";
          if(secondPrefid == rset.getInt("SECCONTENTINDICATORPREFERREDID"))
            selected = "selected";
        
          out.println("\t\t<option " + selected + " value='"+ rset.getString("SECCONTENTINDICATORPREFERREDID") +"'>" + rset.getString("PREFERREDTERM") + "</option>\n");
        }while(rset.next());
        out.println("\t</select>\n");  
      }else{
        out.println("\t<select name='f_existing_pref_term' class='line200'>\n");
        out.println("\t\t<option value='0'>No Preferred Term found.</option>\n");
        out.println("\t</select>\n"); 
      }
%>
      <a style='cursor:hand' onclick="Javascript:editDelPrefTerm(f_second_content_ind_addedit.f_existing_pref_term.options[f_second_content_ind_addedit.f_existing_pref_term.selectedIndex].value, f_second_content_ind_addedit.f_existing_pref_term.options[f_second_content_ind_addedit.f_existing_pref_term.selectedIndex].text, '<%=secondcontentindid%>', 'edit');"><img border='0' src='<%=AppConstants.IMAGE_DIRECTORY%>/edit.gif'></a>&nbsp;
      <a style='cursor:hand' onclick="Javascript:editDelPrefTerm(f_second_content_ind_addedit.f_existing_pref_term.options[f_second_content_ind_addedit.f_existing_pref_term.selectedIndex].value, f_second_content_ind_addedit.f_existing_pref_term.options[f_second_content_ind_addedit.f_existing_pref_term.selectedIndex].text, '<%=secondcontentindid%>', 'delete');"><img border='0' src='<%=AppConstants.IMAGE_DIRECTORY%>/delete.gif'></a>
<%
      pageFormater.writeTwoColTableFooter (out); 
      pageFormater.writeTwoColTableHeader (out, "Create new Preferred Term");
%>
      <input type="radio" name="f_pref_term" value="new">
      <input class="line200" type="text" name="f_new_pref_term" size="10" maxlength="300" value="<%=new_pref_term%>">
<%
      pageFormater.writeTwoColTableFooter (out);
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "", "", "", "", "SUBMIT", "tick.gif");
    }else{
      out.println("You have not selected a Secondary Subject to edit.<br>Please click the back button to return to the Secondary Subjects Search page.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "second_content_ind_search.jsp", "prev.gif", "", "", "", "");  
    }
  }

  pageFormater.writeFooter(out);
%>
  <input type="hidden" name="act" value="<%=action%>">
  </form>
<%
  stmt.close();
  db_ausstage.disconnectDatabase();
%>

<script language="javascript">
<!--
  function checkFields(){

    if(isBlank(document.f_second_content_ind_addedit.f_second_content_ind_name.value)){
      alert("You can not continue until Secondary Content Indicator is filled in!");
      return false;
    //}else if(isBlank(document.f_second_content_ind_addedit.f_second_content_ind_desc.value)){
     // alert("You can not continue until Secondary Content Indicator Description is filled in!");
     // return false;
    }else if(document.f_second_content_ind_addedit.f_pref_term[1].checked 
     && document.f_second_content_ind_addedit.f_new_pref_term.value ==""){
      alert("You can not continue until Create new Preferred Term is filled in!");
      return false;
    }else{
      if(document.f_second_content_ind_addedit.f_pref_term[0].checked 
       && document.f_second_content_ind_addedit.f_existing_pref_term.value == '0'){
        alert("You can not continue without specifying a Preferred Term!");
        return false;
      }else{  
        return true;
      }
    }
  }

  function editDelPrefTerm(p_prefftermId, p_second_contentind_pref_term, p_second_content_ind_id, p_mode){ 
    if(p_prefftermId != "" && p_prefftermId > 0){
      document.f_second_content_ind_addedit.action= "sec_contentind_editdel_prefterm.jsp?f_second_contentind_pref_term=" + p_second_contentind_pref_term + "&f_mode=" + p_mode + "&f_existing_pref_term_id=" + p_prefftermId + "&f_second_content_ind_id=" + p_second_content_ind_id;
      document.f_second_content_ind_addedit.submit();
    }else{
      alert("You must select an existing Preferred Term first.");
    }
  }
//-->
</script>
<jsp:include page="../templates/admin-footer.jsp" />

