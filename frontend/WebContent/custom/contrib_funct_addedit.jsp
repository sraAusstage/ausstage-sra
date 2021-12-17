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
  if (!session.getAttribute("permissions").toString().contains("Collection Information Access Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
   
  String        sqlString;
  CachedRowSet  rset;
  String        cont_funct_id = request.getParameter("f_selected_contfunct_id");
  Statement     stmt = db_ausstage.m_conn.createStatement();
  ausstage.AusstageInputOutput contfunct = new ausstage.ContributorFunction(db_ausstage);
  int    contfunctionid;
  String contfunction;
  String description;
  int    contfunctprefid;

%>
  <form name="f_edit_contrib_funct" id="f_edit_contrib_funct" method="post" action="contrib_funct_addedit_process.jsp" onsubmit="return checkFields();">
<%
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  if (cont_funct_id != null && !cont_funct_id.equals("")) {
    // Edit
    // load some data to its members
    contfunct.load(Integer.parseInt(cont_funct_id));
    
    // lets add the contfunct object with its current state in the request object
    //request.setAttribute("f_contfunct", contfunct);

    contfunctionid  = contfunct.getId();
    contfunction    = contfunct.getName();
    description     = contfunct.getDescription();
    contfunctprefid = contfunct.getPrefId();
  }
  else
  {
    // Add
    contfunctionid  = 0;
    contfunction    = "";
    description     = "";
    contfunctprefid = 0;
  }

  pageFormater.writeHelper(out, "Enter the Contributor Function Details", "helpers_no1.gif");

  if(contfunction   == null){contfunction = "";}
  if(description    == null){description = "";}
  if (cont_funct_id != null && !cont_funct_id.equals("") && !cont_funct_id.equals("0") && !cont_funct_id.equals("null"))
  {
    pageFormater.writeTwoColTableHeader (out, "ID");
    out.println(cont_funct_id);
    pageFormater.writeTwoColTableFooter (out);
  }
  pageFormater.writeTwoColTableHeader (out, "Contributor Function *");
  %>
  <input type="hidden" name="f_cont_funct_id" value="<%=cont_funct_id%>">
  <input class="line200" type="text" name="f_contrib_funct" size="40" maxlength="40" value="<%=contfunction%>">
  <%
  pageFormater.writeTwoColTableFooter (out);
  pageFormater.writeTwoColTableHeader (out, "Description");
  %>
  <textarea name="f_desc" rows="5" cols="32"><%=description%></textarea>
  <%
  pageFormater.writeTwoColTableFooter (out);
  pageFormater.writeTwoColTableHeader (out, "Select Existing Preferred Term");
  %>
  <input checked type="radio" name="f_pref_term" value="existing">
  <%
  sqlString = "select * from CONTRIBUTORFUNCTPREFERRED";
  rset = db_ausstage.runSQL(sqlString, stmt);
  if(rset.next()){                       
    out.println("\t<select name='f_existing_pref_term' class='line200'>\n");
    do{
      String selected = "";
      if(contfunctprefid == rset.getInt("CONTRIBUTORFUNCTPREFERREDID"))
        selected = "selected";
        
      out.println("\t\t<option " + selected + " value='"+ rset.getString("CONTRIBUTORFUNCTPREFERREDID") +"'>" + rset.getString("PREFERREDTERM") + "</option>\n");
    }while(rset.next());
    out.println("\t</select>\n");  
  }else{
    out.println("\t<select name='f_existing_pref_term' class='line200'>\n");
    out.println("\t\t<option value='0'>No Preferred Term found.</option>\n");
    out.println("\t</select>\n"); 
  }
  pageFormater.writeTwoColTableFooter (out);  
  pageFormater.writeTwoColTableHeader (out, "Create new Preferred Term");
  %>
  <input type="radio" name="f_pref_term" value="new">
  <input class="line200" type="text" name="f_new_pref_term" size="35" maxlength="300">
  <%
  pageFormater.writeTwoColTableFooter (out);
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT", "tick.gif");
%>
  <script language="javascript">
  <!--
    function checkFields(){

      if(document.f_edit_contrib_funct.f_pref_term[1].checked 
       && document.f_edit_contrib_funct.f_new_pref_term.value ==""){
        alert("You can not continue until Create new Preferred Term is filled in!");
        return false;
      }else{
        if(document.f_edit_contrib_funct.f_pref_term[0].checked 
          && document.f_edit_contrib_funct.f_existing_pref_term.value == 0){
          alert("You can not continue without specifying a Preferred Term!");
          return false;
        }else{  
          return true;
        }
      }
    }
  //-->
  </script>
<%
  pageFormater.writeFooter(out);
%>
  </form>
<%
  stmt.close();
  db_ausstage.disconnectDatabase();
%>
<jsp:include page="../templates/admin-footer.jsp" />