package ausstage;

import java.util.*;
import java.sql.*;

import sun.jdbc.rowset.*;

public class CodeAssociation {

	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private String m_code_1_type;
	private int m_code_1_lov_id;
	private String m_code_2_type;
	private int m_code_2_lov_id;
	private String[] m_code_2_lov_ids;

	/*
	 * Name: CodeAssociation ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public CodeAssociation(ausstage.Database p_db) {
		m_db = p_db;

		m_code_1_type = "";
		m_code_1_lov_id = 0;
		m_code_2_type = "";
		m_code_2_lov_id = 0;
	}

	// gets all lookup codes currently associated to a lookup code
	// Returns a single ArrayList that contains two ArrayList of equal size, one
	// containing the code_lov_ids and the other containing the description for
	// the code_lov_id
	public static ArrayList getAssociatedLookupCodes(final String code1LovId, final String code2Type, final ausstage.Database p_db) {
		ArrayList arlRet = new ArrayList();
		ArrayList arlDescriptions = new ArrayList();
		ArrayList arlCodeLovIds = new ArrayList();
		CachedRowSet l_rs;
		String sqlString;
		Statement stmt = null;

		if (code1LovId == null || code1LovId.equals("")) {
			return (null);
		}

		// do query for input code_lov_id in code associations table
		try {

			stmt = p_db.m_conn.createStatement();

			// query will return unique values
			sqlString = "SELECT CODE_2_LOV_ID, lookup_codes.DESCRIPTION " + "FROM CODE_ASSOCIATIONS, lookup_codes " + "WHERE code_1_lov_id= " + p_db.plSqlSafeString(code1LovId);
			// only use code 2 type if it is supplied
			if (!code2Type.equals("")) {
				sqlString += "  and code_2_type='" + p_db.plSqlSafeString(code2Type) + "'";
			}
			sqlString += "  and CODE_ASSOCIATIONS.CODE_2_LOV_ID=lookup_codes.CODE_LOV_ID " + "ORDER BY description, sequence_no, short_code";

			l_rs = p_db.runSQL(sqlString, stmt);

			// populate the array list
			while (l_rs.next()) {
				arlCodeLovIds.add(new Integer(l_rs.getInt("CODE_2_LOV_ID")));
				arlDescriptions.add(l_rs.getString("DESCRIPTION"));
			}

			l_rs.close();
			stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getAssociatedLookupCodes()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e1) {
					System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
					System.out.println("An Exception occured in getAssociatedLookupCodes()");
					System.out.println("MESSAGE: " + e.getMessage());
					System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
					System.out.println("CLASS.TOSTRING: " + e.toString());
					System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
				}
			}
			return (null);
		}
		arlRet.add(arlCodeLovIds);
		arlRet.add(arlDescriptions);
		return arlRet;
	}

	// creates populates fields for the code association object from an input
	// code_1_type
	public void load(final String code1LovId) {
		ArrayList arlCode2LovIds = new ArrayList();
		CachedRowSet l_rs;
		String sqlString;
		Statement stmt = null;

		// do query for input code_lov_id in code associations table
		try {

			stmt = m_db.m_conn.createStatement();

			// query will return unique values
			sqlString = "SELECT CODE_1_TYPE, CODE_1_LOV_ID,  " + "CODE_2_TYPE, CODE_2_LOV_ID " + "FROM CODE_ASSOCIATIONS " + "WHERE code_1_lov_id= " + m_db.plSqlSafeString(code1LovId);

			l_rs = m_db.runSQL(sqlString, stmt);

			// if there is a records then start the ball rolling
			if (l_rs.next()) {
				// setup the values...
				m_code_1_type = l_rs.getString("CODE_1_TYPE");
				m_code_1_lov_id = l_rs.getInt("CODE_1_LOV_ID");
				m_code_2_type = l_rs.getString("CODE_2_TYPE");
				m_code_2_lov_id = l_rs.getInt("CODE_2_LOV_ID");

				// populate the String array based on the recordsarray list
				m_code_2_lov_ids = new String[l_rs.size()];

				int recordCount = 0;
				m_code_2_lov_ids[recordCount] = ("" + l_rs.getInt("CODE_2_LOV_ID"));
				recordCount++;

				// while there are records to process, loadd the code 2 lov ids
				// into the string array
				while (l_rs.next()) {
					// arlCode2LovIds.add(new
					// Integer(l_rs.getInt("CODE_2_LOV_ID")));
					m_code_2_lov_ids[recordCount] = ("" + l_rs.getInt("CODE_2_LOV_ID"));
					recordCount++;
				}
			} else {
				m_code_1_type = "";
				m_code_1_lov_id = 0;
				m_code_2_type = "";
				m_code_2_lov_id = 0;
			}
			l_rs.close();
			stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e1) {
					System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
					System.out.println("An Exception occured in load().");
					System.out.println("MESSAGE: " + e.getMessage());
					System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
					System.out.println("CLASS.TOSTRING: " + e.toString());
					System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
				}
			}

			// return null;
		}

		// return arlCode2LovIds;
	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: True if the add was successful, else false.
	 */
	// public boolean add (final String code1Type, final String code1LovId,
	// final String code2Type, final ArrayList codeLovIds)
	public boolean add() {
		boolean ret = false;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlInsertString;
			String sqlString;

			sqlInsertString = "INSERT INTO CODE_ASSOCIATIONS " + "(CODE_1_TYPE, CODE_1_LOV_ID, CODE_2_TYPE, CODE_2_LOV_ID) ";

			// Iterator it = m_code_2_lov_ids.iterator ();
			// Do a new Insert statement per each record
			// while (it.hasNext ()) {
			for (int i = 0; i < m_code_2_lov_ids.length; i++) {
				// Integer codeLovId = new Integer(it.next().toString());
				Integer codeLovId = new Integer(m_code_2_lov_ids[i].toString());

				sqlString = "VALUES (" + "'" + m_db.plSqlSafeString(m_code_1_type) + "'" + ", " + m_code_1_lov_id + ", " + "'" + m_db.plSqlSafeString(m_code_2_type) + "'" + ", "
						+ codeLovId.intValue() + ") ";

				m_db.runSQL(sqlInsertString + sqlString, stmt);
			}
			ret = true;
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in CodeAssociation.add()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (ret);
	}

	/*
	 * Name: delete ()
	 * 
	 * Purpose: Removes link records from the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: None
	 */
	public void delete() {

		Statement stmt = null;
		try {
			stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from code_associations " + "WHERE code_1_type= '" + m_db.plSqlSafeString(m_code_1_type) + "'" + "  AND code_1_lov_id = " + m_code_1_lov_id;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println("Unable to delete the Lookup Code Assocations. The data may be in use.");
			try {
				if (stmt != null) {
					stmt.close();
				}
			} catch (Exception stmtException) {

			}
		}
	}

	// Mutator Methods
	public String getCode1Type() {
		return m_code_1_type;
	}

	public int getCode1LovId() {
		return m_code_1_lov_id;
	}

	public String getCode2Type() {
		return m_code_2_type;
	}

	public int getCode2LovId() {
		return m_code_2_lov_id;
	}

	public String[] getCode2LovIds() {
		return m_code_2_lov_ids;
	}

	public void setCode1Type(final String code_1_type) {
		m_code_1_type = code_1_type;
	}

	public void setCode1LovId(final int code_1_lov_id) {
		m_code_1_lov_id = code_1_lov_id;
	}

	public void setCode2Type(final String code_2_type) {
		m_code_2_type = code_2_type;
	}

	public void setCode2LovId(final int code_2_lov_id) {
		m_code_2_lov_id = code_2_lov_id;
	}

	public void setCode2LovIds(final String[] codeLovIds) {
		m_code_2_lov_ids = codeLovIds;
	}

}
