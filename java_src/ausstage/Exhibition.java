/***************************************************

Company: SRA
 Author: Brad Williams
Project: Ausstage 2017/2018

   File: Exhibition.java

Purpose: 	Provides Exhibition object functions. - a lot of ajax functions are currently in jsps and spread through the 
			jsp code... ask Tom about why this is...:) TODO : collate everything into this file?

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import java.sql.Date;

import ausstage.Database;
import sun.jdbc.rowset.*;

public class Exhibition {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private int m_exhibition_id;
	private String m_name;
	private String m_description;
	private String m_published_flag;
	private String m_owner;
	private String m_entered_by_user;
	private Date   m_entered_by_date;
	private String m_updated_by_user;
	private Date   m_updated_by_date;
	

	/*
	 * Name: Exhibition ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public Exhibition(ausstage.Database p_db) {
		m_db = p_db;
		initialise();
	}

	/*
	 * Name: initialise ()
	 * 
	 * Purpose: Resets the object to point to no record.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */
	public void initialise() {
		m_exhibition_id = 0;
		m_name = "";
		m_description = "";
		m_published_flag = "";
		m_owner = "";
		m_entered_by_user="";
		m_updated_by_user="";
	}

	
	

	/*
	 * Name: getExhibitions ()
	 * 
	 * Purpose: Returns a record set with all of the Event information in it.
	 * 
	 * Parameters: p_stmt : Database statement, string entity, string entity_id
	 * 
	 * Returns: A record set.
	 */
	public static Vector<Exhibition> getExhibitionsForEntity(ausstage.Database p_db, String p_entity, String p_entity_id ) {
		CachedRowSet l_rs;
		String sqlString;
		String where = "";
		Vector<Exhibition> returnExhibitions = new Vector(); 
		// set the where clause based on the entity
		
		if(p_entity.equals("item")){
			where = " itemid = "+p_entity_id;
		} 
		else if(p_entity.equals("organisation")){
			where = " organisationid = "+p_entity_id;
		}
		else if(p_entity.equals("event")){
			where = " eventid = "+p_entity_id;
		}
		else if(p_entity.equals("venue")){
			where = " venueid = "+p_entity_id;
		}
		else if(p_entity.equals("contributor")){
			where = " contributorid = "+p_entity_id;
		}
		else if(p_entity.equals("work")){
			where = " workid = "+p_entity_id;
		}
		
		sqlString = "SELECT * FROM exhibition e "+
					"LEFT JOIN exhibition_section es "+
					"ON es.exhibitionid = e.exhibitionid "+
					"WHERE "+where;

		try {
			Statement stmt = p_db.m_conn.createStatement();

			l_rs = p_db.runSQL(sqlString, stmt);
			stmt.close();
			while(l_rs.next()){
				Exhibition newEx = new Exhibition(p_db);
				newEx.setExhibitionId(l_rs.getInt("exhibitionid"));
				newEx.setName(l_rs.getString("name"));
				newEx.setDescription(l_rs.getString("description"));
				newEx.setPublishedFlag(l_rs.getString("published_flag"));
				newEx.setOwner(l_rs.getString("owner"));
				newEx.setEnteredByUser(l_rs.getString("entered_by_user"));
				newEx.setUpdatedByUser(l_rs.getString("updated_by_user"));
				returnExhibitions.add(newEx);
			}
			return returnExhibitions;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getExhibitions().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}


	public int getExhibitionId() {
		return m_exhibition_id;
	}

	public void setExhibitionId(int m_exhibition_id) {
		this.m_exhibition_id = m_exhibition_id;
	}

	public String getName() {
		return m_name;
	}

	public void setName(String m_name) {
		this.m_name = m_name;
	}

	public String getDescription() {
		return m_description;
	}

	public void setDescription(String m_description) {
		this.m_description = m_description;
	}

	public String getPublishedFlag() {
		return m_published_flag;
	}

	public void setPublishedFlag(String m_published_flag) {
		this.m_published_flag = m_published_flag;
	}

	public String getOwner() {
		return m_owner;
	}

	public void setOwner(String m_owner) {
		this.m_owner = m_owner;
	}

	public String getEnteredByUser() {
		return m_entered_by_user;
	}

	public void setEnteredByUser(String m_entered_by_user) {
		this.m_entered_by_user = m_entered_by_user;
	}

	public Date getEnteredByDate() {
		return m_entered_by_date;
	}

	public void setEnteredByDate(Date m_entered_by_date) {
		this.m_entered_by_date = m_entered_by_date;
	}

	public String getUpdatedByUser() {
		return m_updated_by_user;
	}

	public void setUpdatedByUser(String m_updated_by_user) {
		this.m_updated_by_user = m_updated_by_user;
	}

	public Date getUpdatedByDate() {
		return m_updated_by_date;
	}

	public void setUpdatedByDate(Date m_updated_by_date) {
		this.m_updated_by_date = m_updated_by_date;
	}
	
	

}
