<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Country"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  	admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
    if (!session.getAttribute("permissions").toString().contains("Country Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
		response.sendRedirect("/custom/welcome.jsp" );
		return;
	}
  admin.FormatPage    pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database      db_ausstage  = new ausstage.Database ();
  ausstage.Country    countryObj   = new ausstage.Country (db_ausstage);
  String              country_id;
  CachedRowSet        rset;
  boolean             error_occurred = false;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  country_id = request.getParameter ("f_id");
  
  // if editing set the object to the selected record
  if (country_id != null && !country_id.equals ("") && !country_id.equals ("null"))
    countryObj.load (Integer.parseInt(country_id));

  countryObj.setName(request.getParameter("f_name"));

  // if editing
  if (country_id != null && !country_id.equals ("") && !country_id.equals ("null"))
    error_occurred = !countryObj.update();
  else // Adding
    error_occurred = !countryObj.add();

  // Error
  if (error_occurred)
    pageFormater.writeText (out,countryObj.getError());
  else
    pageFormater.writeText (out,"The country <b>" + countryObj.getName() + "</b> was successfully saved");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "", "", "", "", "country_admin.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />