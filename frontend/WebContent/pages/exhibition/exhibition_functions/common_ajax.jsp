<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="java.sql.*,sun.jdbc.rowset.*"%>
<%@ page import="ausstage.State"%>
<%@ page import="admin.Common"%>

<%@ include file="../../../public/common.jsp"%>
<%
//this page is designed to receive ajax calls and perform simple operations to exhibitions - 
// it isn't ideally set up. 
// I'd rather use a java class...
// but this is how its started. I'll try and fix it later
	String p_action = request.getParameter("action");	
	String exhibitionid = request.getParameter("id");
	String p_itemid = request.getParameter("itemid");
	String p_organisationid = request.getParameter("organisationid");
	String p_eventid = request.getParameter("eventid");
	String p_venueid = request.getParameter("venueid");
	String p_contributorid = request.getParameter("contributorid");
	String p_workid = request.getParameter("workid");
	
	String p_description = request.getParameter("description");
	String p_name = request.getParameter("name");
	
	String userName = (String)session.getAttribute("fullUserName");

	ausstage.Database m_db = new ausstage.Database ();
	m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);

	//ADD EXHIBITION SECTION
	if("add".equals(p_action)) {
		addRecord(m_db, exhibitionid, p_itemid, p_organisationid, p_eventid, p_venueid, p_contributorid, p_workid);
	}
	//remove entity - will be different to the remove on the admin pages.
	if("deleteByEntityId".equals(p_action)){
		deleteRecordByEntityId(m_db, exhibitionid, p_itemid, p_organisationid, p_eventid, p_venueid, p_contributorid, p_workid);
	}
	//DELETE EXHIBITION
	if("deleteExhibition".equals(p_action)){
		Statement stmt = m_db.m_conn.createStatement();
		String sqlStmt = "DELETE FROM `exhibition_section` WHERE `exhibition_section`.`exhibitionid` = " + exhibitionid ;
		stmt.executeUpdate(sqlStmt );
		sqlStmt = "DELETE FROM `exhibition` WHERE `exhibition`.`exhibitionid` = " + exhibitionid ;
		stmt.executeUpdate(sqlStmt );
		stmt.close();
		out.print("success");
	}
	//CREATE EXHIBITION
	if(("createExhibition").equals(p_action)){
		out.print(insertNewExhibition(m_db, p_name, p_description, userName));
	}
	
	

%>
<%!
//needs a lot of cleaning up...

	public String insertNewExhibition(ausstage.Database p_db, String p_name, String p_description, String userName) {
		p_name = p_name.replace("'", "''");
		p_description = p_description.replace("'", "''");
		userName= userName.replace("'", "''");
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

//deletes a record from the exhibition by its section id
	public void deleteRecord(ausstage.Database p_db, String p_exhibition_sectionid) {
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
//delete a record from an exhibition by entity id	
public void deleteRecordByEntityId(ausstage.Database p_db, String exhibitionid, String itemid, String organisationid, String eventid, String venueid, String contributorid, String workid) {
		// validate data and return field and value
		String[] data = getData(exhibitionid, itemid, organisationid, eventid, venueid, contributorid, workid);
		if(data != null && data.length == 2) {
			// delete section
		       	String deleteStmt = generateDeleteSQLStatement(exhibitionid, data[0], data[1]);
			try{ 
				Statement stmt = p_db.m_conn.createStatement();
		       		stmt.addBatch(deleteStmt);
		       		stmt.executeBatch();
				stmt.close();
		       	} catch (SQLException e) {
		       		System.out.println(e);
		       		System.out.println(deleteStmt);
		       	}
		}
	}
		
//adds a record to an exhibition	
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
	
	public String generateDeleteSQLStatement(String exhibitionid, String field, String value ) {
		return
		" DELETE FROM exhibition_section \n" +
		" WHERE "+ field + " = " + value + "\n"+
		" AND exhibitionid = " + exhibitionid +" \n";
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