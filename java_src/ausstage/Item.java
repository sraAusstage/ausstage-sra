/***************************************************

Company: Ignition Design
Author: Luke Sullivan
Project: Ausstage
File: item.java
Purpose: Provides item object functions.

Update: 10/01/06
Author: Brad Williams
Purpose: Add item_url field & methods to the clafss.

***************************************************/

package

ausstage;

import ausstage.Database;
import admin.Common;

import ausstage.Contributor;
import ausstage.Event;
import ausstage.Organisation;
import ausstage.Venue;

import java.util.Arrays;
import java.util.Date;
import java.util.Calendar;
import java.util.Vector;

import java.sql.*;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import java.util.GregorianCalendar;

import sun.jdbc.rowset.CachedRowSet;

import java.net.URL;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

public class Item {
  private ausstage.Database m_db;
  private admin.AppConstants AppConstants = new admin.AppConstants();
  private admin.Common Common = new admin.Common();

  private final int INSERT = 0;
  private final int DELETE = 1;
  private final int UPDATE = 2;
  private boolean m_is_in_copy_mode;
  // All of the Item record information
  private String m_itemid;
  private String m_sourceid;
  private String m_catalogueid;
  private String m_institutionid;
  private String m_item_type;
  private String m_item_sub_type;
  private String m_item_language;
  private String m_item_description;
  private String m_item_condition_id;
  private String m_detail_comments;
  private String m_donated_purchased;
  private String m_aquired_from;
  private String m_storage;
  private String m_provenance;
  private String m_significance;
  private String m_comments;
  private String m_entered_by_user;
  private String m_updated_by_user;
  private Date m_entered_date;
  private Date m_updated_date;
  private String m_item_url;
  private String m_action;
  private String m_error_string;
  private boolean m_is_copy;
  // Derived Objects
  private Vector m_item_evlinks;
  private Vector m_item_contentindlinks;
  private Vector<ItemItemLink> m_item_itemlinks;
  private Vector m_item_orglinks;
  private Vector m_item_creator_orglinks;

  private Vector m_item_venuelinks;
  private Vector m_item_conlinks;
  private Vector m_item_creator_conlinks;
  private Vector m_item_secgenrelinks;
  private Vector m_item_workslinks;
  
  // ADDED BY BW FOR ADDITIONAL ITEM URLs
  private Vector m_additional_urls;

  // CR0001
  private String m_ddCreate_date;
  private String m_mmCreate_date;
  private String m_yyyyCreate_date;
  private Date m_create_date;

  private String m_ddCopyright_date;
  private String m_mmCopyright_date;
  private String m_yyyyCopyright_date;
  private Date m_copyright_date;

  private String m_ddIssued_date;
  private String m_mmIssued_date;
  private String m_yyyyIssued_date;
  private Date m_issued_date;

  private String m_ddAccessioned_date;
  private String m_mmAccessioned_date;
  private String m_yyyyAccessioned_date;
  private Date m_accessioned_date;
  
  private String m_ddTerminated_date;
  private String m_mmTerminated_date;
  private String m_yyyyTerminated_date;
  private Date m_terminated_date;


  private String m_description_abstract;
  private String m_format_extent;
  private String m_format_medium;
  private String m_format_mimetype;
  private String m_format;
  private String m_citation;
  private String m_source_citation;
  private String m_ident_isbn;
  private String m_ident_ismn;
  private String m_ident_issn;
  private String m_ident_sici;
  private String m_publisher;
  private String m_rights_access_rights;
  private String m_rights;
  private String m_rights_holder;
  private String m_title;
  private String m_title_alternative;
  private String m_dc_creator;

  private String m_date_notes;
  private String m_publisher_location;
  private String m_volume;
  private String m_issue;
  private String m_page;
  private String m_date_updated;


  /**
  Name: item ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

   */
  public Item(ausstage.Database p_db) {
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

  public void initialise() {
    m_is_in_copy_mode = false;
    //item record info
    m_itemid = "0";
    m_sourceid = "";
    m_catalogueid = "";
    m_institutionid = "";
    m_item_type = "";
    m_item_sub_type = "";
    m_item_language = "";
    m_item_description = "";
    m_item_condition_id = "";
    m_detail_comments = "";
    m_donated_purchased = "";
    m_aquired_from = "";
    m_storage = "";
    m_provenance = "";
    m_significance = "";
    m_comments = "";
    m_entered_by_user = "";
    m_updated_by_user = "";
    m_action = "";
    m_entered_date = new Date();
    m_error_string = "";
    m_is_copy = false;
    m_item_url = "";
    // Derived Objects
    m_item_evlinks = new Vector();
    m_item_contentindlinks = new Vector();
    m_item_itemlinks = new Vector<ItemItemLink>();
    m_item_orglinks = new Vector();
    m_item_creator_orglinks = new Vector();
    m_item_venuelinks = new Vector();
    m_item_conlinks = new Vector();
    m_item_creator_conlinks = new Vector();
    m_item_secgenrelinks = new Vector();
    m_item_workslinks = new Vector();
    m_additional_urls = new Vector(); //BW ADDITIONAL ITEM URLS

    // CR0001
    m_ddCreate_date = "";
    m_mmCreate_date = "";
    m_yyyyCreate_date = "";
    m_create_date = new Date();

    m_ddCopyright_date = "";
    m_mmCopyright_date = "";
    m_yyyyCopyright_date = "";
    m_copyright_date = new Date();

    m_ddIssued_date = "";
    m_mmIssued_date = "";
    m_yyyyIssued_date = "";
    m_issued_date = new Date();

    m_ddAccessioned_date = "";
    m_mmAccessioned_date = "";
    m_yyyyAccessioned_date = "";
    m_accessioned_date = new Date();
    
    m_ddTerminated_date = "";
    m_mmTerminated_date = "";
    m_yyyyTerminated_date = "";
    m_terminated_date = new Date();

    m_description_abstract = "";
    m_format_extent = "";
    m_format_medium = "";
    m_format_mimetype = "";
    m_format = "";
    m_citation = "";
    m_source_citation = "";
    m_ident_isbn = "";
    m_ident_ismn = "";
    m_ident_issn = "";
    m_ident_sici = "";
    m_publisher = "";
    m_rights_access_rights = "";
    m_rights = "";
    m_rights_holder = "";
    m_title = "";
    m_title_alternative = "";
    m_dc_creator = "";

    m_date_notes = "";
    m_publisher_location = "";
    m_volume = "";
    m_issue = "";
    m_page = "";


  }

  /*
  Name: load ()
  Overloaded method for loading Item details using an item id
  */

  public void load(final int p_item_id) {
    load(p_item_id + "", true);
  }
  /*
  Name: load ()
  Overloaded method for loading Item details using a catalogue id
  */

  public void load(final String p_catalogue_id) {
    load(p_catalogue_id, false);
  }

  /*
  Name: load ()

  Purpose: Sets the memeber variables of the class based on an item or catalogue id.

  Parameters:
    p_id      : The item or catalogue id of the item record we are loading.
   p_isItemId : Determine if the item or catalogue id is to be used.
  Returns:
     None

  */

  public void load(String p_id, boolean p_isItemId) {
    ResultSet l_rs;
    ResultSet l_rs2;
    String sqlString = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      if (p_isItemId) {
        sqlString = 
            "SELECT * " + "FROM item " + "WHERE itemid = '" + p_id + "'";
      } else {
        sqlString = 
            "SELECT * " + "FROM item " + "WHERE catalogueid = '" + p_id + "'";
      }
      l_rs = m_db.runSQL(sqlString, stmt);

      if (l_rs.next()) {
        m_itemid = l_rs.getString("itemid");
        m_catalogueid = l_rs.getString("catalogueid");
        m_sourceid = l_rs.getString("sourceid");
        m_institutionid = l_rs.getString("institutionid");
        m_item_type = l_rs.getString("item_type_lov_id");
        m_item_sub_type = l_rs.getString("item_sub_type_lov_id");
        m_item_language = l_rs.getString("language_lov_id");
        m_item_description = l_rs.getString("item_description");
        m_item_condition_id = l_rs.getString("item_condition_id");
        m_detail_comments = l_rs.getString("detail_comments");
        m_donated_purchased = l_rs.getString("donated_purchased");
        m_aquired_from = l_rs.getString("aquired_from");
        m_storage = l_rs.getString("storage");
        m_provenance = l_rs.getString("provenance");
        m_significance = l_rs.getString("significance");
        m_comments = l_rs.getString("comments");
        m_entered_by_user = l_rs.getString("entered_by_user");
        m_updated_by_user = l_rs.getString("modified_by_user");
        m_entered_date = l_rs.getDate("entered_date");
        m_updated_date = l_rs.getDate("modified_date");
        m_item_url = l_rs.getString("item_url");

        // CR0001
        m_ddCreate_date = l_rs.getString("ddCreated_date");
        m_mmCreate_date = l_rs.getString("mmCreated_date");
        m_yyyyCreate_date = l_rs.getString("yyyyCreated_date");
        m_create_date = l_rs.getDate("created_date");

        m_ddCopyright_date = l_rs.getString("ddCopyright_date");
        m_mmCopyright_date = l_rs.getString("mmCopyright_date");
        m_yyyyCopyright_date = l_rs.getString("yyyyCopyright_date");
        m_copyright_date = l_rs.getDate("copyright_date");

        m_ddIssued_date = l_rs.getString("ddIssued_date");
        m_mmIssued_date = l_rs.getString("mmIssued_date");
        m_yyyyIssued_date = l_rs.getString("yyyyIssued_date");
        m_issued_date = l_rs.getDate("issued_date");

        m_ddAccessioned_date = l_rs.getString("ddAccessioned_date");
        m_mmAccessioned_date = l_rs.getString("mmAccessioned_date");
        m_yyyyAccessioned_date = l_rs.getString("yyyyAccessioned_date");
        m_accessioned_date = l_rs.getDate("accessioned_date");
        
        m_ddTerminated_date = l_rs.getString("ddTerminated_date");
        m_mmTerminated_date = l_rs.getString("mmTerminated_date");
        m_yyyyTerminated_date = l_rs.getString("yyyyTerminated_date");
        m_terminated_date = l_rs.getDate("terminated_date");


        m_description_abstract = l_rs.getString("description_abstract");
        m_format_extent = l_rs.getString("format_extent");
        m_format_medium = l_rs.getString("format_medium");
        m_format_mimetype = l_rs.getString("format_mimetype");
        m_format = l_rs.getString("format");
        m_citation = l_rs.getString("citation");
        m_ident_isbn = l_rs.getString("ident_isbn");
        m_ident_ismn = l_rs.getString("ident_ismn");
        m_ident_issn = l_rs.getString("ident_issn");
        m_ident_sici = l_rs.getString("ident_sici");
        m_publisher = l_rs.getString("publisher");
        m_rights_access_rights = l_rs.getString("rights_access_rights");
        m_rights = l_rs.getString("rights");
        m_rights_holder = l_rs.getString("rights_holder");
        m_title = l_rs.getString("title");
        m_title_alternative = l_rs.getString("title_alternative");
        m_dc_creator = l_rs.getString("dc_creator");

        //TIR032
        m_date_notes = l_rs.getString("date_notes");
        m_publisher_location = l_rs.getString("publisher_location");
        m_volume = l_rs.getString("volume");
        m_issue = l_rs.getString("issue");
        m_page = l_rs.getString("page");


        //deal with empty tuples
        if (m_itemid == null)
          m_itemid = "";
        if (m_catalogueid == null)
          m_catalogueid = "";
        if (m_sourceid == null)
          m_sourceid = "";
        if (m_institutionid == null)
          m_institutionid = "";
        if (m_item_type == null)
          m_item_type = "";
        if (m_item_sub_type == null)
          m_item_sub_type = "";
        if (m_item_language == null)
          m_item_language = "";
        if (m_item_description == null)
          m_item_description = "";
        if (m_item_condition_id == null)
          m_item_condition_id = "";
        if (m_detail_comments == null)
          m_detail_comments = "";
        if (m_donated_purchased == null)
          m_donated_purchased = "";
        if (m_aquired_from == null)
          m_aquired_from = "";
        if (m_storage == null)
          m_storage = "";
        if (m_provenance == null)
          m_provenance = "";
        if (m_significance == null)
          m_significance = "";
        if (m_comments == null)
          m_comments = "";
        if (m_entered_by_user == null)
          m_entered_by_user = "";
        if (m_updated_by_user == null)
          m_updated_by_user = "";
        // if (m_entered_date == null)      m_entered_date      = new Date();
        // if (m_updated_date == null)      m_updated_date      = new Date();
        if (m_item_url == null)
          m_item_url = "";

        // CR0001
        if (m_description_abstract == null)
          m_description_abstract = "";
        if (m_format_extent == null)
          m_format_extent = "";
        if (m_format_medium == null)
          m_format_medium = "";
        if (m_format_mimetype == null)
          m_format_mimetype = "";
        if (m_format == null)
          m_format = "";
        if (m_citation == null)
          m_citation = "";
        if (m_ident_isbn == null)
          m_ident_isbn = "";
        if (m_ident_ismn == null)
          m_ident_ismn = "";
        if (m_ident_issn == null)
          m_ident_issn = "";
        if (m_ident_sici == null)
          m_ident_sici = "";
        if (m_publisher == null)
          m_publisher = "";
        if (m_rights_access_rights == null)
          m_rights_access_rights = "";
        if (m_rights == null)
          m_rights = "";
        if (m_rights_holder == null)
          m_rights_holder = "";
        if (m_title == null)
          m_title = "";
        if (m_title_alternative == null)
          m_title_alternative = "";
        if (m_dc_creator == null)
          m_dc_creator = "";

        if (m_ddCreate_date == null)
          m_ddCreate_date = "";
        if (m_mmCreate_date == null)
          m_mmCreate_date = "";
        if (m_yyyyCreate_date == null)
          m_yyyyCreate_date = "";

        if (m_ddCopyright_date == null)
          m_ddCopyright_date = "";
        if (m_mmCopyright_date == null)
          m_mmCopyright_date = "";
        if (m_yyyyCopyright_date == null)
          m_yyyyCopyright_date = "";

        if (m_ddIssued_date == null)
          m_ddIssued_date = "";
        if (m_mmIssued_date == null)
          m_mmIssued_date = "";
        if (m_yyyyIssued_date == null)
          m_yyyyIssued_date = "";

        if (m_ddAccessioned_date == null)
          m_ddAccessioned_date = "";
        if (m_mmAccessioned_date == null)
          m_mmAccessioned_date = "";
        if (m_yyyyAccessioned_date == null)
          m_yyyyAccessioned_date = "";
          
        if (m_ddTerminated_date == null)
          m_ddTerminated_date = "";
        if (m_mmTerminated_date == null)
          m_mmTerminated_date = "";
        if (m_yyyyTerminated_date == null)
          m_yyyyTerminated_date = "";

        if (m_date_notes == null)
          m_date_notes = "";
        if (m_publisher_location == null)
          m_publisher_location = "";
        if (m_volume == null)
          m_volume = "";
        if (m_issue == null)
          m_issue = "";
        if (m_page == null)
          m_page = "";

        loadLinkedEvents();
        loadLinkedItems();
        loadLinkedSecGenre();
        loadLinkedOrganisations();
        loadLinkedVenues();
        loadLinkedContributors();
        loadLinkedCreatorContributors();
        loadLinkedCreatorOrganisations();
        loadLinkedContentInd();
        loadLinkedWork();
        loadAdditionalUrls(); //BW -additional URLS

        // Load the source citation
        if (m_sourceid != null && !m_sourceid.equals("")) {
          l_rs2 = 
              m_db.runSQLResultSet("SELECT citation FROM item where itemid = " + 
                                   m_sourceid, stmt);

          if (l_rs2.next()) {
            m_source_citation = l_rs2.getString("citation");
          }
          l_rs2.close();
        }
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occurred in item - load().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  public String getItemId() {
    return m_itemid;
  }

  public String getSourceId() {
    return m_sourceid;
  }

  public String getCatalogueId() {
    return m_catalogueid;
  }

  public String getInstitutionId() {
    return m_institutionid;
  }

  public String getItemType() {
    return m_item_type;
  }

  public String getItemSubType() {
    return m_item_sub_type;
  }

  public String getItemLanguage() {
    return m_item_language;
  }

  public String getItemDescription() {
    return m_item_description;
  }

  public String getItemConditionId() {
    return m_item_condition_id;
  }

  public String getDetailComments() {
    return m_detail_comments;
  }

  public String getItemDonatedPurchasedId() {
    return m_donated_purchased;
  }

  public String getAquiredFrom() {
    return m_aquired_from;
  }

  public String getItemStorage() {
    return m_storage;
  }

  public String getProvenance() {
    return m_provenance;
  }

  public String getSignificance() {
    return m_significance;
  }

  public String getComments() {
    return m_comments;
  }

  public String getEnteredByUser() {
    return m_entered_by_user;
  }

  public Date getEnteredDate() {
    return m_entered_date;
  }

  public String getUpdatedByUser() {
    return m_updated_by_user;
  }

  public Date getUpdatedDate() {
    return m_updated_date;
  }

  public String getItemUrl() {
    return m_item_url;
  }

  public String getError() {
    return m_error_string;
  }

  // CR0001

  public String getDescriptionAbstract() {
    return m_description_abstract;
  }

  public String getFormatExtent() {
    return m_format_extent;
  }

  public String getFormatMedium() {
    return m_format_medium;
  }

  public String getFormatMimetype() {
    return m_format_mimetype;
  }

  public String getFormat() {
    return m_format;
  }

  public String getCitation() {
    return m_citation;
  }

  public String getIdentIsbn() {
    return m_ident_isbn;
  }

  public String getIdentIsmn() {
    return m_ident_ismn;
  }

  public String getIdentIssn() {
    return m_ident_issn;
  }

  public String getIdentSici() {
    return m_ident_sici;
  }

  public String getPublisher() {
    return m_publisher;
  }

  public String getRightsAccessRights() {
    return m_rights_access_rights;
  }

  public String getRights() {
    return m_rights;
  }

  public String getRightsHolder() {
    return m_rights_holder;
  }

  public String getTitle() {
    return m_title;
  }

  public String getTitleAlternative() {
    return m_title_alternative;
  }

  public String getDcCreator() {
    return m_dc_creator;
  }

  public String getDdCreateDate() {
    return m_ddCreate_date;
  }

  public String getMmCreateDate() {
    return m_mmCreate_date;
  }

  public String getYyyyCreateDate() {
    return m_yyyyCreate_date;
  }

  public Date getCreateDate() {
    return m_create_date;
  }

  public String getDdCopyrightDate() {
    return m_ddCopyright_date;
  }

  public String getMmCopyrightDate() {
    return m_mmCopyright_date;
  }

  public String getYyyyCopyrightDate() {
    return m_yyyyCopyright_date;
  }

  public Date getCopyrightDate() {
    return m_copyright_date;
  }

  public String getDdIssuedDate() {
    return m_ddIssued_date;
  }

  public String getMmIssuedDate() {
    return m_mmIssued_date;
  }

  public String getYyyyIssuedDate() {
    return m_yyyyIssued_date;
  }

  public Date getIssuedDate() {
    return m_issued_date;
  }

  public String getDdAccessionedDate() {
    return m_ddAccessioned_date;
  }

  public String getMmAccessionedDate() {
    return m_mmAccessioned_date;
  }

  public String getYyyyAccessionedDate() {
    return m_yyyyAccessioned_date;
  }

  public Date getAccessionedDate() {
    return m_accessioned_date;
  }
  
  public String getDdTerminatedDate() {
    return m_ddTerminated_date;
  }

  public String getMmTerminatedDate() {
    return m_mmTerminated_date;
  }

  public String getYyyyTerminatedDate() {
    return m_yyyyTerminated_date;
  }

  public Date getTerminatedDate() {
    return m_terminated_date;
  }

  // Get Linked Objects

  public Vector getAssociatedEvents() {
    return m_item_evlinks;
  }

  public Vector getAssociatedContentIndicators() {
    return m_item_contentindlinks;
  }

  public Vector getAssociatedSecGenres() {
    return m_item_secgenrelinks;
  }

  public Vector getAssociatedWorks() {
    return m_item_workslinks;
  }

  //BW additional URLS
  public Vector getAdditionalUrls() {
	    return m_additional_urls;
  }
  
  public Vector<Item> getAssociatedItems() {
	Vector<Item> items = new Vector<Item>();
	for (ItemItemLink iil : m_item_itemlinks) {
		Item item = new Item(m_db);
		item.load(Integer.parseInt(iil.getChildId()));
		items.add(item);
	}
	return items;
  }
	  
  public Vector<ItemItemLink> getItemItemLinks() {
	return m_item_itemlinks;
  }

  public Vector getAssociatedOrganisations() {
    return m_item_orglinks;
  }

  public Vector getAssociatedCreatorOrganisations() {
    return m_item_creator_orglinks;
  }

  public Vector getAssociatedVenues() {
    return m_item_venuelinks;
  }

  public Vector getAssociatedContributors() {
    return m_item_conlinks;
  }

  public Vector getAssociatedCreatorContributors() {
    return m_item_creator_conlinks;
  }

  //TIR032

  public String getDateNotes() {
    return m_date_notes;
  }

  public String getPublisherLocation() {
    return m_publisher_location;
  }

  public String getVolume() {
    return m_volume;
  }

  public String getIssue() {
    return m_issue;
  }

  public String getPage() {
    return m_page;
  }

  public void setIsInCopyMode(boolean p_is_in_copy_mode) {
    m_is_copy = p_is_in_copy_mode;
  }


  /*
  Name: addItem ()

  Purpose: add in a new Item to the database.

  Parameters:
     None

  Returns:
     boolean true or false to represent success

  */

  public boolean addItem() {

    String l_sql = "";
    boolean l_ret = false;
    String l_entered_date = m_db.safeDateFormat(m_entered_date, false);
    ResultSet l_rs;
    String l_item_id = "";

    // CR0001
    String l_create_date = null;
    String l_copyright_date = null;
    String l_issued_date = null;
    String l_accessioned_date = null;
    String l_terminated_date = null;

    try {
      Statement stmt = m_db.m_conn.createStatement();

      /*
       * Removed by Brad Williams. Cat id no longer needs to be unique
       * 
      l_sql = "SELECT itemid " + "FROM item " + "WHERE catalogueid IS NOT NULL AND catalogueid != '' AND catalogueid = '";

      //run this sql to make sure we are not trying to insert a item that already has a copy
      // i.e only one copy allowed per item
      if (m_is_copy == true)
        l_sql += m_db.plSqlSafeString("Copy of " + m_catalogueid) + "'";
      else //check we are not inserting a new item with the same catalogue id
        l_sql += m_db.plSqlSafeString(m_catalogueid) + "'";

      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      if (!l_rs.next()) {
    	  */
        if (m_item_description.length() > 1000)
          m_item_description = m_item_description.substring(0, 999);
        if (m_storage.length() > 250)
          m_storage = m_storage.substring(0, 249);
        if (m_detail_comments.length() > 2048)
          m_detail_comments = m_detail_comments.substring(0, 2047);
        if (m_provenance.length() > 250)
          m_provenance = m_provenance.substring(0, 249);
        if (m_significance.length() > 250)
          m_significance = m_significance.substring(0, 249);
        if (m_comments.length() > 2048)
          m_comments = m_comments.substring(0, 2047);
        if (m_item_url.length() > 2048)
          m_item_url = m_item_url.substring(0, 2047);

        // CR0001
        if (m_description_abstract.length() > 4000)
          m_description_abstract = m_description_abstract.substring(0, 3999);
        if (m_format_extent.length() > 60)
          m_format_extent = m_format_extent.substring(0, 59);
        if (m_format_medium.length() > 60)
          m_format_medium = m_format_medium.substring(0, 59);
        if (m_format_mimetype.length() > 60)
          m_format_mimetype = m_format_mimetype.substring(0, 59);
        if (m_format.length() > 60)
          m_format = m_format.substring(0, 59);
        if (m_ident_isbn.length() > 60)
          m_ident_isbn = m_ident_isbn.substring(0, 59);
        if (m_ident_ismn.length() > 60)
          m_ident_ismn = m_ident_ismn.substring(0, 59);
        if (m_ident_issn.length() > 60)
          m_ident_issn = m_ident_issn.substring(0, 59);
        if (m_ident_sici.length() > 60)
          m_ident_sici = m_ident_sici.substring(0, 59);
        if (m_publisher.length() > 60)
          m_publisher = m_publisher.substring(0, 59);
        if (m_rights_access_rights.length() > 60)
          m_rights_access_rights = m_rights_access_rights.substring(0, 59);
        if (m_rights.length() > 300)
          m_rights = m_rights.substring(0, 299);
        if (m_rights_holder.length() > 60)
          m_rights_holder = m_rights_holder.substring(0, 59);
        if (m_title.length() > 300)
          m_title = m_title.substring(0, 299);
        if (m_title_alternative.length() > 300)
          m_title_alternative = m_title_alternative.substring(0, 299);
        if (m_dc_creator.length() > 300)
          m_dc_creator = m_dc_creator.substring(0, 299);

        if (m_date_notes.length() > 300)
          m_date_notes = m_date_notes.substring(0, 299);
        if (m_publisher_location.length() > 300)
          m_publisher_location = m_publisher_location.substring(0, 299);
        if (m_volume.length() > 60)
          m_volume = m_volume.substring(0, 59);
        if (m_issue.length() > 60)
          m_issue = m_issue.substring(0, 59);
        if (m_page.length() > 60)
          m_page = m_page.substring(0, 59);


        /***************************
        * DEAL WITH Create DATE
        ***************************/
        if (m_ddCreate_date.equals("") && m_mmCreate_date.equals("") && 
            m_yyyyCreate_date.equals("")) {
          // no date specified
          l_create_date = "null";
        } else if (m_ddCreate_date.equals("") && !m_mmCreate_date.equals("") && 
                   !m_yyyyCreate_date.equals("")) {
          // month and year were filled in
          l_create_date = 
              m_db.safeDateFormat("01/" + m_mmCreate_date + "/" + m_yyyyCreate_date);
        } else if (m_ddCreate_date.equals("") && m_mmCreate_date.equals("") && 
                   !m_yyyyCreate_date.equals("")) {
          // just year is filled in
          l_create_date = m_db.safeDateFormat("01/01/" + m_yyyyCreate_date);
        } else {
          // all fields in the this date were filled in
          l_create_date = m_db.safeDateFormat(m_create_date, false);
        }
        if (l_create_date.equals("")) {
          l_create_date = "null";
        }

        /***************************
        * DEAL WITH Copyright DATE
        ***************************/
        if (m_ddCopyright_date.equals("") && m_mmCopyright_date.equals("") && 
            m_yyyyCopyright_date.equals("")) {
          // no date specified
          l_copyright_date = "null";
        } else if (m_ddCopyright_date.equals("") && 
                   !m_mmCopyright_date.equals("") && 
                   !m_yyyyCopyright_date.equals("")) {
          // month and year were filled in
          l_copyright_date = 
              m_db.safeDateFormat("01/" + m_mmCopyright_date + "/" + 
                                  m_yyyyCopyright_date);
        } else if (m_ddCopyright_date.equals("") && 
                   m_mmCopyright_date.equals("") && 
                   !m_yyyyCopyright_date.equals("")) {
          // just year is filled in
          l_copyright_date = 
              m_db.safeDateFormat("01/01/" + m_yyyyCopyright_date);
        } else {
          // all fields in the this date were filled in
          l_copyright_date = m_db.safeDateFormat(m_copyright_date, false);
        }
        if (l_copyright_date.equals("")) {
          l_copyright_date = "null";
        }

        /***************************
        * DEAL WITH Issued DATE
        ***************************/
        if (m_ddIssued_date.equals("") && m_mmIssued_date.equals("") && 
            m_yyyyIssued_date.equals("")) {
          // no date specified
          l_issued_date = "null";
        } else if (m_ddIssued_date.equals("") && !m_mmIssued_date.equals("") && 
                   !m_yyyyIssued_date.equals("")) {
          // month and year were filled in
          l_issued_date = 
              m_db.safeDateFormat("01/" + m_mmIssued_date + "/" + m_yyyyIssued_date);
        } else if (m_ddIssued_date.equals("") && m_mmIssued_date.equals("") && 
                   !m_yyyyIssued_date.equals("")) {
          // just year is filled in
          l_issued_date = m_db.safeDateFormat("01/01/" + m_yyyyIssued_date);
        } else {
          // all fields in the this date were filled in
          l_issued_date = m_db.safeDateFormat(m_issued_date, false);
        }
        if (l_issued_date.equals("")) {
          l_issued_date = "null";
        }

        /***************************
        * DEAL WITH Accessioned DATE
        ***************************/
        if (m_ddAccessioned_date.equals("") && 
            m_mmAccessioned_date.equals("") && 
            m_yyyyAccessioned_date.equals("")) {
          // no date specified
          l_accessioned_date = "null";
        } else if (m_ddAccessioned_date.equals("") && 
                   !m_mmAccessioned_date.equals("") && 
                   !m_yyyyAccessioned_date.equals("")) {
          // month and year were filled in
          l_accessioned_date = 
              m_db.safeDateFormat("01/" + m_mmAccessioned_date + "/" + 
                                  m_yyyyAccessioned_date);
        } else if (m_ddAccessioned_date.equals("") && 
                   m_mmAccessioned_date.equals("") && 
                   !m_yyyyAccessioned_date.equals("")) {
          // just year is filled in
          l_accessioned_date = 
              m_db.safeDateFormat("01/01/" + m_yyyyAccessioned_date);
        } else {
          // all fields in the this date were filled in
          l_accessioned_date = m_db.safeDateFormat(m_accessioned_date, false);
        }
        if (l_accessioned_date.equals("")) {
          l_accessioned_date = "null";
        }
        
        
        
        /***************************
        * DEAL WITH Terminated DATE
        ***************************/
        if (m_ddTerminated_date.equals("") && 
            m_mmTerminated_date.equals("") && 
            m_yyyyTerminated_date.equals("")) {
          // no date specified
          l_terminated_date = "null";
        } else if (m_ddTerminated_date.equals("") && 
                   !m_mmTerminated_date.equals("") && 
                   !m_yyyyTerminated_date.equals("")) {
          // month and year were filled in
          l_terminated_date = 
              m_db.safeDateFormat("01/" + m_mmTerminated_date + "/" + 
                                  m_yyyyTerminated_date);
        } else if (m_ddTerminated_date.equals("") && 
                   m_mmTerminated_date.equals("") && 
                   !m_yyyyTerminated_date.equals("")) {
          // just year is filled in
          l_terminated_date = 
              m_db.safeDateFormat("01/01/" + m_yyyyTerminated_date);
        } else {
          // all fields in the this date were filled in
          l_terminated_date = m_db.safeDateFormat(m_terminated_date, false);
        }
        if (l_terminated_date.equals("")) {
          l_terminated_date = "null";
        }


        if (m_institutionid.equals("")) {
          // no m_institutionid specified
          m_institutionid = "null";
        }
        if (m_item_language.equals("")) {
          // no m_item_language specified
          m_item_language = "null";
        }
        if (m_item_condition_id.equals("")) {
          // no m_item_condition_id specified
          m_item_condition_id = "null";
        }

        l_sql = 
            "INSERT INTO item (CATALOGUEID, INSTITUTIONID, ITEM_TYPE_LOV_ID, ITEM_SUB_TYPE_LOV_ID, LANGUAGE_LOV_ID, " + 
            "ITEM_DESCRIPTION, ITEM_CONDITION_ID, DETAIL_COMMENTS, " + 
            "DONATED_PURCHASED, AQUIRED_FROM, STORAGE, PROVENANCE, " + 
            "SIGNIFICANCE, COMMENTS, ENTERED_BY_USER, ENTERED_DATE, ITEM_URL, " + 
            "description_abstract, format_extent, format_medium, format_mimetype, " + 
            "format, ident_isbn, ident_ismn, ident_issn, " + 
            "ident_sici, publisher, rights_access_rights, rights, rights_holder, " + 
            "title, title_alternative, dc_creator, " + 
            "ddcreated_date, mmcreated_date, yyyycreated_date, created_date, " + 
            "ddcopyright_date, mmcopyright_date, yyyycopyright_date, copyright_date, " + 
            "ddissued_date, mmissued_date, yyyyissued_date, issued_date, " + 
            "ddaccessioned_date, mmaccessioned_date, yyyyaccessioned_date, accessioned_date, " + 
            "ddterminated_date, mmterminated_date, yyyyterminated_date, terminated_date, " +
            " sourceid,date_notes,publisher_location,volume,issue,page" + 
            ") " + "VALUES (";
        if (m_is_copy == true) {
          m_title = "Copy of " + m_title;
        }

        if (m_sourceid.equals("")) {
          // no m_sourceid specified
          m_sourceid = "null";
        }


        l_sql += 
            "'" + m_db.plSqlSafeString(m_catalogueid) + "', " + m_institutionid + 
            ", " + m_item_type + ", " + m_item_sub_type + ", " + 
            m_item_language + ", " + "'" + 
            m_db.plSqlSafeString(m_item_description) + "', " + 
            m_item_condition_id + ", " + "'" + 
            m_db.plSqlSafeString(m_detail_comments) + "', '" + 
            m_db.plSqlSafeString(m_donated_purchased) + "', '" + 
            m_db.plSqlSafeString(m_aquired_from) + "', '" + 
            m_db.plSqlSafeString(m_storage) + "', '" + 
            m_db.plSqlSafeString(m_provenance) + "', '" + 
            m_db.plSqlSafeString(m_significance) + "', '" + 
            m_db.plSqlSafeString(m_comments) + "', '" + 
            m_db.plSqlSafeString(m_entered_by_user) + "', " + l_entered_date + 
            ", '" + m_db.plSqlSafeString(m_item_url) + "' " + ", '" + 
            m_db.plSqlSafeString(m_description_abstract) + "' " + ", '" + 
            m_db.plSqlSafeString(m_format_extent) + "' " + ", '" + 
            m_db.plSqlSafeString(m_format_medium) + "' " + ", '" + 
            m_db.plSqlSafeString(m_format_mimetype) + "' " + ", '" + 
            m_db.plSqlSafeString(m_format) + "' " + ", '" + 
            m_db.plSqlSafeString(m_ident_isbn) + "' " + ", '" + 
            m_db.plSqlSafeString(m_ident_ismn) + "' " + ", '" + 
            m_db.plSqlSafeString(m_ident_issn) + "' " + ", '" + 
            m_db.plSqlSafeString(m_ident_sici) + "' " + ", '" + 
            m_db.plSqlSafeString(m_publisher) + "' " + ", '" + 
            m_db.plSqlSafeString(m_rights_access_rights) + "' " + ", '" + 
            m_db.plSqlSafeString(m_rights) + "' " + ", '" + 
            m_db.plSqlSafeString(m_rights_holder) + "' " + ", '" + 
            m_db.plSqlSafeString(m_title) + "' " + ", '" + 
            m_db.plSqlSafeString(m_title_alternative) + "' " + ", '" + 
            m_db.plSqlSafeString(m_dc_creator) + "' " + ", '" + 
            m_ddCreate_date + "' " + ", '" + m_mmCreate_date + "' " + ", '" + 
            m_yyyyCreate_date + "' " + ",  " + l_create_date + " " + ", '" + 
            m_ddCopyright_date + "' " + ", '" + m_mmCopyright_date + "' " + 
            ", '" + m_yyyyCopyright_date + "' " + ",  " + l_copyright_date + 
            " " + ", '" + m_ddIssued_date + "' " + ", '" + m_mmIssued_date + 
            "' " + ", '" + m_yyyyIssued_date + "' " + ",  " + l_issued_date + 
            " " + ", '" + m_ddAccessioned_date + "' " + ", '" + 
            m_mmAccessioned_date + "' " + ", '" + m_yyyyAccessioned_date + 
            "' " + ",  " + l_accessioned_date +
            " " + ", '" + m_ddTerminated_date + "' " + ", '" + 
            m_mmTerminated_date + "' " + ", '" + m_yyyyTerminated_date + 
            "' " + ",  " + l_terminated_date +
            ", " + m_sourceid + " " + 
            ", '" + m_db.plSqlSafeString(m_date_notes) + "' " + ", '" + 
            m_db.plSqlSafeString(m_publisher_location) + "' " + ", '" + 
            m_db.plSqlSafeString(m_volume) + "' " + ", '" + 
            m_db.plSqlSafeString(m_issue) + "' " + ", '" + 
            m_db.plSqlSafeString(m_page) + "' " + ")";
        m_db.runSQLResultSet(l_sql, stmt);


        /*************************************************************
            We need to insert all the links as well for the new item.
            First we need to get the id of the item inserted above.
        ***************************************************************/
        l_item_id = m_db.getInsertedIndexValue(stmt, "ITEMID_SEQ");
        m_itemid = l_item_id;
        if (!l_item_id.equals("")) {
          //insert into the itemevlinks table
          for (int i = 0; i < m_item_evlinks.size(); i++) {
            l_sql = 
                "INSERT INTO itemevlink (ITEMID, EVENTID) " + "VALUES (" + l_item_id + 
                "," + m_item_evlinks.elementAt(i) + ")";
            m_db.runSQLResultSet(l_sql, stmt);
          }
          //insert into the itemcontentindlinks table
          for (int i = 0; i < m_item_contentindlinks.size(); i++) {
            l_sql = 
                "INSERT INTO itemcontentindlink (ITEMID, CONTENTINDICATORID) " + 
                "VALUES (" + l_item_id + "," + 
                m_item_contentindlinks.elementAt(i) + " )";
            m_db.runSQLResultSet(l_sql, stmt);
          }

          for (int i = 0; i < m_item_secgenrelinks.size(); i++) {
            l_sql = 
                "INSERT INTO itemsecgenrelink (ITEMID, SECGENREPREFERREDID) " + 
                "VALUES (" + l_item_id + "," + 
                m_item_secgenrelinks.elementAt(i) + ")";
            m_db.runSQLResultSet(l_sql, stmt);
          }
          for (int i = 0; i < m_item_workslinks.size(); i++) {
            l_sql = 
                "INSERT INTO itemworklink (ITEMID, WORKID) " + "VALUES (" + l_item_id + 
                "," + m_item_workslinks.elementAt(i) + ")";
            m_db.runSQLResultSet(l_sql, stmt);
          }
          //BW additional URLS
          for (int i = 0; i < m_additional_urls.size(); i++) {
              l_sql = 
                  "INSERT INTO item_url (ITEMID, URL) " + "VALUES (" + l_item_id + 
                  ",'" + m_db.plSqlSafeString((String)m_additional_urls.elementAt(i)) + "')";
              m_db.runSQLResultSet(l_sql, stmt);
            }
          
          for (int i = 0; i < m_item_itemlinks.size(); i++) {
            ItemItemLink itemItemLink = m_item_itemlinks.elementAt(i);
            l_sql = 
                "INSERT INTO itemitemlink (ITEMID, CHILDID, RELATIONLOOKUPID, NOTES, CHILDNOTES) " + 
                "VALUES (" + itemItemLink.getItemId() + "," + itemItemLink.getChildId() + 
                ", " + itemItemLink.getRelationLookupId() + ", '" + 
                m_db.plSqlSafeString(itemItemLink.getNotes()) + "','" +
                m_db.plSqlSafeString(itemItemLink.getChildNotes()) + "')";
            m_db.runSQLResultSet(l_sql, stmt);
          }
          //insert into the itemconlinks table
          for (int i = 0; i < m_item_conlinks.size(); i++) {
            ItemContribLink itemContribLink = 
              (ItemContribLink)m_item_conlinks.elementAt(i);
            l_sql = 
                "INSERT INTO itemconlink (ITEMID, CONTRIBUTORID, CREATOR_FLAG, ORDERBY) " + 
                "VALUES (" + l_item_id + "," + itemContribLink.getContribId() + 
                ",'N', " + m_db.plSqlSafeString(itemContribLink.getOrderBy()) + 
                ")";
            m_db.runSQLResultSet(l_sql, stmt);
          }
          //insert into the itemconlinks table
          for (int i = 0; i < m_item_creator_conlinks.size(); i++) {
            ItemContribLink itemContribLink = 
              (ItemContribLink)m_item_creator_conlinks.elementAt(i);
            String tempFunctionId = itemContribLink.getFunctionId();
            if (tempFunctionId.equals("0")) {
              tempFunctionId = "null";
            }
            l_sql = 
                "INSERT INTO itemconlink (ITEMID, CONTRIBUTORID,CREATOR_FLAG, ORDERBY, FUNCTION_LOV_ID) " + 
                "VALUES (" + l_item_id + "," + itemContribLink.getContribId() + 
                ",'Y' , " + 
                m_db.plSqlSafeString(itemContribLink.getOrderBy()) + ", " + 
                tempFunctionId + ")";
            m_db.runSQLResultSet(l_sql, stmt);
          }
          //insert into the itemvenuelinks table
          for (int i = 0; i < m_item_venuelinks.size(); i++) {
            l_sql = 
                "INSERT INTO itemvenuelink (ITEMID, VENUEID) " + "VALUES (" + 
                l_item_id + "," + m_item_venuelinks.elementAt(i) + ")";
            m_db.runSQLResultSet(l_sql, stmt);
          }
          //insert into the itemorglinks table
          for (int i = 0; i < m_item_orglinks.size(); i++) {
            ItemOrganLink itemOrganLink = 
              (ItemOrganLink)m_item_orglinks.elementAt(i);
            l_sql = 
                "INSERT INTO itemorglink (ITEMID, ORGANISATIONID,CREATOR_FLAG,ORDERBY) " + 
                "VALUES (" + l_item_id + "," + 
                itemOrganLink.getOrganisationId() + ",'N' , " + 
                m_db.plSqlSafeString(itemOrganLink.getOrderBy()) + ")";
            m_db.runSQLResultSet(l_sql, stmt);
          }
          //insert into the itemorglinks table
          for (int i = 0; i < m_item_creator_orglinks.size(); i++) {
            ItemOrganLink itemOrganLink = 
              (ItemOrganLink)m_item_creator_orglinks.elementAt(i);
            String tempFunctionId = itemOrganLink.getFunctionId();
            if (tempFunctionId.equals("0")) {
              tempFunctionId = "null";
            }
            l_sql = 
                "INSERT INTO itemorglink (ITEMID, ORGANISATIONID,CREATOR_FLAG,ORDERBY, FUNCTION_LOV_ID) " + 
                "VALUES (" + l_item_id + "," + 
                itemOrganLink.getOrganisationId() + ",'Y' , " + 
                m_db.plSqlSafeString(itemOrganLink.getOrderBy()) + ", " + 
                tempFunctionId + ")";
            m_db.runSQLResultSet(l_sql, stmt);
          }
        }

        // Update the citation field LAST
        m_citation = this.getNewCitation(l_item_id);

        l_sql = 
            "UPDATE item set citation='" + m_db.plSqlSafeString(m_citation) + 
            "' where itemid=" + l_item_id;
        m_db.runSQLResultSet(l_sql, stmt);

        l_ret = true;
     /*
      * Removed by Brad Williams - cat id no longer needs to be null.
      *  
      *  } else { // a copy of this item already exist
        setErrorMessage("Unable to add the resource. An item with this <b>catalogue id</b> already exists");
        l_ret = false; 
      }
*/
      stmt.close();

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in Item.addItem().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      setErrorMessage("Unable to add the resource. Please ensure all mandatory fields (*) are filled in.");
      l_ret = false;
    }
    return l_ret;
  }

  /*
  Name: updateItem ()

  Purpose: update the changed Item to the database.

  Parameters:
     None

  Returns:
     boolean true or false to represent success

  */

  public boolean updateItem() {

    String l_sql = "";
    boolean l_ret = false;
    ResultSet l_rs = null;
    boolean l_cat_id_exists = false;
    String l_create_date = null;
    String l_copyright_date = null;
    String l_issued_date = null;
    String l_accessioned_date = null;
    String l_terminated_date = null;

    try {
      Statement stmt = m_db.m_conn.createStatement();
      //first make sure we are not updating a item with catalogue id
      //that already exists in the database.
      /*
       * removed by Brad Williams. Cat Id no longer needs to be unique
      l_sql = 
          "SELECT itemid " + "FROM item " + "WHERE (itemid !=" + m_itemid + ") " + 
          "AND catalogueid='" + m_catalogueid + "'";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      if (l_rs.next()) // get the current catalogue id of the item.
        l_cat_id_exists = true;

      if (!l_cat_id_exists) {
      */
        //make sure that we are not inserting data too large for the table column
        if (m_item_description.length() > 1000)
          m_item_description = m_item_description.substring(0, 999);
        if (m_storage.length() > 250)
          m_storage = m_storage.substring(0, 249);
        if (m_detail_comments.length() > 2048)
          m_detail_comments = m_detail_comments.substring(0, 2047);
        if (m_provenance.length() > 250)
          m_provenance = m_provenance.substring(0, 249);
        if (m_significance.length() > 250)
          m_significance = m_significance.substring(0, 249);
        if (m_comments.length() > 2048)
          m_comments = m_comments.substring(0, 2047);
        if (m_item_url.length() > 2048)
          m_item_url = m_item_url.substring(0, 2047);

        // CR0001
        if (m_description_abstract.length() > 4000)
          m_description_abstract = m_description_abstract.substring(0, 3999);
        if (m_format_extent.length() > 60)
          m_format_extent = m_format_extent.substring(0, 59);
        if (m_format_medium.length() > 60)
          m_format_medium = m_format_medium.substring(0, 59);
        if (m_format_mimetype.length() > 60)
          m_format_mimetype = m_format_mimetype.substring(0, 59);
        if (m_format.length() > 60)
          m_format = m_format.substring(0, 59);
        if (m_ident_isbn.length() > 60)
          m_ident_isbn = m_ident_isbn.substring(0, 59);
        if (m_ident_ismn.length() > 60)
          m_ident_ismn = m_ident_ismn.substring(0, 59);
        if (m_ident_issn.length() > 60)
          m_ident_issn = m_ident_issn.substring(0, 59);
        if (m_ident_sici.length() > 60)
          m_ident_sici = m_ident_sici.substring(0, 59);
        if (m_publisher.length() > 60)
          m_publisher = m_publisher.substring(0, 59);
        if (m_rights_access_rights.length() > 60)
          m_rights_access_rights = m_rights_access_rights.substring(0, 59);
        if (m_rights.length() > 300)
          m_rights = m_rights.substring(0, 299);
        if (m_rights_holder.length() > 60)
          m_rights_holder = m_rights_holder.substring(0, 59);
        if (m_title.length() > 300)
          m_title = m_title.substring(0, 299);
        if (m_title_alternative.length() > 300)
          m_title_alternative = m_title_alternative.substring(0, 299);
        if (m_dc_creator.length() > 300)
          m_dc_creator = m_dc_creator.substring(0, 299);

        if (m_date_notes.length() > 300)
          m_date_notes = m_date_notes.substring(0, 299);
        if (m_publisher_location.length() > 300)
          m_publisher_location = m_publisher_location.substring(0, 299);
        if (m_volume.length() > 60)
          m_volume = m_volume.substring(0, 59);
        if (m_issue.length() > 60)
          m_issue = m_issue.substring(0, 59);
        if (m_page.length() > 60)
          m_page = m_page.substring(0, 59);


        /***************************
        * DEAL WITH Create DATE
        ***************************/
        if (m_ddCreate_date.equals("") && m_mmCreate_date.equals("") && 
            m_yyyyCreate_date.equals("")) {
          // no date specified
          l_create_date = "null";
        } else if (m_ddCreate_date.equals("") && !m_mmCreate_date.equals("") && 
                   !m_yyyyCreate_date.equals("")) {
          // month and year were filled in
          l_create_date = 
              m_db.safeDateFormat("01/" + m_mmCreate_date + "/" + m_yyyyCreate_date);
        } else if (m_ddCreate_date.equals("") && m_mmCreate_date.equals("") && 
                   !m_yyyyCreate_date.equals("")) {
          // just year is filled in
          l_create_date = m_db.safeDateFormat("01/01/" + m_yyyyCreate_date);
        } else {
          // all fields in the this date were filled in
          l_create_date = m_db.safeDateFormat(m_create_date, false);
        }

        /***************************
        * DEAL WITH Copyright DATE
        ***************************/
        if (m_ddCopyright_date.equals("") && m_mmCopyright_date.equals("") && 
            m_yyyyCopyright_date.equals("")) {
          // no date specified
          l_copyright_date = "null";
        } else if (m_ddCopyright_date.equals("") && 
                   !m_mmCopyright_date.equals("") && 
                   !m_yyyyCopyright_date.equals("")) {
          // month and year were filled in
          l_copyright_date = 
              m_db.safeDateFormat("01/" + m_mmCopyright_date + "/" + 
                                  m_yyyyCopyright_date);
        } else if (m_ddCopyright_date.equals("") && 
                   m_mmCopyright_date.equals("") && 
                   !m_yyyyCopyright_date.equals("")) {
          // just year is filled in
          l_copyright_date = 
              m_db.safeDateFormat("01/01/" + m_yyyyCopyright_date);
        } else {
          // all fields in the this date were filled in
          l_copyright_date = m_db.safeDateFormat(m_copyright_date, false);
        }

        /***************************
        * DEAL WITH Issued DATE
        ***************************/
        if (m_ddIssued_date.equals("") && m_mmIssued_date.equals("") && 
            m_yyyyIssued_date.equals("")) {
          // no date specified
          l_issued_date = "null";
        } else if (m_ddIssued_date.equals("") && !m_mmIssued_date.equals("") && 
                   !m_yyyyIssued_date.equals("")) {
          // month and year were filled in
          l_issued_date = 
              m_db.safeDateFormat("01/" + m_mmIssued_date + "/" + m_yyyyIssued_date);
        } else if (m_ddIssued_date.equals("") && m_mmIssued_date.equals("") && 
                   !m_yyyyIssued_date.equals("")) {
          // just year is filled in
          l_issued_date = m_db.safeDateFormat("01/01/" + m_yyyyIssued_date);
        } else {
          // all fields in the this date were filled in
          l_issued_date = m_db.safeDateFormat(m_issued_date, false);
        }

        /***************************
        * DEAL WITH Accessioned DATE
        ***************************/
        if (m_ddAccessioned_date.equals("") && 
            m_mmAccessioned_date.equals("") && 
            m_yyyyAccessioned_date.equals("")) {
          // no date specified
          l_accessioned_date = "null";
        } else if (m_ddAccessioned_date.equals("") && 
                   !m_mmAccessioned_date.equals("") && 
                   !m_yyyyAccessioned_date.equals("")) {
          // month and year were filled in
          l_accessioned_date = 
              m_db.safeDateFormat("01/" + m_mmAccessioned_date + "/" + 
                                  m_yyyyAccessioned_date);
        } else if (m_ddAccessioned_date.equals("") && 
                   m_mmAccessioned_date.equals("") && 
                   !m_yyyyAccessioned_date.equals("")) {
          // just year is filled in
          l_accessioned_date = 
              m_db.safeDateFormat("01/01/" + m_yyyyAccessioned_date);
        } else {
          // all fields in the this date were filled in
          l_accessioned_date = m_db.safeDateFormat(m_accessioned_date, false);
        }
        
        
        /***************************
        * DEAL WITH Terminated DATE
        ***************************/
        if (m_ddTerminated_date.equals("") && 
            m_mmTerminated_date.equals("") && 
            m_yyyyTerminated_date.equals("")) {
          // no date specified
          l_terminated_date = "null";
        } else if (m_ddTerminated_date.equals("") && 
                   !m_mmTerminated_date.equals("") && 
                   !m_yyyyTerminated_date.equals("")) {
          // month and year were filled in
          l_terminated_date = 
              m_db.safeDateFormat("01/" + m_mmTerminated_date + "/" + 
                                  m_yyyyTerminated_date);
        } else if (m_ddTerminated_date.equals("") && 
                   m_mmTerminated_date.equals("") && 
                   !m_yyyyTerminated_date.equals("")) {
          // just year is filled in
          l_terminated_date = 
              m_db.safeDateFormat("01/01/" + m_yyyyTerminated_date);
        } else {
          // all fields in the this date were filled in
          l_terminated_date = m_db.safeDateFormat(m_terminated_date, false);
        }
        
        

        if (m_institutionid.equals("")) {
          // no m_institutionid specified
          m_institutionid = "null";
        }

        if (m_sourceid.equals("")) {
          // no m_sourceid specified
          m_sourceid = "null";
        }

        l_sql = "UPDATE item SET ";
        if (m_catalogueid != null)
          l_sql += 
              "CATALOGUEID='" + m_db.plSqlSafeString(m_catalogueid) + "',";
        if (m_sourceid != null && !m_sourceid.equals(""))
          l_sql += "SOURCEID=" + m_sourceid + ",";
        if (m_institutionid != null && !m_institutionid.equals(""))
          l_sql += "INSTITUTIONID=" + m_institutionid + ",";
        if (m_item_type != null && !m_item_type.equals(""))
          l_sql += "ITEM_TYPE_LOV_ID=" + m_item_type + ",";
        if (m_item_sub_type != null && !m_item_sub_type.equals(""))
          l_sql += "ITEM_SUB_TYPE_LOV_ID=" + m_item_sub_type + ",";
        if (m_item_language != null && !m_item_language.equals(""))
          l_sql += "LANGUAGE_LOV_ID=" + m_item_language + ",";
        if (m_item_description != null)
          l_sql += 
              "ITEM_DESCRIPTION='" + m_db.plSqlSafeString(m_item_description) + 
              "',";
        if (m_item_condition_id != null && !m_item_condition_id.equals(""))
          l_sql += "ITEM_CONDITION_ID=" + m_item_condition_id + ",";
        if (m_detail_comments != null)
          l_sql += 
              "DETAIL_COMMENTS='" + m_db.plSqlSafeString(m_detail_comments) + 
              "',";
        if (m_donated_purchased != null && !m_donated_purchased.equals(""))
          l_sql += "DONATED_PURCHASED=" + m_donated_purchased + ",";
        if (m_aquired_from != null)
          l_sql += 
              "AQUIRED_FROM='" + m_db.plSqlSafeString(m_aquired_from) + "',";
        if (m_storage != null)
          l_sql += "STORAGE='" + m_db.plSqlSafeString(m_storage) + "',";
        if (m_provenance != null)
          l_sql += "PROVENANCE='" + m_db.plSqlSafeString(m_provenance) + "',";
        if (m_significance != null)
          l_sql += 
              "SIGNIFICANCE='" + m_db.plSqlSafeString(m_significance) + "',";
        if (m_comments != null)
          l_sql += "COMMENTS='" + m_db.plSqlSafeString(m_comments) + "',";
        if (m_item_url != null)
          l_sql += "ITEM_URL='" + m_db.plSqlSafeString(m_item_url) + "',";
        //if(m_entered_by_user != null && !m_entered_by_user.equals(""))
        //l_sql += "ENTERED_BY_USER='" + m_db.plSqlSafeString(m_entered_by_user) + "', ";
        if (m_updated_date != null)
          l_sql += 
              "UPDATED_DATE=" + m_db.safeDateFormat(m_updated_date) + ", ";

        // CR0001
        if (m_description_abstract != null)
          l_sql += 
              "description_abstract='" + m_db.plSqlSafeString(m_description_abstract) + 
              "',";
        if (m_format_extent != null)
          l_sql += 
              "format_extent='" + m_db.plSqlSafeString(m_format_extent) + "',";
        if (m_format_medium != null)
          l_sql += 
              "format_medium='" + m_db.plSqlSafeString(m_format_medium) + "',";
        if (m_format_mimetype != null)
          l_sql += 
              "format_mimetype='" + m_db.plSqlSafeString(m_format_mimetype) + 
              "',";
        if (m_format != null)
          l_sql += "format='" + m_db.plSqlSafeString(m_format) + "',";
        if (m_ident_isbn != null)
          l_sql += "ident_isbn='" + m_db.plSqlSafeString(m_ident_isbn) + "',";
        if (m_ident_ismn != null)
          l_sql += "ident_ismn='" + m_db.plSqlSafeString(m_ident_ismn) + "',";
        if (m_ident_issn != null)
          l_sql += "ident_issn='" + m_db.plSqlSafeString(m_ident_issn) + "',";
        if (m_ident_sici != null)
          l_sql += "ident_sici='" + m_db.plSqlSafeString(m_ident_sici) + "',";
        if (m_publisher != null)
          l_sql += "publisher='" + m_db.plSqlSafeString(m_publisher) + "',";
        if (m_rights_access_rights != null)
          l_sql += 
              "rights_access_rights='" + m_db.plSqlSafeString(m_rights_access_rights) + 
              "',";
        if (m_rights != null)
          l_sql += "rights='" + m_db.plSqlSafeString(m_rights) + "',";
        if (m_rights_holder != null)
          l_sql += 
              "rights_holder='" + m_db.plSqlSafeString(m_rights_holder) + "',";
        if (m_title != null)
          l_sql += "title='" + m_db.plSqlSafeString(m_title) + "',";
        if (m_title_alternative != null)
          l_sql += 
              "title_alternative='" + m_db.plSqlSafeString(m_title_alternative) + 
              "',";
        if (m_dc_creator != null)
          l_sql += "dc_creator='" + m_db.plSqlSafeString(m_dc_creator) + "', ";
        //TIR032 
        if (m_date_notes != null)
          l_sql += "date_notes='" + m_db.plSqlSafeString(m_date_notes) + "', ";
        if (m_publisher_location != null)
          l_sql += 
              "publisher_location='" + m_db.plSqlSafeString(m_publisher_location) + 
              "', ";
        if (m_volume != null)
          l_sql += "volume='" + m_db.plSqlSafeString(m_volume) + "', ";
        if (m_issue != null)
          l_sql += "issue='" + m_db.plSqlSafeString(m_issue) + "', ";
        if (m_page != null)
          l_sql += "page='" + m_db.plSqlSafeString(m_page) + "', ";


        l_sql += "ddCreated_date = '" + m_ddCreate_date + "', ";
        l_sql += "mmCreated_date = '" + m_mmCreate_date + "', ";
        l_sql += "yyyyCreated_date = '" + m_yyyyCreate_date + "', ";
        l_sql += "created_date = " + l_create_date + " ,";

        l_sql += " ddCopyright_date = '" + m_ddCopyright_date + "' ,";
        l_sql += " mmCopyright_date = '" + m_mmCopyright_date + "' ,";
        l_sql += " yyyyCopyright_date = '" + m_yyyyCopyright_date + "' ,";
        l_sql += " copyright_date = " + l_copyright_date + " ,";

        l_sql += " ddIssued_date = '" + m_ddIssued_date + "' ,";
        l_sql += " mmIssued_date = '" + m_mmIssued_date + "' ,";
        l_sql += " yyyyIssued_date = '" + m_yyyyIssued_date + "' ,";
        l_sql += " issued_date = " + l_issued_date + " ,";

        l_sql += " ddAccessioned_date = '" + m_ddAccessioned_date + "' ,";
        l_sql += " mmAccessioned_date = '" + m_mmAccessioned_date + "' ,";
        l_sql += " yyyyAccessioned_date = '" + m_yyyyAccessioned_date + "' ,";
        l_sql += " accessioned_date = " + l_accessioned_date + " ,";
        
        l_sql += " ddTerminated_date = '" + m_ddTerminated_date + "' ,";
        l_sql += " mmTerminated_date = '" + m_mmTerminated_date + "' ,";
        l_sql += " yyyyTerminated_date = '" + m_yyyyTerminated_date + "' ,";
        l_sql += " terminated_date = " + l_terminated_date + " ,";
        
        l_sql += 
            " modified_by_user = '" + m_db.plSqlSafeString(m_updated_by_user) + 
            "' ,";
        l_sql += " modified_date = sysdate() ";


        if (m_itemid != null)
          l_sql += "WHERE ITEMID=" + m_itemid + " ";
       // System.out.println("Update Item: " + l_sql);
        m_db.runSQLResultSet(l_sql, stmt);


        //update all the item link tables
        //For each event id in the vector, delete the current links
        //and insert all the new links to reflect the state of the item object.

        l_sql = "DELETE FROM itemevlink WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_item_evlinks.size(); i++) {
          l_sql = 
              "INSERT INTO itemevlink (ITEMID, EVENTID) " + "VALUES (" + m_itemid + 
              "," + m_item_evlinks.elementAt(i) + ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }

        l_sql = "DELETE FROM itemcontentindlink WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_item_contentindlinks.size(); i++) {
          l_sql = 
              "INSERT INTO itemcontentindlink (itemid, contentindicatorid) VALUES (" + 
              m_itemid + "," + m_item_contentindlinks.elementAt(i) + ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }

        l_sql = "DELETE FROM itemsecgenrelink WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_item_secgenrelinks.size(); i++) {
          l_sql = 
              "INSERT INTO itemsecgenrelink (itemid, SECGENREPREFERREDID)VALUES (" + 
              m_itemid + "," + m_item_secgenrelinks.elementAt(i) + ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }
        l_sql = "DELETE FROM itemworklink WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_item_workslinks.size(); i++) {
          l_sql = 
              "INSERT INTO itemworklink (itemid, workid)VALUES (" + m_itemid + 
              "," + m_item_workslinks.elementAt(i) + ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }
        //BW ADDITIONAL URLS
        l_sql = "DELETE FROM item_url WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_additional_urls.size(); i++) {
          l_sql = 
              "INSERT INTO item_url (itemid, url)VALUES (" + m_itemid + 
              ",'" + m_db.plSqlSafeString((String) m_additional_urls.elementAt(i)) + "')";
          m_db.runSQLResultSet(l_sql, stmt);
        }
        

        l_sql = "DELETE FROM itemitemlink WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        l_sql = "DELETE FROM itemitemlink WHERE childid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_item_itemlinks.size(); i++) {
          ItemItemLink itemItemLink = 
            (ItemItemLink)m_item_itemlinks.elementAt(i);
          l_sql = 
              "INSERT INTO itemitemlink (itemid, childid, relationlookupid, NOTES, childnotes) " + 
              "VALUES (" + itemItemLink.getItemId() 
              			+ ", " + itemItemLink.getChildId() 
              			+ ", " + itemItemLink.getRelationLookupId() 
              			+ ", '" + m_db.plSqlSafeString(itemItemLink.getNotes()) + "'"
              			+ ", '" + m_db.plSqlSafeString(itemItemLink.getChildNotes()) + "')";
          m_db.runSQLResultSet(l_sql, stmt);
        }

        //for each contributor id in the vector, delete the current links
        //and insert all the new links to reflect the state of the item object.
        l_sql = "DELETE FROM itemconlink WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_item_conlinks.size(); i++) {
          ItemContribLink itemContribLink = 
            (ItemContribLink)m_item_conlinks.elementAt(i);
          l_sql = 
              "INSERT INTO itemconlink (ITEMID, CONTRIBUTORID, CREATOR_FLAG, ORDERBY) " + 
              "VALUES (" + m_itemid + "," + itemContribLink.getContribId() + 
              ",'N', " + m_db.plSqlSafeString(itemContribLink.getOrderBy()) + 
              ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }

        for (int i = 0; i < m_item_creator_conlinks.size(); i++) {
          ItemContribLink itemContribLink = 
            (ItemContribLink)m_item_creator_conlinks.elementAt(i);
          String tempFunctionId = itemContribLink.getFunctionId();
          if (tempFunctionId.equals("0")) {
            tempFunctionId = "null";
          }
          l_sql = 
              "INSERT INTO itemconlink (itemid, contributorid, CREATOR_FLAG, " + 
              "ORDERBY, FUNCTION_LOV_ID)" + "VALUES (" + m_itemid + "," + 
              itemContribLink.getContribId() + ", 'Y', " + 
              m_db.plSqlSafeString(itemContribLink.getOrderBy()) + ", " + 
              tempFunctionId + ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }

        //for each venue id in the vector, delete the current links
        //and insert all the new links to reflect the state of the item object.
        l_sql = "DELETE FROM itemvenuelink WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_item_venuelinks.size(); i++) {
          l_sql = 
              "INSERT INTO itemvenuelink (itemid, venueid)VALUES (" + m_itemid + 
              "," + m_item_venuelinks.elementAt(i) + ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }

        //for each organisation id in the vector, delete the current links
        //and insert all the new links to reflect the state of the item object.

        l_sql = "DELETE FROM itemorglink WHERE itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        for (int i = 0; i < m_item_orglinks.size(); i++) {
          ItemOrganLink itemOrganLink = 
            (ItemOrganLink)m_item_orglinks.elementAt(i);
          l_sql = 
              "INSERT INTO itemorglink (ITEMID, ORGANISATIONID,CREATOR_FLAG,ORDERBY) " + 
              "VALUES (" + m_itemid + "," + itemOrganLink.getOrganisationId() + 
              ",'N' , " + m_db.plSqlSafeString(itemOrganLink.getOrderBy()) + 
              ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }

        for (int i = 0; i < m_item_creator_orglinks.size(); i++) {
          ItemOrganLink itemOrganLink = 
            (ItemOrganLink)m_item_creator_orglinks.elementAt(i);
          String tempFunctionId = itemOrganLink.getFunctionId();
          if (tempFunctionId.equals("0")) {
            tempFunctionId = "null";
          }
          l_sql = 
              "INSERT INTO itemorglink (ITEMID, ORGANISATIONID,CREATOR_FLAG,ORDERBY, FUNCTION_LOV_ID) " + 
              "VALUES (" + m_itemid + "," + itemOrganLink.getOrganisationId() + 
              ",'Y' , " + m_db.plSqlSafeString(itemOrganLink.getOrderBy()) + 
              ", " + tempFunctionId + ")";
          m_db.runSQLResultSet(l_sql, stmt);
        }

        // Update the citation field LAST
        m_citation = this.getNewCitation(m_itemid);

        l_sql = 
            "UPDATE item set citation='" + m_db.plSqlSafeString(m_citation) + 
            "' where itemid=" + m_itemid;
        m_db.runSQLResultSet(l_sql, stmt);
        l_ret = true;
      
      /* Brad Williams - catalogue id no longer needs to be unique
       * 
       * } else { //we are trying to update a item with a catalogue id that already exists.
        l_ret = false;
        setErrorMessage("Unable to update the resource. You are trying to update a item with a <b>catalogue id</b> that already exists.");
      }*/
      stmt.close();

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in updateItem().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      l_ret = false;
      setErrorMessage("Unable to update the resource.");
    }
    return l_ret;
  }

  public boolean isInUse() {

    CachedRowSet l_rs;
    boolean ret = false;
    String sqlString = "";
    int counter = 0;

    try {

      Statement stmt = m_db.m_conn.createStatement();
      // lets check if a preferred term exist this secondary genre
      sqlString = 
          "select sum(counter) counter from ( select count(*) as counter from itemitemlink " + 
          "where childid=" + m_itemid;
      sqlString += 
          " UNION ALL select count(*) as counter from item " + "where sourceid=" + 
          m_itemid + ") a";
      l_rs = m_db.runSQL(sqlString, stmt);
      l_rs.next();
      counter = l_rs.getInt("counter");

      if (counter >= 1) {
        ret = true; // can't delete item    
      }
      stmt.close();

    } catch (Exception e) {
      System.out.println("An Exception occured in Item.isInUse().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (ret);
  }

  /*
  Name: deleteItem ()

  Purpose: delete a item from the database.

  Parameters:
     None

  Returns:
     boolean true or false to represent success

  */

  public boolean deleteItem() {

    String l_sql = "";
    boolean l_ret = false;

    try {
      Statement stmt = m_db.m_conn.createStatement();
      //need to delete all links as well
      l_sql = "DELETE FROM itemevlink WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);
      l_sql = "DELETE FROM itemitemlink WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);
      l_sql = "DELETE FROM itemitemlink WHERE childid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);
      l_sql = "DELETE FROM itemsecgenrelink WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);
      l_sql = "DELETE FROM itemconlink WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);
      l_sql = "DELETE FROM itemvenuelink WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);
      l_sql = "DELETE FROM itemorglink WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);
      l_sql = "DELETE FROM ITEMCONTENTINDLINK WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);

      l_sql = "DELETE FROM ITEMWORKLINK WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);
      //BW ADDITIONAL URL
      l_sql = "DELETE FROM ITEM_URL WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);

      l_sql = "DELETE FROM item WHERE itemid=" + m_itemid;
      m_db.runSQLResultSet(l_sql, stmt);

      stmt.close();
      l_ret = true;
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in deleteItem().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      l_ret = false;
    }
    return l_ret;
  }


  /* get citation when you insert or update an item*/

  private String getNewCitation(String p_item_id) {
    String l_sql = "";
    ResultSet l_rs = null;
    String l_citation;

    try {
      Statement stmt = m_db.m_conn.createStatement();
      l_sql = "select fn_get_citation( " + p_item_id + ") citation from dual";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);


      if (l_rs.next()) {
        l_citation = l_rs.getString("citation");
      } else {
        l_citation = "";
      }

      l_rs.close();
      stmt.close();
      return l_citation;
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in deleteItem().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return "";
    }


  }
  /*
  Name: loadLinkedEvents ()

  Purpose: Sets the class to a contain the Event information for the
           specified item id.

  Parameters:
    None

  Returns:
     None

  */

  private void loadLinkedEvents() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "SELECT events.eventid, events.event_name, events.first_date, venue.venue_name " + 
          "FROM events, venue, itemevlink, item " + 
          "WHERE item.itemid = itemevlink.itemid " + 
          "AND itemevlink.eventid = events.eventid " + 
          "AND events.venueid = venue.venueid " + 
          "AND item.itemid=" +  m_itemid + " " +
          "ORDER BY first_date desc, event_name"; 
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_evlinks.removeAllElements();

      while (l_rs.next()) {
        m_item_evlinks.addElement(l_rs.getString("eventid"));
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedEvents().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }
  /*
  Name: loadLinkedItems ()

  Purpose: Sets the class to a contain the Child Item information for the
           specified item id.

  Parameters:
    None

  Returns:
     None

  */

  private void loadLinkedItems() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 	" SELECT distinct iil.itemitemlinkid " 
				+ " FROM itemitemlink iil, item p, item child, relation_lookup rl "
				+ " WHERE (iil.itemid = "+m_itemid+"  || iil.childid = "+m_itemid+" ) "
				+ " AND iil.itemid = p.itemid "
				+ " AND iil.childid = child.itemid "
				+ " AND iil.relationlookupid = rl.relationlookupid "
				+ " ORDER BY CASE WHEN iil.childid = "+m_itemid+" THEN rl.child_relation ELSE rl.parent_relation END, "
				+ " CASE WHEN iil.childid = "+m_itemid+" THEN p.issued_date ELSE child.issued_date END ";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_itemlinks.removeAllElements();

      while (l_rs.next()) {
        ItemItemLink itemItemLink = new ItemItemLink(m_db);
        itemItemLink.load(l_rs.getString("ITEMITEMLINKID"));
        m_item_itemlinks.addElement(itemItemLink);
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedItems().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }
  /*
  Name: loadLinkedOrganisations ()

  Purpose: Sets the class to a contain the Organisation information for the
           specified item id. Elements are ordered by the Order By field.

  Parameters:
    None

  Returns:
     None

  */

  private void loadLinkedOrganisations() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "SELECT ITEMORGLINKID " + "FROM organisation, states, itemorglink, item " + 
          "WHERE item.itemid = itemorglink.itemid " + 
          "AND itemorglink.organisationid = organisation.organisationid " + 
          "AND organisation.state = states.stateid " + "AND item.itemid=" + 
          m_itemid + 
          " AND (creator_flag is null or creator_flag = 'N') order by organisation.name asc";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_orglinks.removeAllElements();

      while (l_rs.next()) {
        ItemOrganLink itemOrganLink = new ItemOrganLink(m_db);
        itemOrganLink.load(l_rs.getString("ITEMORGLINKID"), "N");
        m_item_orglinks.addElement(itemOrganLink);
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedOrganisations().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  /*
  Name: loadLinkedCreatorOrganisations ()

  Purpose: Sets the class to a contain the Organisation information for the
          specified item id.

  Parameters:
   None

  Returns:
    None

  */

  private void loadLinkedCreatorOrganisations() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "SELECT ITEMORGLINKID " + "FROM organisation, states, itemorglink, item " + 
          "WHERE item.itemid = itemorglink.itemid " + 
          "AND itemorglink.organisationid = organisation.organisationid " + 
          "AND organisation.state = states.stateid " + "AND item.itemid=" + 
          m_itemid + 
          " AND creator_flag = 'Y' order by organisation.name asc";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_creator_orglinks.removeAllElements();

      while (l_rs.next()) {
        ItemOrganLink itemOrganLink = new ItemOrganLink(m_db);
        itemOrganLink.load(l_rs.getString("ITEMORGLINKID"), "Y");
        m_item_creator_orglinks.addElement(itemOrganLink);  
        //m_item_creator_orglinks.addElement(itemOrganLink.getOrganisationId()); Edited by BW
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedCreatorOrganisations().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }


  /*
  Name: loadLinkedSecGenre ()

  Purpose: Sets the class to a contain the Genre information for the
          specified item id.

  Parameters:
   None

  Returns:
    None

  */

  private void loadLinkedSecGenre() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          " SELECT isl.secgenrepreferredid genreid FROM itemsecgenrelink isl, secgenrepreferred sgp " + 
          " WHERE isl.itemid = " + m_itemid + 
          " AND isl.secgenrepreferredid = sgp.secgenrepreferredid " +
          " ORDER BY sgp.preferredterm ";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_secgenrelinks.removeAllElements();

      while (l_rs.next()) {
        m_item_secgenrelinks.addElement(l_rs.getString("genreid"));
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedSecGenre().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  /*
  Name: loadLinkedWork ()

  Purpose: Sets the class to a contain the Genre information for the
          specified item id.

  Parameters:
   None

  Returns:
    None

  */

  private void loadLinkedWork() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "SELECT iwl.workid  FROM itemworklink iwl, work w WHERE itemid = " + m_itemid +
          " AND iwl.workid = w.workid ORDER BY w.work_title; ";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_workslinks.removeAllElements();

      while (l_rs.next()) {
        m_item_workslinks.addElement(l_rs.getString("workid"));
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedWork().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }
  /*
  Name: loadAdditionalUrls ()

  Purpose: Sets the class to contain the additional Urls for the
          specified item id.

  Parameters:
   None

  Returns:
    None

  */

  private void loadAdditionalUrls() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "SELECT url FROM item_url WHERE itemid = " + m_itemid +";";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_additional_urls.removeAllElements();

      while (l_rs.next()) {
        m_additional_urls.addElement(l_rs.getString("url"));
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedWork().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  
  /*
  Name: loadLinkedVenues ()

  Purpose: Sets the class to a contain the Venue information for the
           specified item id.

  Parameters:
    None

  Returns:
     None

  */

  private void loadLinkedVenues() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "SELECT venue.venueid " + "FROM venue, itemvenuelink, item " + "WHERE item.itemid = itemvenuelink.itemid " + 
          "AND itemvenuelink.venueid = venue.venueid " + "AND item.itemid=" + 
          m_itemid + " ORDER BY venue.venue_name";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_venuelinks.removeAllElements();

      while (l_rs.next()) {
        m_item_venuelinks.addElement(l_rs.getString("venueid"));
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedVenues().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }
  /*
  Name: loadLinkedContributors ()

  Purpose: Sets the class to a contain the Contributors information for the
           specified item id.

  Parameters:
    None

  Returns:
     None

  */

  private void loadLinkedContributors() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "SELECT ITEMCONLINKID " + "FROM contributor, itemconlink, item " + 
          "WHERE item.itemid = itemconlink.itemid " + 
          "AND itemconlink.contributorid = contributor.contributorid " + 
          "AND item.itemid=" + m_itemid + " " + 
          "AND (CREATOR_FLAG != 'Y' OR CREATOR_FLAG is null)  order by contributor.last_name, contributor.first_name";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_conlinks.removeAllElements();

      while (l_rs.next()) {
        ItemContribLink itemContribLink = new ItemContribLink(m_db);
        itemContribLink.load(l_rs.getString("ITEMCONLINKID"), "N");
        m_item_conlinks.addElement(itemContribLink);
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedContributors().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  /*
  Name: loadLinkedCreatorContributors ()

  Purpose: Sets the class to a contain the Contributors information for the
           specified item id.

  Parameters:
    None

  Returns:
     None

  */

  private void loadLinkedCreatorContributors() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "SELECT ITEMCONLINKID " + "FROM contributor, itemconlink, item " + 
          "WHERE item.itemid = itemconlink.itemid " + 
          "AND itemconlink.contributorid = contributor.contributorid " + 
          "AND item.itemid=" + m_itemid + " " + 
          "AND CREATOR_FLAG = 'Y' order by contributor.last_name, contributor.first_name";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_creator_conlinks.removeAllElements();

      while (l_rs.next()) {
        ItemContribLink itemContribLink = new ItemContribLink(m_db);
        itemContribLink.load(l_rs.getString("ITEMCONLINKID"), "Y");
        m_item_creator_conlinks.addElement(itemContribLink);
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedCreatorContributors().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }


  /*
  Name: loadLinkedContentIndicators ()

  Purpose: Sets the class to a contain the Content Indicators information for the
          specified item id.

  Parameters:
   None

  Returns:
    None

  */

  private void loadLinkedContentInd() {
    ResultSet l_rs = null;
    String l_sql = "";

    try {
      Statement stmt = m_db.m_conn.createStatement();

      l_sql = 
          "select c.* " + "from CONTENTINDICATOR c, ITEMCONTENTINDLINK i " + 
          "WHERE c.CONTENTINDICATORID = i.CONTENTINDICATORID " + 
          "AND i.itemid=" + m_itemid + " ORDER BY c.CONTENTINDICATOR";
      l_rs = m_db.runSQLResultSet(l_sql, stmt);
      // Reset the object
      m_item_contentindlinks.removeAllElements();

      while (l_rs.next()) {
        m_item_contentindlinks.addElement(l_rs.getString("contentindicatorid"));
      }
      l_rs.close();
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in loadLinkedContentIndicators().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }


  public ResultSet getInstitutions(Statement p_stmt) {

    String l_sql = "";
    ResultSet l_rs = null;

    try {

      l_sql = 
          "SELECT organisation.name, organisation.organisationid " + "FROM organisation " + 
          "WHERE organisation.organisation_type_id = " + 
          AusstageCommon.INSTITUTION_ID + " " + 
          "order by upper(organisation.name) asc";
      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occurred in item -  getInstitutions().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (l_rs);

  }

  public ResultSet getItemType(Statement p_stmt) {

    String l_sql = "";
    ResultSet l_rs = null;

    try {
      l_sql = 
          "SELECT code_lov_id item_type_id, description item_type " + "FROM lookup_codes " + 
          "WHERE code_type = 'RESOURCE_TYPE' " + 
          "ORDER BY sequence_no, short_code";
      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occurred in item - getItemType().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (l_rs);
  }

  public ResultSet getItemSubTypes(Statement p_stmt, int itemTypeLovId) {

    String l_sql = "";
    ResultSet l_rs = null;

    try {
      l_sql = 
          "SELECT code_lov_id item_sub_type_id, description item_sub_type " + 
          "FROM lookup_codes, code_associations " + 
          "WHERE code_type = 'RESOURCE_SUB_TYPE' " + 
          "AND CODE_1_TYPE = 'RESOURCE_TYPE' " + 
          "AND CODE_2_TYPE = 'RESOURCE_SUB_TYPE' " + "AND CODE_1_LOV_ID = " + 
          itemTypeLovId + " " + 
          "AND lookup_codes.CODE_LOV_ID = code_associations.CODE_2_LOV_ID " + 
          "ORDER BY description, sequence_no, short_code";
      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occurred in item - getItemSubTypes().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (l_rs);
  }

  public ResultSet getCitationByResourceSubType(Statement p_stmt, int itemTypeLovId) {

	    String l_sql = "";
	    ResultSet l_rs = null;
	    
	    try {
	      l_sql = 
	          "SELECT DISTINCT item.citation FROM item " + 
	          "FROM lookup_codes " + "WHERE UPPER(code_type) = 'LANGUAGE' " + 
	          "WHERE lookup_codes.`code_type`='RESOURCE_SUB_TYPE' and lookup_codes.code_lov_id = "+  itemTypeLovId +
	          "order by item.citation";
	      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

	    } catch (Exception e) {
	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
	      System.out.println("An Exception occurred in item - getItemLanguage().");
	      System.out.println("MESSAGE: " + e.getMessage());
	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
	      System.out.println("CLASS.TOSTRING: " + e.toString());
	      System.out.println("sqlString: " + l_sql);
	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
	    }
	    return (l_rs);
	  }
  
  public ResultSet getItemLanguage(Statement p_stmt, String orderBy) {

    String l_sql = "";
    ResultSet l_rs = null;

    try {
      l_sql = 
          "SELECT code_lov_id item_language_id, description item_language, default_flag " + 
          "FROM lookup_codes " + "WHERE UPPER(code_type) = 'LANGUAGE' " + 
          orderBy;
      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occurred in item - getItemLanguage().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (l_rs);
  }

  public ResultSet getItemLanguage(Statement p_stmt) {

    String l_sql = "";
    ResultSet l_rs = null;


    return getItemLanguage(p_stmt, "ORDER BY sequence_no, short_code");
  }


  public ResultSet getItemDonatedPurchased(Statement p_stmt) {

    String l_sql = "";
    ResultSet l_rs = null;

    try {

      l_sql = 
          "SELECT donated_purchased.donated_purchased_id, donated_purchased.donated_purchased FROM donated_purchased";
      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occurred in item - getItemDonatedPurchased().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (l_rs);
  }

  public ResultSet getItemConditions(Statement p_stmt) {

    String l_sql = "";
    ResultSet l_rs = null;

    try {

      l_sql = 
          "SELECT condition.condition_id, condition.condition FROM `condition`";
      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occurred in item - getItemDonatedPurchased().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + l_sql);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (l_rs);
  }

  public String getSourceCitation() {
    return (m_source_citation);
  }

  /*************************************************************************
    this method is used for passing in a vector containing id strings
    of the relevent object. i.e eventids, contributor ids etc.
    It then appends the appropriate display info to the id as a string.
    Such that when used in the displayLinkedItem method from item_addedit.jsp
    it has all the information as a string per element ready to be displayed.
   **************************************************************************/
  public

  Vector generateDisplayInfo(Vector p_ids, String p_id_type, 
                             Statement p_stmt) {
    Vector l_display_info = new Vector();
    String l_info_to_add = "";
    String l_id = "";
    ;

    for (int i = 0; i < p_ids.size(); i++) {
      if (p_id_type.equals("event")) {
        Event event = new Event(m_db);
        //l_info_to_add = (String) m_item_evlinks.elementAt(i) + ", ";
        l_info_to_add = event.getEventInfoForItemDisplay(Integer.parseInt((String)m_item_evlinks.elementAt(i)), p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("contentInd")) {
        ContentIndicator contentInd = new ContentIndicator(m_db);
        l_info_to_add = 
            contentInd.getContentIndInfoForItemDisplay(Integer.parseInt((String)m_item_contentindlinks.elementAt(i)), 
                                                       p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("contributor")) {
        Contributor contributor = new Contributor(m_db);
        int contribId = 
          Integer.parseInt(((ItemContribLink)m_item_conlinks.elementAt(i)).getContribId());
        l_info_to_add = 
            contributor.getContributorInfoForItemDisplay(contribId, p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("creator contributor")) {
        Contributor contributor = new Contributor(m_db);
        int contribId = 
          Integer.parseInt(((ItemContribLink)m_item_creator_conlinks.elementAt(i)).getContribId());
        l_info_to_add = 
            contributor.getContributorInfoForItemDisplay(contribId, p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("venue")) {
        Venue venue = new Venue(m_db);
        l_id = m_item_venuelinks.elementAt(i) + "";
        l_info_to_add = 
            venue.getVenueInfoForItemDisplay(Integer.parseInt(l_id), p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("organisation")) {
        Organisation organisation = new Organisation(m_db);
        l_info_to_add = 
            organisation.getOrganisationInfoForItemDisplay(Integer.parseInt(((ItemOrganLink)m_item_orglinks.elementAt(i)).getOrganisationId()), 
                                                           p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("creator organisation")) {
        Organisation organisation = new Organisation(m_db);
        l_info_to_add = 
            organisation.getOrganisationInfoForItemDisplay(Integer.parseInt(((ItemOrganLink)m_item_creator_orglinks.elementAt(i)).getOrganisationId()), 
                                                           p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("genre")) {
        SecondaryGenre genre = new SecondaryGenre(m_db);
        //l_info_to_add = (String) m_item_secgenrelinks.elementAt(i) + ", ";
        l_info_to_add = 
            genre.getGenreInfoForItemDisplay(Integer.parseInt((String)m_item_secgenrelinks.elementAt(i)), 
                                             p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("work")) {
        Work work = new Work(m_db);
        //l_info_to_add = (String) m_item_workslinks.elementAt(i) + ", ";
        l_info_to_add = 
            work.getWorkInfoForDisplay(Integer.parseInt((String)m_item_workslinks.elementAt(i)), 
                                       p_stmt);
        l_display_info.add(l_info_to_add);
      }
      if (p_id_type.equals("item")) {
        boolean isParent = m_itemid.equals(m_item_itemlinks.elementAt(i).getItemId());
    	Item childItem = new Item(m_db);
        int childItemId = 
        	Integer.parseInt((isParent)?((ItemItemLink)m_item_itemlinks.elementAt(i)).getChildId() : ((ItemItemLink)m_item_itemlinks.elementAt(i)).getItemId());
        l_info_to_add = 
            childItem.getItemInfoForItemDisplay(childItemId, p_stmt);

        // Get the selected item function
        l_display_info.add(l_info_to_add);
      }

    }
    //contributor.getContributorName()
    return l_display_info;
  }


  public ResultSet getitemsById(String p_item_id) {
    String sqlString = "";
    ResultSet l_rs = null;

    try {
      sqlString = "SELECT * " + "FROM items " + "WHERE itemid=" + p_item_id;

      Statement stmt = m_db.m_conn.createStatement();
      l_rs = m_db.runSQLResultSet(sqlString, stmt);
      stmt.close();

    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in item.getitemsByVenue().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (l_rs);
  }

  /***********************
          Set Methods
   ************************/
  public
  //with this set method we also have to automatically set
  //the contributor, venue and organisation objects
  // 
  void setItemEvLinks(Vector p_item_evlinks, Statement p_stmt, 
                      boolean p_removing_links) {
    m_item_evlinks = p_item_evlinks;
    /* COMMENT OUT THE AUTO ADDITION OF CONTRIBUTORS, VENUES AND ORGANISATIONS, TIR35
    String l_sql      = "";
    ResultSet l_rs    = null;
    boolean exists    = false;
    int     counter   = 0;

    try{
      if(!p_removing_links){ //only use this auto populate links if we are adding
        //for every event in the vector get its currently associated linked venues, contributors, organiations
        //and assign them as the current links for this item.
        for(int i = 0; i < m_item_evlinks.size();i ++){

          /////////////////////////////////////
          //          Contributor            //
          /////////////////////////////////////
          l_sql = "SELECT DISTINCT contributorid " +
                    "FROM conevlink " +
                   "WHERE eventid=" + (String) m_item_evlinks.elementAt(i) + " " +
                "ORDER BY contributorid";

          l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
          while(l_rs.next()){
            exists = false;
            String temp = l_rs.getString("contributorid");
            //make sure the contributor id is not already associated to the item
            //only add it if it is not associated
            for(int j = 0; j < m_item_conlinks.size(); j++){
              if(m_item_conlinks.elementAt(j).equals(temp))
                exists = true;
            }
            //add the contributor id to the linked vector
            if(!exists)
              m_item_conlinks.add(temp);
          }

          /////////////////////////////////////
          //          Organisation            //
          /////////////////////////////////////
          l_sql = "SELECT DISTINCT organisationid " +
                    "FROM orgevlink " +
                   "WHERE eventid=" + (String) m_item_evlinks.elementAt(i) + " " +
                "ORDER BY organisationid";

          //re set exists
          exists = false;
          l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
          while(l_rs.next()){
            String temp = l_rs.getString("organisationid");
            //make sure the organisation id is not already associated to the item
            //only add it if it is not associated
            for(int j = 0; j < m_item_orglinks.size(); j++){
              if(m_item_orglinks.elementAt(j).equals(temp))
                exists = true;
            }
            //add the organisation id to the linked vector
            if(!exists)
              m_item_orglinks.add(temp);
          }

          /////////////////////////////////////
          //          Venue                  //
          /////////////////////////////////////
          l_sql = "SELECT DISTINCT venueid " +
                    "FROM events " +
                   "WHERE eventid=" + (String) m_item_evlinks.elementAt(i) + " " +
                  "ORDER BY venueid";

          exists = false;
          l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
          while(l_rs.next()){
              String temp = l_rs.getString("venueid");
              //make sure the organisation id is not already associated to the item
              //only add it if it is not associated
              for(int j = 0; j < m_item_venuelinks.size(); j++){
                if(m_item_venuelinks.elementAt(j).equals(temp))
                  exists = true;
              }
              //add the venue id to the linked vector
              if(!exists)
                m_item_venuelinks.add(temp);
          }
          //reset exists
          exists = false;
        }
      }
    }
    catch(Exception e){
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in item.setItemEvLinks().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }*/
  }

  public void setItemOrgLinks(Vector p_item_orglinks) {
    m_item_orglinks = p_item_orglinks;
  }

  public void setItemCreatorOrgLinks(Vector p_item_creator_orglinks) {
    m_item_creator_orglinks = p_item_creator_orglinks;
  }

  public void setItemVenueLinks(Vector p_item_venuelinks) {
    m_item_venuelinks = p_item_venuelinks;
  }

  public void setItemConLinks(Vector p_item_conlinks) {
    m_item_conlinks = p_item_conlinks;
  }

  public void setItemCreatorConLinks(Vector p_item_creator_conlinks) {
    m_item_creator_conlinks = p_item_creator_conlinks;
  }

  public void setItemContentIndLinks(Vector p_item_contentIndlinks) {
    m_item_contentindlinks = p_item_contentIndlinks;
  }

  public void setItemItemLinks(Vector p_item_itemlinks) {
    m_item_itemlinks = p_item_itemlinks;
  }

  public void setItemSecGenreLinks(Vector p_item_secgenrelinks) {
    m_item_secgenrelinks = p_item_secgenrelinks;
  }

  public void setItemWorkLinks(Vector p_item_worklinks) {
    m_item_workslinks = p_item_worklinks;
  }
  
  //BW additional URLS
  public void setAdditionalUrls(Vector p_additional_urls) {
	    m_additional_urls = p_additional_urls;
	  }

  public void setEnteredByUser(String p_user_name) {
    m_entered_by_user = p_user_name;
  }

  public void setUpdatedByUser(String p_user_name) {
    m_updated_by_user = p_user_name;
  }

  public void setErrorMessage(String p_error_message) {
    m_error_string = p_error_message;
  }

  public void setDatabaseConnection(ausstage.Database ad) {
    m_db = ad;
  }

  public void setItemCatalogueId(String p_catalogue_id) {
    m_catalogueid = p_catalogue_id;
  }

  public void setSource(String p_sourceid, String p_source_citation) {
    m_sourceid = p_sourceid;
    m_source_citation = p_source_citation;
  }

  // CR0001

  public void setDescriptionAbstract(String s) {
    m_description_abstract = s;
  }

  public void setFormatExtent(String s) {
    m_format_extent = s;
  }

  public void setFormatMedium(String s) {
    m_format_medium = s;
  }

  public void setFormatMimetype(String s) {
    m_format_mimetype = s;
  }

  public void setFormat(String s) {
    m_format = s;
  }

  public void setIdentIsbn(String s) {
    m_ident_isbn = s;
  }

  public void setIdentIsmn(String s) {
    m_ident_ismn = s;
  }

  public void setIdentIssn(String s) {
    m_ident_issn = s;
  }

  public void setIdentSici(String s) {
    m_ident_sici = s;
  }

  public void setPublisher(String s) {
    m_publisher = s;
  }

  public void setRightsAccessRights(String s) {
    m_rights_access_rights = s;
  }

  public void setRights(String s) {
    m_rights = s;
  }

  public void setRightsHolder(String s) {
    m_rights_holder = s;
  }

  public void setTitle(String s) {
    m_title = s;
  }

  public void setTitleAlternative(String s) {
    m_title_alternative = s;
  }

  public void setDcCreator(String s) {
    m_dc_creator = s;
  }

  public void setDdCreateDate(String s) {
    m_ddCreate_date = leadingZero(s);
  }

  public void setMmCreateDate(String s) {
    m_mmCreate_date = leadingZero(s);
  }

  public void setYyyyCreateDate(String s) {
    m_yyyyCreate_date = s;
  }

  public void setCreateDate(Date d) {
    m_create_date = d;
  }

  public void setDdCopyrightDate(String s) {
    m_ddCopyright_date = leadingZero(s);
  }

  public void setMmCopyrightDate(String s) {
    m_mmCopyright_date = leadingZero(s);
  }

  public void setYyyyCopyrightDate(String s) {
    m_yyyyCopyright_date = s;
  }

  public void setCopyrightDate(Date d) {
    m_copyright_date = d;
  }

  public void setDdIssuedDate(String s) {
    m_ddIssued_date = leadingZero(s);
  }

  public void setMmIssuedDate(String s) {
    m_mmIssued_date = leadingZero(s);
  }

  public void setYyyyIssuedDate(String s) {
    m_yyyyIssued_date = s;
  }

  public void setIssuedDate(Date d) {
    m_issued_date = d;
  }

  public void setDdAccessionedDate(String s) {
    m_ddAccessioned_date = leadingZero(s);
  }

  public void setMmAccessionedDate(String s) {
    m_mmAccessioned_date = leadingZero(s);
  }

  public void setYyyyAccessionedDate(String s) {
    m_yyyyAccessioned_date = s;
  }

  public void setAccessionedDate(Date d) {
    m_accessioned_date = d;
  }
  
  public void setDdTerminatedDate(String s) {
    m_ddTerminated_date = leadingZero(s);
  }

  public void setMmTerminatedDate(String s) {
    m_mmTerminated_date = leadingZero(s);
  }

  public void setYyyyTerminatedDate(String s) {
    m_yyyyTerminated_date = s;
  }

  public void setTerminatedDate(Date d) {
    m_terminated_date = d;
  }

  //TIR032

  public void setDateNotes(String s) {
    m_date_notes = s;
  }

  public void setPublisherLocation(String s) {
    m_publisher_location = s;
  }

  public void setVolume(String s) {
    m_volume = s;
  }

  public void setIssue(String s) {
    m_issue = s;
  }

  public void setPage(String s) {
    m_page = s;
  }


  /*
  Name: setItemAttributes (HttpServletRequest request)

  Purpose: Sets the attributes in this object from the request.

  Parameters:
    request - The request received by the current page.

  Returns:
     None.

  */

  public void setItemAttributes(HttpServletRequest request) {
    Calendar calendar;
    String day = "";
    String month = "";
    String year = "";  
    
    //BW additional URLS
    //System.out.println("empty additional urls");
    m_additional_urls.clear();
    String urls [] = request.getParameter("f_additional_urls").split(",");
    //System.out.println("urls length"+urls.length);
    for (int i = 0; i < urls.length; i++){
    	if (!urls[i].equals(""))
        m_additional_urls.add(urls[i]);
    }//BW additional URLS
    
    this.m_itemid = request.getParameter("f_itemid");
    if (m_itemid == null)
      m_itemid = "0";
    this.m_catalogueid = request.getParameter("f_catalogue_id");
    if (m_catalogueid == null)
      m_catalogueid = "";
    this.m_sourceid = request.getParameter("f_sourceid");
    if (m_sourceid == null)
      m_sourceid = "";
    this.m_institutionid = request.getParameter("f_institution");
    if (this.m_institutionid == null)
      this.m_institutionid = "";
    this.m_item_type = request.getParameter("f_item_type");
    if (m_item_type == null)
      m_item_type = "";
    this.m_item_sub_type = request.getParameter("f_item_sub_type");
    if (m_item_sub_type == null)
      m_item_sub_type = "";
    this.m_item_description = request.getParameter("f_item_description");
    if (m_item_description == null)
      m_item_description = "";
    this.m_item_condition_id = request.getParameter("f_item_condition");
    if (m_item_condition_id == null)
      m_item_condition_id = "";
    this.m_detail_comments = request.getParameter("f_detail_comments");
    if (m_detail_comments == null)
      m_detail_comments = "";
    this.m_donated_purchased = request.getParameter("f_donated_purchased");
    if (m_donated_purchased == null)
      m_donated_purchased = "";
    this.m_aquired_from = request.getParameter("f_aquired_from");
    if (m_aquired_from == null)
      m_aquired_from = "";
    this.m_storage = request.getParameter("f_storage");
    if (m_storage == null)
      m_storage = "";
    this.m_provenance = request.getParameter("f_provenance");
    if (m_provenance == null)
      m_provenance = "";
    this.m_significance = request.getParameter("f_significance");
    if (m_significance == null)
      m_significance = "";
    this.m_comments = request.getParameter("f_comments");
    if (m_comments == null)
      m_comments = "";
    this.m_item_url = request.getParameter("f_item_url");
    if (m_item_url == null)
      m_item_url = "";
    this.m_item_language = request.getParameter("f_item_language");
    if (m_item_language == null)
      m_item_language = "";


    // CR0001
    this.m_description_abstract = 
        request.getParameter("f_description_abstract");
    if (m_description_abstract == null)
      m_description_abstract = "";
    this.m_format_extent = request.getParameter("f_format_extent");
    if (m_format_extent == null)
      m_format_extent = "";
    this.m_format_medium = request.getParameter("f_format_medium");
    if (m_format_medium == null)
      m_format_medium = "";
    this.m_format_mimetype = request.getParameter("f_format_mimetype");
    if (m_format_mimetype == null)
      m_format_mimetype = "";
    this.m_format = request.getParameter("f_format");
    if (m_format == null)
      m_format = "";
    this.m_ident_isbn = request.getParameter("f_ident_isbn");
    if (m_ident_isbn == null)
      m_ident_isbn = "";
    this.m_ident_ismn = request.getParameter("f_ident_ismn");
    if (m_ident_ismn == null)
      m_ident_ismn = "";
    this.m_ident_issn = request.getParameter("f_ident_issn");
    if (m_ident_issn == null)
      m_ident_issn = "";
    this.m_ident_sici = request.getParameter("f_ident_sici");
    if (m_ident_sici == null)
      m_ident_sici = "";
    this.m_publisher = request.getParameter("f_publisher");
    if (m_publisher == null)
      m_publisher = "";
    this.m_rights_access_rights = 
        request.getParameter("f_rights_access_rights");
    if (m_rights_access_rights == null)
      m_rights_access_rights = "";
    this.m_rights = request.getParameter("f_rights");
    if (m_rights == null)
      m_rights = "";
    this.m_rights_holder = request.getParameter("f_rights_holder");
    if (m_rights_holder == null)
      m_rights_holder = "";
    this.m_title = request.getParameter("f_title");
    if (m_title == null)
      m_title = "";
    this.m_title_alternative = request.getParameter("f_title_alternative");
    if (m_title_alternative == null)
      m_title_alternative = "";
    this.m_dc_creator = request.getParameter("f_dc_creator");
    if (m_dc_creator == null)
      m_dc_creator = "";

    //TIR 032
    this.m_date_notes = request.getParameter("f_date_notes");
    if (m_date_notes == null)
      m_date_notes = "";
    this.m_publisher_location = request.getParameter("f_publisher_location");
    if (m_publisher_location == null)
      m_publisher_location = "";
    this.m_volume = request.getParameter("f_volume");
    if (m_volume == null)
      m_volume = "";
    this.m_issue = request.getParameter("f_issue");
    if (m_issue == null)
      m_issue = "";
    this.m_page = request.getParameter("f_page");
    if (m_page == null)
      m_page = "";


    // Set m_create_date
    day = request.getParameter("f_create_date_day");
    month = request.getParameter("f_create_date_month");
    year = request.getParameter("f_create_date_year");

    if (day == null || day.equals("")) {
      this.setDdCreateDate("");
      day = "";
    } else
      this.setDdCreateDate(day);

    if (month == null || month.equals("")) {
      this.setMmCreateDate("");
      month = "";
    } else
      this.setMmCreateDate(month);

    if (year == null || year.equals("")) {
      this.setYyyyCreateDate("");
      year = "";
    } else
      this.setYyyyCreateDate(year);

    try {
      if (!day.equals("") && !month.equals("") && !year.equals("")) {
        calendar = Calendar.getInstance();
        calendar.set(Integer.parseInt(year.trim()), 
                     Integer.parseInt(month.trim()) - 1, 
                     Integer.parseInt(day.trim()));
        this.m_create_date = calendar.getTime();
      }
    } catch (Exception e) { // Should never happen due to JavaScript date checking
      m_error_string = 
          "Unable to update the resource. The Create Date field is invalid.";
    }


    // Set m_copyright_date
    day = request.getParameter("f_copyright_date_day");
    month = request.getParameter("f_copyright_date_month");
    year = request.getParameter("f_copyright_date_year");

    if (day == null || day.equals("")) {
      this.setDdCopyrightDate("");
      day = "";
    } else
      this.setDdCopyrightDate(day);

    if (month == null || month.equals("")) {
      this.setMmCopyrightDate("");
      month = "";
    } else
      this.setMmCopyrightDate(month);

    if (year == null || year.equals("")) {
      this.setYyyyCopyrightDate("");
      year = "";
    } else
      this.setYyyyCopyrightDate(year);

    try {
      if (!day.equals("") && !month.equals("") && !year.equals("")) {
        calendar = Calendar.getInstance();
        calendar.set(Integer.parseInt(year.trim()), 
                     Integer.parseInt(month.trim()) - 1, 
                     Integer.parseInt(day.trim()));
        this.m_copyright_date = calendar.getTime();
      }
    } catch (Exception e) // Should never happen due to JavaScript date checking
    {
      m_error_string = 
          "Unable to update the resource. The Copyright Date field is invalid.";
    }


    // Set m_issued_date
    day = request.getParameter("f_issued_date_day");
    month = request.getParameter("f_issued_date_month");
    year = request.getParameter("f_issued_date_year");

    if (day == null || day.equals("")) {
      this.setDdIssuedDate("");
      day = "";
    } else
      this.setDdIssuedDate(day);

    if (month == null || month.equals("")) {
      this.setMmIssuedDate("");
      month = "";
    } else
      this.setMmIssuedDate(month);

    if (year == null || year.equals("")) {
      this.setYyyyIssuedDate("");
      year = "";
    } else
      this.setYyyyIssuedDate(year);

    try {
      if (!day.equals("") && !month.equals("") && !year.equals("")) {
        calendar = Calendar.getInstance();
        calendar.set(Integer.parseInt(year.trim()), 
                     Integer.parseInt(month.trim()) - 1, 
                     Integer.parseInt(day.trim()));
        this.m_issued_date = calendar.getTime();
      }
    } catch (Exception e) { // Should never happen due to JavaScript date checking
      m_error_string = 
          "Unable to update the resource. The Issued Date field is invalid.";
    }


    // Set m_accessioned_date
    day = request.getParameter("f_accessioned_date_day");
    month = request.getParameter("f_accessioned_date_month");
    year = request.getParameter("f_accessioned_date_year");

    if (day == null || day.equals("")) {
      this.setDdAccessionedDate("");
      day = "";
    } else
      this.setDdAccessionedDate(day);

    if (month == null || month.equals("")) {
      this.setMmAccessionedDate("");
      month = "";
    } else
      this.setMmAccessionedDate(month);

    if (year == null || year.equals("")) {
      this.setYyyyAccessionedDate("");
      year = "";
    } else
      this.setYyyyAccessionedDate(year);

    try {
      if (!day.equals("") && !month.equals("") && !year.equals("")) {
        calendar = Calendar.getInstance();
        calendar.set(Integer.parseInt(year.trim()), 
                     Integer.parseInt(month.trim()) - 1, 
                     Integer.parseInt(day.trim()));
        this.m_accessioned_date = calendar.getTime();
      }
    } catch (Exception e) { // Should never happen due to JavaScript date checking
      m_error_string = 
          "Unable to update the resource. The Accessioned Date field is invalid.";
    }
    
    
    
    
    // Set m_terminated_date
    day = request.getParameter("f_terminated_date_day");
    month = request.getParameter("f_terminated_date_month");
    year = request.getParameter("f_terminated_date_year");

    if (day == null || day.equals("")) {
      this.setDdTerminatedDate("");
      day = "";
    } else
      this.setDdTerminatedDate(day);

    if (month == null || month.equals("")) {
      this.setMmTerminatedDate("");
      month = "";
    } else
      this.setMmTerminatedDate(month);

    if (year == null || year.equals("")) {
      this.setYyyyTerminatedDate("");
      year = "";
    } else
      this.setYyyyTerminatedDate(year);

    try {
      if (!day.equals("") && !month.equals("") && !year.equals("")) {
        calendar = Calendar.getInstance();
        calendar.set(Integer.parseInt(year.trim()), 
                     Integer.parseInt(month.trim()) - 1, 
                     Integer.parseInt(day.trim()));
        this.m_terminated_date = calendar.getTime();
      }
    } catch (Exception e) { // Should never happen due to JavaScript date checking
      m_error_string = 
          "Unable to update the resource. The Terminated Date field is invalid.";
    }
    
    


    //check to see if we are copying a current item
    if (request.getParameter("action") != null && 
        !request.getParameter("action").equals("") && 
        request.getParameter("action").equals("copy"))
      m_is_copy = true;

    if (m_itemid.equals("0")) //we are adding a item
      m_action = "add";
    else
      m_action = "edit";

    if (m_action.equals("add"))
      this.m_entered_date = new Date();
    else // must be editing a item
      this.m_updated_date = new Date();

    //double check mandatory fields are not null or ""
    if (m_catalogueid == null || m_institutionid == null || 
        m_institutionid.equals("") || m_item_type == null || 
        m_item_type.equals("")) {
      if (m_action.equals("add"))
        m_error_string = 
            "Unable to add the resource. Please ensure all mandatory fields (*) are filled in.";
      else // must be editing a item
        m_error_string = 
            "Unable to update the resource. Please ensure all mandatory fields (*) are filled in.";
    }
  }

  ////////////////////////
  //    Utility methods
  ////////////////////////

  public String getItemInfoForItemDisplay(int p_item_id, Statement p_stmt) {
    String sqlString = "", retStr = "";
    ResultSet l_rs = null;

    try {

      sqlString = 
          "select citation display_info " + "FROM item i " + " WHERE i.itemid = " + 
          p_item_id;

      l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

      if (l_rs.next())
        retStr = l_rs.getString("display_info");


    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in Contributor.getChildItemInfoForItemDisplay().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (retStr);
  }

  private String leadingZero(String dayMonth) {
    dayMonth = dayMonth.trim();
    if (dayMonth.length() == 1)
      dayMonth = "0" + dayMonth;
    return dayMonth;
  }

  public String getCitation(int itemId) {
    String citation = "";
    CachedRowSet rset;
    try {
      Statement stmt = m_db.m_conn.createStatement();
      rset = 
          m_db.runSQL("select CITATION from ITEM where ITEMID=" + itemId, stmt);
      if (rset.next())
        citation = rset.getString("CITATION");
      stmt.close();
    } catch (Exception e) {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println("An Exception occured in Item.getCitation(int itemId).");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return (citation);
  }

  
  public boolean isImageUrl (String url) {
	  boolean isImage = false;
	  if (url.toLowerCase().endsWith(".gif") ||
			  url.toLowerCase().endsWith(".jpeg") ||
			  url.toLowerCase().endsWith(".jpg") ||
			  url.toLowerCase().endsWith(".png") ||
			  url.toLowerCase().endsWith(".bmp")) {
		  isImage = true;
	  }
	  return isImage; 
  }
  
  public String getThumbnail (String path) {
	  Image img = null;
	  ImageType imageType = null;
	  try {
		  if (isImageUrl(path) && path.toLowerCase().startsWith("http")) {
			  //read the image from a URL
			  URL url = new URL(path);
			  int idx = (url.getPath() == null ? -1 : url.getPath().lastIndexOf("."));
			  if (idx != -1) {
				  imageType = ImageType.getType(url.getPath().substring(idx + 1));
			  } else {
				  //imageType = ImageType.UNKNOWN;
				  return null;
			  }
			  img = new Image(url.openStream(), imageType);
			  //small thumbs
	          return squareIt(img, 100, 0.1, 0.95f, 0.08f);
		  } else {
			  System.out.println("Not a url");
		  }
	  } catch (IOException ioe) {
		  ioe.printStackTrace();
	  }
	  return null;
  }

  private String squareIt(Image img, int width, double cropEdges, float quality, float soften) throws IOException {
	  //String dir = "C:\\temp\\";
      Image square = img.getResizedToSquare(width, cropEdges).soften(soften);
      //square.writeToJPG(new File(dir + "squareit.jpg"), quality);

      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      ImageIO.write(square.img, square.getSourceType().toString(), baos);
      baos.flush();
      byte[] imageInByteArray = baos.toByteArray();
      baos.close();
      img.dispose();
      String b64 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
      square.dispose();

      return b64;
      
  }   
}


