/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: MaterialLink.java

Purpose: Provides MaterialLink object functions.

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.Statement;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class MaterialLink {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private int m_materialid;
	private int m_collection_information_id;
	private String m_error_string;

	/*
	 * Name: MaterialLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public MaterialLink(ausstage.Database p_db) {
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
		m_materialid = 0;
		m_collection_information_id = 0;
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the MaterialLink information for the
	 * specified materials id.
	 * 
	 * Parameters: p_id : id of the materials record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM materiallink WHERE " + "materialid=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_materialid = l_rs.getInt("MATERIALID");
				m_collection_information_id = l_rs.getInt("COLLECTION_INFORMATION_ID");
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadResource().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database. Does this by simply calling
	 * the update() method.
	 * 
	 * Parameters: collectionInformationId String array of Material Links
	 * records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String collectionInformationId, String[] materialLinks) {
		return update(collectionInformationId, materialLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * MaterialLinks for this Collection and inserting new ones from an array of
	 * Materials records to link to this Collection.
	 * 
	 * Parameters: collectionInformationId String array of Material Links
	 * records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String collectionInformationId, String[] materialLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				sqlString = "DELETE FROM MATERIALLINK where " + "COLLECTION_INFORMATION_ID=" + m_db.plSqlSafeString(collectionInformationId);
				m_db.runSQL(sqlString, stmt);

				for (int i = 0; materialLinks != null && i < materialLinks.length; i++) {
					sqlString = "INSERT INTO MATERIALLINK " + "(materialid, collection_information_id) " + "VALUES (" + materialLinks[i] + ", " + m_db.plSqlSafeString(collectionInformationId) + ")";
					m_db.runSQL(sqlString, stmt);
				}
				l_ret = true;
			}
			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected materials records. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: deleteMaterialLinksForCollection ()
	 * 
	 * Purpose: Deletes all MaterialLink records for the specified Collection
	 * Information Id.
	 * 
	 * Parameters: Collection Information Id
	 * 
	 * Returns: None
	 */
	public void deleteMaterialLinksForCollection(int collectionInformationId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from MATERIALLINK WHERE collection_information_id=" + collectionInformationId;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteMaterialLinksForCollection().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: checkInUse ()
	 * 
	 * Purpose: Checks to see if the specified MaterialLink is in use in the
	 * database.
	 * 
	 * Parameters: p_id : id of the materials record
	 * 
	 * Returns: True if the MaterialLink is in use, else false
	 */
	public boolean checkInUse(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		boolean ret = false;

		try {
			return true;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in checkInUse().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (ret);
		}
	}

	/*
	 * Name: validateObjectForDB ()
	 * 
	 * Purpose: Determines if the object is valid for insert or update.
	 * 
	 * Parameters: True if the object is valid, else false
	 * 
	 * Returns: None
	 */
	private boolean validateObjectForDB() {
		return true;
	}

	/*
	 * Name: getMaterialLinks ()
	 * 
	 * Purpose: Returns a record set with all of the MaterialLinks information
	 * in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getMaterialLinks(int collectionInformationId) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM materiallink WHERE collection_information_id = " + collectionInformationId;
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getMaterialLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getMaterialLinksForCollection (p_id)
	 * 
	 * Purpose: Returns a Vector containing all the MaterialLinks for this
	 * Collection.
	 * 
	 * Parameters: p_id: collection_information_id
	 * 
	 * Returns: A Vector of all MaterialLinks for this Collection.
	 */

	public Vector getMaterialLinksForCollection(int collectionInformationId) {
		Vector allMaterialLinks = new Vector();
		CachedRowSet rset = this.getMaterialLinks(collectionInformationId);
		try {
			while (rset.next()) {
				allMaterialLinks.add(new Integer(rset.getInt("materialid")));
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getMaterialLinksForCollection().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		} finally {
			try {
				rset.close();
			} catch (Exception ex) {
			}
		}
		return allMaterialLinks;
	}

	public void setMaterialid(int i) {
		m_materialid = i;
	}

	public void setCollectionInformationId(int i) {
		m_collection_information_id = i;
	}

	public int getMaterialid() {
		return (m_materialid);
	}

	public int getCollectionInformationId() {
		return (m_collection_information_id);
	}

	public String getError() {
		return (m_error_string);
	}
}
