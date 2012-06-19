<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%><%@ page
	import="java.sql.*,sun.jdbc.rowset.*,ausstage.CollInfoAccess"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import="ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
	admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
	admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
	ausstage.Database db_ausstage = new ausstage.Database();
	ausstage.CollInfoAccess collInfoAccessObj = new ausstage.CollInfoAccess(db_ausstage);
	String collection_info_access_id;
	CachedRowSet rset;
	boolean error_occurred = false;

	db_ausstage.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
	Statement stmt = db_ausstage.m_conn.createStatement();

	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);

	collection_info_access_id = request.getParameter("f_id");

	// if editing set the object to the selected record
	if (collection_info_access_id != null && !collection_info_access_id.equals("") && !collection_info_access_id.equals("null"))
		collInfoAccessObj.load(Integer.parseInt(collection_info_access_id));

	collInfoAccessObj.setCollAccess(request.getParameter("f_coll_access"));

	// if editing
	if (collection_info_access_id != null && !collection_info_access_id.equals("") && !collection_info_access_id.equals("null"))
		error_occurred = !collInfoAccessObj.update();
	else // Adding
		error_occurred = !collInfoAccessObj.add();

	// Error
	if (error_occurred)
		pageFormater.writeText(out, collInfoAccessObj.getError());
	else
		pageFormater.writeText(out, "The Collection Information Access <b>" + collInfoAccessObj.getCollAccess() + "</b> was successfully saved");

	db_ausstage.disconnectDatabase();
	pageFormater.writePageTableFooter(out);
	pageFormater.writeButtons(out, "", "", "", "", "coll_info_access_admin.jsp", "tick.gif");
	pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />