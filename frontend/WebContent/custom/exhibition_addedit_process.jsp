<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Map" %>

<%@ page  import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Event"%>
<%@ page import="java.sql.*,sun.jdbc.rowset.*"%>
<%@ page import="admin.Common"%>
<%@ include file="../public/common.jsp"%>


<%@ page import = "ausstage.AusstageCommon"%>

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
	
	String returnVal = "";
	
	//delete exhibition
	if("delete".equals(action)){
		String sqlStmt = "DELETE FROM `exhibition_section` WHERE `exhibition_section`.`exhibitionid` = " + exhibitionid ;
		stmt.executeUpdate(sqlStmt );
		sqlStmt = "DELETE FROM `exhibition` WHERE `exhibition`.`exhibitionid` = " + exhibitionid ;
		stmt.executeUpdate(sqlStmt );
		stmt.close();
		
		out.print("Exhibition deleted");
	} 
	//delete exhibition section
	if("delete_section".equals(action)){
		String exhibitionSectionid = "-1";
		exhibitionSectionid = request.getParameter("exhibition_sectionid");
		System.out.println(""+exhibitionSectionid);
		
		deleteSection(m_db, exhibitionSectionid);
		
	}
	//ADD HEADING OR ADD TEXT
	else if("addheading".equals(action) || "addtext".equals(action)) {
		if("addheading".equals(action)){
			returnVal = addHeadingOrText(m_db, exhibitionid, "heading", "" );
			
		}
		if ("addtext".equals(action)){
			returnVal = addHeadingOrText(m_db, exhibitionid, "text", "" );
		}
		%>
		<input type="hidden" name="section_id<%= returnVal%>_seq" value="1">
		<li>
			<div class="exhibition-element-container linked-resources" name="<%= returnVal%>" data-exhibition-sectionid="<%= returnVal%>" data-sequencenumber="1">				
				<div style=""><!--Is this div necessary?-->
					<div  class="exhibition-edit-bar" >
						<span class="glyphicon glyphicon-option-vertical small" aria-hidden="true" style="color: white; float: left; padding-left: 0px;"></span>
						<a  onclick="removeSection(<%=returnVal%>)" style="float: right; color: white;">
						<span class="glyphicon glyphicon-remove small" aria-hidden="true" style="color: white; float: right; padding-right: 0px;"></span></a>
					</div>
					<div style="width: 100%; ">
					<!-- INCLUDE TEXT -->
						<cms:include page="./exhibition_addedit_text.jsp" >
							<cms:param name="exhibition_sectionid"><%= returnVal%></cms:param>
							<%if("addheading".equals(action)){%>
								<cms:param name="heading"></cms:param>
							<%} else if("addtext".equals(action)){%>
								<cms:param name="text"></cms:param>
							<%}%>
							

						</cms:include>
					<!-- END TEXT -->
					</div>
				</div>
		   	</div>  
		</li>
		<%	
	}
	//save exhibition and sections
	else {
	
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
		out.print("Exhibition changes saved");
	}
	m_db.m_conn.close();
	
	//stmt.executeUpdate(sbSQL.toString());
	 
  
%>
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
	
	
%>

<%!

	public String addHeadingOrText(ausstage.Database p_db, String exhibitionid, String field, String value) {
		String newId = "0";
		if(exhibitionid != null && !"".equals(exhibitionid) && field != null && !"".equals(field) && value != null ) {
			// increment sequence numbers by 1 to put the new section at the top
			String updateStmt = generateUpdateSequenceNumberSQLStatement(exhibitionid);
			// insert new section
		       	String insertStmt = generateInsertSQLStatement(exhibitionid, field, "'"+value+"'" );
		       	
			try{ 			
				Statement stmt = p_db.m_conn.createStatement();
		       		stmt.addBatch(updateStmt);
		       		stmt.addBatch(insertStmt);
		       		stmt.executeBatch();
		       		ResultSet keys = stmt.getGeneratedKeys();
		    		if(keys.next()) {
		      			newId = keys.getString(1);
		    		}
				stmt.close();
				return newId;
		       	} catch (SQLException e) {
		       		System.out.println(e);
		       		System.out.println(updateStmt);
		       		System.out.println(insertStmt);
		       		return "-1";
		       	}

		}
		System.out.println("made it here");
		return newId;
	}

	public String insertNewExhibition(ausstage.Database p_db, String p_name, String p_description, String userName) {
		String sqlStmt = "INSERT INTO `exhibition`(`name`, `description`, `published_flag`,`owner`,`entered_by_user`,`entered_date`) VALUES ('" + p_name + "', '" + p_description + "', 'N','" + userName + "','" + userName + "',NOW())";
		String newId = "0";
		try{ 
			Statement stmt = p_db.m_conn.createStatement();
			stmt.executeUpdate(sqlStmt, Statement.RETURN_GENERATED_KEYS);
			ResultSet keys = stmt.getGeneratedKeys();
		    	if(keys.next()) {
		      		newId = keys.getString(1);
		    	}
			stmt.close();
			return newId;
	       	} catch (SQLException e) {
	       		System.out.println(e);
	       		System.out.println(sqlStmt);
	       		return "-1";
	       	}

	
	}


	public void deleteSection(ausstage.Database p_db, String p_exhibition_sectionid) {
		if(p_exhibition_sectionid!= null && !"".equals(p_exhibition_sectionid)) {
			String sqlStmt = "DELETE FROM `exhibition_section` WHERE `exhibition_sectionid` = " + p_exhibition_sectionid;
			
			try{ 
				Statement stmt = p_db.m_conn.createStatement();
		       		stmt.executeUpdate(sqlStmt);
				stmt.close();
		       	} catch (SQLException e) {
		       		System.out.println(e);
		       		System.out.println(sqlStmt);
		       	}
		}
	}
	
	public void addRecord(ausstage.Database p_db, String exhibitionid, String itemid, String organisationid, String eventid, String venueid, String contributorid, String workid) {
		// validate data and return field and value
		String[] data = getData(exhibitionid, itemid, organisationid, eventid, venueid, contributorid, workid);
		if(data != null && data.length == 2) {
			// increment sequence numbers by 1 to put the new section at the top
			String updateStmt = generateUpdateSequenceNumberSQLStatement(exhibitionid);
			// insert new section
		       	String insertStmt = generateInsertSQLStatement(exhibitionid, data[0], data[1]);
			try{ 
				Statement stmt = p_db.m_conn.createStatement();
		       		stmt.addBatch(updateStmt);
		       		stmt.addBatch(insertStmt);
		       		stmt.executeBatch();
				stmt.close();
		       	} catch (SQLException e) {
		       		System.out.println(e);
		       		System.out.println(updateStmt);
		       		System.out.println(insertStmt);
		       	}
		}
	}
	public String generateInsertSQLStatement(String exhibitionid, String field, String value ) {
		return
		"INSERT INTO `exhibition_section`\n" +
		"(\n" +
		"  `sequencenumber`,\n" +
		"  `exhibitionid`,\n" +
		"  `" + field + "`)\n" +
		"VALUES\n" +
		"(\n" +
		"  1,\n" +
		"  " + exhibitionid + ",\n" +
		"  " + value + "\n" +
		")\n";
	}
	public String generateUpdateSequenceNumberSQLStatement(String exhibitionid) {
		return
		"UPDATE `exhibition_section`\n" +
		"SET\n" +
		"	`sequencenumber` = `sequencenumber` + 1\n" +
		"WHERE `exhibitionid` = " + exhibitionid + "\n";
	}
	
	public String[] getData(String exhibitionid, String itemid, String organisationid, String eventid, String venueid, String contributorid, String workid) {
		if (exhibitionid != null && !"".equals(exhibitionid)) {
			if (itemid!= null && !"".equals(itemid)) {
				return new String[] {"itemid", itemid};
			} else if (organisationid!= null && !"".equals(organisationid)) {
				return  new String[] {"organisationid", organisationid};
			} else if (eventid!= null && !"".equals(eventid)) {
				return  new String[] {"eventid", eventid};
			} else if (venueid!= null && !"".equals(venueid)) {
				return  new String[] {"venueid", venueid};
			} else if (contributorid!= null && !"".equals(contributorid)) {
				return  new String[] {"contributorid", contributorid};
			} else if (workid!= null && !"".equals(workid)) {
				return  new String[] {"workid", workid};
			} else {
				return null;
			}
		} else {
			return null;
		}
	}
	
%>