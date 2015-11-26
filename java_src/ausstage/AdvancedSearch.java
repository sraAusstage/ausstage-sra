package ausstage;
//test
import java.util.*;

import ausstage.Database;

import java.sql.*;

import sun.jdbc.rowset.*;

public class AdvancedSearch {
	private Database m_db;
	private CachedRowSet m_crset;
	private String m_eventKeyAndVal = "";
	private String m_primGenreKeyAndVal = "";
	private String m_primConIndKeyAndVal = "";
	private String m_venueKeyAndVal = "";
	private String m_countryKeyAndVal = "";
	private String m_organisationKeyAndVal = "";
	private String m_contributorKeyAndVal = "";
	private String m_statesKeyAndVal = "";
	private String m_orgFunctMenuKeyAndVal = "";
	private String m_contFunctKeyAndVal = "";
	private String m_sqlString = "";
	private String m_sqlFromString = "";
	private String m_sqlWhereString = "1=1 ";
	private String m_sqlWhereString2 = "";
	private String m_dateClause = "";
	private String m_eventDateClause = "";
	private String m_firstDateOnDD = "";
	private String m_firstDateOnMM = "";
	private String m_firstDateOnYYYY = "";
	private String m_lastDateOnDD = "";
	private String m_lastDateOnMM = "";
	private String m_lastDateOnYYYY = "";
	private String m_orderBy = "";
	private boolean m_statesTableUsed = false;
	private boolean m_organisationTableUsed = false;
	private boolean m_countryTableUsed = false;
	private boolean m_productionEvLinkTableUsed = false;
	private boolean m_playEvLinkTableUsed = false;
	private boolean m_contribtorTableUsed = false;
	private boolean m_secGenreClassTableUsed = false;
	private boolean m_priGenreClassTableUsed = false;
	private boolean m_contentindTableUsed = false;
	private boolean m_orgContFunctTableUsed = false; // Note1
	private boolean m_contFuntTableUsed = false;
	private boolean m_is_event_dates = false;
	private boolean m_contributorFunctPreferredTableUsed = false;
	private boolean m_resourceTableUsed = false;
	private boolean m_creator_contributor = false;
	private boolean m_creator_organisation = false;
	private boolean m_resourceSourceTableUsed = false;
	// resource/item dates
	private String m_copyrightDateOnDD = "";
	private String m_copyrightDateOnMM = "";
	private String m_copyrightDateOnYYYY = "";
	private String m_copyrightbetweenFromDateDD = "";
	private String m_copyrightbetweenFromDateMM = "";
	private String m_copyrightbetweenFromDateYYYY = "";
	private String m_copyrightbetweenToDateDD = "";
	private String m_copyrightbetweenToDateMM = "";
	private String m_copyrightbetweenToDateYYYY = "";
	private String m_resourceKeyAndVal = "";
	private String m_resourceDateKeyAndVal = "";

	// ////////////////////////////////////////////////
	// Note1: this variable represents a search for both
	// function and artistic function fields of OrgEvLink
	// and their associated tables - OrgFunctMenu and ContFunct.
	// ************************************************/

	public AdvancedSearch(Database p_db) {
		m_db = p_db;
	}

	/*************************************************
	 * Set methods to assign values to member varibles
	 **************************************************/
	public void setEventInfo(String p_eventId, String p_eventName, String p_firstDateOnDD, String p_firstDateOnMM, String p_firstDateOnYYYY, String p_lastDateOnDD,
			String p_lastDateOnMM, String p_lastDateOnYYYY, String p_umbrella) {

		Vector column_types = new Vector();

		if (!p_eventId.equals("")) {
			m_eventKeyAndVal = "events.eventid|" + p_eventId;
			column_types.addElement("int");
		}

		if (!p_eventName.equals("")) {
			m_eventKeyAndVal += ",event_name|" + p_eventName;
			column_types.addElement("string");
		}

		if (!p_umbrella.equals("")) {
			m_eventKeyAndVal += ",events.umbrella|" + p_umbrella;
			column_types.addElement("string");
		}

		buildWhereClause(m_eventKeyAndVal, column_types);
		column_types.clear();

		if ((p_firstDateOnDD != null && !p_firstDateOnDD.equals("")) || (p_firstDateOnMM != null && !p_firstDateOnMM.equals(""))
				|| (p_firstDateOnYYYY != null && !p_firstDateOnYYYY.equals("")) || (p_lastDateOnDD != null && !p_lastDateOnDD.equals(""))
				|| (p_lastDateOnMM != null && !p_lastDateOnMM.equals("")) || (p_lastDateOnYYYY != null && !p_lastDateOnYYYY.equals(""))) {

			m_is_event_dates = true;

			m_firstDateOnDD = p_firstDateOnDD;
			m_firstDateOnMM = p_firstDateOnMM;
			m_firstDateOnYYYY = p_firstDateOnYYYY;
			m_lastDateOnDD = p_lastDateOnDD;
			m_lastDateOnMM = p_lastDateOnMM;
			m_lastDateOnYYYY = p_lastDateOnYYYY;

			// First Date On
			if (!m_firstDateOnDD.equals("")) {
				m_eventDateClause += " AND (events.DDFIRST_DATE='" + m_firstDateOnDD + "' ";
				if (m_firstDateOnDD.length() == 1) {
					m_eventDateClause += " OR events.DDFIRST_DATE='0" + m_firstDateOnDD + "' ";
				}
				m_eventDateClause += ")";
			}
			if (!m_firstDateOnMM.equals("")) {
				m_eventDateClause += " AND (events.MMFIRST_DATE='" + m_firstDateOnMM + "' ";
				if (m_firstDateOnMM.length() == 1) {
					m_eventDateClause += " OR events.MMFIRST_DATE='0" + m_firstDateOnMM + "' ";
				}
				m_eventDateClause += ")";
			}
			if (!m_firstDateOnYYYY.equals("")) {
				m_eventDateClause += " AND events.YYYYFIRST_DATE='" + m_firstDateOnYYYY + "' ";
			}

			// Last Date On
			if (!m_lastDateOnDD.equals("")) {
				m_eventDateClause += " AND (events.DDLAST_DATE='" + m_lastDateOnDD + "' ";
				if (m_lastDateOnDD.length() == 1) {
					m_eventDateClause += " OR events.DDLAST_DATE='0" + m_lastDateOnDD + "' ";
				}
				m_eventDateClause += ")";
			}
			if (!m_lastDateOnMM.equals("")) {
				m_eventDateClause += " AND (events.MMLAST_DATE='" + m_lastDateOnMM + "' ";
				if (m_lastDateOnMM.length() == 1) {
					m_eventDateClause += " OR events.MMLAST_DATE='0" + m_lastDateOnMM + "' ";
				}
				m_eventDateClause += ")";
			}
			if (!m_lastDateOnYYYY.equals("")) {
				m_eventDateClause += " AND events.YYYYLAST_DATE='" + m_lastDateOnYYYY + "' ";
			}
		}
	}

	public void setAssociatedItems(String p_assocItem) {
		if (p_assocItem.equals("resources")) {
			m_sqlWhereString += " AND (assoc_item  = 'Y' OR  assoc_item = 'ONLINE') ";
		} else if (p_assocItem.equals("online resources")) {
			m_sqlWhereString += " AND assoc_item = 'ONLINE' ";
		}

	}

	public void setStatus(String p_statusId) {
		m_sqlWhereString += " AND status = " + p_statusId + " ";

	}

	public void setGenreInfo(String p_primaryGenre, String p_secondaryGenre[]) {
		Vector column_types = new Vector();

		if (!p_primaryGenre.equals("")) {
			m_primGenreKeyAndVal = "prigenreclass.genreclass|" + p_primaryGenre;
			m_priGenreClassTableUsed = true;
			column_types.addElement("stringNoLike");
			buildWhereClause(m_primGenreKeyAndVal, column_types);
			column_types.clear(); // clear it for the next if statement
		}
		/*
		 * if (!p_secondaryGenre.equals("")) { m_secoGenreKeyAndVal =
		 * "secgenreclass.genreclass|" + p_secondaryGenre;
		 * m_secGenreClassTableUsed = true;
		 * column_types.addElement("stringNoLike");
		 * buildWhereClause(m_secoGenreKeyAndVal, column_types); }
		 */

		// sec genre now allows you to select multiplte items

		String secGenre = "";
		if (p_secondaryGenre != null && p_secondaryGenre.length > 0) {

			for (int i = 0; i < p_secondaryGenre.length; i++) {
				if (i == 0) {
					secGenre = p_secondaryGenre[i];
				} else {
					secGenre = secGenre + "," + p_secondaryGenre[i];
				}

			}
			m_secGenreClassTableUsed = true;
			m_resourceKeyAndVal = "";
			m_resourceKeyAndVal += "secgenreclass.genreclass|" + secGenre;
			column_types.addElement("String list");

			buildInWhereClause(m_resourceKeyAndVal, column_types);
			column_types.clear();

		}

	}

	public void setContentInfo(String p_primaryContentIndicator) {

		Vector column_types = new Vector();

		if (!p_primaryContentIndicator.equals("")) {
			m_primConIndKeyAndVal = "contentindicator|" + p_primaryContentIndicator;
			m_contentindTableUsed = true;
			column_types.addElement("string");
			buildWhereClause(m_primConIndKeyAndVal, column_types);
			column_types.clear(); // clear it for the next if statement
		}
	}

	public void setVenueInfo(String p_venueId, String p_venueName, String p_venueState) {

		Vector column_types = new Vector();

		if (!p_venueId.equals("") || !p_venueName.equals("")) {
			m_venueKeyAndVal = "venue.venueid|" + p_venueId;
			column_types.addElement("int");
			m_venueKeyAndVal += ",venue_name|" + p_venueName;
			column_types.addElement("string");
			buildWhereClause(m_venueKeyAndVal, column_types);
			column_types.clear(); // clear it for the next if statement
		}
		if (!p_venueState.equals("")) {
			m_statesKeyAndVal = "states.state|" + p_venueState;
			m_statesTableUsed = true;
			column_types.addElement("string");
			buildWhereClause(m_statesKeyAndVal, column_types);
		}
	}
	
	public void setVenueInfo(String p_venueId, String p_venueName, String p_venueState, String p_venueCountry) {

		Vector column_types = new Vector();

		if (!p_venueId.equals("") || !p_venueName.equals("")) {
			m_venueKeyAndVal = "venue.venueid|" + p_venueId;
			column_types.addElement("int");
			m_venueKeyAndVal += ",venue_name|" + p_venueName;
			column_types.addElement("string");
			buildWhereClause(m_venueKeyAndVal, column_types);
			column_types.clear(); // clear it for the next if statement
		}
		if (!p_venueState.equals("")) {
			m_statesKeyAndVal = "states.state|" + p_venueState;
			m_statesTableUsed = true;
			column_types.addElement("string");
			buildWhereClause(m_statesKeyAndVal, column_types);
		}
		if (!p_venueCountry.equals("")) {
			m_countryKeyAndVal = "country.countryid|" + p_venueCountry;
			m_countryTableUsed = true;
			column_types.addElement("int");
			buildWhereClause(m_countryKeyAndVal, column_types);
		}
	}

	public void setOriginsInfo(String p_origin_of_text, String p_origin_of_production) {

		Vector column_types = new Vector();

		if (!p_origin_of_text.equals("")) {
			m_countryKeyAndVal = "playevlink.countryid|" + p_origin_of_text;
			m_countryTableUsed = true;
			m_playEvLinkTableUsed = true;
			column_types.addElement("int");
			buildWhereClause(m_countryKeyAndVal, column_types);
			column_types.clear(); // clear it for the next if statement
		}
		if (!p_origin_of_production.equals("")) {
			m_countryKeyAndVal = "productionevlink.countryid|" + p_origin_of_production;
			m_countryTableUsed = true;
			m_productionEvLinkTableUsed = true;
			column_types.addElement("int");
			buildWhereClause(m_countryKeyAndVal, column_types);
		}

	}

	public void setOrganisationInfo(String p_organisationId, String p_organisationName, String p_orgFunctMenuAndContFunct) {

		Vector column_types = new Vector();

		if (!p_organisationId.equals("") || !p_organisationName.equals("")) {
			m_organisationKeyAndVal = "organisation.organisationid|" + p_organisationId;
			m_organisationTableUsed = true;
			column_types.addElement("int");
			m_organisationKeyAndVal += ",name|" + p_organisationName;
			column_types.addElement("string");
			buildWhereClause(m_organisationKeyAndVal, column_types);
			column_types.clear(); // clear it for the next if statement
		}
		if (!p_orgFunctMenuAndContFunct.equals("")) {
			m_orgContFunctTableUsed = true;
			m_orgFunctMenuKeyAndVal = "orgfunction|" + p_orgFunctMenuAndContFunct;
			column_types.addElement("string");
			buildWhereClause(m_orgFunctMenuKeyAndVal, column_types);
			m_contFunctKeyAndVal = "contfunction|" + p_orgFunctMenuAndContFunct;
			buildWhereClause(m_contFunctKeyAndVal, column_types);
		}
	}

	public void setContributorInfo(String p_contributorId, String p_contributorName, String p_contributorFunction) {

		Vector column_types = new Vector();

		if (!p_contributorId.equals("") || !p_contributorName.equals("")) {
			m_contributorKeyAndVal = "contributor.contributorid|" + p_contributorId;
			m_contribtorTableUsed = true;
			column_types.addElement("int");
			m_contributorKeyAndVal += ",combined_all|" + p_contributorName;
			column_types.addElement("string");
			buildWhereClause(m_contributorKeyAndVal, column_types);
			column_types.clear(); // clear it for the next if statement
		}
		if (!p_contributorFunction.equals("")) {
			m_contFunctKeyAndVal = "contributorfunctpreferred.preferredterm|" + p_contributorFunction;
			m_contributorFunctPreferredTableUsed = true;
			column_types.addElement("string");
			buildWhereClause(m_contFunctKeyAndVal, column_types);
		}

	}

	public void setResourceInfo(String p_resource_title, String p_resource_source, String p_resource_abstract, String p_contributor_creator, String p_organisation_creator,
			String[] p_resource_subTypes, String p_copyrightDateChecked, String p_issuedDateChecked, String p_accessionedDateChecked, String p_copyright_date_yyyy,
			String p_copyright_date_mm, String p_copyright_date_dd, String p_copyrightbetweenFromDateDD, String p_copyrightbetweenFromDateMM,
			String p_copyrightbetweenFromDateYYYY, String p_copyrightbetweenToDateDD, String p_copyrightbetweenToDateMM, String p_copyrightbetweenToDateYYYY,
			String p_issued_date_yyyy, String p_issued_date_mm, String p_issued_date_dd, String p_issuedbetweenFromDateDD, String p_issuedbetweenFromDateMM,
			String p_issuedbetweenFromDateYYYY, String p_issuedbetweenToDateDD, String p_issuedbetweenToDateMM, String p_issuedbetweenToDateYYYY, String p_accessioned_date_yyyy,
			String p_accessioned_date_mm, String p_accessioned_date_dd, String p_accessionedbetweenFromDateDD, String p_accessionedbetweenFromDateMM,
			String p_accessionedbetweenFromDateYYYY, String p_accessionedbetweenToDateDD, String p_accessionedbetweenToDateMM, String p_accessionedbetweenToDateYYYY) {

		Vector column_types = new Vector();
		String safeDateFormat = "";
		m_resourceTableUsed = true;

		if (!p_resource_title.equals("") || !p_resource_source.equals("") || !p_resource_abstract.equals("")) {

			m_resourceKeyAndVal = "item.title|" + p_resource_title;
			column_types.addElement("string");
			// source
			// this refers to the 'parent' item of this item
			if (!p_resource_source.equals("")) {
				// need to add another item table to the list to query for the
				// citation
				m_resourceSourceTableUsed = true;
				m_resourceKeyAndVal += ",source_name.citation|" + p_resource_source;
				column_types.addElement("string");
			} else {
				// do nothing about the source
			}

			m_resourceKeyAndVal += ",item.description_abstract|" + p_resource_abstract;
			column_types.addElement("string");

			buildWhereClause(m_resourceKeyAndVal, column_types);
			column_types.clear();
		}
		if (!p_contributor_creator.equals("")) {
			m_creator_contributor = true;

			m_resourceKeyAndVal = "cont_creator.last_name|" + p_contributor_creator;
			column_types.addElement("string");
			buildWhereClause(m_resourceKeyAndVal, column_types);

			column_types.clear();
		}
		if (!p_organisation_creator.equals("")) {
			m_creator_organisation = true;

			m_resourceKeyAndVal += "orga_creator.name|" + p_organisation_creator;
			column_types.addElement("string");

			buildWhereClause(m_resourceKeyAndVal, column_types);
			column_types.clear();
		}
		// add the selected subtypes to the query
		if (p_resource_subTypes != null && p_resource_subTypes.length > 0) {
			// build string with all selected subtypes
			String subTypes = "";

			for (int i = 0; i < p_resource_subTypes.length; i++) {
				if (i == 0) {
					subTypes = p_resource_subTypes[i];
				} else {
					subTypes = subTypes + "," + p_resource_subTypes[i];
				}
			}
			m_resourceKeyAndVal = "";
			m_resourceKeyAndVal += "item.item_sub_type_lov_id|" + subTypes;
			column_types.addElement("int list");

			buildInWhereClause(m_resourceKeyAndVal, column_types);
			column_types.clear();
		}
		// need to add the contributor table with creator flag = 'Y'
		if (!p_contributor_creator.equals("")) {

		}
		// need to add the organisation table with creator flag = 'Y'
		if (!p_organisation_creator.equals("")) {

		}
		// copyright date
		if (!p_copyrightDateChecked.equals("") || !p_copyright_date_dd.equals("") || !p_copyright_date_mm.equals("") || !p_copyright_date_yyyy.equals("")
				|| !p_copyrightbetweenFromDateDD.equals("") || !p_copyrightbetweenFromDateMM.equals("") || !p_copyrightbetweenFromDateYYYY.equals("")
				|| !p_copyrightbetweenToDateDD.equals("") || !p_copyrightbetweenToDateMM.equals("") || !p_copyrightbetweenToDateYYYY.equals("")) {

			if (p_copyrightDateChecked.equals("item copyrightdate")) { // copyright
																		// date
																		// being
																		// used
				m_copyrightDateOnDD = p_copyright_date_dd;
				m_copyrightDateOnMM = p_copyright_date_mm;
				m_copyrightDateOnYYYY = p_copyright_date_yyyy; // set member
																// variables
				if (!p_copyright_date_yyyy.equals("")) {
					if (m_resourceDateKeyAndVal.equals(""))
						// return date clause value
						m_resourceDateKeyAndVal = "item.copyright_date|"
								+ setResourceDateClause(p_copyright_date_dd, p_copyright_date_mm, p_copyright_date_yyyy, p_copyrightbetweenFromDateDD,
										p_copyrightbetweenFromDateMM, p_copyrightbetweenFromDateYYYY, p_copyrightbetweenToDateDD, p_copyrightbetweenToDateMM,
										p_copyrightbetweenToDateYYYY, "copyright_date");
					else
						// return date clause value
						m_resourceDateKeyAndVal += ",item.copyright_date|"
								+ setResourceDateClause(p_copyright_date_dd, p_copyright_date_mm, p_copyright_date_yyyy, p_copyrightbetweenFromDateDD,
										p_copyrightbetweenFromDateMM, p_copyrightbetweenFromDateYYYY, p_copyrightbetweenToDateDD, p_copyrightbetweenToDateMM,
										p_copyrightbetweenToDateYYYY, "copyright_date");
				}
			} else { // between date being used
				m_copyrightbetweenFromDateDD = p_copyrightbetweenFromDateDD;
				m_copyrightbetweenFromDateMM = p_copyrightbetweenFromDateMM;
				m_copyrightbetweenFromDateYYYY = p_copyrightbetweenFromDateYYYY;
				m_copyrightbetweenToDateDD = p_copyrightbetweenToDateDD;
				m_copyrightbetweenToDateMM = p_copyrightbetweenToDateMM;
				m_copyrightbetweenToDateYYYY = p_copyrightbetweenToDateYYYY; // set
																				// member
																				// variables

				if (!p_copyrightbetweenFromDateYYYY.equals("") && !p_copyrightbetweenToDateYYYY.equals("")) if (m_resourceDateKeyAndVal.equals(""))
					// return date clause value
					m_resourceDateKeyAndVal = "item.copyright_date|"
							+ setResourceDateClause(p_copyright_date_dd, p_copyright_date_mm, p_copyright_date_yyyy, p_copyrightbetweenFromDateDD, p_copyrightbetweenFromDateMM,
									p_copyrightbetweenFromDateYYYY, p_copyrightbetweenToDateDD, p_copyrightbetweenToDateMM, p_copyrightbetweenToDateYYYY, "copyright_date");
				else
					// return date clause value
					m_resourceDateKeyAndVal += ",item.copyright_date|"
							+ setResourceDateClause(p_copyright_date_dd, p_copyright_date_mm, p_copyright_date_yyyy, p_copyrightbetweenFromDateDD, p_copyrightbetweenFromDateMM,
									p_copyrightbetweenFromDateYYYY, p_copyrightbetweenToDateDD, p_copyrightbetweenToDateMM, p_copyrightbetweenToDateYYYY, "copyright_date");
			}
			// column_types.addElement("date");
			// buildWhereClause(m_eventDateKeyAndVal , column_types);
		}

		// issued date
		if (!p_issuedDateChecked.equals("") || !p_issued_date_dd.equals("") || !p_issued_date_mm.equals("") || !p_issued_date_yyyy.equals("")
				|| !p_issuedbetweenFromDateDD.equals("") || !p_issuedbetweenFromDateMM.equals("") || !p_issuedbetweenFromDateYYYY.equals("") || !p_issuedbetweenToDateDD.equals("")
				|| !p_issuedbetweenToDateMM.equals("") || !p_issuedbetweenToDateYYYY.equals("")) {

			if (p_issuedDateChecked.equals("item issueddate")) { // issued date
																	// being
																	// used

				if (!p_issued_date_yyyy.equals("")) {
					if (m_resourceDateKeyAndVal.equals(""))
						// return date clause value
						m_resourceDateKeyAndVal = "item.issued_date|"
								+ setResourceDateClause(p_issued_date_dd, p_issued_date_mm, p_issued_date_yyyy, p_issuedbetweenFromDateDD, p_issuedbetweenFromDateMM,
										p_issuedbetweenFromDateYYYY, p_issuedbetweenToDateDD, p_issuedbetweenToDateMM, p_issuedbetweenToDateYYYY, "issued_date");
					else
						// return date clause value
						m_resourceDateKeyAndVal += ",item.issued_date|"
								+ setResourceDateClause(p_issued_date_dd, p_issued_date_mm, p_issued_date_yyyy, p_issuedbetweenFromDateDD, p_issuedbetweenFromDateMM,
										p_issuedbetweenFromDateYYYY, p_issuedbetweenToDateDD, p_issuedbetweenToDateMM, p_issuedbetweenToDateYYYY, "issued_date");
				}
			} else { // between date being used

				if (!p_issuedbetweenFromDateYYYY.equals("") && !p_issuedbetweenToDateYYYY.equals("")) if (m_resourceDateKeyAndVal.equals(""))
					// return date clause value
					m_resourceDateKeyAndVal = "item.issued_date|"
							+ setResourceDateClause(p_issued_date_dd, p_issued_date_mm, p_issued_date_yyyy, p_issuedbetweenFromDateDD, p_issuedbetweenFromDateMM,
									p_issuedbetweenFromDateYYYY, p_issuedbetweenToDateDD, p_issuedbetweenToDateMM, p_issuedbetweenToDateYYYY, "issued_date");
				else
					// return date clause value
					m_resourceDateKeyAndVal += ",item.issued_date|"
							+ setResourceDateClause(p_issued_date_dd, p_issued_date_mm, p_issued_date_yyyy, p_issuedbetweenFromDateDD, p_issuedbetweenFromDateMM,
									p_issuedbetweenFromDateYYYY, p_issuedbetweenToDateDD, p_issuedbetweenToDateMM, p_issuedbetweenToDateYYYY, "issued_date");
			}
			// column_types.addElement("date");
			// buildWhereClause(m_eventDateKeyAndVal , column_types);
		}

		// accessioned date
		if (!p_accessionedDateChecked.equals("") || !p_accessioned_date_dd.equals("") || !p_accessioned_date_mm.equals("") || !p_accessioned_date_yyyy.equals("")
				|| !p_accessionedbetweenFromDateDD.equals("") || !p_accessionedbetweenFromDateMM.equals("") || !p_accessionedbetweenFromDateYYYY.equals("")
				|| !p_accessionedbetweenToDateDD.equals("") || !p_accessionedbetweenToDateMM.equals("") || !p_accessionedbetweenToDateYYYY.equals("")) {

			if (p_accessionedDateChecked.equals("item accessioneddate")) { // accessioned
																			// date
																			// being
																			// used

				if (!p_accessioned_date_yyyy.equals("")) {
					if (m_resourceDateKeyAndVal.equals(""))
						// return date clause value
						m_resourceDateKeyAndVal = "item.accessioned_date|"
								+ setResourceDateClause(p_accessioned_date_dd, p_accessioned_date_mm, p_accessioned_date_yyyy, p_accessionedbetweenFromDateDD,
										p_accessionedbetweenFromDateMM, p_accessionedbetweenFromDateYYYY, p_accessionedbetweenToDateDD, p_accessionedbetweenToDateMM,
										p_accessionedbetweenToDateYYYY, "accessioned_date");
					else
						// return date clause value
						m_resourceDateKeyAndVal += ",item.accessioned_date|"
								+ setResourceDateClause(p_accessioned_date_dd, p_accessioned_date_mm, p_accessioned_date_yyyy, p_accessionedbetweenFromDateDD,
										p_accessionedbetweenFromDateMM, p_accessionedbetweenFromDateYYYY, p_accessionedbetweenToDateDD, p_accessionedbetweenToDateMM,
										p_accessionedbetweenToDateYYYY, "accessioned_date");
				}
			} else { // between date being used

				if (!p_accessionedbetweenFromDateYYYY.equals("") && !p_accessionedbetweenToDateYYYY.equals(""))
					if (m_resourceDateKeyAndVal.equals(""))
						// return date clause value
						m_resourceDateKeyAndVal = "item.accessioned_date|"
								+ setResourceDateClause(p_accessioned_date_dd, p_accessioned_date_mm, p_accessioned_date_yyyy, p_accessionedbetweenFromDateDD,
										p_accessionedbetweenFromDateMM, p_accessionedbetweenFromDateYYYY, p_accessionedbetweenToDateDD, p_accessionedbetweenToDateMM,
										p_accessionedbetweenToDateYYYY, "accessioned_date");
					else
						// return date clause value
						m_resourceDateKeyAndVal += ",item.accessioned_date|"
								+ setResourceDateClause(p_accessioned_date_dd, p_accessioned_date_mm, p_accessioned_date_yyyy, p_accessionedbetweenFromDateDD,
										p_accessionedbetweenFromDateMM, p_accessionedbetweenFromDateYYYY, p_accessionedbetweenToDateDD, p_accessionedbetweenToDateMM,
										p_accessionedbetweenToDateYYYY, "accessioned_date");
			}
			// column_types.addElement("date");
			// buildWhereClause(m_eventDateKeyAndVal , column_types);
		}

	}

	/**********************
	 * End set methods
	 **********************/

	/****************************************************************************
	 * this method adds the conditions into the clause E.G.(articleid=55, column
	 * name like '%luke%') the joins between the tables are added in
	 * buildFromAndLinksSqlString() method.
	 *****************************************************************************/
	private void buildWhereClause(String p_hashtable, Vector p_columnTypes) {
		String l_column_name = "";
		String l_column_value = "";
		int counter = 0;
		StringTokenizer st_token = new StringTokenizer(p_hashtable, ",");
		while (st_token.hasMoreTokens()) {
			StringTokenizer key_and_val = new StringTokenizer(st_token.nextToken(), "|");
			l_column_name = key_and_val.nextToken();
			if (key_and_val.hasMoreTokens())
				l_column_value = key_and_val.nextToken();
			else
				l_column_value = "";
			// only put field and value into clause if the value is not ""
			if (!l_column_value.equals("")) {

				if (l_column_name.equals("contfunction") && m_orgContFunctTableUsed == true) // only
																								// add
																								// an
																								// AND
																								// to
																								// the
																								// where
																								// clause
					m_sqlString += "";
				else
					m_sqlWhereString += " AND ";

				if (p_columnTypes.elementAt(counter).equals("string") || p_columnTypes.elementAt(counter).equals("stringNoLike")) {
					if (l_column_name.equals("orgfunction") && m_orgContFunctTableUsed == true) {
						m_sqlWhereString += " (upper(" + l_column_name + ") like '%" + m_db.plSqlSafeString(l_column_value.toUpperCase()).trim() + "%' "
								+ " and orgfunctmenu.orgfunctionid = orgevlink.function and orgevlink.eventid = events.eventid ";
					} else if (l_column_name.equals("contfunction") && m_orgContFunctTableUsed == true) {
						m_sqlWhereString +=

						" and orgfunctmenu.orgfunctionid = orgevlink.function and orgevlink.eventid = events.eventid )";
					}
					/*
					 * else if(l_column_name.equals("combined_all") &&
					 * m_authorAliasTableUsed == true) m_sqlWhereString +=
					 * "upper(author.first_name || ' ' || author.last_name) like '%"
					 * +
					 * m_db.plSqlSafeString(l_column_value.toUpperCase()).trim()
					 * + "%' ";
					 */
					else if (l_column_name.equals("combined_all") && m_contribtorTableUsed == true)
						m_sqlWhereString += "upper(concat_ws(' ', contributor.first_name, contributor.last_name)) like '%"
								+ m_db.plSqlSafeString(l_column_value.toUpperCase()).trim() + "%' ";
					else if (l_column_name.equals("cont_creator.last_name") && m_creator_contributor) {
						m_sqlWhereString += "upper(concat_ws(' ', cont_creator.first_name, cont_creator.last_name)) like '%"
								+ m_db.plSqlSafeString(l_column_value.toUpperCase()).trim() + "%' ";
					} else if (p_columnTypes.elementAt(counter).equals("stringNoLike")) {
						m_sqlWhereString += "upper(" + l_column_name + ") = '" + m_db.plSqlSafeString(l_column_value.toUpperCase()) + "' ";
					} else
						m_sqlWhereString += "upper(" + l_column_name + ") like '%" + m_db.plSqlSafeString(l_column_value.toUpperCase()).trim() + "%' ";
				}

				else if (p_columnTypes.elementAt(counter).equals("int")) m_sqlWhereString += l_column_name + "=" + m_db.plSqlSafeString(l_column_value.toUpperCase()).trim() + " ";
			}
			counter++;
		}
	}

	private void buildInWhereClause(String p_field_with_val, Vector p_columnTypes) {
		String l_column_name = "";
		String l_column_values = "";
		int counter = 0;

		// firstly split the input string up into field + values
		StringTokenizer st_token = new StringTokenizer(p_field_with_val, "|");
		// get the column name
		l_column_name = st_token.nextToken().toString();
		// if the column type is a collection of int values then no need for
		// safe string
		// otherwise apply a safe string wrap to the collection ie. e,r,t ->
		// 'e','r','t'
		if (p_columnTypes.elementAt(counter).equals("int list")) {

			StringTokenizer key_and_val = new StringTokenizer(st_token.nextToken(), ",");
			while (key_and_val.hasMoreTokens()) {

				if (counter == 0) {
					l_column_values = key_and_val.nextToken();
				} else {
					l_column_values = l_column_values + "," + m_db.plSqlSafeString(key_and_val.nextToken());
				}
				// increment counter
				counter++;
			}

		} else {

			StringTokenizer key_and_val = new StringTokenizer(st_token.nextToken(), ",");
			while (key_and_val.hasMoreTokens()) {

				if (counter == 0) {
					l_column_values = "'" + m_db.plSqlSafeString(key_and_val.nextToken()) + "'";
				} else {
					l_column_values = l_column_values + "," + "'" + m_db.plSqlSafeString(key_and_val.nextToken()) + "'";
				}
				// increment counter
				counter++;
			}

		}
		m_sqlWhereString += " AND ";
		m_sqlWhereString += l_column_name + " in (" + l_column_values.trim() + ") ";

	}

	public void buildFromAndLinksSqlString() {
		m_sqlFromString += "events inner join venue on events.venueid = venue.venueid ";

		if (m_organisationTableUsed == true) { // for organisation id, name
												// search
			m_sqlFromString += "inner join orgevlink on orgevlink.eventid = events.eventid inner join organisation on organisation.organisationid = orgevlink.organisationid ";
		}

		if (m_contribtorTableUsed == true) { // for contributor id and name
												// search
			m_sqlFromString += "inner join conevlink on events.eventid = conevlink.eventid inner join contributor on conevlink.contributorid = contributor.contributorid ";
		}

		if (m_countryTableUsed == true) { // link tables for "origins of text"
											// and "origins of production"
			if (m_playEvLinkTableUsed == true) {
				m_sqlFromString += "inner join playevlink on events.eventid = playevlink.eventid inner join country c1 on playevlink.countryid = c1.countryid ";
			}
			if (m_productionEvLinkTableUsed == true) {
				m_sqlFromString += "inner join productionevlink on events.eventid = productionevlink.eventid inner join country c2 on productionevlink.countryid = c2.countryid ";
			}
		}
		if (m_orgContFunctTableUsed == true) { // for search for organisation
												// functions and contributor
												// functions in one go
			m_sqlFromString += "inner join orgevlink on (orgevlink.eventid=events.eventid) " + "inner join orgfunctmenu on orgfunctmenu.orgfunctionid = orgevlink.function ";
		}
		if (m_contFuntTableUsed == true) { // for contributor function search
			m_sqlFromString += "inner join contfunct on contfunct.contfunctionid = orgevlink.artistic_function ";
		}
		if (m_contributorFunctPreferredTableUsed == true) {
			m_sqlFromString += "inner join conevlink conevlinkfunctpref on conevlinkfunctpref.eventid = events.eventid "
					+ "inner join contributorfunctpreferred on conevlinkfunctpref.function = contributorfunctpreferred.contributorfunctpreferredid ";
		}
		if (m_priGenreClassTableUsed == true) { // for primary genre search
			m_sqlFromString += "inner join prigenreclass on events.primary_genre = prigenreclass.genreclassid ";
		}
		if (m_secGenreClassTableUsed == true) { // for secondary genre search
			m_sqlFromString += "inner join secgenreclasslink on secgenreclasslink.eventid = events.eventid "
					+ "inner join secgenrepreferred on secgenrepreferred.secgenrepreferredid = secgenreclasslink.secgenrepreferredid "
					+ "inner join secgenreclass on secgenreclass.secgenrepreferredid = secgenrepreferred.secgenrepreferredid ";
		}
		if (m_contentindTableUsed == true) {
			m_sqlFromString += "inner join primcontentindicatorevlink on events.eventid=primcontentindicatorevlink.eventid "
					+ "inner join contentindicator on primcontentindicatorevlink.PRIMCONTENTINDICATORID=contentindicator.contentindicatorid ";
		}
		if (m_resourceTableUsed == true) { // for resource text fields and dates
			m_sqlFromString += "inner join itemevlink on itemevlink.eventid = events.eventid inner join item item.itemid = itemevlink.itemid ";

			// only creator contributor
			if (m_creator_contributor == true) {
				m_sqlFromString += "inner join itemconlink on (item.itemid = itemconlink.itemid and itemconlink.creator_flag = 'Y') inner join contributor cont_creator on itemconlink.contributorid = cont_creator.contributorid ";
			}
			// only creator organisation
			if (m_creator_organisation == true) {
				m_sqlFromString += "inner join itemorglink on (item.itemid = itemorglink.itemid and itemorglink.creator_flag = 'Y') inner join organisation orga_creator on itemorglink.organisationid = orga_creator.organisationid ";

			}
			// only if thge source name is being searched
			if (m_resourceSourceTableUsed) {
				m_sqlFromString += "inner join item source_name on item.sourceid = source_name.itemid ";
			}
		}

	}

	public void setOrderBy(String orderBy) {
		if (orderBy == null) {
			m_orderBy = "";
		} else {
			m_orderBy = orderBy;
		}
	}

	/*
	 * public void setLimitBy(String limitBy) { if (limitBy == null) { m_limitBy
	 * = ""; } else { m_limitBy = limitBy; } }
	 */
	public CachedRowSet getResult() {
		// By selecting * from original query, allows you to add assoc_item to
		// the where clause without doing the decode again.

		m_sqlString = "SELECT events.eventid, events.event_name, events.status, venue.venue_name, venue.suburb, "
				+ " venue.state as state_id, states.state as state, events.first_date ,events.ddfirst_date ,events.mmfirst_date ,events.yyyyfirst_date , if(max(i.ITEM_URL) is null,if(max(i.itemid) is null,'N','Y'),'ONLINE')  ASSOC_ITEM, "
				+ " count(distinct ie.itemid) as total, country.countryname  " 
				+ " FROM " + m_sqlFromString
				+ " INNER JOIN country ON (venue.countryid = country.countryid)"
				+ " inner join states on states.stateid=venue.state "
				+ " left join itemevlink ie on ie.eventid = events.eventid  "
				+ " left join item i on i.itemid = ie.itemid " 
				+ " WHERE "
				+ m_sqlWhereString;
		// add resource date clause onto the end
		if (!m_dateClause.equals("")) {
			m_sqlString += " and " + m_dateClause;
		}

		// add event date clause onto the end
		if (!m_eventDateClause.equals("")) {
			m_sqlString += " " + m_eventDateClause;
		}

		m_sqlString += " group by  events.eventid, events.event_name, events.status, venue.venue_name, venue.suburb," + " venue.state , " + " states.state, events.first_date";

		if (m_orderBy != null) {
			m_sqlString += " order by " + m_orderBy + " ";
		}

		try {
			Statement l_stmt = m_db.m_conn.createStatement();
			m_crset = m_db.runSQL(m_sqlString, l_stmt);
			System.out.println(m_sqlString.toString());
			System.out.println(m_sqlWhereString.toString());
			l_stmt.close();

		} catch (Exception e) {

			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in AdvancedSearch.getResult()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sqlString.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			System.out.println(m_sqlString);
			System.out.println("It should be noted the user may have entered incorrect search keywords, such as *, &, $, + etc.. symbols");

		}
		// debug purposes only
		// System.out.println(m_sqlString);
		return (m_crset);
	} // end getResult

	public String setResourceDateClause(final String day, final String month, final String year, final String dayFrom, final String monthFrom, final String yearFrom,
			final String dayTo, final String monthTo, final String yearTo, final String tableColumn) {

		String l_tableCol = tableColumn;
		String l_DateOnDD = day;
		String l_DateOnMM = month;
		String l_DateOnYYYY = year;
		String l_betweenFromDateDD = dayFrom;
		String l_betweenFromDateMM = monthFrom;
		String l_betweenFromDateYYYY = yearFrom;
		String l_betweenToDateDD = dayTo;
		String l_betweenToDateMM = monthTo;
		String l_betweenToDateYYYY = yearTo;
		// From other date clause
		Search search = new Search(m_db); // created so I can use the
											// getNumberOfDays method.

		// if m_dateClause has already been used we need to add and AND into the
		// clause
		if (!m_dateClause.equals("")) {
			m_dateClause += " and ";
		}

		/***********************************************
		 * DATES: only called if result type is event * NOTE: all dates MUST be
		 * in yyyy-mm-dd format*
		 ************************************************/
		// if the year is not empty then only use a full date
		// otherwise use the from to values to formulate a date

		if (l_DateOnYYYY != null && !l_DateOnYYYY.equals("")) {

			if (!l_DateOnDD.equals("")) {
				m_dateClause += " " + l_tableCol + "=to_date('" + l_DateOnYYYY + "-" + l_DateOnMM + "-" + l_DateOnDD + "','yyyy-mm-dd') ";

			} else if (!l_DateOnMM.equals("") && !l_DateOnYYYY.equals("")) {

				if (l_DateOnMM.equals("02")) {

					// do some leap year testing - from other code, so its been
					// kept as it works
					GregorianCalendar cal = new GregorianCalendar();
					if (cal.isLeapYear(Integer.parseInt(l_DateOnYYYY))) {
						m_dateClause += (" (" + l_tableCol + " between to_date('" + l_DateOnYYYY + "-02-01','yyyy-mm-dd') and ");
						m_dateClause += ("to_date('" + l_DateOnYYYY + "-02-29','yyyy-mm-dd')) ");
					} else {
						m_dateClause += (" (" + l_tableCol + " between to_date('" + l_DateOnYYYY + "-02-01','yyyy-mm-dd') and ");
						m_dateClause += ("to_date('" + l_DateOnYYYY + "-02-28','yyyy-mm-dd')) ");
					}

				} else {
					// lets get the last date of the given month & year
					String num_of_days = Integer.toString(search.getNumberOfDays(l_DateOnMM, Integer.parseInt(l_DateOnYYYY)));

					m_dateClause += (" (" + l_tableCol + " between to_date('" + l_DateOnYYYY + "-" + l_DateOnMM + "-01','yyyy-mm-dd') and ");
					m_dateClause += ("to_date('" + l_DateOnYYYY + "-" + l_DateOnMM + "-" + num_of_days + "','yyyy-mm-dd')) ");
				}
			} else { // only YEAR is specified
				m_dateClause += (" (" + l_tableCol + " between to_date('" + l_DateOnYYYY + "-01-01','yyyy-mm-dd') and ");
				m_dateClause += ("to_date('" + l_DateOnYYYY + "-12-31','yyyy-mm-dd')) ");
			}

		} else if ((l_betweenFromDateYYYY != null && !l_betweenFromDateYYYY.equals("")) && (l_betweenToDateYYYY != null && !l_betweenToDateYYYY.equals(""))) {

			// //////////////////////////
			// BETWEEN DATES
			// //////////////////////////

			// From Date
			if (!l_betweenFromDateDD.equals("")) {
				m_dateClause += (" (" + l_tableCol + " between to_date('" + l_betweenFromDateYYYY + "-" + l_betweenFromDateMM + "-" + l_betweenFromDateDD + "','yyyy-mm-dd') and ");
			} else if (!l_betweenFromDateMM.equals("") && !l_betweenFromDateYYYY.equals("")) {
				m_dateClause += (" (" + l_tableCol + " between to_date('" + l_betweenFromDateYYYY + "-" + l_betweenFromDateMM + "-01','yyyy-mm-dd') and ");
			} else { // only YEAR is specified
				m_dateClause += (" (" + l_tableCol + " between to_date('" + l_betweenFromDateYYYY + "-01-01','yyyy-mm-dd') and ");
			}

			// To Date
			if (!l_betweenToDateDD.equals("")) {
				m_dateClause += ("to_date('" + l_betweenToDateYYYY + "-" + l_betweenToDateMM + "-" + l_betweenToDateDD + "','yyyy-mm-dd')) ");
			} else if (!l_betweenToDateMM.equals("") && !l_betweenToDateYYYY.equals("")) {

				if (l_betweenToDateMM.equals("02")) {
					// do some leap year testing
					GregorianCalendar cal = new GregorianCalendar();
					if (cal.isLeapYear(Integer.parseInt(l_betweenToDateYYYY))) {
						m_dateClause += ("to_date('" + l_betweenToDateYYYY + "-02-29','yyyy-mm-dd')) ");
					} else {
						m_dateClause += ("to_date('" + l_betweenToDateYYYY + "-02-28','yyyy-mm-dd')) ");
					}

				} else {
					// lets get the last date of the given month & year
					String num_of_days = Integer.toString(search.getNumberOfDays(l_betweenToDateMM, Integer.parseInt(l_betweenToDateYYYY)));
					m_dateClause += ("to_date('" + l_betweenToDateYYYY + "-" + l_betweenToDateMM + "-" + num_of_days + "','yyyy-mm-dd')) ");
				}

			} else { // only YEAR is specified
				m_dateClause += ("to_date('" + l_betweenToDateYYYY + "-12-31','yyyy-mm-dd')) ");
			}
		}

		return m_dateClause;
	}

}
