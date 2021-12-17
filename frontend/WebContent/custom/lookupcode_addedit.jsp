<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Venue"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import = "ausstage.CodeAssociation"%>
<%@ page import = "java.util.ArrayList"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Lookups Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage    pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage   = new ausstage.Database ();
  ausstage.LookupCode lookupCode    = new ausstage.LookupCode (db_ausstage);
  ausstage.LookupType lookupTypeObj = new ausstage.LookupType(db_ausstage);
  CodeAssociation     lookCA        = new CodeAssociation(db_ausstage);
  ArrayList           arl           = new ArrayList();
  String              code_lov_id;
  String              code_type;
  String              ass_code_type;
  String              sqlString;
  CachedRowSet        rset;
  
  String  shortCode     = "";
  String  description   = "";
  boolean systemCode    = false;
  boolean defaultFlag   = false;
  String  seqNumber     = "0";
  boolean disableScreen = false;
  
  

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  code_lov_id = request.getParameter ("f_id");
  if (code_lov_id == null || code_lov_id.equals("null") || code_lov_id.equals("")) {
    code_lov_id = "";
  }
  
  code_type     = request.getParameter("f_code_type"); 
  ass_code_type = request.getParameter("f_ass_lookup_type");
  
  // if editing
  if (!code_lov_id.equals("")) {
    lookupCode.load (Integer.parseInt(code_lov_id));
    shortCode   = lookupCode.getShortCode();
    description = lookupCode.getDescription();
    systemCode  = lookupCode.getSystemCode();
    defaultFlag = lookupCode.getDefaultFlag();
    seqNumber   = lookupCode.getSequenceNo()+"";
    
    if (systemCode) {
      disableScreen = true;
    }
  }
  else {
    if (request.getParameter("f_shortcode") != null) {
      shortCode = request.getParameter("f_shortcode");
    }
    if (request.getParameter("f_description") != null) {
      description = request.getParameter("f_description");
    }
    
    if (request.getParameter("f_system_code") != null && request.getParameter("f_system_code").equals("Y")) {
      systemCode = true;
    }
    if (request.getParameter("f_defaultflag") != null && request.getParameter("f_defaultflag").equals("Y")) {
      defaultFlag = true;
    }
    if (request.getParameter("f_sequenceno") != null && !request.getParameter("f_sequenceno").equals("")) {
      seqNumber = request.getParameter("f_sequenceno");
    }
  }
  %>
  <form action='lookupcode_addedit_process.jsp' name='lookup_codes_update' method='post'>
  <%
  pageFormater.writeHelper(out, "Enter the Lookup Code Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + code_lov_id + "\">");
  out.println("<input type=\"hidden\" name=\"f_code_type\" value=\"" + code_type + "\">");
  
  if (!code_lov_id.equals("")) {
    pageFormater.writeTwoColTableHeader(out, "ID");
    out.println(code_lov_id);
    pageFormater.writeTwoColTableFooter(out);
  }
  
  
  pageFormater.writeTwoColTableHeader(out, "Code Type");
  out.println(code_type);
  pageFormater.writeTwoColTableFooter(out);
    
  pageFormater.writeTwoColTableHeader(out, "Short Code *");
  out.println("<input type=\"text\" name=\"f_shortcode\" size=\"20\" class=\"line300\" maxlength=30 value=\"" + shortCode + "\" " + (disableScreen?"DISABLED":"") + ">");
  if (disableScreen){
    out.println("<input type='hidden' name='f_shortcode' value=\"" + shortCode + "\">");
  }
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Description *");
  out.println("<textarea name='f_description' rows='5' cols='10' class='line300' maxlength=\"200\" " + (disableScreen?"READONLY":"") + ">" + description  + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "");
  out.println("Yes No");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "System Code");
  out.println("<input type='radio' name='f_system_code' value='Y' " +
              (systemCode?"checked":"") + " " + (disableScreen?"DISABLED":"") + ">");
  out.println("<input type='radio' name='f_system_code' value='N' " +
              (systemCode?"":"checked") + " " + (disableScreen?"DISABLED":"") + ">");
  if (disableScreen){
    out.println("<input type='hidden' name='f_system_code' value=" + (systemCode?"'Y'":"'N'") + ">");
  }

  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "");
  out.println("Yes No");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Default Flag");
  out.println("<input type='radio' name='f_defaultflag' value='Y' " +
              (defaultFlag?"checked":"") + " " + (disableScreen?"DISABLED":"") + ">");
  out.println("<input type='radio' name='f_defaultflag' value='N' " +
              (defaultFlag?"":"checked") + " " + (disableScreen?"DISABLED":"") + ">");
  if (disableScreen){
    out.println("<input type='hidden' name='f_defaultflag' value=\"" + (defaultFlag?"'Y'":"'N'") + "\">");
  }
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Sequence No");
  out.println("<input type=\"text\" name=\"f_sequenceno\" size=\"20\" class=\"line50\" maxlength=50 value=\"" + seqNumber + "\" " + (disableScreen?"DISABLED":"") + ">");
  if (disableScreen){
    out.println("<input type='hidden' name='f_sequenceno' value=\"" + seqNumber + "\">");
  }
  pageFormater.writeTwoColTableFooter(out);

  // Check if there is an association already for this Lookup Code
  // If there is then set combo to the correct Lookup Type and select the associated values in the list box.
  // Otherwise just load the combo with all Lookup Types. Load the list box with the values for the 'first' Lookup Type
  pageFormater.writeTwoColTableHeader(out, "Lookup Type");
  
  out.println("<select name='f_ass_lookup_type' onChange='getLookupCodes(value)' class='line200'>\n");

  // load existing code associations
  if (!code_lov_id.equals("")) {
    lookCA.load(code_lov_id);
  }

  // populate the drop down with all available Code Types
  sqlString = "SELECT * " + 
              "FROM Lookup_Types " +
              "ORDER BY DESCRIPTION";

  rset = db_ausstage.runSQL(sqlString, stmt);
  
  // if the first time new page then set code_type to empty string, 
  //  only if there are no existing code associations is null
  // - also covers if no code type set for the Lookup 
  if (ass_code_type != null && !ass_code_type.equals("null")){
    // this is not the first time
  } else {
    if (lookCA.getCode2Type().equals("")){
      ass_code_type = "";
    } else {
      // get code type of association
      ass_code_type = lookCA.getCode2Type();
    }
  }
  // populate the combo with the Lookup Types and select one if it was chosen
  if(rset.next()){
    out.println("<option value=''></option>\n");
    do {
      String selected = "";
      
      if(!ass_code_type.equals("")){
        // if selected existing lookup type then select it
        if(ass_code_type.equals(rset.getString("CODE_TYPE"))){
          // if this page is refreshing from a change in Lookup Type selection,
          // make sure the selected Lookup Type is selected in the refreshed page
          selected = "selected";
        } else {
          selected = "";
        }
      }// else { // no selection yet as on entry => use the first value
       // ass_code_type = rset.getString("CODE_TYPE");
       // selected = "selected";
      //}
      out.println("<option " + selected + " value='"+ rset.getString("CODE_TYPE") +"'>" + rset.getString("CODE_TYPE") + "</option>\n");
    }
    while(rset.next());
  }
  // close select, close table
  out.println("</select>");
  pageFormater.writeTwoColTableFooter(out);

  // fill in the list box for lookup codes
  pageFormater.writeTwoColTableHeader (out, "Lookup Codes");
  out.println("<select name='f_code_2_lov_ids' size='7' class='line300' multiple>");
  
  // get any existing code associations
  if (lookCA.getCode2LovIds() != null){
    for (int i = 0; i < lookCA.getCode2LovIds().length; i++){
      arl.add(new Integer(lookCA.getCode2LovIds()[i]));
    }
  }
  // do the query to populate the list
  // there is a bug and casting short_code to char as a workaround 
  // See https://stackoverflow.com/a/15185345/882437
  sqlString = "SELECT CODE_LOV_ID, cast(short_code as char) as value " + 
              "FROM LOOKUP_CODES " + 
              "WHERE CODE_TYPE = '" + ass_code_type + "' " +
              "ORDER BY short_code ";
  
  rset = db_ausstage.runSQL(sqlString, stmt);

  // Display all of the Lookup Codes for the Lookup Type
  while (rset.next())
  {
  int blah = rset.getInt("code_lov_id");
    out.print("<option value='" + rset.getInt("code_lov_id") + "'");

    if (arl.contains(new Integer(rset.getInt("code_lov_id")))){
      out.print(" selected");
    }
    out.print(">" + rset.getString ("value") + "</option>");
  }
  rset.close ();
  
  out.println("</select>");
  pageFormater.writeTwoColTableFooter(out);
  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  // if system code, allow code association to be made - other fields are not updateable
  if (disableScreen) {
    //pageFormater.writeButtons(out, "back", "prev.gif");
    pageFormater.writeButtons(out, "", "", "lookuptype_search.jsp", "", "submit", "next.gif");
  }
  else {
    //pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/custom/ausstage/welcome.jsp", "cross.gif", "submit", "next.gif");
    pageFormater.writeButtons(out, "", "", "lookuptype_search.jsp", "cross.gif", "submit", "next.gif");
  }
  pageFormater.writeFooter(out);
%>

</form>

<script language="Javascript">

    function getLookupCodes(lookupType){
      
      document.lookup_codes_update.action = 'lookupcode_addedit.jsp';
      document.lookup_codes_update.submit();
    }
    
</script>
<jsp:include page="../templates/admin-footer.jsp" />