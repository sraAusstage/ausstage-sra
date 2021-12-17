<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Country"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import = "java.util.Vector"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Lookups Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.LookupCode lookupCodeObj   = new ausstage.LookupCode (db_ausstage);
  ausstage.CodeAssociation codeAssociation = new ausstage.CodeAssociation (db_ausstage);
  String              code_lov_id;
  CachedRowSet        rset;
  boolean            error_occurred = false;
  String              description    = request.getParameter("f_description");

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  code_lov_id = request.getParameter ("f_id");
  String code_type = request.getParameter ("f_code_type");
  
  // if editing set the object to the selected record
  if (code_lov_id != null && !code_lov_id.equals ("") && !code_lov_id.equals ("null"))
    lookupCodeObj.load (Integer.parseInt(code_lov_id));

  if (description == null) description = "";
  
  lookupCodeObj.setShortCode(request.getParameter("f_shortcode"));
  lookupCodeObj.setCodeType(code_type);
  lookupCodeObj.setDescription(description);
  lookupCodeObj.setSystemCode(request.getParameter("f_system_code"));
  lookupCodeObj.setDefaultFlag(request.getParameter("f_defaultflag"));
  lookupCodeObj.setSequenceNo(Integer.parseInt(request.getParameter("f_sequenceno")));

  // code association
  //codeAssociation.setCode1Type(code_type);

  // if editing
  if (code_lov_id != null && !code_lov_id.equals ("") && !code_lov_id.equals ("null")) {
    error_occurred = !lookupCodeObj.update();
  }   else { // Adding
    error_occurred = !lookupCodeObj.add();
    code_lov_id = lookupCodeObj.getCodeLovID()+"";
  }

  if (code_lov_id != null && !code_lov_id.equals("")) {
    codeAssociation.setCode1Type(code_type);
    codeAssociation.setCode1LovId(Integer.parseInt(code_lov_id));
  
    // always remove existing code association then insert new records
    codeAssociation.delete();
  }
  
  
  // code associations, if any
  if (request.getParameter("f_ass_lookup_type") != null && !request.getParameter("f_ass_lookup_type").equals("") && request.getParameterValues("f_code_2_lov_ids") != null) {
    
  
    codeAssociation.setCode2Type(request.getParameter("f_ass_lookup_type"));
    codeAssociation.setCode2LovIds((String [])request.getParameterValues("f_code_2_lov_ids"));
  
    error_occurred = !codeAssociation.add();
  }

  // Error
  if (error_occurred)
    pageFormater.writeText (out, lookupCodeObj.getError());
  else
    pageFormater.writeText (out, "The lookup code <b>" + lookupCodeObj.getShortCode() + "</b> was successfully saved");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  if (error_occurred) {
    pageFormater.writeButtons(out, "back", "prev.gif", "", "", "", "");
  }
  else {
    pageFormater.writeButtons(out, "", "", "", "", "lookupcode_admin.jsp?f_code_type=" + code_type, "tick.gif");
  }
  pageFormater.writeFooter(out);
%>
</form><jsp:include page="../templates/admin-footer.jsp" />