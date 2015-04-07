/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Ausstage

   File: Search.java

Purpose: Provides Search object functions.

 ***************************************************/

package ausstage;

import admin.Common;
import ausstage.Database;
import java.sql.*;
import sun.jdbc.rowset.*;
import java.lang.Character;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.GregorianCalendar;

public class Search {
	private Database m_db;
	private String m_id = "";
	private String m_orderBy = "";
	private String m_collectingInstitution = "";
	private String m_work = "";
	private String m_event = "";
	private String m_contributor = "";
	private String m_venue = "";
	private String m_organisation = "";
	private String m_title = "";
	private String m_creator = "";
	private String m_source = "";
	private String m_key_word = "";
	private String m_sql_switch = "";
	private String m_yyyyfirst_date = "";
	private String m_mmfirst_date = "";
	private String m_ddfirst_date = "";
	private String m_yyyybetween_from_date = "";
	private String m_mmbetween_from_date = "";
	private String m_ddbetween_from_date = "";
	private String m_yyyybetween_to_date = "";
	private String m_mmbetween_to_date = "";
	private String m_ddbetween_to_date = "";
	// Copyright date variables
	private String m_yyyycopyright_date = "";
	private String m_mmcopyright_date = "";
	private String m_ddcopyright_date = "";
	private String m_search_for = "";
	private String m_sort_by = "";
	private String m_sort_Ord = "";
	private StringBuffer m_sql_string = new StringBuffer("");
	private CachedRowSet m_rset;
	private String m_record_count = "0";
	private String m_search_within_result_str = "";
	// defaulted to always show resources
	private String m_showResources = "";
	private String[] m_sub_Type_lov_id; // used when searching resources
	private String[] m_secondary_genre;
	private admin.Common common = new admin.Common();

	public Search(Database p_db) {
		m_db = p_db;
	}

	// pw changed following
	public Search(Database p_db, java.sql.Connection p_connection) {
		// m_db = p_db;
		p_db.m_conn = p_connection;
		m_db = p_db;
	}

	private void buildSqlSearchString() {
		// ///////////////////////////////////
		// KEYWORD(S)
		// ///////////////////////////////////
		if (m_key_word.indexOf(" ") != -1) { // multiple keywords
			m_sql_string.append(getFormattedMultipleKeyWords(m_key_word.toLowerCase(), "combined_all"));

			// /////////////////////////////////////////////////////////
			// DEAL WITH NEW & OLD WHERE CLAUSE (search within result)
			// /////////////////////////////////////////////////////////
			if (m_search_within_result_str.equals(""))
				m_search_within_result_str = getFormattedMultipleKeyWords(m_key_word.toLowerCase(), "combined_all");
			else
				m_sql_string.append(" and " + m_search_within_result_str);

		} else { // single keyword
			m_sql_string.append("MATCH (combined_all) AGAINST ('" + m_db.plSqlSafeString(m_key_word).toLowerCase() + "')");

			// /////////////////////////////////////////////////////////
			// DEAL WITH NEW & OLD WHERE CLAUSE (search within result)
			// /////////////////////////////////////////////////////////
			if (m_search_within_result_str.equals(""))
				m_search_within_result_str = m_key_word;
			else
				m_sql_string.append(" and MATCH (combined_all) AGAINST ('" + m_search_within_result_str.toLowerCase() + "')");
		}
		// //////////////
		// ///////////////////
		// DATES
		// ///////////////////////////////////
		// NOTE: all dates MUST be in yyyy-mm-dd format
		if (m_yyyyfirst_date != null && !m_yyyyfirst_date.equals("")) {
			// //////////////////////////
			// FIRST DATE ON
			// //////////////////////////
			if (!m_ddfirst_date.equals("")) {
				m_sql_string.append(" and search_event.first_date=STR_TO_DATE('" + m_yyyycopyright_date + "-" + m_mmcopyright_date + "-" + m_ddcopyright_date + "','%Y-%m-%d') ");

			} else if (!m_mmcopyright_date.equals("") && !m_yyyycopyright_date.equals("")) {

				if (m_mmcopyright_date.equals("02")) {

					// do some leap year testing
					GregorianCalendar cal = new GregorianCalendar();
					if (cal.isLeapYear(Integer.parseInt(m_yyyyfirst_date))) {
						m_sql_string.append(" and (search_event.first_date between STR_TO_DATE('" + m_yyyyfirst_date + "-02-01','%Y-%m-%d') and ");
						m_sql_string.append("STR_TO_DATE('" + m_yyyyfirst_date + "-02-29','%Y-%m-%d')) ");
					} else {
						m_sql_string.append(" and (search_event.first_date between STR_TO_DATE('" + m_yyyyfirst_date + "-02-01','%Y-%m-%d') and ");
						m_sql_string.append("STR_TO_DATE('" + m_yyyyfirst_date + "-02-28','%Y-%m-%d')) ");
					}
				} else {
					// lets get the last date of the given month & year
					String num_of_days = Integer.toString(getNumberOfDays(m_mmfirst_date, Integer.parseInt(m_yyyyfirst_date)));

					m_sql_string.append(" and (search_event.first_date between STR_TO_DATE('" + m_yyyyfirst_date + "-" + m_mmfirst_date + "-01','%Y-%m-%d') and ");
					m_sql_string.append("STR_TO_DATE('" + m_yyyyfirst_date + "-" + m_mmfirst_date + "-" + num_of_days + "','%Y-%m-%d')) ");
				}
			} else { // only YEAR is specified

				m_sql_string.append(" and (search_event.first_date between STR_TO_DATE('" + m_yyyyfirst_date + "-01-01','%Y-%m-%d') and ");
				m_sql_string.append("STR_TO_DATE('" + m_yyyyfirst_date + "-12-31','%Y-%m-%d')) ");
			}
		} else if ((m_yyyybetween_from_date != null && !m_yyyybetween_from_date.equals("")) && (m_yyyybetween_to_date != null && !m_yyyybetween_to_date.equals(""))) {

			if (m_search_for.equals("contributor")) {
				m_sql_string.append(" and YYYYDATE_OF_BIRTH is not null and");
				buildBetweenDateWhereClause(" STR_TO_DATE( concat(YYYYDATE_OF_BIRTH, '-01-01'),'yyyy-mm-dd'  ) ");
			} else {
				// System.out.println("Year is" + m_yyyyfirst_date);
				// System.out.println("In here");
				m_sql_string.append(" and ");
				buildBetweenDateWhereClause(" search_event.first_date ");
			}
		}
		
		// if search all check if resources are to be included in the results
		// normal query does not limit on the resource flag, so only apply
		// filter if hiding resources
		if (!m_showResources.equals("")) {
			if (m_showResources.equals("Y")) {
				m_sql_string.append(" and (resource_flag = 'Y' OR resource_flag = 'ONLINE') ");
			} else {
				m_sql_string.append(" and resource_flag = '" + m_showResources + "' ");
			}
		}

		// ///////////////////////////////////
		// ORDER BY
		// ///////////////////////////////////

		if (m_search_for.equals("all") || m_search_for.equals("event")) {
			if (m_sort_by.equals("date"))
				m_sql_string.append(" group by eventid order by first_date desc, event_name asc");
			else if (m_sort_by.equals("id"))
				m_sql_string.append(" group by eventid order by eventid asc, event_name asc");
			else if (m_sort_by.equals("state"))
				m_sql_string.append(" group by eventid order by venue_state asc, event_name asc");
			else if (m_sort_by.equals("venue"))
				m_sql_string.append(" group by eventid order by venue_name asc, first_date desc");
			else if (m_sort_by.equals("alphab_rvrs"))
				m_sql_string.append(" group by eventid order by event_name desc, first_date asc");
			else if (m_sort_by.equals("alphab_frwd"))
				m_sql_string.append(" group by eventid order by event_name asc, first_date asc");
			else if (!m_orderBy.equals(""))
				m_sql_string.append(" group by eventid order by " + m_orderBy + " " + m_sort_Ord);
			else
				m_sql_string.append(" group by eventid order by event_name, first_date asc");
			System.out.println("Order BY: " + m_orderBy);

		} else if (m_search_for.equals("venue")) {

			if (m_sort_by.equals("alphab_frwd"))
				m_sql_string.append(" group by venueid order by venue_name asc, venue_state asc");
			else if (m_sort_by.equals("state"))
				m_sql_string.append(" group by venueid order by venue_state asc, venue_name asc");
			else if (m_sort_by.equals("id"))
				m_sql_string.append(" group by venueid order by venueid asc");
			else if (!m_orderBy.equals(""))
				m_sql_string.append(" group by venueid order by " + m_orderBy);
			else
				// default to alphab_frwrd
				m_sql_string.append(" group by venueid order by venue_name asc, venue_state asc");

		} else if (m_search_for.equals("contributor")) {

			if (m_sort_by.equals("alphab_frwd"))
				m_sql_string.append(" group by search_contributor.contributorid order by contrib_name asc, contrib_state asc");
			else if (m_sort_by.equals("state"))
				m_sql_string.append(" group by search_contributor.contributorid order by contrib_state asc, contrib_name asc");
			else if (m_sort_by.equals("id"))
				m_sql_string.append(" group by search_contributor.contributorid order by contributorid asc");
			else if (m_sort_by.equals("date"))
				m_sql_string.append(" group by search_contributor.contributorid order by event_dates");
			else if (!m_orderBy.equals(""))
				m_sql_string.append(" group by search_contributor.contributorid order by " + m_orderBy);
			else
				// default to alphab_frwrd
				m_sql_string.append(" group by search_contributor.contributorid order by contrib_name asc, contrib_state asc");

		} else if (m_search_for.equals("organisation")) {

			if (m_sort_by.equals("alphab_frwd"))
				m_sql_string.append(" group by search_organisation.organisationid order by name asc, org_state asc");
			else if (m_sort_by.equals("state"))
				m_sql_string.append(" group by search_organisation.organisationid order by org_state asc, name asc");
			else if (m_sort_by.equals("id"))
				m_sql_string.append(" group by search_organisation.organisationid order by organisationid asc");
			else if (!m_orderBy.equals(""))
				m_sql_string.append(" group by search_organisation.organisationid order by " + m_orderBy);
			else
				// default to alphab_frwrd
				m_sql_string.append(" group by search_organisation.organisationid order by name asc, org_state asc");

		} else if (m_search_for.equals("work")) {
			if (m_sort_by.equals("alphab_frwd"))
				m_sql_string.append(" group by workid order by work_title");
			else if (!m_orderBy.equals(""))
				m_sql_string.append(" group by workid order by " + m_orderBy);
			else
				// default to alphab_frwrd
				m_sql_string.append(" group by workid order by work_title" + m_orderBy);
		}
	}

	private void buildBetweenDateWhereClause(String l_date_field) {
		// //////////////////////////
		// BETWEEN DATES
		// //////////////////////////

		// From Date
		if (!m_ddbetween_from_date.equals("")) {
			m_sql_string.append("  (" + l_date_field + " between STR_TO_DATE('" + m_yyyybetween_from_date + "-" + m_mmbetween_from_date + "-" + m_ddbetween_from_date
					+ "','%Y-%m-%d') and ");
		} else if (!m_mmbetween_from_date.equals("") && !m_yyyybetween_from_date.equals("")) {
			m_sql_string.append("  (" + l_date_field + " between STR_TO_DATE('" + m_yyyybetween_from_date + "-" + m_mmbetween_from_date + "-01','%Y-%m-%d') and ");
		} else {
			if (!m_yyyybetween_from_date.equals("")) {// only YEAR is specified
				m_sql_string.append("  (" + l_date_field + " between STR_TO_DATE('" + m_yyyybetween_from_date + "-01-01','%Y-%m-%d') and ");
			}
		}

		// To Date
		if (!m_ddbetween_to_date.equals("")) {
			m_sql_string.append("STR_TO_DATE('" + m_yyyybetween_to_date + "-" + m_mmbetween_to_date + "-" + m_ddbetween_to_date + "','%Y-%m-%d')) ");
		} else if (!m_mmbetween_to_date.equals("") && !m_yyyybetween_to_date.equals("")) {

			if (m_mmbetween_to_date.equals("02")) {
				// do some leap year testing
				GregorianCalendar cal = new GregorianCalendar();
				if (cal.isLeapYear(Integer.parseInt(m_yyyybetween_to_date))) {
					m_sql_string.append("STR_TO_DATE('" + m_yyyybetween_to_date + "-02-29','%Y-%m-%d')) ");
				} else {
					m_sql_string.append("STR_TO_DATE('" + m_yyyybetween_to_date + "-02-28','%Y-%m-%d')) ");
				}

			} else {
				// lets get the last date of the given month & year
				String num_of_days = Integer.toString(getNumberOfDays(m_mmbetween_to_date, Integer.parseInt(m_yyyybetween_to_date)));
				m_sql_string.append("STR_TO_DATE('" + m_yyyybetween_to_date + "-" + m_mmbetween_to_date + "-" + num_of_days + "','%Y-%m-%d')) ");
			}

		} else { // only YEAR is specified
			if (!m_yyyybetween_from_date.equals("")) {
				m_sql_string.append("STR_TO_DATE('" + m_yyyybetween_to_date + "-12-31','%Y-%m-%d')) ");
			}
		}
	}

	private void buildDateWhereClause(String l_date_field) {

		if (m_yyyyfirst_date != null && !m_yyyyfirst_date.equals("")) {

			// //////////////////////////
			// COPYRIGHT DATE ON
			// //////////////////////////

			// assume that if here then dd mm and yyyy are populated and make a
			// valid date
			// if the dd, mm and yyyy are not populated then, look at between
			// date fields
			//
			if (!m_ddfirst_date.equals("")) {
				m_sql_string.append("  " + l_date_field + " =STR_TO_DATE('" + m_yyyyfirst_date + "-" + m_mmfirst_date + "-" + m_ddfirst_date + "','%Y-%m-%d') ");

			} else if (!m_mmfirst_date.equals("") && !m_yyyyfirst_date.equals("")) {

				if (m_mmfirst_date.equals("02")) {

					// do some leap year testing
					GregorianCalendar cal = new GregorianCalendar();
					if (cal.isLeapYear(Integer.parseInt(m_yyyyfirst_date))) {
						m_sql_string.append("  (" + l_date_field + " between STR_TO_DATE('" + m_yyyyfirst_date + "-02-01','%Y-%m-%d') and ");
						m_sql_string.append("STR_TO_DATE('" + m_yyyyfirst_date + "-02-29','%Y-%m-%d')) ");
					} else {
						m_sql_string.append("  (" + l_date_field + " between STR_TO_DATE('" + m_yyyyfirst_date + "-02-01','%Y-%m-%d') and ");
						m_sql_string.append("STR_TO_DATE('" + m_yyyyfirst_date + "-02-28','%Y-%m-%d')) ");
					}

				} else {
					// lets get the last date of the given month & year
					String num_of_days = Integer.toString(getNumberOfDays(m_mmfirst_date, Integer.parseInt(m_yyyyfirst_date)));

					m_sql_string.append("  (" + l_date_field + " between STR_TO_DATE('" + m_yyyyfirst_date + "-" + m_mmfirst_date + "-01','%Y-%m-%d') and ");
					m_sql_string.append("STR_TO_DATE('" + m_yyyyfirst_date + "-" + m_mmfirst_date + "-" + num_of_days + "','%Y-%m-%d')) ");
				}

			} else { // only YEAR is specified
				m_sql_string.append("  (" + l_date_field + " between STR_TO_DATE('" + m_yyyyfirst_date + "-01-01','%Y-%m-%d') and ");
				m_sql_string.append("STR_TO_DATE('" + m_yyyyfirst_date + "-12-31','%Y-%m-%d')) ");
			}
		}
	}

	/*
	 * This method only to be used in building the Resource Search String
	 */

	private void buildResourceSqlSearchString() {

		String subTypes = "";
		String secGenre = "";

		// ///////////////////////////////////
		// KEYWORD(S)
		// ///////////////////////////////////
		if (m_key_word != null && !m_key_word.trim().equals("")) {
			if (m_key_word.indexOf(" ") != -1) { // multiple keywords
				m_sql_string.append(getFormattedMultipleKeyWords(m_key_word, "combined_all"));

				// /////////////////////////////////////////////////////////
				// DEAL WITH NEW & OLD WHERE CLAUSE (search within result)
				// /////////////////////////////////////////////////////////
				if (m_search_within_result_str.equals(""))
					m_search_within_result_str = getFormattedMultipleKeyWords(m_key_word, "combined_all");
				else
					m_sql_string.append(" and " + m_search_within_result_str);

			} else { // single keyword
				//m_sql_string.append("MATCH (combined_all) AGAINST ('" + m_db.plSqlSafeString(m_key_word.toLowerCase()) + "') ");
				m_sql_string.append("soundex_match('" + m_key_word + "', combined_all, ' ')");

				// /////////////////////////////////////////////////////////
				// DEAL WITH NEW & OLD WHERE CLAUSE (search within result)
				// /////////////////////////////////////////////////////////
				if (m_search_within_result_str.equals(""))
					m_search_within_result_str = m_key_word;
				else
					m_sql_string.append(" and " + m_search_within_result_str);
			}

		} else {
			// No key word entered, put a dummy clause in
			m_sql_string.append("1=1 ");
		}

		// ///////////////////////////////////
		// DATES
		// ///////////////////////////////////
		// NOTE: all dates MUST be in yyyy-mm-dd format

		if (m_yyyyfirst_date != null && !m_yyyyfirst_date.equals("")) {
			m_sql_string.append(" and ( ");
			buildDateWhereClause(" COPYRIGHT_DATE ");
			m_sql_string.append(" OR ");
			buildDateWhereClause(" CREATED_DATE ");
			m_sql_string.append(" OR ");
			buildDateWhereClause(" ISSUED_DATE ");
			m_sql_string.append(" OR ");
			buildDateWhereClause(" ACCESSIONED_DATE ");
			m_sql_string.append(" ) ");

		}

		if (m_yyyybetween_to_date != null && !m_yyyybetween_to_date.equals("") && m_yyyybetween_from_date != null && !m_yyyybetween_from_date.equals("")) {
			m_sql_string.append(" and ( ");
			buildBetweenDateWhereClause(" COPYRIGHT_DATE ");
			m_sql_string.append(" OR ");
			buildBetweenDateWhereClause(" CREATED_DATE ");
			m_sql_string.append(" OR ");
			buildBetweenDateWhereClause(" ISSUED_DATE ");
			m_sql_string.append(" OR ");
			buildBetweenDateWhereClause(" ACCESSIONED_DATE ");
			m_sql_string.append(" ) ");
		}

		// ///////////////////////////////////
		// SubType - only do if selected
		// ///////////////////////////////////
		if (m_sub_Type_lov_id != null && m_sub_Type_lov_id.length > 0) {
			for (int i = 0; i < m_sub_Type_lov_id.length; i++) {
				if (i == 0) {
					subTypes = m_sub_Type_lov_id[i];
				} else {
					subTypes = subTypes + "," + m_sub_Type_lov_id[i];
				}

			}
			m_sql_string.append(" and item_sub_type_lov_id in (" + subTypes + ")");
		}

		/*
		 * f_firstdate_dd f_firstdate_mm f_firstdate_yyyy
		 */
		if (m_collectingInstitution != null && !m_collectingInstitution.equals("")) {
			m_sql_string.append(" and INSTITUTIONID in (" + m_collectingInstitution + ")");
		}

		if (m_work != null && !m_work.equals("")) {
			m_sql_string.append(" and itemid in (SELECT itemid " + "                  FROM ITEMWORKLINK IW, WORK W " + "                 WHERE w.workid = iw.workid"
					+ "                   and upper(work_title) LIKE '%" + m_work.toUpperCase() + "%' )");
		}
		if (m_event != null && !m_event.equals("")) {
			m_sql_string.append(" and itemid in (SELECT itemid " + "                  FROM ITEMEVLINK IE, EVENTS E " + "                 WHERE e.eventid = ie.eventid"
					+ "                   and upper(event_name) LIKE '%" + m_event.toUpperCase() + "%' )");
		}

		if (m_contributor != null && !m_contributor.equals("")) {
			m_sql_string.append(" and itemid in (SELECT itemid " + "                  FROM ITEMCONLINK IC, CONTRIBUTOR C "
					+ "                 WHERE c.CONTRIBUTORID = ic.CONTRIBUTORID" + "                   AND CREATOR_FLAG ='N' "
					+ "                   and upper(concat_ws(' ', FIRST_NAME, LAST_NAME)) LIKE '%" + m_contributor.toUpperCase() + "%' )");
		}

		if (m_venue != null && !m_venue.equals("")) {

			m_sql_string.append(" and itemid in (SELECT itemid " + "                  FROM ITEMVENUELINK IV, VENUE V " + "                 WHERE v.VENUEID = iv.VENUEID"
					+ "                   and upper(VENUE_NAME) LIKE '%" + m_venue.toUpperCase() + "%' )");
		}

		if (m_organisation != null && !m_organisation.equals("")) {
			m_sql_string.append(" and itemid in (SELECT itemid " + "                  FROM ITEMORGLINK IO, ORGANISATION O "
					+ "                 WHERE o.ORGANISATIONID = io.ORGANISATIONID" + "                   AND (CREATOR_FLAG ='N' OR CREATOR_FLAG is null)"
					+ "                   and upper(NAME) LIKE '%" + m_organisation.toUpperCase() + "%' )");
		}

		if (m_title != null && !m_title.equals("")) {
			m_sql_string.append(" and upper(TITLE) LIKE '%" + m_title.toUpperCase() + "%' ");
		}

		if (m_creator != null && !m_creator.equals("")) {
			m_sql_string.append(" and  " + "itemid in (SELECT itemid " + "                  FROM ITEMORGLINK IO, ORGANISATION O "
					+ "                 WHERE o.ORGANISATIONID = io.ORGANISATIONID" + "                   AND CREATOR_FLAG ='Y' " + "                   and upper(NAME) LIKE '%"
					+ m_creator.toUpperCase() + "%'  " + "                 UNION " + "                SELECT itemid " + "                  FROM ITEMCONLINK IC, CONTRIBUTOR C "
					+ "                 WHERE c.CONTRIBUTORID = ic.CONTRIBUTORID" + "                   AND CREATOR_FLAG ='Y' "
					+ "                   and upper(concat_ws(' ', FIRST_NAME, LAST_NAME)) LIKE '%" + m_creator.toUpperCase() + "%' )" + "");
		}

		if (m_source != null && !m_source.equals("")) {
			m_sql_string.append(" and sourceid in (select itemid from item where upper(title) LIKE '%" + m_source.toUpperCase() + "%' )");
		}

		if (m_secondary_genre != null) {

			for (int i = 0; i < m_secondary_genre.length; i++) {
				if (i == 0) {
					secGenre = m_secondary_genre[i];
				} else {
					secGenre = secGenre + "," + m_secondary_genre[i];
				}
			}

			m_sql_string.append(" and itemid in (SELECT itemid " + "                  FROM ITEMSECGENRELINK IW" + "                 WHERE SECGENREPREFERREDID  IN (" + secGenre
					+ " ))");
		}
// Edit by Brad Williams 8/12/2014 fix search online resources bug.
		if (!m_showResources.equals("")) {
			if (m_showResources.equals("ONLINE")) {
				m_sql_string.append(" and if((item_url IS NULL || item_url = '' || item_url = ' '),' ','ONLINE') = '" + m_showResources + "' ");
			}
		}

		// ///////////////////////////////////
		// ORDER BY
		// ///////////////////////////////////
		if (m_sort_by.equals("date"))
			m_sql_string.append(" order by citation_date desc, item_sub_type asc");
		else if (m_sort_by.equals("type"))
			m_sql_string.append(" order by item_sub_type asc, title asc");
		else if (m_sort_by.equals("title"))
			m_sql_string.append(" order by title asc, item_sub_type asc");
		else if (m_sort_by.equals("source"))
			m_sql_string.append(" order by SOURCE_CITATION asc, item_sub_type asc");
		else if (m_sort_by.equals("citation"))
			m_sql_string.append(" order by citation asc, item_sub_type asc");
		else if (!m_orderBy.equals(""))
			m_sql_string.append(" order by " + m_orderBy);
		else
			// default order
			m_sql_string.append(" order by item_sub_type asc, title asc");

	}

	/*******************
	 * GET FUNCTIONS
	 *******************/
	private String getFormattedMultipleKeyWords(String l_key_word, String field) {
		String[] words = l_key_word.split(" +");
		String l_retString = "";
		// System.out.println("sql switch: " + m_sql_switch);
		// System.out.println("l_key_word: " + l_key_word);
		// System.out.println("field: " + field);

		if (field.equals("combined_all")) {
			// If the switch is "and" then add a plus to each word
			for (int i = 0; i < words.length; i++) {
				l_retString += (m_sql_switch.equals("and") ? " +" : " ") + words[i];
			}

			// Add quotes around the string if it's an exact phrase
			if (m_sql_switch.equals("exact")) {
				l_retString = "\"" + l_retString.trim() + "\"";
			}

			return " MATCH(" + field + ") AGAINST ('" + m_db.plSqlSafeString(l_retString).toLowerCase() + "' IN BOOLEAN MODE) ";
		} else {
			// For exact phrases just return the sql
			if (m_sql_switch.equals("exact")) {
				return " upper(" + field + ") LIKE '%" + m_db.plSqlSafeString(l_key_word.toUpperCase()) + "%' ";
			}

			// For "and" and "or" loop through the words and add the switch
			// between
			l_retString = " (upper(" + field + ") LIKE '%" + m_db.plSqlSafeString(words[0].toUpperCase()) + "%' ";
			if (words.length > 1) {
				for (int i = 1; i < words.length; i++) {
					l_retString += (m_sql_switch + " upper(" + field + ") LIKE '%" + m_db.plSqlSafeString(words[i].toUpperCase()) + "%' ");
				}
			}

			return l_retString;
		}
	}

	public CachedRowSet getAll() {
		Statement l_stmt;
		CachedRowSet l_crset = null;
		String m_sql_items = "search_all.eventid, event_name, venue_name, suburb, venue_state, first_date, resource_flag, count(distinct itemevlink.itemid) as total";
		m_sql_string.append("select distinct " + m_sql_items + " from search_all left join itemevlink on itemevlink.eventid = search_all.eventid ");
		m_sql_string.append("where ");
		// lets build the search string
		buildSqlSearchString();
		try {
			l_stmt = m_db.m_conn.createStatement();
			l_crset = m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
			l_stmt.close();
			// System.out.println("SQL STRING: " + m_sql_string.toString());

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getAll()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("SQL STRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		// DEBUG SQL STATEMENT
		System.out.println("m_sql_string = " + m_sql_string.toString());

		return (l_crset);
	}

	/*
	 * Following method specifically for invoke through the BSService. It
	 * returns XML formatted output.
	 */
	public CachedRowSet getAll(boolean calling_from_BSService) {
		Statement l_stmt;
		CachedRowSet l_crset = null;

		if (calling_from_BSService) {

			System.out.println("Executing method Search.getAll(calling_from_BSService)");
			String m_sql_items = "eventid, event_name, venue_name, suburb, venue_state, first_date, resource_flag";
			m_sql_string.append("select distinct " + m_sql_items + " from search_all ");
			m_sql_string.append("where ");
			// lets build the search string
			buildSqlSearchString();

			// lets alter search query for BSService
			String temp_result_table = "search_all_result";
			// alter the query to return XML formatted output from DB
			String altered_query = ConstructXMLQuery(m_sql_items, temp_result_table);
			altered_query = altered_query + m_sql_string.toString();
			altered_query = altered_query + ") as " + temp_result_table;

			try {
				l_stmt = m_db.m_conn.createStatement();

				l_crset = m_db.runSQL(altered_query, l_stmt);
				l_stmt.close();
				System.out.println("SQL STRING: " + altered_query);

			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in Search.getAll(boolean calling_from_BSService)");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("SQL STRING: " + m_sql_string.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
		return (l_crset);
	}

	/***** Construct select query string in following format ******/
	/*
	 * select fn_xml_tag('ALL_ROW',null,null, concat(
	 * fn_xml_tag('EVENTID',search_all_result.eventid,null,null),
	 * fn_xml_tag('EVENT_NAME',search_all_result.event_name,null,null),
	 * fn_xml_tag('VENUE_NAME',search_all_result.venue_name,null,null),
	 * fn_xml_tag('SUBURB',search_all_result.suburb,null,null),
	 * fn_xml_tag('VENUE_STATE',search_all_result.venue_state,null,null),
	 * fn_xml_tag('FIRST_DATE',search_all_result.first_date,null,null),
	 * fn_xml_tag('RESOURCE_FLAG',search_all_result.resource_flag,null,null)))
	 * from (
	 */
	public String ConstructXMLQuery(String table_column_list, String result_name) {
		StringBuilder xml_query = new StringBuilder("select fn_xml_tag('ALL_ROW',null,null,concat(");
		StringTokenizer st_value = new StringTokenizer(table_column_list, ",");
		String alter_value = "";
		while (st_value.hasMoreTokens()) {
			alter_value = st_value.nextToken().trim();
			xml_query.append("fn_xml_tag('" + alter_value + "'," + result_name + "." + alter_value + ",null,null),");
		}
		// Remove last comma value and construct full select statement
		alter_value = xml_query.substring(0, xml_query.length() - 1) + " )) from (";
		return alter_value;
	}

	public CachedRowSet getEvent() {

		m_sql_string.append("select * from search_event where eventid = ");
		m_sql_string.append(m_id);

		try {

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getEvent()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		// DEBUG SQL STATEMENT
		// System.out.println("m_sql_string = " + m_sql_string.toString());
		return (m_rset);
	}

	/*
	 * Following method specifically for invoke through the BSService. It
	 * returns XML formatted output.
	 */
	public CachedRowSet getEvents(boolean calling_from_BSService) {
		m_rset = null;
		if (calling_from_BSService) {

			System.out.println("Executing method Search.getEvents(calling_from_BSService)");
			String m_sql_items = "eventid, event_name, venue_name, suburb, venue_state, first_date,  resource_flag ";
			m_sql_string.append("select distinct " + m_sql_items + "  from search_event where ");
			buildSqlSearchString();

			// lets alter search query for BSService
			String temp_result_table = "get_Events";
			// alter the query to return XML formatted output from DB
			String altered_query = ConstructXMLQuery(m_sql_items, temp_result_table);
			altered_query = altered_query + m_sql_string.toString();
			altered_query = altered_query + ") as " + temp_result_table;

			try {
				Statement l_stmt;
				l_stmt = m_db.m_conn.createStatement();
				m_rset = m_db.runSQL(altered_query, l_stmt);
				System.out.println("SQL STRING(events): " + altered_query);
				l_stmt.close();
			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in Search.getEvents(calling_from_BSService)");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
		return (m_rset);
	}

	public CachedRowSet getEvents() {

		String m_sql_items = "search_event.eventid, search_event.event_name, search_event.venue_name, search_event.suburb, search_event.venue_state, search_event.first_date, search_event.resource_flag, count(distinct itemevlink.itemid) as total, events.ddfirst_date, events.mmfirst_date, events.yyyyfirst_date";
		m_sql_string.append("select distinct " + m_sql_items + "  from search_event inner join events on events.eventid = search_event.eventid left join itemevlink on itemevlink.eventid = search_event.eventid where ");
		buildSqlSearchString();
		try {
			Statement l_stmt;
			l_stmt = m_db.m_conn.createStatement();
			m_rset = m_db.runSQL(new String(m_sql_string.toString()), l_stmt);
			System.out.println("SQL STRING(events): " + m_sql_string.toString());
			l_stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getEvents()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		// DEBUG SQL STATEMENT
		// System.out.println("m_sql_string = " + m_sql_string.toString());
		return (m_rset);
	}

	/*
	 * Query to do the Resources search
	 */

	public CachedRowSet getResources() {

		// just select the fields that will be good for the distinct
		String m_sql_items = "search_resource.itemid, search_resource.item_sub_type_lov_id,search_resource.item_sub_type,"
				+ "  search_resource.copyright_date,  search_resource.issued_date, search_resource.accessioned_date,  search_resource.citation_date,"
				+ " search_resource.source_citation,search_resource.citation,search_resource.title" + ", if(ITEM_URL is null,' ','ONLINE') resource_flag";
		m_sql_string.append("select distinct " + m_sql_items + " from search_resource where ");
		buildResourceSqlSearchString();

		try {
			Statement l_stmt;
			l_stmt = m_db.m_conn.createStatement();

			m_rset = m_db.runSQL(new String(m_sql_string.toString()), l_stmt);
			System.out.println("SQL STRING(resources): " + m_sql_string.toString());
			l_stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getResources()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		// DEBUG SQL STATEMENT
		// System.out.println("m_sql_string = " + m_sql_string.toString());
		return (m_rset);
	}

	/*
	 * Following method specifically for invoke through the BSService. It
	 * returns XML formatted output.
	 */
	public CachedRowSet getResources(boolean calling_from_BSService) {
		m_rset = null;
		if (calling_from_BSService) {

			System.out.println("Executing method Search.getResources(calling_from_BSService)");
			// just select the fields that will be good for the distinct
			String m_sql_items = "itemid, item_sub_type_lov_id,item_sub_type," + "  copyright_date,  issued_date, accessioned_date,  citation_date,"
					+ " source_citation,citation,title" + ", ITEM_URL";
			m_sql_string.append("select distinct " + m_sql_items + " from search_resource where ");
			buildResourceSqlSearchString();

			// lets alter search query for BSService
			String temp_result_table = "get_Events";
			// alter the query to return XML formatted output from DB
			String altered_query = ConstructXMLQuery(m_sql_items, temp_result_table);
			altered_query = altered_query + m_sql_string.toString();
			altered_query = altered_query + ") as " + temp_result_table;

			try {
				Statement l_stmt;
				l_stmt = m_db.m_conn.createStatement();
				m_rset = m_db.runSQL(altered_query, l_stmt);
				System.out.println("SQL STRING(resources): " + altered_query);
				l_stmt.close();
			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in Search.getResources(calling_from_BSService)");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
		return (m_rset);
	}

	public CachedRowSet getWhatsOn(String l_state) {

		m_sql_string
				.append("SELECT  distinct search_event.eventid,search_event.event_name,search_event.venue_name,search_event.venue_state,search_event.suburb,events.yyyyfirst_date,events.mmfirst_date,events.ddfirst_date,  events.mmlast_date, events.ddlast_date,  events.yyyylast_date, events.first_date, events.last_date FROM events, search_event WHERE events.eventid = search_event.eventid AND events.MMFIRST_DATE is not null AND events.DDFIRST_DATE is not null AND events.YYYYFIRST_DATE is not null AND LENGTH(events.YYYYFIRST_DATE) =4 AND search_event.venue_state = '"
						+ l_state
						+ "' AND((events.MMLAST_DATE is not null AND events.DDLAST_DATE is not null AND events.YYYYLAST_DATE is not null AND events.LAST_DATE >= now())OR(NOT(events.MMLAST_DATE is not null AND events.DDLAST_DATE is not null AND events.YYYYLAST_DATE is not null) AND events.FIRST_DATE >= now())) ORDER BY search_event.suburb, search_event.venue_name,events.YYYYLAST_DATE,events.FIRST_DATE,events.LAST_DATE");

		try {
			Statement l_stmt = m_db.m_conn.createStatement();
			m_rset = m_db.runSQL(new String(m_sql_string.toString()), l_stmt);
			l_stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getWhatsOn()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		// DEBUG SQL STATEMENT
		// System.out.println("m_sql_string = " + m_sql_string.toString());
		return (m_rset);
	}

	/*
	 * Following method specifically for invoke through the BSService. It
	 * returns XML formatted output.
	 */
	public CachedRowSet getVenues(boolean calling_from_BSService) {
		m_rset = null;
		if (calling_from_BSService) {

			System.out.println("Executing method Search.getVenues(calling_from_BSService)");
			String m_sql_items = "venueid, venue_name, street, suburb, venue_state, web_links, resource_flag";
			m_sql_string.append("select distinct " + m_sql_items + " from search_venue where ");
			buildSqlSearchString();

			// lets alter search query for BSService
			String temp_result_table = "get_Events";
			// alter the query to return XML formatted output from DB
			String altered_query = ConstructXMLQuery(m_sql_items, temp_result_table);
			altered_query = altered_query + m_sql_string.toString();
			altered_query = altered_query + ") as " + temp_result_table;

			try {
				Statement l_stmt;
				l_stmt = m_db.m_conn.createStatement();
				m_rset = m_db.runSQL(altered_query, l_stmt);
				System.out.println("SQL STRING(venues): " + altered_query);
				l_stmt.close();
			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in Search.getVenues(calling_from_BSService)");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
		return (m_rset);
	}

	public CachedRowSet getVenues() {

		String m_sql_items = "search_venue.venueid, venue_name, street, suburb, venue_state, web_links, resource_flag, CONCAT_WS('- '  ,min(events.yyyyfirst_date), max(events.yyyylast_date)) dates,count(distinct events.eventid) num, "
				+ " count(distinct itemvenuelink.itemid) as total";
		m_sql_string.append("select distinct " + m_sql_items + " from search_venue " + "LEFT JOIN events ON (search_venue.venueid = events.venueid) "
				+ "LEFT JOIN itemvenuelink ON (search_venue.venueid = itemvenuelink.venueid)where ");
		buildSqlSearchString();

		try {
			Statement l_stmt;
			l_stmt = m_db.m_conn.createStatement();
			m_rset = m_db.runSQL(new String(m_sql_string.toString()), l_stmt);
			System.out.println("SQL STRING(venues): " + m_sql_string.toString());
			l_stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getVenues()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		// DEBUG SQL STATEMENT
		// System.out.println("m_sql_string = " + m_sql_string.toString());
		return (m_rset);
	}

	public CachedRowSet getContributors() {

		String m_sql_items = "search_contributor.contributorid, contrib_name, last_name, first_name, contrib_gender, nationality, date_of_birth_str as date_of_birth, contrib_state, event_dates, DATE_OF_DEATH_STR, DATE_OF_BIRTH_STR, resource_flag,count(distinct itemconlink.itemid) total, count(distinct events.eventid) num, "
				+ " group_concat(distinct contributorfunctpreferred.preferredterm separator ', ') function ";
		m_sql_string.append("select distinct " + m_sql_items + " from search_contributor LEFT JOIN conevlink ON (search_contributor.contributorid = conevlink.contributorid) "
				+ "LEFT JOIN events ON (conevlink.eventid = events.eventid) " + "Left JOIN contfunctlink ON (search_contributor.contributorid = contfunctlink.contributorid) "
				+ "Left JOIN contributorfunctpreferred ON (contfunctlink.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid) "
				+ "Left join itemconlink ON (search_contributor.contributorid = itemconlink.contributorid) where ");
		buildSqlSearchString();

		try {
			Statement l_stmt;
			l_stmt = m_db.m_conn.createStatement();
			m_rset = m_db.runSQL(new String(m_sql_string.toString()), l_stmt);
			System.out.println("SQL STRING(contributors): " + m_sql_string.toString());
			l_stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getContributors()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (m_rset);
	}

	/*
	 * Following method specifically for invoke through the BSService. It
	 * returns XML formatted output.
	 */
	public CachedRowSet getContributors(boolean calling_from_BSService) {
		m_rset = null;

		if (calling_from_BSService) {

			System.out.println("Executing method Search.getContributors(calling_from_BSService)");
			// String m_sql_items =
			// "contributorid, contrib_name, last_name, first_name, contrib_gender, nationality, date_of_birth_str as date_of_birth, contrib_state, event_dates, DATE_OF_DEATH_STR, DATE_OF_BIRTH_STR, resource_flag";
			String m_sql_items = "contributorid, contrib_name, last_name, first_name, contrib_gender, nationality, date_of_birth, contrib_state, event_dates, DATE_OF_DEATH_STR, DATE_OF_BIRTH_STR, resource_flag";
			m_sql_string.append("select distinct " + m_sql_items + " from search_contributor where ");
			buildSqlSearchString();

			// lets alter search query for BSService
			String temp_result_table = "get_Events";
			// alter the query to return XML formatted output from DB
			String altered_query = ConstructXMLQuery(m_sql_items, temp_result_table);
			altered_query = altered_query + m_sql_string.toString();
			altered_query = altered_query + ") as " + temp_result_table;

			try {
				Statement l_stmt;
				l_stmt = m_db.m_conn.createStatement();
				m_rset = m_db.runSQL(altered_query, l_stmt);
				System.out.println("SQL STRING(contributors): " + altered_query);
				l_stmt.close();
			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in Search.getContributors(calling_from_BSService)");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
		return (m_rset);
	}

	/*
	 * Following method specifically for invoke through the BSService. It
	 * returns XML formatted output.
	 */
	public CachedRowSet getOrganisations(boolean calling_from_BSService) {
		m_rset = null;
		if (calling_from_BSService) {

			System.out.println("Executing method Search.getOrganisations(calling_from_BSService)");
			String m_sql_items = "organisationid, name, address, suburb, org_state, web_links, resource_flag";
			m_sql_string.append("select distinct " + m_sql_items + "  from search_organisation where ");
			buildSqlSearchString();

			// lets alter search query for BSService
			String temp_result_table = "get_Events";
			// alter the query to return XML formatted output from DB
			String altered_query = ConstructXMLQuery(m_sql_items, temp_result_table);
			altered_query = altered_query + m_sql_string.toString();
			altered_query = altered_query + ") as " + temp_result_table;

			try {
				Statement l_stmt;
				l_stmt = m_db.m_conn.createStatement();
				m_rset = m_db.runSQL(altered_query, l_stmt);
				System.out.println("SQL STRING(organisations): " + altered_query);
				l_stmt.close();
			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in Search.getOrganisations(calling_from_BSService)");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
		return (m_rset);
	}

	public CachedRowSet getOrganisations() {

		String m_sql_items = "search_organisation.organisationid, name, address, suburb, org_state, web_links, resource_flag,count(distinct events.eventid) num, COUNT(distinct itemorglink.itemid) + COUNT(distinct item.itemid) as total, CONCAT_WS('- ',min(events.yyyyfirst_date), max(events.yyyylast_date)) dates  ";
		m_sql_string
				.append("select distinct " + m_sql_items + "  from search_organisation  LEFT JOIN orgevlink ON (orgevlink.organisationid = search_organisation.organisationid) "
						+ "LEFT JOIN events ON (orgevlink.eventid = events.eventid) "
						+ "LEFT JOIN itemorglink ON (search_organisation.organisationid = itemorglink.organisationid) "
						+ "LEFT JOIN item on (search_organisation.organisationid = item.institutionid) "
						+ "where ");
		buildSqlSearchString();

		try {
			Statement l_stmt;
			l_stmt = m_db.m_conn.createStatement();
			m_rset = m_db.runSQL(new String(m_sql_string.toString()), l_stmt);
			System.out.println("SQL STRING(organisations): " + m_sql_string.toString());
			l_stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getOrganisations()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		// DEBUG SQL STATEMENT
		// System.out.println("m_sql_string = " + m_sql_string.toString());
		return (m_rset);
	}

	public CachedRowSet getWorks() {

		String m_sql_items = "search_work.workid, work_title, alter_work_title, "
				+ "concat_ws(', ', GROUP_CONCAT(distinct if (CONCAT_WS(' ', CONTRIBUTOR.FIRST_NAME ,CONTRIBUTOR.LAST_NAME) = '', null, "
				+ "CONCAT_WS(' ', CONTRIBUTOR.FIRST_NAME ,CONTRIBUTOR.LAST_NAME)) SEPARATOR ', '), group_concat(distinct organisation.name separator ', ')) contrib, "
				+ "count(distinct events.eventid) events,  count(distinct itemworklink.itemid) as resources, "
				+ "concat_ws('- ', MIN(events.yyyyfirst_date), MAX(events.yyyylast_date)) dates";
		m_sql_string.append("select distinct " + m_sql_items + "  from search_work " + "LEFT  JOIN eventworklink ON (search_work.workid = eventworklink.workid) "
				+ "LEFT  JOIN events ON (eventworklink.eventid = events.eventid) " + "LEFT  JOIN workconlink ON (search_work.workid = workconlink.workid) "
				+ "LEFT  JOIN contributor ON (workconlink.contributorid = contributor.contributorid) "
				+ "Left  Join `workorglink` ON (search_work.`workid`= `workorglink`.`workid`) "
				+ "Left  Join `organisation` ON (`workorglink`.`organisationid`= `organisation`.`organisationid`) "
				+ "Left join itemworklink On (search_work.workid = itemworklink.workid) where ");
		buildSqlSearchString();

		try {
			Statement l_stmt;
			l_stmt = m_db.m_conn.createStatement();
			m_rset = m_db.runSQL(new String(m_sql_string.toString()), l_stmt);
			System.out.println("SQL STRING(works): " + m_sql_string.toString());
			l_stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Search.getWorks()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		// DEBUG SQL STATEMENT
		// System.out.println("m_sql_string = " + m_sql_string.toString());
		return (m_rset);
	}

	public int getNumberOfDays(String month, int year) {
		year += 1900;
		// year is given minus 1900
		if (month == "02") {
			if (year % 4 != 0)
				return (28);
			else if (year % 100 != 0)
				return (29);
			else if (year % 400 != 0)
				return (28);
			else
				return (29);
		} else if (month == "01" || month == "03" || month == "05" || month == "07" || month == "08" || month == "10" || month == "12") {
			return 31; // month has 31 days
		} else
			return 30; // month has 30 days
	}

	public String getRecordCount() {
		return (m_record_count);
	}

	public String getSearchWithinResults() {
		return (m_search_within_result_str);
	}

	/*******************
	 * SET FUNCTIONS
	 *******************/
	public void setId(String p_id) {
		m_id = p_id;
	}

	public void setKeyWord(String p_key_word) {
		m_key_word = p_key_word.trim();
	}

	public void setSqlSwitch(String p_sql_switch) {
		m_sql_switch = p_sql_switch;
	}

	public void setCollectionInstitution(String p_collectingInstitution) {
		m_collectingInstitution = p_collectingInstitution;
	}

	public void setWork(String p_work) {
		m_work = p_work;
	}

	public void setCreator(String p_creator) {
		m_creator = p_creator;
	}

	public void setSource(String p_source) {
		m_source = p_source;
	}

	public void setTitle(String p_title) {
		m_title = p_title;
	}

	public void setEvent(String p_event) {
		m_event = p_event;
	}

	public void setContributor(String p_contributor) {
		m_contributor = p_contributor;
	}

	public void setVenue(String p_venue) {
		m_venue = p_venue;
	}

	public void setOrganisation(String p_organisation) {
		m_organisation = p_organisation;
	}

	public void setSecondaryGenre(String[] p_secondary_genre) {
		m_secondary_genre = p_secondary_genre;
	}

	public void setBoolean(String p_boolean) {
	}

	public void setFirstDate(String p_yyyyfirst_date, String p_mmfirst_date, String p_ddfirst_date) {

		if (p_yyyyfirst_date != null) {
			m_yyyyfirst_date = p_yyyyfirst_date;
		}
		;
		if (p_mmfirst_date != null) {
			m_mmfirst_date = p_mmfirst_date;
		}
		;
		if (p_ddfirst_date != null) {
			m_ddfirst_date = p_ddfirst_date;
		}

	}

	public void setBetweenFromDate(String p_yyyybetween_from_date, String p_mmbetween_from_date, String p_ddbetween_from_date) {

		if (p_yyyybetween_from_date != null) {
			m_yyyybetween_from_date = p_yyyybetween_from_date;
		}
		;
		if (p_mmbetween_from_date != null) {
			m_mmbetween_from_date = p_mmbetween_from_date;
		}
		;
		if (p_ddbetween_from_date != null) {
			m_ddbetween_from_date = p_ddbetween_from_date;
		}

	}

	public void setBetweenToDate(String p_yyyybetween_to_date, String p_mmbetween_to_date, String p_ddbetween_to_date) {

		if (p_yyyybetween_to_date != null) {
			m_yyyybetween_to_date = p_yyyybetween_to_date;
		}
		;
		if (p_mmbetween_to_date != null) {
			m_mmbetween_to_date = p_mmbetween_to_date;
		}
		;
		if (p_ddbetween_to_date != null) {
			m_ddbetween_to_date = p_ddbetween_to_date;
		}

	}

	public void setSearchFor(String p_search_for) {
		m_search_for = p_search_for;
	}

	public void setSortBy(String p_sort_by) {
		m_sort_by = p_sort_by;
	}

	public void setSearchWithinResults(String p_search_within_result_str) {
		m_search_within_result_str = p_search_within_result_str;
	}

	public void setSubTypes(String[] p_sub_Type_lov_id) {
		m_sub_Type_lov_id = p_sub_Type_lov_id;
	}

	// set Copyright Date

	public void setCopyrightDate(String p_yyyycopyright_date, String p_mmcopyright_date, String p_ddcopyright_date) {

		if (p_yyyycopyright_date != null) {
			m_yyyycopyright_date = p_yyyycopyright_date;
		}
		;
		if (p_mmcopyright_date != null) {
			m_mmcopyright_date = p_mmcopyright_date;
		}
		;
		if (p_ddcopyright_date != null) {
			m_ddcopyright_date = p_ddcopyright_date;
		}

	}

	// set Copyright Between From Date

	public void setBetweenCopyrightFromDate(String p_yyyycopybetween_from_date, String p_mmcopybetween_from_date, String p_ddcopybetween_from_date) {

		if (p_yyyycopybetween_from_date != null) {
		}
		;
		if (p_mmcopybetween_from_date != null) {
		}
		;
		if (p_ddcopybetween_from_date != null) {
		}

	}

	// set Copyright Between To Date

	public void setBetweenCopyrightToDate(String p_yyyycopybetween_to_date, String p_mmcopybetween_to_date, String p_ddcopybetween_to_date) {

		if (p_yyyycopybetween_to_date != null) {
		}
		;
		if (p_mmcopybetween_to_date != null) {
		}
		;
		if (p_ddcopybetween_to_date != null) {
		}

	}

	// set Issued Date

	public void setIssuedDate(String p_yyyyissued_date, String p_mmissued_date, String p_ddissued_date) {

		if (p_yyyyissued_date != null) {
		}
		;
		if (p_mmissued_date != null) {
		}
		;
		if (p_ddissued_date != null) {
		}

	}

	// set Issued Between From Date

	public void setBetweenIssuedFromDate(String p_yyyyissuedbetween_from_date, String p_mmissuedbetween_from_date, String p_ddissuedbetween_from_date) {

		if (p_yyyyissuedbetween_from_date != null) {
		}
		;
		if (p_mmissuedbetween_from_date != null) {
		}
		;
		if (p_ddissuedbetween_from_date != null) {
		}

	}

	// set Issued Between To Date

	public void setBetweenIssuedToDate(String p_yyyyissuedbetween_to_date, String p_mmissuedbetween_to_date, String p_ddissuedbetween_to_date) {

		if (p_yyyyissuedbetween_to_date != null) {
		}
		;
		if (p_mmissuedbetween_to_date != null) {
		}
		;
		if (p_ddissuedbetween_to_date != null) {
		}

	}

	// set Accessioned Date

	public void setAccessionedDate(String p_yyyyaccessioned_date, String p_mmaccessioned_date, String p_ddaccessioned_date) {

		if (p_yyyyaccessioned_date != null) {
		}
		;
		if (p_mmaccessioned_date != null) {
		}
		;
		if (p_ddaccessioned_date != null) {
		}

	}

	// set Accessioned Between From Date

	public void setBetweenAccessionedFromDate(String p_yyyyaccessionedbetween_from_date, String p_mmaccessionedbetween_from_date, String p_ddaccessionedbetween_from_date) {

		if (p_yyyyaccessionedbetween_from_date != null) {
		}
		;
		if (p_mmaccessionedbetween_from_date != null) {
		}
		;
		if (p_ddaccessionedbetween_from_date != null) {
		}

	}

	// set Accessioned Between To Date

	public void setBetweenAccessionedToDate(String p_yyyyaccessionedbetween_to_date, String p_mmaccessionedbetween_to_date, String p_ddaccessionedbetween_to_date) {

		if (p_yyyyaccessionedbetween_to_date != null) {
		}
		;
		if (p_mmaccessionedbetween_to_date != null) {
		}
		;
		if (p_ddaccessionedbetween_to_date != null) {
		}

	}

	public void setResourceVisible(String showResources) {
		m_showResources = showResources;
	}

	public void setOrderBy(String orderBy) {
		if (orderBy == null) {
			m_orderBy = "";
		} else {
			m_orderBy = orderBy;
		}
	}
}
