<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<cms:include property="template" element="head" /><%@ include
	file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import="ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
	admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
	admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
	ausstage.Database db_ausstage = new ausstage.Database();
	db_ausstage.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
	ausstage.AusstageReports sqlInterface = null;

	out.println("SQL Interface");
	pageFormater.writeHeader(out);
	// pageFormater.writePageTableHeader (out, "SQL Interface", ausstage_main_page_link);

	String sqlToBeExecuted = request.getParameter("f_sqlblock");
	String commadelimfilename = "";
	//pageFormater.writeHelper(out, "SQL Interface","helpers_no1.gif");
	out.println("<form name='sqlform' id='sqlform' method='post'>");

	if (sqlToBeExecuted != null && !sqlToBeExecuted.equals("") && !sqlToBeExecuted.equals("null")) {
		sqlInterface = new ausstage.AusstageReports(db_ausstage, request, "sql_interface.csv");
		boolean success = sqlInterface.ExecuteQuery(out, sqlToBeExecuted);
		if (!success) {
			out.println(sqlInterface.getErrorMessage());
			pageFormater.writePageTableFooter(out);
			pageFormater.writeButtons(out, "BACK", "prev.gif", "", "", "", "");
		} else {
			if (sqlToBeExecuted.toLowerCase().startsWith("select")) {
				commadelimfilename = sqlInterface.getCommaDelimFileName();

				if (!commadelimfilename.equals("")) {

					out.print("<p>You can <a href=/opencms" + AppConstants.REPORTS_FILE_PATH);
					out.print("/" + sqlInterface.getCommaDelimFileName());
					out.print("> <font COLOR='#99CF16'>click here</font></a> to get the comma delimited file. ");
					out.print("(size " + sqlInterface.getCommaDelimFileSize() + "KB)</p>");
					if (sqlInterface.isReachedMaxRowAllowed())
						out.print("<p><font color='FF0000'>Warning. The above list is not a complete listing,<br>as more results were found than could be displayed.<br>Please refine your search.</font></p>");
					pageFormater.writePageTableFooter(out);
					pageFormater.writeButtons(out, "", "", "", "", "ausstage_sql_interface.jsp", "tick.gif");
				} else {
					out.println("Your SQL Query did not return any result(s).");
					pageFormater.writePageTableFooter(out);
					pageFormater.writeButtons(out, "BACK", "prev.gif", "", "", "", "");
				}

			} else if (sqlToBeExecuted.toLowerCase().startsWith("update")) {
				out.println("Update SQL command was executed successfully.");
				pageFormater.writePageTableFooter(out);
				pageFormater.writeButtons(out, "", "", "", "", "ausstage_sql_interface.jsp", "tick.gif");

			} else if (sqlToBeExecuted.toLowerCase().startsWith("delete")) {
				out.println("Delete SQL command was executed successfully.");
				pageFormater.writePageTableFooter(out);
				pageFormater.writeButtons(out, "", "", "", "", "ausstage_sql_interface.jsp", "tick.gif");

			} else if (sqlToBeExecuted.toLowerCase().startsWith("insert")) {
				out.println("insert SQL command was executed successfully.");
				pageFormater.writePageTableFooter(out);
				pageFormater.writeButtons(out, "", "", "", "", "ausstage_sql_interface.jsp", "tick.gif");

			} else {
				// sql statement like drop table, create table, descibe table etc.
				// is not supported by this interface
				out.println("The following SQL statement can not be executed from the SQL Interface.<br><br>" + sqlToBeExecuted);
				pageFormater.writePageTableFooter(out);
				pageFormater.writeButtons(out, "BACK", "prev.gif", "", "", "", "");
			}
		}
	} else {
		out.println("<textarea name='f_sqlblock' rows='15' cols='40' class='line300'></textarea>");
		pageFormater.writePageTableFooter(out);
		pageFormater.writeButtons(out, "", "", "", "", "SUBMIT", "tick.gif");
	}

	pageFormater.writeFooter(out);
	db_ausstage.disconnectDatabase();
	out.println("</form>");
%>
<cms:include property="template" element="foot" />