<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Map" %>
<%@ page  import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Event"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Exhibition Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
	
	ausstage.Database m_db = new ausstage.Database ();
	m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
	Statement stmt = m_db.m_conn.createStatement();
	
	
  	String exhibitionid = request.getParameter("exhibitionid");
  	String name = request.getParameter("name");
  	String description= request.getParameter("description");
  	String published_flag = "Y".equals(request.getParameter("published_flag")) ? "Y" : "N";
	String action = request.getParameter("action");
	
	if("delete".equals(action)){
		String sqlStmt = "DELETE FROM `exhibition_section` WHERE `exhibition_section`.`exhibitionid` = " + exhibitionid ;
		stmt.executeUpdate(sqlStmt );
		sqlStmt = "DELETE FROM `exhibition` WHERE `exhibition`.`exhibitionid` = " + exhibitionid ;
		stmt.executeUpdate(sqlStmt );
		stmt.close();
		
		%>
			<h1>Exhibition Deleted</h1>
			<a href="exhibition_manage.jsp">Back to manage exhibitions</a>
		<%
	} else {
		String userName = (String)session.getAttribute("fullUserName");
		// update exhibition
		String sqlExhibition = 
			"UPDATE `exhibition`\n" +
			"SET\n" +
			"`name` = '" + name + "',\n" +
			"`description` = '" + description + "',\n" +
			"`published_flag` = '" + published_flag + "',\n" +
			" updated_date = NOW(), \n" + 
			" updated_by_user = '" + userName + "' \n" +
			"WHERE `exhibitionid` = '" + exhibitionid  + "'\n";
			
		stmt.addBatch(sqlExhibition);
		
		// update exhibition_section(s)
		Map<String, String[]> parameters = request.getParameterMap();
		for(String parameter : parameters.keySet()) {
		    if(parameter.toLowerCase().startsWith("section") && parameter.toLowerCase().endsWith("_seq")) {
		       	String exhibitionSectionId = getId(parameter);
		        String[] values = parameters.get(parameter);
		       	for(String sequenceNumber : values) {
		       		String heading = request.getParameter("section_id" + exhibitionSectionId + "_heading");
		       		String text = request.getParameter("section_id" + exhibitionSectionId + "_text");
		       		System.out.println(heading);
		       		text = m_db.plSqlSafeString(text);
		       		heading = m_db.plSqlSafeString(heading);
		       		
		       		
		       		if(heading != null && !"".equals(heading)) {// update heading
		       			String sqlHeadingSeq = updateSectionHeadingAndSequenceNumber(exhibitionSectionId, sequenceNumber, heading);
		       			stmt.addBatch(sqlHeadingSeq );
		       			
		       		} else if(text != null && !"".equals(text )) {// update text
		       			String sqlTextSeq = updateSectionTextAndSequenceNumber(exhibitionSectionId, sequenceNumber, text);
		       			stmt.addBatch(sqlTextSeq );
		       		} else { // update venue, event, organisation, resource, contributor
		       			String sqlSeq = updateSectionSequenceNumber(exhibitionSectionId, sequenceNumber);
		       			stmt.addBatch(sqlSeq);
		       		}
		       	}
		    }
		}	
		stmt.executeBatch();
		stmt.close();
		%>
			<h1>Changes Saved</h1>
			<a href="exhibition_addedit.jsp?id=<%= exhibitionid %>">Back to Exhibition</a>
		<%
	}
	m_db.m_conn.close();
	
	//stmt.executeUpdate(sbSQL.toString());
	 
  
%>




<cms:include property="template" element="foot" />

<%!

	public String getId(String param) {
		return param.replace("section_id", "").replace("_seq", "");
	}

	public String updateSectionSequenceNumber(String exhibitionSectionId, String sequenceNumber) {
		return 
			"UPDATE `exhibition_section`\n" +
			"SET\n" +
			"`sequencenumber` = " + sequenceNumber + "\n" +
			"WHERE `exhibition_sectionid` = " + exhibitionSectionId + "\n";
	}
	public String updateSectionHeadingAndSequenceNumber(String exhibitionSectionId, String sequenceNumber, String heading) {
		return 
			"UPDATE `exhibition_section`\n" +
			"SET\n" +
			"`heading` = '" + heading + "',\n" +
			"`sequencenumber` = " + sequenceNumber + "\n" +
			"WHERE `exhibition_sectionid` = " + exhibitionSectionId + "\n";
	}
	public String updateSectionTextAndSequenceNumber(String exhibitionSectionId, String sequenceNumber, String text) {
		return 
			"UPDATE `exhibition_section`\n" +
			"SET\n" +
			"`text` = '" + text + "',\n" +
			"`sequencenumber` = " + sequenceNumber + "\n" +
			"WHERE `exhibition_sectionid` = " + exhibitionSectionId + "\n";
	}
%><jsp:include page="../templates/admin-footer.jsp" />