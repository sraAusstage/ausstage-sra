 /***************************************************

 Company: SRA IT
  Author: Aaron Keatley
 Project: Ausstage

    File: LookupType.java

 Purpose: Provides Lookup Type object functions.

 ***************************************************/

 package ausstage;

 import java.util.*;
 import java.sql.*;

 import ausstage.Database;
import sun.jdbc.rowset.*;

 public class LookupType
 {
   private ausstage.Database     m_db;
   private admin.AppConstants AppConstants = new admin.AppConstants();
   private admin.Common       Common       = new admin.Common();

   // All of the record information
   private int m_id;
   private String   m_code_type;
   private String   m_description;
   private boolean   m_system_flag;
   private String   m_error_string;
   private Vector   m_lookupCodes  = new Vector ();
   /*
   Name: LookupType ()

   Purpose: Constructor.

   Parameters:
     p_db       : The database object

   Returns:
      None

   */
   public LookupType(ausstage.Database p_db)
   {
     m_db = p_db;
     initialise();
   }


   /*
   Name: initialise ()

   Purpose: Resets the object to point to no record.

   Parameters:
     None

   Returns:
      None

   */
   public void initialise()
   {
     m_id =0;
      m_code_type   = "";
      m_description = "";
      m_system_flag   =  false;
      m_error_string = "";
   }

   /*
   Name: load ()

   Purpose: Sets the class to a contain the Country information for the
            specified Country id.

   Parameters:
     code_type : code_type of the Lookup_type record

   Returns:
      None

   */
   public void load(int p_id)
   {
     CachedRowSet  l_rs;
     String        sqlString;

     try
     {      
       Statement stmt = m_db.m_conn.createStatement ();

       sqlString = "SELECT * FROM lookup_types WHERE " +
                   "id=" + p_id;
       l_rs = m_db.runSQL (sqlString, stmt);
         
       if (l_rs.next())
       {
          // Reset the object
          initialise();

          // Setup the new data
          m_id = p_id;
          m_code_type     = l_rs.getString ("code_type");
          m_description   = l_rs.getString ("description");
          if (m_description == null) m_description = "";
          if(l_rs.getString ("system_flag").equals("Y"))
            m_system_flag = true;
          else
            m_system_flag = false;
       }
       l_rs.close();
       stmt.close();
     }
     catch (Exception e)
     {
       System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
       System.out.println ("An Exception occured in loadResource().");
       System.out.println("MESSAGE: " + e.getMessage());
       System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
       System.out.println("CLASS.TOSTRING: " + e.toString());
       System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
     }
   }

   /*
   Name: add ()

   Purpose: Adds this object to the database.

   Parameters:

   Returns:
      True if the add was successful, else false. Also fills out the id of the
      new record in the m_country_id member.

   */
   public boolean add ()
   {
     Statement stmt = null;
     try
     {
       stmt = m_db.m_conn.createStatement ();
       String    sqlString;
       boolean   ret = false;
       String strSystemFlag;
       if(m_system_flag)
         strSystemFlag = "Y";
       else
         strSystemFlag = "N";
         
       if(m_description.length() > 200)
         m_description = m_description.substring(0,200);

       // Check to make sure that the user has entered in all of the required fields
       if (validateObjectForDB ())
       {
    	 sqlString = "SELECT MAX(id) id from lookup_types";
    	 ResultSet rs = m_db.runSQL (sqlString, stmt);
    	 rs.next();
    	   
         sqlString = "INSERT INTO lookup_types (code_type, description, system_flag, id) VALUES (" +
                     "'" + m_db.plSqlSafeString(m_code_type) + "', '" + m_db.plSqlSafeString(m_description) + 
                      "', '" + m_db.plSqlSafeString(strSystemFlag) + "', " + (rs.getInt("id")+1) + ")";
         m_db.runSQL (sqlString, stmt);

         // Get the inserted index
         m_id = rs.getInt("id")+1;
         ret = true;
       }
       stmt.close ();
       return (ret);
     }
     catch (Exception e)
     {
       m_error_string = "Unable to add the lookup type. The data may be invalid.";
       e.printStackTrace();
       if (stmt != null)
		try {
			stmt.close();
		} catch (SQLException e1) {
		  System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
	      System.out.println ("An Exception occured in LookupType.add().");
	      System.out.println("MESSAGE: " + e.getMessage());
	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
	      System.out.println("CLASS.TOSTRING: " + e.toString());
	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
       return (false);
     }
   }

   /*
   Name: update ()

   Purpose: Modifies this object in the database.

   Parameters:

   Returns:
      None

   */
   public boolean update ()
   {
     Statement stmt = null;
     try
     {
       stmt = m_db.m_conn.createStatement ();
       String    sqlString;
       boolean   l_ret = false;

       // Check to make sure that the user has entered in all of the required fields
       if (validateObjectForDB ())
       {
         String strSystemFlag;
         if(m_system_flag)
           strSystemFlag = "Y";
         else
           strSystemFlag = "N";
           
         if(m_description.length() > 200)
           m_description = m_description.substring(0,200);
           
         sqlString = "UPDATE lookup_types set code_type ='" + m_db.plSqlSafeString(m_code_type) + 
                     "',  description ='" + m_db.plSqlSafeString(m_description) + "' " + 
                     ",  system_flag ='" + m_db.plSqlSafeString(strSystemFlag) + "' " + 
                     "where id=" + m_id;
         m_db.runSQL (sqlString, stmt);
         l_ret = true;
       }
       stmt.close ();
       return (l_ret);
     }
     catch (Exception e)
     {
       m_error_string = "Unable to update the lookup type. The data may be invalid, or may be in use.";
       if (stmt != null)
		try {
			stmt.close();
		} catch (SQLException e1) {
			 System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
		      System.out.println ("An Exception occured in LookupType.update().");
		      System.out.println("MESSAGE: " + e.getMessage());
		      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
		      System.out.println("CLASS.TOSTRING: " + e.toString());
		      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
       return (false);
     }
   }


   /*
   Name: delete ()

   Purpose: Removes this object from the database.

   Parameters:

   Returns:
      None

   */
   public void delete ()
   {
     Statement stmt = null;
     try
     {
       stmt = m_db.m_conn.createStatement ();
       String    sqlString;
       String    ret;
       sqlString = "DELETE from lookup_codes WHERE code_type= '" + m_code_type + "'";
       m_db.runSQL (sqlString, stmt);
       
       sqlString = "DELETE from lookup_types WHERE id=" + m_id;
       m_db.runSQL (sqlString, stmt);
       stmt.close();
     }
     catch (Exception e)
     {
       if (stmt != null)
		try {
			stmt.close();
		} catch (SQLException e1) {
			 System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
		      System.out.println ("An Exception occured in LookupType.delete().");
		      System.out.println("MESSAGE: " + e.getMessage());
		      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
		      System.out.println("CLASS.TOSTRING: " + e.toString());
		      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
       System.out.println("Unable to delete the Lookup Type. The data may be in use.");
     }
   }


   /*
   Name: checkInUse ()

   Purpose: Checks to see if the specified Country is in use in the database.

   Parameters:
     p_id : id of the record

   Returns:
      True if the country is in use, else false

   */
   public boolean checkInUse(String p_code_type)
   {
     CachedRowSet  l_rs;
     String        sqlString;
     boolean       ret = false;
     Statement     stmt = null;

     try
     {      
       stmt = m_db.m_conn.createStatement ();

       // Venue
       sqlString = "SELECT * FROM lookup_codes WHERE " +
                   " code_type ='" + p_code_type +"'";
       l_rs = m_db.runSQL (sqlString, stmt);
         
       if (l_rs.next())
         ret = true;
       l_rs.close();
   
       stmt.close();
       return (ret);
     }
     catch (Exception e)
     {
       System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
       System.out.println ("An Exception occured in checkInUse().");
       System.out.println("MESSAGE: " + e.getMessage());
       System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
       System.out.println("CLASS.TOSTRING: " + e.toString());
       System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
       if (stmt != null)
		try {
			stmt.close();
		} catch (SQLException e1) {
			 System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
		      System.out.println ("An Exception occured in LookupType.CheckInUse().");
		      System.out.println("MESSAGE: " + e.getMessage());
		      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
		      System.out.println("CLASS.TOSTRING: " + e.toString());
		      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
       return (ret);
     }
   }

   /*
   Name: validateObjectForDB ()

   Purpose: Determines if the object is valid for insert or update.

   Parameters:
      True if the object is valid, else false
      
   Returns:
      None

   */
   private boolean validateObjectForDB ()
   {
     boolean l_ret = true;
     if (m_code_type.equals (""))
     {
       if (m_id == 0) {
         m_error_string = "Unable to add the lookup type. Code Type is required.";
       }
       else {
         m_error_string = "Unable to update the lookup type. Code Type is required.";
       }
       l_ret = false;
     }
     return (l_ret);
   }

   /*
   Name: getCountries ()

   Purpose: Returns a record set with all of the country information in it.

   Parameters:
     p_stmt : Database statement

   Returns:
      A record set.

   */
   public CachedRowSet getLookupType(Statement p_stmt)
   {
     CachedRowSet  l_rs;
     String        sqlString;
     String        l_ret;

     try
     {
       Statement stmt = m_db.m_conn.createStatement ();

       sqlString = "SELECT * FROM lookup_types order by code_type";
       l_rs = m_db.runSQL (sqlString, stmt);
       stmt.close();
       return (l_rs);
     }
     catch (Exception e)
     {
       System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
       System.out.println ("An Exception occured in getLookupType().");
       System.out.println("MESSAGE: " + e.getMessage());
       System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
       System.out.println("CLASS.TOSTRING: " + e.toString());
       System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
       return (null);
     }
   }

   void handleException(Exception p_e, String p_description) {
     System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
     System.out.println("MESSAGE: " + p_e.getMessage());
     System.out.println("LOCALIZED MESSAGE: " + p_e.getLocalizedMessage());
     System.out.println("CLASS.TOSTRING: " + p_e.toString());
     System.out.println(">>>>>>> STACK TRACE <<<<<<<");
     p_e.printStackTrace();
     System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
   }

   void handleException(Exception p_e) {
     handleException(p_e, "");
   }
   
   
   public void loadLookupCodeLinks()
   {
     CachedRowSet l_rs;
     String       sqlString;
     LookupCode   temp_lookupCodeLink;
     Statement stmt = null;

     try
     {
       stmt = m_db.m_conn.createStatement ();

       sqlString = "SELECT code_lov_id, short_code, description " +
                     "FROM lookup_codes " +
                    "WHERE code_type= '" + m_code_type + "' ORDER BY SEQUENCE_NO, short_code";
       l_rs = m_db.runSQL (sqlString, stmt);

       // Reset the object
       clearLookupCodeLinks();

       while (l_rs.next())
       {
         temp_lookupCodeLink = new LookupCode(m_db);
         temp_lookupCodeLink.setCodeLovId(l_rs.getInt("code_lov_id"));
         temp_lookupCodeLink.setShortCode(l_rs.getString("short_code"));
         temp_lookupCodeLink.setDescription(l_rs.getString("description"));
         m_lookupCodes.addElement(temp_lookupCodeLink);
       }
       l_rs.close();
       stmt.close();
     }
     catch (Exception e)
     {
       System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
       System.out.println ("An Exception occured in LookupType.loadLookupCodeLinks().");
       System.out.println("MESSAGE: " + e.getMessage());
       System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
       System.out.println("CLASS.TOSTRING: " + e.toString());
       System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
       if (stmt != null)
		try {
			stmt.close();
		} catch (SQLException e1) {
			 System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
		      System.out.println ("An Exception occured in LookupType.loadLookupCodeLinks().");
		      System.out.println("MESSAGE: " + e.getMessage());
		      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
		      System.out.println("CLASS.TOSTRING: " + e.toString());
		      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
     }
   }
   
   public void clearLookupCodeLinks(){
     m_lookupCodes.removeAllElements();
   }
   
   public Vector getLookupCodeLinks() {
     loadLookupCodeLinks();
     return m_lookupCodes;
   }
   
   private void modifyLookupCodeLinks() {
     ConOrgLink conOrgLink = new ConOrgLink(m_db);

     try {
       conOrgLink.add(m_id+"", m_lookupCodes);
     }
     catch (Exception e) {
       System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
       System.out.println ("An Exception occured in modifyLookupCodeLinks().");
       System.out.println("MESSAGE: " + e.getMessage());
       System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
       System.out.println("CLASS.TOSTRING: " + e.toString());
       System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
     }
   }
 
   ///////////////////////////////
   //  SET FUNCTIONS
   //////////////////////////////
   
   public void setCodeType (String p_code_type)
   {
     m_code_type = p_code_type;
   }
   public void setDescription (String p_description)
   {
     m_description = p_description;
   }
   public void setSystemFlag (String p_system_flag)
   {
      if(p_system_flag.equals("Y"))
        m_system_flag = true;
      else
        m_system_flag = false;
   }

   public void setMdb(ausstage.Database p_db){
     m_db = p_db;
   }



   
   ///////////////////////////////
   //  GET FUNCTIONS
   //////////////////////////////

   public String getCodeType ()
   {
     return (m_code_type);
   }
   
   public String getDescription ()
   {
     return (m_description);
   }
   
   public boolean getSystemFlag ()
   {
     return (m_system_flag);
   }

   public String getError ()
   {
     return (m_error_string);
   }

 }


