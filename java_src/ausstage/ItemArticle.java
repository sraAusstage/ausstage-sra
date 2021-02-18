/***************************************************

Company: SRA
 Author: Brad Williams

   File: ItemArticle.java

Purpose: Provides Item Full text article 

 ***************************************************/

package ausstage;

import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;
import static org.apache.commons.lang.StringEscapeUtils.escapeHtml;

public class ItemArticle {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String itemArticleId;
	private String body;
	
	//error string for fun
	private String m_error_string;

	/*
	 * Name: ItemArticleLink ()
	 * Purpose: Constructor.
	 * Parameters: p_db : The database object
	 * Returns: None
	 */
	public ItemArticle(ausstage.Database m_db2) {
		m_db = m_db2;
		initialise();
	}

	/*
	 * Name: initialise ()
	 * Purpose: Resets the object to point to no record.
	 * Parameters: None 
	 * Returns: None
	 */
	public void initialise() {
		itemArticleId = "0";
		body = "";
	}

	/*
	 * Name: load ()
	 * Parameters: p_item_id : id of the main item record
	 * Returns: None
	 */
	public void load(String p_itemArticleId) {
		CachedRowSet l_rs;
		String sqlString;
		// Reset the object
		initialise();
		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString =   " SELECT * FROM ITEM_ARTICLE" 
						+ " WHERE ITEMARTICLEID = " + m_db.plSqlSafeString(p_itemArticleId);
			
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				itemArticleId = l_rs.getString("itemarticleid");
				body = l_rs.getString("body");
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ItemArticleLink: load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: add ()
	 * Purpose: Adds this object to the database. Does this by simply calling
	 * the update() method.
	 * Parameters: itemId String and Body String
	 * Returns: True if successful, else false
	 */
	public boolean add(String p_itemId, String p_body) {
		return update(p_itemId, p_body);
	}

	
	/*
	 * Name: update ()
	 * Purpose: Modifies this object in the database by deleting matching records and inserting the new one
	 * Parameters: Item Id String Body String
	 * Returns: True if successful, else false
	 */
	public boolean update(){
		return update(this.itemArticleId, this.body);
	}
	
	public boolean update(String p_itemId, String p_body) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;
			delete(p_itemId);
			sqlString =   "INSERT INTO ITEM_ARTICLE (itemarticleid, body) " 
						+ "VALUES (" + m_db.plSqlSafeString(p_itemId) + ", '"+m_db.plSqlSafeString(p_body)+"')";
				m_db.runSQL(sqlString, stmt);
			l_ret = true;
			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the Item Article";
			return (false);
		}
	}
	
	//delete records 
	public boolean delete(){
		return delete(this.itemArticleId);
	}
	public boolean delete(String p_itemId){
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;
			
			sqlString = "DELETE FROM ITEM_ARTICLE where itemarticleid=" + m_db.plSqlSafeString(p_itemId); 
			m_db.runSQL(sqlString, stmt);
		
			l_ret = true;
			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to Delete the Item Article";
			return (false);
		}
	}

	public void setItemArticleId(String s) {
		itemArticleId = s;
	}

	public void setBody(String s) {
		body = s;
	}

	public String getItemArticleId() {
		return (itemArticleId);
	}

	public String getBody() {
		//need to escape the double quotes but not the html code so escapeHtml wont work.
		//instead, I'll just replace the " with &quot;
		return fixSpecialCharacters(body);
		//return (escapeHtml(body));
	}

	public String getError() {
		return (m_error_string);
	}
	
	/*this can most likely be extracted to a utility class?? or it's good here to specifically handle the issue of storing and displaying HTML*/
	/*the escapeHTML util doesnt work because it escapes all HTML tags. For the Wysiwyg editor we annoyingly need to keep all the tags but escape the quotes */
	public static String fixSpecialCharacters(String s){
		String returnString = s.replaceAll("'", "&#39;");//replace all the single quotes
		//returnString = returnString.replaceAll("\"", "&#34;");//replace all the double quotes
		
		return returnString;
		
	}
}
