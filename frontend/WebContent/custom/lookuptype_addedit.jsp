
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.LookupCode, java.util.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Lookups Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage        pageFormater          = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database          db_ausstage           = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator  htmlGenerator         = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.LookupType     lookupTypeObj         = new ausstage.LookupType (db_ausstage);
  String                  id;
  CachedRowSet            rset;
  Hashtable               hidden_fields         = new Hashtable();
  Vector                  lookup_code_vec       = new Vector();
  Vector                  temp_display_info;
  LookupCode              lookupCode            = new LookupCode(db_ausstage);
  String                  action                = request.getParameter("act");

  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
 
  
  // id = request.getParameter ("f_id");
  id = request.getParameter ("f_lookuptype_id");

  // if editing
  if (id != null && !id.equals("null")){
    lookupTypeObj.load(Integer.parseInt(id));
     lookup_code_vec  = lookupTypeObj.getLookupCodeLinks();
 }
    
%>
    
  <form name='f_lookupcode_addedit' id='f_lookupcode_addedit' action='lookuptype_addedit_process.jsp' method='post'>
  <%
  
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + id + "\">");

  if (id != null && !id.equals("null"))
  {
    pageFormater.writeHelper(out, "Enter the Lookup Details", "helpers_no1.gif");
    pageFormater.writeTwoColTableHeader(out, "ID");
    out.println(id);
    pageFormater.writeTwoColTableFooter(out);
  }
  pageFormater.writeTwoColTableHeader(out, "Code Type *");
  out.println("<input type=\"text\" name=\"f_code_type\" size=\"40\" class=\"line300\" maxlength=50 value=\"" + lookupTypeObj.getCodeType() + "\" " + (lookupTypeObj.getSystemFlag()?"DISABLED":"") + ">");
  if (lookupTypeObj.getSystemFlag()) {
    out.println("<input type=\"hidden\" name=\"f_code_type\" value=\"" + lookupTypeObj.getCodeType() + "\">");
  }
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "Description");
  out.println("<textarea name='f_description' rows='5' cols='10' class='line300' maxlength=\"200\"" + (lookupTypeObj.getSystemFlag()?"READONLY":"") + ">" + lookupTypeObj.getDescription()  + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "");
  out.println("Yes No");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "System Flag");
  out.println("<input type='radio' name='f_system_flag' value='Y' " +
              (lookupTypeObj.getSystemFlag()?"checked":"") + " " + (lookupTypeObj.getSystemFlag()?"DISABLED":"") + ">");
  out.println("<input type='radio' name='f_system_flag' value='N' " +
              (lookupTypeObj.getSystemFlag()?"":"checked") + " " + (lookupTypeObj.getSystemFlag()?"DISABLED":"") + ">");
  pageFormater.writeTwoColTableFooter(out);
  
 
    ///////////////////////////////////
  // Lookup Code Association(s)
  ///////////////////////////////////
 
  if (id != null && !id.equals("null")){
    out.println("<a name='event_data_resource'></a>");
    out.println (htmlGenerator.displayLinkedItem("",
                                               "2",
                                               "lookupcode_admin.jsp",
                                               "f_lookupcode_addedit",
                                               hidden_fields,
                                               "Lookup Codes",
                                               lookup_code_vec,
                                               1000));
  }
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  if (lookupTypeObj.getSystemFlag()) {
    pageFormater.writeButtons(out, "back", "prev.gif");
  }
  else {
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  }
  pageFormater.writeFooter(out);
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />