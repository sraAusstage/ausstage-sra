/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Centricminds

   File: Organisation.java
      
Purpose: Provides Organisation object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.util.Date;
import java.sql.*;

import javax.servlet.http.HttpServletRequest;

import ausstage.Database;
import sun.jdbc.rowset.*;

public class Organisation
{
  private ausstage.Database     m_db;
  private admin.AppConstants AppConstants = new admin.AppConstants();
  private admin.Common       Common       = new admin.Common();
  
  private final int INSERT = 0;
  private final int DELETE = 1;
  private final int UPDATE = 2;

  // All of the record information
  private int     m_organisation_id = 0;
  private String  m_organisation_name;
  private String  m_other_names1;
  private String  m_other_names2;
  private String  m_other_names3;
  private String  m_address;
  private String  m_suburb;
  private String  m_state_id;
  private String  m_state_name;
  private String  m_contact;
  private String  m_postcode;
  private String  m_phone1;
  private String  m_phone2;
  private String  m_phone3;
  private String  m_fax;
  private String  m_email;
  private String  m_web_links;
  private String  m_notes;
  private String  m_country = "0";
  private String  m_organisation_type;
  private String  m_error_string;
  private String  m_FunctionList = "";
  private String  m_entered_by_user;
  private Date    m_entered_date;
  private String  m_updated_by_user;
  private Date    m_updated_date;
  private Vector m_org_orglinks;
  private String m_ddfirst_date;
  private String m_mmfirst_date;
  private String m_yyyyfirst_date;
  private String m_ddlast_date;
  private String m_mmlast_date;
  private String m_yyyylast_date;
  private String orgDate;
  private Date m_first_date;
  private String m_place_of_origin;
  private String m_place_of_demise;
  private String m_nla;

  /*
  Name: Organisation ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public Organisation(ausstage.Database m_db2)
  {
    m_db = m_db2;
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
    m_organisation_id   = 0;
    m_organisation_name = "";
    m_other_names1      = "";
    m_other_names2      = "";
    m_other_names3      = "";
    m_address           = "";
    m_suburb            = "";
    m_state_id          = "";
    m_state_name        = "";
    m_contact           = "";
    m_postcode          = "";
    m_phone1            = "";
    m_phone2            = "";
    m_phone3            = "";
    m_fax               = "";
    m_email             = "";
    m_web_links         = "";
    m_notes             = "";
    m_country           = "0";
    m_organisation_type = "";
    m_error_string      = "";
    m_org_orglinks = new Vector();
    m_entered_by_user              = "";
    m_updated_by_user              = "";
    m_ddfirst_date = "";
    m_mmfirst_date = "";
    m_yyyyfirst_date = "";
    m_ddlast_date = "";
    m_mmlast_date = "";
    m_yyyylast_date = "";
    m_place_of_origin= "";
    m_place_of_demise= "";
    m_nla="";

    m_first_date = new Date();
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the Organisation information for the
           specified organisation id.

  Parameters:
    p_id : id of the organisation record

  Returns:
     None

  */
  public void load(int p_id)
  {
    CachedRowSet  l_rs     = null;
    CachedRowSet  l_sub_rs = null;
    String        sqlString;

    try
    {      
      Statement stmt    = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM organisation " +
                  "WHERE organisationId=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
      {
        // Reset the object
        initialise();

        // Setup the new data
        m_organisation_id   = l_rs.getInt    ("organisationid");
        m_organisation_name = l_rs.getString ("name");
        m_other_names1      = l_rs.getString ("other_names1");
        m_other_names2      = l_rs.getString ("other_names2");
        m_other_names3      = l_rs.getString ("other_names3");
        m_address           = l_rs.getString ("address");
        m_suburb            = l_rs.getString ("suburb");
        m_state_id          = l_rs.getString ("state");
        m_contact           = l_rs.getString ("contact");
        m_postcode          = l_rs.getString ("postcode");
        m_phone1            = l_rs.getString ("phone1");
        m_phone2            = l_rs.getString ("phone2");
        m_phone3            = l_rs.getString ("phone3");
        m_fax               = l_rs.getString ("fax");
        m_email             = l_rs.getString ("email");
        m_web_links         = l_rs.getString ("web_links");
        m_notes             = l_rs.getString ("notes");
        m_country           = l_rs.getString ("countryid");
        m_organisation_type = l_rs.getString ("organisation_type_id");
        m_entered_by_user          = l_rs.getString ("entered_by_user");
        m_entered_date             = l_rs.getDate   ("entered_date");
        m_updated_by_user          = l_rs.getString ("updated_by_user");
        m_updated_date             = l_rs.getDate   ("updated_date");
        
        m_ddfirst_date = l_rs.getString("ddfirst_date");
        m_mmfirst_date = l_rs.getString("mmfirst_date");
        m_yyyyfirst_date = l_rs.getString("yyyyfirst_date");
        m_ddlast_date = l_rs.getString("ddlast_date");
        m_mmlast_date = l_rs.getString("mmlast_date");
        m_yyyylast_date = l_rs.getString("yyyylast_date");
       // m_first_date = l_rs.getDate("first_date");
        m_place_of_origin = l_rs.getString ("PLACE_OF_ORIGIN");
		m_place_of_demise = l_rs.getString ("PLACE_OF_DEMISE");
		m_nla         = l_rs.getString ("NLA");
		System.out.println("NLA: " + m_nla);

        if (m_organisation_name == null)
          m_organisation_name = "";
        if (m_other_names1 == null)
          m_other_names1 = "";
        if (m_other_names2 == null)
          m_other_names2 = "";
        if (m_other_names3 == null)
          m_other_names3 = "";
        if (m_address == null)
          m_address = "";
        if (m_suburb == null)
          m_suburb = "";
        if (m_postcode == null)
          m_postcode = "";
        if (m_phone1 == null)
          m_phone1 = "";
        if (m_phone2 == null)
          m_phone2 = "";
        if (m_phone3 == null)
          m_phone3 = "";
        if (m_fax == null)
          m_fax = "";
        if (m_email == null)
          m_email = "";
        if (m_web_links == null)
          m_web_links = "";
        if (m_notes == null)
          m_notes = "";
        if (m_contact == null)
          m_contact = "";
        if (m_country == null)
          m_country = "";
        if (m_organisation_type == null)
          m_organisation_type = "";
        if (m_entered_by_user == null)   m_entered_by_user   = "";
        if (m_entered_date == null)      m_entered_date      = new Date();
        if (m_updated_date == null)      m_updated_date      = new Date();
        if (m_updated_by_user == null)   m_updated_by_user      = "";
        if (m_ddfirst_date == null)
            m_ddfirst_date = "";
        if (m_mmfirst_date == null)
        	m_mmfirst_date = "";
        if (m_yyyyfirst_date == null)
        m_yyyyfirst_date = "";
        if (m_ddlast_date == null)
        	m_ddlast_date = "";
        if (m_mmlast_date == null)
        	m_mmlast_date = "";
        if (m_yyyylast_date == null)
        	m_yyyylast_date = "";
        if (m_place_of_origin == null){m_place_of_origin = "";}
        if (m_place_of_demise == null){m_place_of_demise = "";}
        if (m_nla == null){m_nla = "";}
        if (m_state_id == null)
        {
          m_state_id   = "0";
          m_state_name = "";
        }
        else
        {
          sqlString = "SELECT state FROM states " +
                      "WHERE stateId=" + m_state_id;
          l_sub_rs = m_db.runSQL (sqlString, stmt);
          if (l_sub_rs.next())
            m_state_name = l_sub_rs.getString ("state");
          else
            m_state_name = "";
        }
      }
      loadLinkedOrganisations();

      if(l_rs != null)
        l_rs.close();
      if(l_sub_rs != null) 
        l_sub_rs.close();
     
      stmt.close();
    }
    catch (Exception e)
    {
      handleException(e, "An Exception occured in Organisation.load().");
    }
  }
  

  public Vector getOrganisation(){return m_org_orglinks;}

  /*
  Name: add ()

  Purpose: Adds this object to the database.

  Parameters:

  Returns:
     True if the add was successful, else false. Also fills out the id of the
     new record in the m_organisation_id member.

  */
  public boolean add()
  {
    try
    {
      System.out.println("In add 1");
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      boolean   ret = false;
      
      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
    	  System.out.println("In add 2");
        // As the notes is a text area, need to limit characters
        if (m_notes.length() >= 300)
          m_notes = m_notes.substring (0, 299);
        sqlString = "INSERT INTO organisation (name, other_names1, other_names2, " +
                    "other_names3, address, suburb, state, contact, postcode, phone1, phone2, phone3, " +
                    "fax, email, web_links, notes, countryid, organisation_type_id,entered_by_user, entered_date, " +
                    "ddfirst_date, mmfirst_date, yyyyfirst_date, ddlast_date, mmlast_date, yyyylast_date" +
                    ", PLACE_OF_ORIGIN, PLACE_OF_DEMISE, nla) VALUES (" +
                    "'" + m_db.plSqlSafeString(m_organisation_name) + "','" + m_db.plSqlSafeString(m_other_names1) + "'," +
                    "'" + m_db.plSqlSafeString(m_other_names2) + "','" + m_db.plSqlSafeString(m_other_names3) + "'," +
                    "'" + m_db.plSqlSafeString(m_address) + "','" + m_db.plSqlSafeString(m_suburb) + "'," +
                    m_state_id + ",'" + m_db.plSqlSafeString(m_contact) + "'," +
                    m_db.plSqlSafeString(m_postcode.equals("")?"null":m_postcode) + ",'" + m_db.plSqlSafeString(m_phone1) + "'," +
                    "'" + m_db.plSqlSafeString(m_phone2) + "','" + m_db.plSqlSafeString(m_phone3) + "'," +
                    "'" + m_db.plSqlSafeString(m_fax) + "','" + m_db.plSqlSafeString(m_email) + "'," +
                    "'" + m_db.plSqlSafeString(m_web_links) + "','" + m_db.plSqlSafeString(m_notes) + "'," +
                    m_country + ", " + m_db.plSqlSafeString(m_organisation_type.equals("")?"null":m_organisation_type) + ", " +
                    "'" + m_db.plSqlSafeString(m_entered_by_user)  + "', NOW()," + 
                    "'" +m_db.plSqlSafeString(m_ddfirst_date) + "', " +
                    "'" + m_db.plSqlSafeString(m_mmfirst_date) + "', " +
                    "'" + m_db.plSqlSafeString(m_yyyyfirst_date) + "', " +
                    "'" + m_db.plSqlSafeString(m_ddlast_date) + "', " +
                    "'" + m_db.plSqlSafeString(m_mmlast_date) + "', " +
                    "'" + m_db.plSqlSafeString(m_yyyylast_date)   + "'," +
                    m_db.plSqlSafeString(m_place_of_origin.equals("")?"null":m_place_of_origin) + ","+ 
                    m_db.plSqlSafeString(m_place_of_demise.equals("")?"null":m_place_of_demise) + ","+ 
                    m_db.plSqlSafeString(m_nla) + ")";
        m_db.runSQL (sqlString, stmt);
        System.out.println("In add 3");
        System.out.println(sqlString);
        // Get the inserted index
        m_organisation_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "organisationid_seq"));
        ret = true;
      }
      modifyOrgOrgLinks(INSERT);
      stmt.close ();
      System.out.println("In add 4");
      return (ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to add the organisation. The data may be invalid.";
      return (false);
    }
  }

  /*
  Name: update ()

  Purpose: Modifies this object in the database.

  Parameters:

  Returns:
     True if successfull, else false

  */
  public boolean update ()
  {
    try
    {
    	System.out.println("In update 1");
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      boolean   l_ret = false;
      
      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
        // As the notes is a text area, need to limit characters
        if (m_notes.length() >= 300)
          m_notes = m_notes.substring (0, 299);
          if(m_country == null || m_country.equals("") || m_country.equals("0")){m_country="null";}
          if(m_organisation_type == null || m_organisation_type.equals("")){m_organisation_type="1";} 
          if(m_place_of_origin == null  || m_place_of_origin.equals("")  || m_place_of_origin.equals("0"))   { m_place_of_origin  = "null"; }
          if(m_place_of_demise == null  || m_place_of_demise.equals("")  || m_place_of_demise.equals("0"))   { m_place_of_demise  = "null"; }
          System.out.println("In update 2");
        sqlString = "UPDATE organisation set name='" + m_db.plSqlSafeString(m_organisation_name) + "', " +
        			" updated_BY_USER = '" + m_db.plSqlSafeString(m_updated_by_user) + "'" +
        			", updated_DATE =  now(),  " +
                    "other_names1='" + m_db.plSqlSafeString(m_other_names1) + "', " +
                    "other_names2='" + m_db.plSqlSafeString(m_other_names2) + "', " +
                    "other_names3='" + m_db.plSqlSafeString(m_other_names3) + "', " +
                    "address='" + m_db.plSqlSafeString(m_address) + "', " +
                    "SUBURB='" + m_db.plSqlSafeString(m_suburb) + "', " +
                    "state=" + m_state_id + ", " +
                    "contact='" + m_db.plSqlSafeString(m_contact) + "', " +
                    "postcode=" + m_db.plSqlSafeString(m_postcode.equals("")?"null":m_postcode) + ", " +
                    "phone1='" + m_db.plSqlSafeString(m_phone1) + "'," +
                    "phone2='" + m_db.plSqlSafeString(m_phone2) + "'," +
                    "phone3='" + m_db.plSqlSafeString(m_phone3) + "'," +
                    "fax='" + m_db.plSqlSafeString(m_fax) + "', " +
                    "email='" + m_db.plSqlSafeString(m_email) + "', " +
                    "web_links='" + m_db.plSqlSafeString(m_web_links) + "', " +
                    "notes='" + m_db.plSqlSafeString(m_notes) + "', countryid=" + m_country + ", " + 
                    "organisation_type_id=" + m_organisation_type + ", " +
                    "ddfirst_date= '" + m_db.plSqlSafeString(m_ddfirst_date) + "'," +
                    "mmfirst_date= '" + m_db.plSqlSafeString(m_mmfirst_date) + "'," +
                    "yyyyfirst_date= '" + m_db.plSqlSafeString(m_yyyyfirst_date) + "'," +
                    "ddlast_date= '" + m_db.plSqlSafeString(m_ddlast_date) + "'," +
                    "mmlast_date= '" + m_db.plSqlSafeString(m_mmlast_date) + "'," +
                    "yyyylast_date=     '" + m_db.plSqlSafeString(m_yyyylast_date)   + "'," +
                    "PLACE_OF_Origin= " + m_place_of_origin + "," +
                    "PLACE_OF_Demise= " + m_place_of_demise + "," +
                    "NLA= '" + m_db.plSqlSafeString(m_nla)  + "'" +
                    " where organisationid=" + m_organisation_id;
        m_db.runSQL (sqlString, stmt);
        System.out.println(sqlString);
        l_ret = true;
      }
      System.out.println("In update 3");
      modifyOrgOrgLinks(UPDATE);
      stmt.close ();
      System.out.println("In update 4");
      return (l_ret);     
    }
    catch (Exception e)
    {
      m_error_string = "Unable to update the organisation. The data may be invalid.";
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
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      modifyOrgOrgLinks(DELETE);
      sqlString = "DELETE from organisation WHERE organisationid=" + m_organisation_id;
      m_db.runSQL (sqlString, stmt);
      stmt.close ();
    }
    catch (Exception e)
    {
      handleException(e);
    }
  }


  /*
  Name: checkInUse ()

  Purpose: Checks to see if the specified Organisation is in use in the database.

  Parameters:
    p_id : id of the organisation record

  Returns:
     True if the organisation is in use, else false

  */
  public boolean checkInUse(int p_id)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    boolean       ret = false;

    try
    {      
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT orgevlinkid FROM orgevlink WHERE " +
                  "organisationid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
        ret = true;
      l_rs.close();
      
      sqlString = "SELECT workorglinkid FROM workorglink WHERE " +
                  "organisationid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
      if (l_rs.next())
        ret = true;
      l_rs.close();
      
      sqlString = "SELECT conorglinkid FROM conorglink WHERE " +
                  "organisationid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
      if (l_rs.next())
        ret = true;
      l_rs.close();
      
      sqlString = "SELECT itemorglinkid FROM itemorglink WHERE " +
                  "organisationid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
      if (l_rs.next())
        ret = true;
      l_rs.close();
      
      stmt.close();
      return (ret);
    }
    catch (Exception e)
    {
      handleException(e, "An Exception occured in checkInUse().");
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
    CachedRowSet  l_rs;
    String        sqlString;

    try
    {      
      Statement stmt = m_db.m_conn.createStatement ();
      
      // Must have a name
      if (m_organisation_name.equals (""))
      {
        m_error_string = "Organisation name is required.";
        l_ret = false;
      }

      // Check to see if a Organisation record exists (same name and state)
      sqlString = "select organisationid from organisation where name='" + m_db.plSqlSafeString(m_organisation_name) + "' and state=" + m_state_id + 
                  " and not organisationid=" + m_organisation_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
      {
        m_error_string = "A organisation with that name, in that state already exists.";
        l_ret = false;
      }
      l_rs.close();
      stmt.close();
      
      return (l_ret);
    }
    catch (Exception e)
    {
      handleException(e, "An Exception occured in validateObjectForDB().");
      return (false);
    }
  }

 
  public ResultSet getOrgTypes(Statement p_stmt){

    String l_sql = "";
    ResultSet l_rs = null;
  
    try{

      l_sql = "SELECT organisation_type.organisation_type_id, organisation_type.type " +
                "FROM organisation_type ";
      l_rs = m_db.runSQLResultSet (l_sql, p_stmt);
    }
    catch (Exception e)
    {
      handleException(e, "An Exception occured in Organisation.getOrgTypes().");
    }
    return(l_rs);

  }

  public String getFunction(int p_id){
    CachedRowSet  l_rs     = null;
    String        sqlString;

    try
    {      
      Statement stmt    = m_db.m_conn.createStatement ();

      sqlString = "SELECT distinct orgfunctmenu.orgfunction " +
                    "FROM orgfunctmenu, orgevlink, organisation " +
                   "WHERE organisation.organisationid=" + p_id + " " +
                     "AND organisation.organisationid = orgevlink.organisationid " +
                     "AND orgevlink.function = orgfunctmenu.orgfunctionid " +
                "ORDER BY orgfunction ASC";
      l_rs = m_db.runSQL (sqlString, stmt);
      m_FunctionList = "";
      while(l_rs.next()) 
      {
          if(m_FunctionList.equals(""))
          {
              m_FunctionList = l_rs.getString("orgfunction");
          } else
          {
              m_FunctionList += ", " + l_rs.getString("orgfunction");
          }
      }
      
      l_rs.close();
      stmt.close();
          
    }
    catch (Exception e)
    {
      handleException(e, "An Exception occured in Organisation.getFunction().");
    }
    return m_FunctionList;
  }

 
  ///////////////////////////////
  //  SET FUNCTIONS
  //////////////////////////////
  public void setDb(ausstage.Database p_db){
    m_db = p_db;
  }
  public void setId (int p_id)
  {
    p_id = m_organisation_id;
  }
  
  public void setName (String p_name)
  {
    m_organisation_name = p_name;
  }
  
  public void setOtherNames1 (String p_name)
  {
    m_other_names1 = p_name;
  }
  
  public void setOtherNames2 (String p_name)
  {
    m_other_names2 = p_name;
  }
  
  public void setOtherNames3 (String p_name)
  {
    m_other_names3 = p_name;
  }
  
  public void setAddress (String p_address)
  {
    m_address = p_address;
  }
  
  public void setSuburb (String p_suburb)
  {
    m_suburb = p_suburb;
  }
  
  public void setState (String p_state)
  {
    m_state_id = p_state;
  }

  public void setPostcode (String p_postcode)
  {
    m_postcode = p_postcode;
  }
  
  public void setContact (String p_contact)
  {
    m_contact = p_contact;
  }
  
  public void setPhone1 (String p_phone)
  {
    m_phone1 = p_phone;
  }

  public void setPhone2 (String p_phone)
  {
    m_phone2 = p_phone;
  }

  public void setPhone3 (String p_phone)
  {
    m_phone3 = p_phone;
  }
  
  public void setFax (String p_fax)
  {
    m_fax = p_fax;
  }
  
  public void setEmail (String p_email)
  {
    m_email = p_email;
  }
  
  public void setWebLinks (String p_weblinks)
  {
    m_web_links = p_weblinks;
  }
  
  public void setNotes (String p_notes)
  {
    m_notes = p_notes;
  }
  
  public void setCountry (String p_country)
  {
    m_country = p_country;
  }
  
  public void setDdfirstDate (String p_ddfirst_date){
	  m_ddfirst_date = p_ddfirst_date;
  }
	  
  public void setMmfirstDate (String p_mmfirst_date){
	  m_mmfirst_date = p_mmfirst_date;
  }

  public void setYyyyfirstDate (String p_yyyyfirst_date){
	  m_yyyyfirst_date = p_yyyyfirst_date;
  }
  
  public void setDdlastDate (String p_ddlast_date){
	  m_ddlast_date = p_ddlast_date;
  }
	  
  public void setMmlastDate (String p_mmlast_date){
	  m_mmlast_date = p_mmlast_date;
  }

  public void setYyyylastDate (String p_yyyylast_date){
	  m_yyyylast_date = p_yyyylast_date;
  }
  
  public void setOrganisationType (String p_org_type)
  {
    if(p_org_type == null)
      p_org_type = "";
    m_organisation_type = p_org_type;
  }
  
  public void setOrgOrgLinks(Vector p_org_orglinks) 
  {
	  m_org_orglinks = p_org_orglinks;
  }

  public void setEnteredByUser(String  p_user_name) {m_entered_by_user = p_user_name;}
  public void setUpdatedByUser(String  p_user_name) {m_updated_by_user = p_user_name;}
  
  public void setPlaceOfOrigin(String p_place_of_origin){
    m_place_of_origin = p_place_of_origin;
  }

  public void setPlaceOfDemise(String p_place_of_demise){
    m_place_of_demise = p_place_of_demise;
  }

  public void setNLA (String p_nla){
	    m_nla = p_nla;
	  }
  
  ///////////////////////////////
  //  GET FUNCTIONS
  //////////////////////////////
  
  public int getId(){
    return(m_organisation_id);
  }
  
  public String getName ()
  {
    return (m_organisation_name);
  }
  
  public String getOtherNames1 ()
  {
    return (m_other_names1);
  }
  
  public String getOtherNames2 ()
  {
    return (m_other_names2);
  }
  
  public String getOtherNames3 ()
  {
    return (m_other_names3);
  }
  
  public String getAddress ()
  {
    return (m_address);
  }
  
  public String getSuburb ()
  {
    return (m_suburb);
  }
  
  public String getState ()
  {
    return (m_state_id);
  }
  
  public String getStateName ()
  {
    return (m_state_name);
  }
  
  public String getContact ()
  {
    return (m_contact);
  }
  
  public String getPostcode ()
  {
    return (m_postcode);
  }
  
  public String getPhone1 ()
  {
    return (m_phone1);
  }

  public String getPhone2 ()
  {
    return (m_phone2);
  }

  public String getPhone3 ()
  {
    return (m_phone3);
  }
  
  public String getFax ()
  {
    return (m_fax);
  }
  
  public String getEmail ()
  {
    return (m_email);
  }
  
  public String getWebLinks ()
  {
    return (m_web_links);
  }
  
  public String getNotes ()
  {
    return (m_notes);
  }
  
  public String getCountry ()
  {
    return (m_country);
  }

  public String getOrganisationType ()
  {
    return (m_organisation_type);
  }

  public String getError ()
  {
    return (m_error_string);
  }
  
  public Vector getAssociatedOrganisation() {
	    return m_org_orglinks;
	  }
  public Vector getAssociatedOrganisations() {
	    return m_org_orglinks;
	  }
  
  public String getEnteredByUser(){return m_entered_by_user;}
  public Date   getEnteredDate(){return m_entered_date;}
  public Date   getUpdatedDate(){return m_updated_date;}
  public String getUpdatedByUser(){return m_updated_by_user;}
  
  public String getDdfirstDate(){
    return (m_ddfirst_date);
  }

  public String getMmfirstDate(){
    return (m_mmfirst_date);
  }

  public String getYyyyfirstDate(){
    return (m_yyyyfirst_date);
  }
  
  public String getDdlastDate(){
    return (m_ddlast_date);
  }

  public String getMmlastDate(){
    return (m_mmlast_date);
  }

  public String getYyyylastDate(){
    return (m_yyyylast_date);
  }
  
  public String getPlaceOfOrigin(){
    return (m_place_of_origin);
  }

  public String getPlaceOfDemise(){
    return (m_place_of_demise);
  }
  
  public String getNLA(){
	    return (m_nla);
	  }
  
  /*
  Name: loadLinkedVenues ()

  Purpose: Sets the class to a contain the Contributors information for the
           specified organisation id.

  Parameters:
    None

  Returns:
     None

  */
  private void loadLinkedOrganisations()
  {
    ResultSet    l_rs = null;
    String       l_sql = "";

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      l_sql = "SELECT DISTINCT childid " +
                "FROM orgorglink " +
               "WHERE orgorglink.organisationid =" + m_organisation_id;
      l_rs = m_db.runSQLResultSet (l_sql, stmt);
      // Reset the object
      m_org_orglinks.removeAllElements();

      while (l_rs.next())
      {
    	  m_org_orglinks.addElement(l_rs.getString("CHILDID"));

      }
      l_rs.close();
      stmt.close();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in loadLinkedOrganisations().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }
  
  /*************************************************************************
  this method is used for passing in a vector containing id strings
  of the relevent object. i.e eventids, contributor ids etc.
  It then appends the appropriate display info to the id as a string.
  Such that when used in the displayLinkedItem method from item_addedit.jsp
  it has all the information as a string per element ready to be displayed.
 **************************************************************************/
public Vector generateDisplayInfo(Vector p_ids, String p_id_type, 
                           Statement p_stmt) {
  Vector l_display_info = new Vector();
  String l_info_to_add = "";
  
  for (int i = 0; i < p_ids.size(); i++) {  
    if (p_id_type.equals("organisation")) {
    	Organisation childOrganisation = new Organisation(m_db);
        int childOrganisationId = 
          Integer.parseInt(((OrganisationOrganisationLink)m_org_orglinks.elementAt(i)).getChildId());
        l_info_to_add = 
        	childOrganisation.getOrganisationInfoForOrganisationDisplay(childOrganisationId, p_stmt);
        // Get the selected item function
        l_display_info.add(l_info_to_add);
    }
  }   
  return l_display_info;
}
public void setOrganisationAttributes(HttpServletRequest request) {
	   //Calendar calendar;
	   //String day = "";
	   //String month = "";
	   //String year = "";

	  
	   this.m_organisation_name = request.getParameter("f_organisation_name");
	   if (m_organisation_name == null)
		   m_organisation_name = "";
	   this.m_other_names1 = request.getParameter("f_other_names1");
	   if (m_other_names1 == null)
		   m_other_names1 = "";
	   this.m_other_names2 = request.getParameter("f_other_names2");
	   if (m_other_names2 == null)
		   m_other_names2 = "";
	   this.m_other_names3 = request.getParameter("f_other_names3");
	   if (m_other_names3 == null)
		   m_other_names3 = "";
	   this.m_suburb = request.getParameter("f_suburb");
	   if (this.m_suburb == null)
	     this.m_suburb = "";
	   this.m_postcode = request.getParameter("f_postcode");
	   if (m_postcode == null)
		   m_postcode = "";
	   this.m_state_id = request.getParameter("f_state_id");
	   if (m_state_id == null)
		   m_state_id = "";
	   this.m_state_name = request.getParameter("f_state_name;");
	   if (m_state_name == null)
		   m_state_name = "";
	   this.m_contact = request.getParameter("f_contact");
	   if (m_contact == null)
		   m_contact = "";
	   this.m_phone1 = request.getParameter("f_phone1");
	   if (m_phone1 == null)
		   m_phone1 = "";
	   this.m_phone1 = request.getParameter("f_contact_phone2");
	   if (m_phone2 == null)
		   m_phone2 = "";
	   this.m_phone1 = request.getParameter("f_contact_phone3");
	   if (m_phone3 == null)
		   m_phone3 = "";
	   this.m_fax = request.getParameter("f_fax");
	   if (m_fax == null)
		   m_fax = "";
	   this.m_email = request.getParameter("f_email");
	   if (m_email == null)
		   m_email = "";
	   this.m_web_links = request.getParameter("f_web_links");
	   if (m_web_links == null)
		   m_web_links = "";
	   this.m_country = request.getParameter("f_country");
	   if (m_country == null)
		   m_country = "";
	   this.m_phone2 = request.getParameter("f_phone2");
	   if (m_phone2 == null)
		   m_phone2 = "";
	   this.m_phone3 = request.getParameter("f_latitude");
	   if (m_phone3 == null)
		   m_phone3 = "";
	   this.m_notes = request.getParameter("f_notes");
	   if (m_notes == null)
		   m_notes = "";
	   this.m_error_string =  request.getParameter("f_error_string");
	   if (m_error_string == null)
	    m_error_string = "";
	   this.m_ddfirst_date = request.getParameter("f_first_date_day");
	   if (m_ddfirst_date == null)
		   m_ddfirst_date = "";
	   this.m_mmfirst_date = request.getParameter("f_first_date_month");
	   if (m_mmfirst_date == null)
		   m_mmfirst_date = "";
	   this.m_yyyyfirst_date = request.getParameter("f_first_date_year");
	   if (m_yyyyfirst_date == null)
		   m_yyyyfirst_date = "";
	   this.m_ddlast_date = request.getParameter("f_last_date_day");
	   if (m_ddlast_date == null)
		   m_ddlast_date = "";
	   this.m_mmlast_date = request.getParameter("f_last_date_month");
	   if (m_mmlast_date == null)
		   m_mmlast_date = "";
	   this.m_yyyylast_date = request.getParameter("f_last_date_year");
	   if (m_yyyylast_date == null)
		   m_yyyylast_date = "";
	   this.m_nla           = request.getParameter("f_nla");
	   if (m_nla == null) m_nla="";
	
	  // this.m_entered_by_user = request.getParameter("f_entered_by_user");
	  // if (m_entered_by_user == null)
	//   m_entered_by_user = "";
	 //  this.m_entered_date = request.getParameter("f_entered_date");
	 //  if (m_entered_date == null)
//		   m_entered_date = "";
	 //  this.m_updated_by_user = request.getParameter("f_updated_by_user");
	 //  if (m_updated_by_user == null)
//		   m_updated_by_user = "";
	 //  this.m_updated_date = request.getParameter("m_updated_date");
	 //  if (m_updated_date == null)
	//   m_updated_date = "";
	  
	 //

	   } 

	/*
	Name: modifyVenueVenueLinks ()
	
	Purpose: Modifies this object in the database.
	
	Parameters:
	  modifyType - Update, Delete or Insert
	
	Returns:
	   None
	
	*/
	
	private void modifyOrgOrgLinks(int modifyType) {
	  try {
	    OrganisationOrganisationLink temp_object = new OrganisationOrganisationLink(m_db);
	    switch (modifyType) {
	    case UPDATE:
	      temp_object.update(Integer.toString(m_organisation_id), m_org_orglinks);
	      break;
	    case DELETE:
	      temp_object.deleteOrganisationOrganisationLinksForOrganisation(Integer.toString(m_organisation_id));
	      break;
	    case INSERT:
	      temp_object.add(Integer.toString(m_organisation_id), m_org_orglinks);
	      break;
	    }
	  } catch (Exception e) {
	    System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
	    System.out.println("An Exception occured in modifyEventEventLinks().");
	    System.out.println("MESSAGE: " + e.getMessage());
	    System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
	    System.out.println("CLASS.TOSTRING: " + e.toString());
	    System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
	  }
	}
   ////////////////////////
  //    Utility methods
  ////////////////////////
  //public String getOrganisationInfoForItemDisplay(int p_item_id, Statement p_stmt) {
public String getOrganisationInfoForItemDisplay(int p_org_id, Statement p_stmt) {	
    String sqlString = "", retStr = "";
    ResultSet l_rs = null;

    try {
//edited by Brad Williams 18/05/2012 
//incorrect data being retrieved.
//      sqlString = 
//          "select citation display_info " + "FROM item i " + " WHERE i.itemid = " + 
//          p_item_id;

      sqlString = "SELECT organisation.organisationid, name, if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) dates, "+
          "CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
          "FROM organisation LEFT JOIN orgevlink ON (orgevlink.organisationid = organisation.organisationid) "+
          "LEFT JOIN events ON (orgevlink.eventid = events.eventid)  "+
          "WHERE organisation.organisationid=" + p_org_id;
    	
      l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

      if (l_rs.next())
        retStr = l_rs.getString("OUTPUT");


    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in Organisation.getOrganisationInfoForItemDisplay().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (retStr);
  }
  
  public String getOrganisationInfoForOrganisationDisplay(int p_org_id, Statement p_stmt){
    String sqlString   = "", retStr  ="";
    ResultSet l_rs = null;
    
    try{
    
      sqlString = "SELECT organisation.organisationid, name, if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) dates, "+
      "CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
      "FROM organisation LEFT JOIN orgevlink ON (orgevlink.organisationid = organisation.organisationid) "+
      "LEFT JOIN events ON (orgevlink.eventid = events.eventid)  "+
      "WHERE organisation.organisationid=" + p_org_id;
    	  
    	                    
      l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

      if(l_rs.next())
        retStr = l_rs.getString("OUTPUT"); 
  
      
    }catch(Exception e){
      handleException(e, "An Exception occured in Organisation.getOrganisationInfoForOrganisationDisplay().");
    }
    return(retStr);

  }
  public String getOrganisationInfoForWorkDisplay(int p_work_id, Statement p_stmt){
	    String sqlString   = "", retStr  ="";
	    ResultSet l_rs = null;
	    
	    try{
	    
	      sqlString = "SELECT work.workid, work.work_title,organisation.organisationid,organisation.name "+
	      "FROM work "+
	      "INNER JOIN workorglink ON (workorglink.workid = work.workid) "+
	      "INNER JOIN organisation ON (organisation.organisationid = workorglink.organisationid) " +
	      "WHERE work.workid=" + p_work_id;
	    	  
	    	                    
	      l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

	      if(l_rs.next())
	        retStr = l_rs.getString("organisation.name"); 
	  
	      
	    }catch(Exception e){
	      handleException(e, "An Exception occured in Organisation.getOrganisationInfoForWorkDisplay().");
	    }
	    return(retStr);

	  }
  

  public String getOrganisationTypeDescription(String p_org_type_id, Statement p_stmt){
    String sqlString   = "", retStr  ="";
    ResultSet l_rs = null;
    
    try{
    
      sqlString = "SELECT type as display_info " +
                    "FROM organisation_type " +
                   "WHERE ORGANISATION_TYPE_ID =" + p_org_type_id + " " + 
                     "";
                  
      l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

      if(l_rs.next())
        retStr = l_rs.getString("display_info"); 
  
      
    }catch(Exception e){
      handleException(e, "An Exception occured in Organisation.getOrganisationTypeDescription().");
    }
    return(retStr);

  }

   public ResultSet getOrganisationsByItem(int p_organisation_id, Statement p_stmt){
    String sqlString   = "";
    ResultSet l_rs = null;
    
    try {

      sqlString = "SELECT DISTINCT organisation.organisationid, organisation.name " +
                    "FROM organisation, itemorglink, orgevlink, orgfunctmenu " +
                   "WHERE itemorglink.organisationid=" + p_organisation_id + " " + 
                     "AND itemorglink.organisationid = organisation.organisationid " +
                     "AND organisation.organisationid = orgevlink.organisationid " +
                     "AND orgevlink.function = orgfunctmenu.orgfunctionid ";// +
                //"ORDER BY itemorglink.orderby ASC";
                  
      l_rs = m_db.runSQLResultSet(sqlString, p_stmt);
      
    }catch(Exception e){
      handleException(e, "An Exception occured in Organisation.getOrganisationsByItem().");
    }
    return(l_rs);
  }


  /*
  Name: getOrganisations ()

  Purpose: Returns a record set with all of the educational organisations in it.

  Parameters:
    p_stmt : Database statement
    p_org_type : organisation_type

  Returns:
     A record set.

  */
  public CachedRowSet getOrganisations(Statement p_stmt, String p_org_type)
  {
    CachedRowSet  l_rs;
    String        sqlString;
   
    try
    {      
      sqlString = "SELECT * FROM organisation " +
                  " WHERE organisation_type_id = "+ p_org_type + 
                  " order by name";
      l_rs = m_db.runSQL (sqlString, p_stmt);
      return (l_rs);
    }
    catch (Exception e)
    {
      handleException(e);
      return (null);
    }
  }


  /*
  Name: getAccociatedItems (int p_organisation_id)

  Purpose: Find any items that are associated to a organisation.

  Parameters:
    p_organisation_id - The id of the organisation.

  Returns:
     A ResultSet with item information if the organisation is found to be accociated.
  */

  public ResultSet getAssociatedItems(int p_organisation_id, Statement p_stmt){
    String    l_sql = "";
    ResultSet l_rs  = null;
        
    try{
      
        l_sql = "SELECT DISTINCT item.CITATION,item.itemid ,organisation.NAME, organisation.organisationid " +
                  "FROM item  " +
                  "INNER JOIN itemorglink ON (item.ITEMID = itemorglink.ITEMID) "+
                  "INNER JOIN organisation ON (itemorglink.ORGANISATIONID = organisation.ORGANISATIONID) "+
                  "WHERE organisation.organisationid=" + p_organisation_id + " " + 
                  "Order by item.CITATION";
                      
      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
      
    }catch(Exception e){
    	System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
        System.out.println ("An Exception occured in Organisation.getAssociatedItems().");
        System.out.println("MESSAGE: " + e.getMessage());
        System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
        System.out.println("CLASS.TOSTRING: " + e.toString());
        System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return(l_rs);
    
  }
  /*
  Name: getAssociatedWorks (int p_contributor_id)

  Purpose: Find any items that are associated to a contributor.

  Parameters:
    p_contributor_id - The id of the contributor.

  Returns:
     A ResultSet with item information if the contributor is found to be accociated.
  */

  public ResultSet getAssociatedWorks(int p_org_id, Statement p_stmt){
    String    l_sql = "";
    ResultSet l_rs  = null;
    
    try{
      
      l_sql = "SELECT DISTINCT w.workid, WORK_TITLE, ORDER_BY " +
                         "FROM work w, workorglink wcl " +
                        "WHERE wcl.ORGANISATIONID=" + p_org_id + " " + 
                          "AND wcl.workid = w.workid " +
                          "ORDER BY WORK_TITLE";
                  
      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
      
    }catch(Exception e){
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in Organisation.getAssociatedWorks().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      //System.out.println(" sql:" +  l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return(l_rs);
  }
  
  void handleException(Exception p_e, String p_description) {
    System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
    System.out.println("MESSAGE: " + p_e.getMessage());
    System.out.println("LOCALIZED MESSAGE: " + p_e.getLocalizedMessage());
    System.out.println("CLASS.TOSTRING: " + p_e.toString());
    System.out.println(">>>>>>> STACK TRACE <<<<<<<");
    System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  }
  
  void handleException(Exception p_e) {
    handleException(p_e, "");
  }
}


