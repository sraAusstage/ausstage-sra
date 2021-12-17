<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Entity"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Collection Information Access Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage    pageFormater   = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage    = new ausstage.Database ();
  ausstage.EntityType entityTypeObj  = new ausstage.EntityType (db_ausstage);
  ausstage.Entity     entityObj      = new ausstage.Entity (db_ausstage);
  ausstage.State      stateObj       = new ausstage.State (db_ausstage);
  ausstage.Country    countryObj     = new ausstage.Country(db_ausstage);
  String              entity_id;
  CachedRowSet        rset;
  String f_referrer                  = request.getParameter("f_from");
  String coll_id                     = request.getParameter("coll_id");
  
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  entity_id = request.getParameter ("f_id");
  // if editing
  if (entity_id != null)
    entityObj.load (Integer.parseInt(entity_id));%>
  <form action='entity_addedit_process.jsp' method='post'>
  <%
  if(f_referrer != null){
    out.println("<input type=\"hidden\" name=\"f_from\" value=\"" + f_referrer + "\">");
    out.println("<input type=\"hidden\" name=\"coll_id\" value=\"" + coll_id + "\">");
  }
    
  pageFormater.writeHelper(out, "Enter the Entity Details", "helpers_no1.gif");
  out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + entity_id + "\">");

  // Entity Type
  pageFormater.writeTwoColTableHeader(out, "ID");
  out.println(entity_id);
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "Type");
  out.println("<select name=\"f_type\" size=\"1\" class=\"line200\">");
  rset = entityTypeObj.getEntityTypes (stmt);

  // Display all of the Entity Types
  while (rset.next())
  {
    out.print("<option value='" + rset.getInt ("entity_type_id") + "'");

    if (entityObj.getType().equals(Integer.toString(rset.getInt("entity_type_id"))))
      out.print(" selected");
    out.print(">" + rset.getString ("type") + "</option>");
  }
  rset.close ();
  out.println("</select>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Name");
  out.println("<input type=\"text\" name=\"f_name\" size=\"20\" class=\"line150\" maxlength=50 value=\"" + entityObj.getName() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Address");
  out.println("<input type=\"text\" name=\"f_address\" size=\"20\" class=\"line150\" maxlength=2000 value=\"" + entityObj.getAddress() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "City/Suburb");
  out.println("<input type=\"text\" name=\"f_city_suburb\" size=\"20\" class=\"line150\" maxlength=50 value=\"" + entityObj.getCitySuburb() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // State
  pageFormater.writeTwoColTableHeader(out, "State");
  out.println("<select name=\"f_stateid\" size=\"1\" class=\"line50\">");
  rset = stateObj.getStates (stmt);

  // Display all of the states
  while (rset.next())
  {
    out.print("<option value='" + rset.getString ("stateid") + "'");

    if (entityObj.getStateid().equals (rset.getString ("stateid")))
      out.print(" selected");
    out.print(">" + rset.getString ("state") + "</option>");
  }
  rset.close ();
  stmt.close ();
  out.println("</select>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Post Code");
  out.println("<input type=\"text\" name=\"f_postcode\" size=\"5\" class=\"line50\" maxlength=10 value=\"" + entityObj.getPostcode() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contacts");
  out.println("<input type=\"text\" name=\"f_contacts\" size=\"40\" class=\"line150\" maxlength=50 value=\"" + entityObj.getContacts() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Phone");
  out.println("<input type=\"text\" name=\"f_phone\" size=\"40\" class=\"line150\" maxlength=50 value=\"" + entityObj.getPhone() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Fax");
  out.println("<input type=\"text\" name=\"f_fax\" size=\"40\" class=\"line150\" maxlength=50 value=\"" + entityObj.getFax() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Email");
  out.println("<input type=\"text\" name=\"f_email\" size=\"40\" class=\"line150\" maxlength=150 value=\"" + entityObj.getEmail() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Web Address");
  out.println("<input type=\"text\" name=\"f_www\" size=\"40\" class=\"line150\" maxlength=500 value=\"" + entityObj.getWWW() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);
%>
</form><jsp:include page="../templates/admin-footer.jsp" />
