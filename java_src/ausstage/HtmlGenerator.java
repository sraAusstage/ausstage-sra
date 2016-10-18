/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Centricminds

   File: HtmlGenerator.java

Purpose: Provides methods used to display HTML on the
         admin side of the AusStage pages.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.util.Hashtable;
import java.util.Enumeration;
import java.util.StringTokenizer;
import ausstage.Database;
import admin.AppConstants;
import sun.jdbc.rowset.CachedRowSet;
import java.sql.Statement;
import javax.servlet.http.HttpServletRequest;

public class HtmlGenerator {
	private Database m_db;
	public admin.AppConstants Constants = new admin.AppConstants();
	private String f_id;

	/*
	 * Name: HtmlGenerator ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db: The database object
	 * 
	 * Returns: None
	 */
	public HtmlGenerator(ausstage.Database p_db) {
		m_db = p_db;
	}

	/*
	 * Name: displaySearchFilter ()
	 * 
	 * Purpose: Displays the search filter HTML
	 * 
	 * Parameters: p_request - The request sent form the client p_title - The
	 * title of the page p_filter_display_names - The display names of the
	 * fields that the data can be filtered by p_filter_names - The names of the
	 * fields that the data can be filtered by p_order_display_names - The
	 * display names of the fields that the data can be ordered by p_order_names
	 * - The names of the fields that the data can be ordered by p_list_name -
	 * The name of the selection field p_list_db_sql - The sql that obtains the
	 * data to display from the database p_list_db_field_id_name - The database
	 * field name that becomes the selection field p_list_db_display_fields -
	 * The database field names to display p_buttons_names - Names to go on the
	 * buttons that relate to the Select Box p_buttons_actions - Actions to
	 * associatewith the buttons that relate to the Select Box p_multiple -
	 * Indicates if multiple selections are allowed p_max_results_displayed -
	 * The maximum number of rows to display
	 * 
	 * Returns: A string that is the search filter HTML
	 */
	public String displaySearchFilter(HttpServletRequest p_request, String p_title, Vector p_filter_display_names, Vector p_filter_names, Vector p_order_display_names,
			Vector p_order_names, String p_list_name, String p_list_db_sql, String p_list_db_field_id_name, Vector p_list_db_display_fields, Vector p_buttons_names,
			Vector p_buttons_actions, boolean p_multiple, int p_max_results_displayed) {

		return displaySearchFilter(p_request, p_title, p_filter_display_names, p_filter_names, p_order_display_names, p_order_names, p_list_name, p_list_db_sql,
				p_list_db_field_id_name, p_list_db_display_fields, p_buttons_names, p_buttons_actions, p_multiple, p_max_results_displayed, "");
	}

	/*
	 * Name: displaySearchFilter ()
	 * 
	 * Purpose: Displays the search filter HTML
	 * 
	 * Parameters: p_request - The request sent form the client p_title - The
	 * title of the page p_filter_display_names - The display names of the
	 * fields that the data can be filtered by p_filter_names - The names of the
	 * fields that the data can be filtered by p_order_display_names - The
	 * display names of the fields that the data can be ordered by p_order_names
	 * - The names of the fields that the data can be ordered by p_list_name -
	 * The name of the selection field p_list_db_sql - The sql that obtains the
	 * data to display from the database p_list_db_field_id_name - The database
	 * field name that becomes the selection field p_list_db_display_fields -
	 * The database field names to display p_buttons_names - Names to go on the
	 * buttons that relate to the Select Box p_buttons_actions - Actions to
	 * associatewith the buttons that relate to the Select Box p_multiple -
	 * Indicates if multiple selections are allowed p_max_results_displayed -
	 * The maximum number of rows to display p_additional_html - Additional html
	 * can be added below the left column
	 * 
	 * Returns: A string that is the search filter HTML
	 */
	public String displaySearchFilter(HttpServletRequest p_request, String p_title, Vector p_filter_display_names, Vector p_filter_names, Vector p_order_display_names,
			Vector p_order_names, String p_list_name, String p_list_db_sql, String p_list_db_field_id_name, Vector p_list_db_display_fields, Vector p_buttons_names,
			Vector p_buttons_actions, boolean p_multiple, int p_max_results_displayed, String p_additional_html) {

		f_id = p_request.getParameter("f_id");

		try {
			String ret = "";
			String sqlString = p_list_db_sql;
			Statement stmt = m_db.m_conn.createStatement();
			Hashtable hidden_fields = new Hashtable(); // Not used in this
														// method
			CachedRowSet rset;
			int counter = 0;
			String queryString = p_request.getQueryString();

			if (queryString == null) queryString = "";
			// need to add the query string as well to the form action
			// for searching within item associations.

			ret += "<form name='search_form' id='search_form' method='POST' action='"
					+ ((String) p_request.getRequestURI()).substring(((String) p_request.getRequestURI()).lastIndexOf("/") + 1);
			if (!queryString.equals(""))
				ret += "?" + queryString + "'>\n";
			else
				ret += "'>\n";
			ret += "<table cellspacing='0' cellpadding='0' border='0' width='550'>\n";
			ret += "<tr>\n";

			ret += searchFilterInit(p_title, hidden_fields);
			ret += searchFilterOrder(p_request.getParameter("f_order_by"), p_order_names, p_order_display_names);

			ret += "</tr>\n";
			ret += "<tr>\n";

			ret += searchFilterCriteria(p_filter_names, p_filter_display_names, p_request, p_additional_html);

			ret += "  <td class='bodytext'>\n";

			ret += searchFilterSelectBox(p_request, p_list_name, p_multiple, sqlString, p_max_results_displayed, p_list_db_field_id_name, p_list_db_display_fields,
					p_buttons_names, p_buttons_actions, stmt, m_db);

			ret += "  </td>\n";
			ret += "</tr>\n";
			ret += "</table>\n";
			ret += "</form>\n";
			stmt.close();

			return (ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception in displaySearchFilter()!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			return ("");
		}
	}

	/*
	 * Name: displaySearchFilterAndSelector ()
	 * 
	 * Purpose: Displays the search filter and selector control HTML
	 * 
	 * Parameters: p_request - The request sent form the client p_title - The
	 * title of the page p_selected_box_title - The title of the box of selected
	 * items p_filter_display_names - The display names of the fields that the
	 * data can be filtered by p_filter_names - The names of the fields that the
	 * data can be filtered by p_order_display_names - The display names of the
	 * fields that the data can be ordered by p_order_names - The names of the
	 * fields that the data can be ordered by p_list_name - The name of the
	 * selection field p_list_db_sql - The sql that obtains the data to display
	 * from the database p_list_db_field_id_name - The database field name that
	 * becomes the selection field p_list_db_display_fields - The database field
	 * names to display p_selected_list_name - The name of the selection field
	 * in the selected list p_selected_list_db_sql - The sql that obtains the
	 * data to display the selected list p_selected_list_db_field_id_name - The
	 * database field name that becomes the selection field in the selected list
	 * p_selected_list_db_display_fields - The database field names to display
	 * in the selected list p_buttons_names - Names to go on the buttons that
	 * relate to the Select Box p_buttons_actions - Actions to associatewith the
	 * buttons that relate to the Select Box p_hidden_fields - Hashtable of
	 * fields and their values to make hidden; p_multiple - Indicates if
	 * multiple selections are allowed p_max_results_displayed - The maximum
	 * number of rows to display p_additional_html - Additional html can be
	 * added below the left column
	 * 
	 * Returns: A string that is the search filter and selection control HTML
	 */
	public String displaySearchFilterAndSelector(HttpServletRequest p_request, String p_title, String p_selected_box_title, Vector p_filter_display_names, Vector p_filter_names,
			Vector p_order_display_names, Vector p_order_names, String p_list_name, String p_list_db_sql, String p_list_db_field_id_name, Vector p_list_db_display_fields,
			String p_selected_list_name, Vector p_selected_records,
			// String p_selected_list_db_sql,
			String p_selected_list_db_field_id_name,
			// Vector p_selected_list_db_display_fields,
			Vector p_buttons_names, Vector p_buttons_actions, Hashtable p_hidden_fields, boolean p_multiple, int p_max_results_displayed) {
		return (displaySearchFilterAndSelector(p_request, p_title, p_selected_box_title, p_filter_display_names, p_filter_names, p_order_display_names, p_order_names, p_list_name,
				p_list_db_sql, p_list_db_field_id_name, p_list_db_display_fields, p_selected_list_name, p_selected_records, p_selected_list_db_field_id_name, p_buttons_names,
				p_buttons_actions, p_hidden_fields, p_multiple, p_max_results_displayed, ""));
	}

	/*
	 * Name: displaySearchFilterAndSelector ()
	 * 
	 * Purpose: Displays the search filter and selector control HTML
	 * 
	 * Parameters: p_request - The request sent form the client p_title - The
	 * title of the page p_selected_box_title - The title of the box of selected
	 * items p_filter_display_names - The display names of the fields that the
	 * data can be filtered by p_filter_names - The names of the fields that the
	 * data can be filtered by p_order_display_names - The display names of the
	 * fields that the data can be ordered by p_order_names - The names of the
	 * fields that the data can be ordered by p_list_name - The name of the
	 * selection field p_list_db_sql - The sql that obtains the data to display
	 * from the database p_list_db_field_id_name - The database field name that
	 * becomes the selection field p_list_db_display_fields - The database field
	 * names to display p_selected_list_name - The name of the selection field
	 * in the selected list p_selected_list_db_sql - The sql that obtains the
	 * data to display the selected list p_selected_list_db_field_id_name - The
	 * database field name that becomes the selection field in the selected list
	 * p_selected_list_db_display_fields - The database field names to display
	 * in the selected list p_buttons_names - Names to go on the buttons that
	 * relate to the Select Box p_buttons_actions - Actions to associatewith the
	 * buttons that relate to the Select Box p_hidden_fields - Hashtable of
	 * fields and their values to make hidden; p_multiple - Indicates if
	 * multiple selections are allowed p_max_results_displayed - The maximum
	 * number of rows to display p_additional_html - Additional html can be
	 * added below the left column
	 * 
	 * Returns: A string that is the search filter and selection control HTML
	 */
	public String displaySearchFilterAndSelector(HttpServletRequest p_request, String p_title, String p_selected_box_title, Vector p_filter_display_names, Vector p_filter_names,
			Vector p_order_display_names, Vector p_order_names, String p_list_name, String p_list_db_sql, String p_list_db_field_id_name, Vector p_list_db_display_fields,
			String p_selected_list_name, Vector p_selected_records,
			// String p_selected_list_db_sql,
			String p_selected_list_db_field_id_name,
			// Vector p_selected_list_db_display_fields,
			Vector p_buttons_names, Vector p_buttons_actions, Hashtable p_hidden_fields, boolean p_multiple, int p_max_results_displayed, String p_additional_html) {
		try {
			f_id = p_request.getParameter("f_id");
			String ret = "";
			Statement stmt = m_db.m_conn.createStatement();
			CachedRowSet rset;
			int counter = 0;

			ret += "<form name='search_form' id='search_form' method='POST' action='"
					+ ((String) p_request.getRequestURI()).substring(((String) p_request.getRequestURI()).lastIndexOf("/") + 1) + "'>\n";
			ret += "<table cellspacing='0' cellpadding='0' border='0' width='550'>\n";
			ret += "<tr>\n";

			ret += searchFilterInit(p_title, p_hidden_fields);
			ret += searchFilterOrder(p_request.getParameter("f_order_by"), p_order_names, p_order_display_names);

			ret += "</tr>\n";
			ret += "<tr>\n";

			ret += searchFilterCriteria(p_filter_names, p_filter_display_names, p_request, p_additional_html);

			ret += "  <td class='bodytext'>\n";

			ret += searchFilterSelectBox(p_request, p_list_name, p_multiple, p_list_db_sql, p_max_results_displayed, p_list_db_field_id_name, p_list_db_display_fields,
					p_buttons_names, p_buttons_actions, stmt, m_db);

			ret += "  </td>\n";
			ret += "</tr>\n";
			ret += "<tr>\n";
			ret += "  <td></td>\n";
			ret += "  <td></td>\n";
			ret += "  <td>\n";

			ret += searchFilterSelectedItems(p_selected_box_title, p_selected_list_name, p_selected_records, p_selected_list_db_field_id_name,
			// p_selected_list_db_display_fields,
					stmt, m_db);

			ret += "  </td>\n";
			ret += "</tr>\n";
			ret += "</table>\n";
			ret += "</form>\n";
			stmt.close();

			return (ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception in displaySearchFilterandSelector()!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			return ("");
		}
	}

	/*
	 * Name: searchFilterInit ()
	 * 
	 * Purpose: Builds the initial part of the form
	 * 
	 * Parameters: p_title - The title of the form p_hidden_fields - Hashtable
	 * of fields and their values to make hidden;
	 * 
	 * Returns: A HTML string that will display the initial part of the form.
	 */

	private String searchFilterInit(String p_title, Hashtable p_hidden_fields) {
		String ret = "";
		Enumeration enuma = null;

		if (!p_hidden_fields.isEmpty()) {
			enuma = p_hidden_fields.keys();
			while (enuma.hasMoreElements()) {
				Object name = enuma.nextElement();
				Object value = p_hidden_fields.get(name);
				ret += "  <input type='hidden' name='" + name.toString() + "' value='" + value.toString() + "'>\n";
			}
		}

		ret += "  <td class='bodytext' width='150'>\n";
		ret += "    <b>" + p_title + "</b>\n";
		ret += "  </td>\n";
		ret += "  <td width='5'><img src='" + Constants.IMAGE_DIRECTORY + "/spacer.gif' border='0' width='5' height='1'></td>\n";
		return ret;
	}

	/*
	 * Name: searchFilterOrder ()
	 * 
	 * Purpose: Builds the Order By radio buttons
	 * 
	 * Parameters: p_ordered_by - Indicates which field the data is presently
	 * ordered by p_order_names - The names of the fields that the data can be
	 * ordered by p_order_display_names - The display names of the fields that
	 * the data can be ordered by
	 * 
	 * Returns: A HTML string that will display the Order By radio buttons.
	 */

	private String searchFilterOrder(String ordered_by, Vector p_order_names, Vector p_order_display_names) {
		String ret = "";
		ret += "  <td class='bodytext' valign='top' width='400'>\n";
		for (int i = 0; i < p_order_names.size(); i++) {
			if (ordered_by == null) {
				ordered_by = "";
				if (i == 0) ordered_by = p_order_names.elementAt(i).toString();
			}

			ret += "    <input type='radio' name='f_order_by' value='" + p_order_names.elementAt(i) + "'";
			if (ordered_by.equals(p_order_names.elementAt(i))) ret += " checked";
			ret += ">" + p_order_display_names.elementAt(i) + "&nbsp;&nbsp;\n";
		}

		ret += "  </td>\n";
		return ret;
	}

	/*
	 * Name: searchFilterOrder ()
	 * 
	 * Purpose: Builds the Order By radio buttons
	 * 
	 * Parameters: p_filter_names - The names of the fields that the data can be
	 * filtered by p_filter_display_names - The display names of the fields that
	 * the data can be filtered by p_request - The request sent from the client
	 * 
	 * Returns: A HTML string that will display the Order By radio buttons.
	 */

	private String searchFilterCriteria(Vector p_filter_names, Vector p_filter_display_names, HttpServletRequest p_request) {
		return searchFilterCriteria(p_filter_names, p_filter_display_names, p_request, "");
	}

	/*
	 * Name: searchFilterOrder ()
	 * 
	 * Purpose: Builds the Order By radio buttons
	 * 
	 * Parameters: p_filter_names - The names of the fields that the data can be
	 * filtered by p_filter_display_names - The display names of the fields that
	 * the data can be filtered by p_request - The request sent from the client
	 * p_additional_html - Any additional HTML that will appear unter the search
	 * criteria
	 * 
	 * Returns: A HTML string that will display the Order By radio buttons.
	 */

	private String searchFilterCriteria(Vector p_filter_names, Vector p_filter_display_names, HttpServletRequest p_request, String p_additional_html) {
		String ret = "";
		ret += "  <td colspan='2' valign='top' class='bodytext'>\n";
		ret += "    <table cellspacing='0' cellpadding='0' border='0'>\n";
		ret += "    <colgroup><col span='1' width='200'/><col span='1'/> </colgroup>\n";

		for (int i = 0; i < p_filter_display_names.size(); i++) {
			String temp_value = p_request.getParameter(p_filter_names.elementAt(i).toString());

			if (temp_value == null) temp_value = "";

			ret += "    <tr>\n";
			ret += "      <td valign='top' class='bodytext'>" + p_filter_display_names.elementAt(i) + "</td>\n";
			ret += "      <td valign='top'><img src='" + Constants.IMAGE_DIRECTORY + "/spacer.gif' border='0' width='35' height='1'></td>\n";
			ret += "      <td valign='top'><input name='" + p_filter_names.elementAt(i) + "' style=\"width:'80'\" value=\"" + temp_value + "\"></td>\n";
			ret += "      <td valign='top'><img src='" + Constants.IMAGE_DIRECTORY + "/spacer.gif' border='0' width='3' height='1'></td>\n";
			ret += "    </tr>\n";
		}

		ret += "    </table>\n";
		ret += "    <input type='submit' name='submit_type' value='Search'>\n";

		if (!p_additional_html.equals("")) {
			ret += p_additional_html;
		}

		ret += "  </td>\n";

		return ret;
	}

	/*
	 * Name: searchFilterSelectBox ()
	 * 
	 * Purpose: Builds the Select Box
	 * 
	 * Parameters: p_list_name - The name of the selection field p_multiple -
	 * Indicates if multiple selections are allowed sqlString - The sql that
	 * obtains the data to display from the database p_max_results_displayed -
	 * The maximum number of rows to display p_list_db_field_id_name - The
	 * database field name that becomes the selection field
	 * p_list_db_display_fields - The database field names to display
	 * p_buttons_names - Names to go on the buttons that relate to the Select
	 * Box p_buttons_actions - Actions to associatewith the buttons that relate
	 * to the Select Box stmt - The Statement that holds the connection to the
	 * database Database m_db - The database handle
	 * 
	 * Returns: A HTML string that will display the Select Box.
	 */

	private String searchFilterSelectBox(HttpServletRequest p_request, String p_list_name, boolean p_multiple, String sqlString, int p_max_results_displayed,
			String p_list_db_field_id_name, Vector p_list_db_display_fields, Vector p_buttons_names, Vector p_buttons_actions, Statement stmt, Database m_db) {
		String ret = "";
		String ret2 = "";
		// default the results displayed to the max allowed
		int resultsDisplayed = p_max_results_displayed;
		try {
			int counter = 0;
			// The select box width:390px;
			ret = "   <div style=\"width:600px; height:316px; border-width:1px; border-style:solid; border-color:#d3d3d3; overflow:auto;\">\n"
				  //+ "    <select style=\"overflow-y:hidden; overflow-x:hidden;\" name='" + p_list_name + "' id='" + p_list_name + "' size='" + 17 + "' FONT-SIZE: 10px;'";	
				+ "    <select style=\"overflow-y:hidden;\" name='" + p_list_name + "' id='" + p_list_name + "' size='";
			ret2 = "' FONT-SIZE: 10px;'";
			if (p_multiple) ret2 += "multiple";
			ret2 += ">\n";

			// Run the query only if it is not empty
			if (!sqlString.equals("")) {
				CachedRowSet rset = m_db.runSQL(sqlString, stmt);
				while (rset.next()) {
					if (counter >= p_max_results_displayed) break;

					counter++;
					ret2 += "      <option value='" + rset.getString(p_list_db_field_id_name) + "'>\n";
					for (int i = 0; i < p_list_db_display_fields.size(); i++) {
						String temp_display = rset.getString(p_list_db_display_fields.elementAt(i).toString());

						if (temp_display == null) temp_display = "";

						// The first one does not have a comma in front of it
						if (i == 0)
							ret2 += temp_display;
						else if (!temp_display.equals("")) ret2 += "      , " + temp_display;
					}
					
					// this is insane, why is this even here in the first place
					/*String contribFunctions = "";
					if (p_request.getRequestURI().substring(p_request.getRequestURI().lastIndexOf("/") + 1).equals("event_contributors.jsp")) {
						*//**
						 * SPECIAL CASE: when the user is adding & editing
						 * contributor through addedit event facility, we need
						 * to display all the functions of each contibutor, ie
						 * name, lastname (function1, function2,...) within the
						 * selection box
						 */
/*
						if (rset.getString(p_list_db_field_id_name) != null && !rset.getString(p_list_db_field_id_name).equals("")) {
							Contributor contributor = new Contributor(m_db);
							contributor.load(Integer.parseInt(rset.getString(p_list_db_field_id_name)));
							String contFunctIds = contributor.getContFunctIds();
							CachedRowSet crset = null;

							if (contFunctIds != null && !contFunctIds.equals("")) {
								if (contFunctIds.indexOf(",") != -1) {
									StringTokenizer str_token = new StringTokenizer(contFunctIds, ",");
									while (str_token.hasMoreTokens()) {
										crset = contributor.getContFunctPreff(Integer.parseInt(str_token.nextToken()));
										if (crset.next()) {
											if (contribFunctions.equals(""))
												contribFunctions = crset.getString("PREFERREDTERM");
											else
												contribFunctions += "," + crset.getString("PREFERREDTERM");
										}
									}
								} else {
									crset = contributor.getContFunctPreff(Integer.parseInt(contFunctIds));
									if (crset.next()) contribFunctions = crset.getString("PREFERREDTERM");
								}
							}
							if (crset != null) crset.close();
						}
					}
					if (contribFunctions != null && !contribFunctions.equals(""))
						ret += " (" + contribFunctions + ")</option>\n";
					else*/
					ret2 += "    </option>\n";
				}
				rset.close();
			}

			ret2 += "    </select>";
			ret2 += "    </div>";
			ret2 += "    <br>\n";

			// Submit Buttons
			for (int i = 0; i < p_buttons_names.size(); i++) {
				if (p_buttons_names.elementAt(i).toString().toLowerCase().equals("add")) {
					if ((f_id != null && !f_id.equals("")) || (sqlString.toLowerCase().indexOf("like") != -1)) // we
																												// performed
																												// a
																												// search
																												// so
																												// lets
																												// add
																												// the
																												// Add
																												// button
						ret2 += "    <input type='button' name='submit_type' value='" + p_buttons_names.elementAt(i) + "' onclick=\"" + p_buttons_actions.elementAt(i)
								+ "\">&nbsp;\n";
				} else if ((p_buttons_names.elementAt(i).toString().toLowerCase().indexOf("edit") >= 0)
						|| (p_buttons_names.elementAt(i).toString().toLowerCase().indexOf("view") >= 0)) {
					// For edit or preview/view buttons, parse the javascript to
					// check that the user has selected an item first
					String buttonAction = p_buttons_actions.elementAt(i) + "";

					// Put out the javascript part if there is any
					if (buttonAction.toLowerCase().startsWith("javascript:")) {
						buttonAction = buttonAction.substring(11);
					}

					// Now add the check to ensure the user has selected
					// something
					buttonAction = "if (document.getElementById('" + p_list_name + "').selectedIndex>=0) { " + buttonAction
							+ " } else { alert('Please select an item to edit/view'); } ";
					buttonAction = "javascript:" + buttonAction;
					ret2 += "    <input type='button' name='submit_type' value='" + p_buttons_names.elementAt(i) + "' onclick=\"" + buttonAction + "\">&nbsp;\n";
				} else {
					ret2 += "    <input type='button' name='submit_type' value='" + p_buttons_names.elementAt(i) + "' onclick=\"" + p_buttons_actions.elementAt(i) + "\">&nbsp;\n";
				}
			}
			ret2 += "<br>";
			if (counter >= p_max_results_displayed) {
				ret2 += "<font color='FF0000'>Warning. The above list is not a complete listing, as more results were found than could be displayed. Please refine your search.</font>";
			}
			// if the amount of select options is less than the maximum results that will be displayed restrict the select size to the amount select options
			// so we don't get heaps of white space
			if (counter < p_max_results_displayed) {
				resultsDisplayed = counter + 1;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception in searchFilterSelectBox()!!!");
			System.out.println("sql = " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			return ("");
		}
		return ret + resultsDisplayed + ret2;
	}

	/*
	 * Name: searchFilterSelectedItems ()
	 * 
	 * Purpose: Builds the display of items selected
	 * 
	 * Parameters: p_selected_box_title - The title of the box of selected items
	 * p_selected_list_name - The name of the selection field selected_sqlString
	 * - The sql that obtains the data to display from the database
	 * p_selected_list_db_field_id_name - The database field name that becomes
	 * the selection field p_selected_list_db_display_fields - The database
	 * field names to display stmt - The Statement that holds the connection to
	 * the database Database m_db - The database handle
	 * 
	 * Returns: A HTML string that will display the list of selected items.
	 */

	private String searchFilterSelectedItems(String p_selected_box_title, String p_selected_list_name, Vector p_selected_records, String p_selected_list_db_field_id_name,
			Statement stmt, Database m_db) {
		String ret = "";
		try {
			ret += "    <div class=bodyhead>" + p_selected_box_title + "</div>\n";
			// The selected box width was 390
			ret += "    <select name='" + p_selected_list_name + "' size='7' style='width:600px'";
			ret += ">\n";

			for (int i = 0; i < p_selected_records.size(); i += 2) {
				ret += "      <option value='" + p_selected_records.get(i) + "'>\n";
				ret += "        " + p_selected_records.get(i + 1) + "\n";
				ret += "      </option>\n";
			}

			ret += "    </select><br>\n";
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception in searchFilterSelectedItems()!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			return ("");
		}
		return ret;
	}

	/*
	 * Name: displayLinkedItem ()
	 * 
	 * Purpose: Displays the linked items in a form of HTML
	 * 
	 * Parameters:
	 * 
	 * p_helper_text - text for header helper p_helper_number - number displayed
	 * for helper header p_form_action_url - form action url p_hidden_field -
	 * name & value pair for hidden fields p_item_name - linked item name
	 * p_object_vec - storage vector for all the item objects
	 * p_max_results_displayed - max limit of fields that can be displayed
	 * 
	 * Returns: A string that is the linked items HTML
	 */

	public String displayLinkedItem(String p_helper_text, String p_helper_number, String p_form_action_url, String p_form_name, Hashtable p_hidden_field, String p_item_name,
			Vector p_object_vec, int p_max_results_displayed) {
		return (displayLinkedItem(p_helper_text, p_helper_number, p_form_action_url, p_form_name, p_hidden_field, p_item_name, p_object_vec, p_max_results_displayed, "", false));
	}

	public String displayLinkedItem(String p_helper_text, String p_helper_number, String p_form_action_url, String p_form_name, Hashtable p_hidden_field, String p_item_name,
			Vector p_object_vec, int p_max_results_displayed, boolean preview) {
		return (displayLinkedItem(p_helper_text, p_helper_number, p_form_action_url, p_form_name, p_hidden_field, p_item_name, p_object_vec, p_max_results_displayed, "", preview));

	}

	/*
	 * Name: displayLinkedItem ()
	 * 
	 * Purpose: Displays the linked items in a form of HTML
	 * 
	 * Parameters:
	 * 
	 * p_helper_text - text for header helper p_helper_number - number displayed
	 * for helper header p_form_action_url - form action url p_hidden_field -
	 * name & value pair for hidden fields p_item_name - linked item name
	 * p_object_vec - storage vector for all the item objects
	 * p_max_results_displayed - max limit of fields that can be displayed
	 * p_additional_javascript - Any additional javascript to execute on the
	 * button
	 * 
	 * Returns: A string that is the linked items HTML
	 */

	public String displayLinkedItem(String p_helper_text, String p_helper_number, String p_form_action_url, String p_form_name, Hashtable p_hidden_field, String p_item_name,
			Vector p_object_vec, int p_max_results_displayed, String p_additional_javascript, boolean preview) {

		Enumeration enuma = null;
		String ret = "", delimeted_ids = "", id = "";
		String unique_form_id = p_helper_number;
		int counter = 0;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			// //////////////////////////////////
			// HELPER SECTION //
			// //////////////////////////////////

			ret = "<table border='0' width='550' cellspacing='0' cellpadding='0'>\n";
			ret += "	<tr>\n";
			ret += "		<td width='50'></td>\n";
			ret += "		<td width='500'>\n";

			ret += "     <table border='0' width='500' cellspacing='0' cellpadding='0'>\n";
			ret += "	      <tr>\n";

			if (!p_helper_number.equals("") && !p_helper_text.equals("")) {
				ret += "		    <td width='70'><img border='0' src='" + Constants.IMAGE_DIRECTORY + "/helpers_no" + p_helper_number + ".gif' WIDTH='70' HEIGHT='31'></td>\n";
				ret += "		    <td width='17' bgcolor='#FFFFFF'><img border='0' src='" + Constants.IMAGE_DIRECTORY + "/helper_tab.gif' width='16' height='31'></td>\n";
			} else {
				ret += "		    <td width='70'></td>\n";
				ret += "		    <td width='17' bgcolor='#FFFFFF'></td>\n";
			}

			ret += "		      <td width='5' class='bodyhead' bgcolor='#FFFFFF'>\n";
			ret += "		      </td>\n";
			ret += "		      <td width='358' class='bodyhead' bgcolor='#FFFFFF'>" + p_helper_text + "</td>\n";
			ret += "		      <td width='50' bgcolor='#FFFFFF'></td>\n";
			ret += "	      </tr>\n";
			ret += "      </table>\n";

			// //////////////////////////////////
			// END HELPER SECTION //
			// //////////////////////////////////

			ret += "     <table border='0' cellpadding='0' cellspacing='0' width='460'>\n";
			ret += "      <tr>\n";
			ret += "        <td width='50'></td>\n";
			ret += "        <td width='410'>\n";
			// ret += "     <form name='linkedItemsForm_" + unique_form_id +
			// "' id='linkedItemsForm_" + unique_form_id +
			// "' method='post' action='" + p_form_action_url + "'>\n";

			// //////////////////////////////////
			// STANDARD HIDDEN FIELDS SECTION //
			// //////////////////////////////////

			if (!p_hidden_field.isEmpty()) {
				enuma = p_hidden_field.keys();
				while (enuma.hasMoreElements()) {
					Object name = enuma.nextElement();
					Object value = p_hidden_field.get(name);
					ret += "          <input type='hidden' name='" + name.toString() + "' value='" + value.toString() + "'>\n";
				}
			}

			// //////////////////////////////////////
			// END STANDARD HIDDEN FIELDS SECTION //
			// /////////////////////////////////////

			ret += "            <table border='0' cellpadding='0' cellspacing='0' width='410'>\n";
			ret += "              <tr>\n";
			ret += "                <td width='19'><img src='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_top_left.gif' border=0 width='19' height='16'></td>\n";
			ret += "                <td width='372' background='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/line_horizontal.gif' colspan='3'></td>\n";
			ret += "                <td width='19'><img src='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_top_right.gif' border=0 width='19' height='16'></td>\n";
			ret += "              </tr>\n";
			ret += "              <tr>\n";
			ret += "                <td width='19' background='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_vertical_line_left.gif' colspan='2'><img src='"
					+ Constants.IMAGE_DIRECTORY + "/spacer.gif' border=0 width='19' height='16'></td>\n";
			ret += "                <td width='323' class='bodytext'>" + p_item_name + "</td>\n";
			// ret +=
			// "                <td width='66'><input type='button' name='select_btn' value='Select' onclick=\"document.event_addedit_form.action='"
			// + p_form_action_url +
			// "'; document.event_addedit_form.submit();\"></td>\n";
			if (preview == true)
				ret += "                <td width='66' align='right'></td>\n";
			else
				ret += "                <td width='66' align='right'><a style='cursor:hand' onclick=\"" + p_additional_javascript + "document." + p_form_name + ".action='"
						+ p_form_action_url + "'; document." + p_form_name + ".submit();\"><img border='0' src='" + Constants.IMAGE_DIRECTORY + "/popup_button.gif'></a></td>\n";
			ret += "                <td width='2' background='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_vertical_line_right.gif'><img src='" + Constants.IMAGE_DIRECTORY
					+ "/spacer.gif' border=0 width='2' height='16'></td>\n";
			ret += "              </tr>\n";
			ret += "              <tr>\n";
			ret += "                <td width='19'><img src='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_middle_left.gif' border=0 width='19' height='16'></td>\n";
			ret += "                <td width='375' background='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/line_horizontal.gif' colspan='3'></td>\n";
			ret += "                <td width='19'><img src='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_middle_right.gif' border=0 width='19' height='16'></td>\n";
			ret += "              </tr>\n";
			ret += "              <tr>\n";
			ret += "                <td width='19' background='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_vertical_line_left.gif' colspan='2'><img src='"
					+ Constants.IMAGE_DIRECTORY + "/spacer.gif' border=0 width='19' height='16'></td>\n";
			ret += "                <td colspan='2'>\n";

			// //////////////////////////////////
			// DISPLAY DB FIELDS SECTION //
			// //////////////////////////////////
			ret += "                  <table border='0' cellpadding='0' cellspacing='0' width='389'>\n";

			if (p_object_vec != null && !p_object_vec.isEmpty()) {
				enuma = p_object_vec.elements();
				// ret +=
				// "            <table border='0' cellpadding='0' cellspacing='0' width='389'>\n";
				while (enuma.hasMoreElements()) {
					ret += "                  <tr><td class='bodytext'>";

					if (counter >= p_max_results_displayed) {
						ret += "                    <font color='FF0000'><br>Warning. The above list is incomplete, as more results were found than could be displayed.</font>\n";
						ret += "                  </td></tr>\n";
						break;
					}

					counter++;

					Object object = enuma.nextElement();

					// find out what object instance we are dealing with
					if (object instanceof Datasource) {
						Datasource obj = (Datasource) object;
						if (!obj.getName().equals(""))
							ret += obj.getName() + ", " + obj.getDescription() + ", part of collection - " + obj.getCollection();
						else
							ret += "&nbsp;";
						id = obj.getDatasoureEvlinkId();
					} else if (object instanceof SecondaryGenre) {
						SecondaryGenre obj = (SecondaryGenre) object;
						if (!obj.getName().equals(""))
							ret += obj.getName();
						else
							ret += "&nbsp;";
						id = Integer.toString(obj.getId());
					} else if (object instanceof PrimaryContentInd) {
						PrimaryContentInd obj = (PrimaryContentInd) object;
						if (!obj.getName().equals(""))
							ret += obj.getName();
						else
							ret += "&nbsp;";
						id = Integer.toString(obj.getId());
					} else if (object instanceof SecondaryContentInd) {
						SecondaryContentInd obj = (SecondaryContentInd) object;
						if (!obj.getName().equals(""))
							ret += obj.getName();
						else
							ret += "&nbsp;";
						id = Integer.toString(obj.getId());
					} else if (object instanceof Contributor) {
						Contributor obj = (Contributor) object;
						if (!obj.getName().equals(""))
							ret += obj.getName() + " " + obj.getLastName();
						else
							ret += "&nbsp;";
						id = Integer.toString(obj.getId());
					} else if (object instanceof LookupCode) {
						LookupCode obj = (LookupCode) object;
						if (!obj.getShortCode().equals(""))
							ret += obj.getShortCode();
						else
							ret += "&nbsp;";
						id = Integer.toString(obj.getCodeLovID());
					} else if (object instanceof Organisation) {
						Organisation obj = (Organisation) object;
						if (!obj.getName().equals(""))
							ret += obj.getName();
						else
							ret += "&nbsp;";
						id = Integer.toString(obj.getId());
					} else if (object instanceof ConOrgLink) {
						ConOrgLink obj = (ConOrgLink) object;
						Organisation organisation = new Organisation(m_db);
						organisation.load(Integer.parseInt(obj.getOrganisationId()));
						ret += organisation.getName();
						if (obj.getDescription() != null && !obj.getDescription().equals("")) {
							ret += ", " + obj.getDescription();
						}
						id = obj.getOrganisationId();
					} else if (object instanceof String) {
						String obj = (String) object;
						ret += obj;
					} else { // if(object instanceof Country){ // will cater for
								// the two National Origin
						Country obj = (Country) object;
						if (!obj.getName().equals(""))
							ret += obj.getName();
						else
							ret += "&nbsp;";
						id = Integer.toString(obj.getId());
					}

					if (delimeted_ids.equals(""))
						delimeted_ids = id;
					else
						delimeted_ids += "," + id;

					ret += "      </td></tr>\n";
				}
				// ret += "            </table>\n";
			} else {
				ret += "                    <tr><td>&nbsp;</td></tr>\n";
			}
			ret += "                  </table>\n";

			// //////////////////////////////////
			// END DISPLAY DB FIELDS SECTION //
			// //////////////////////////////////

			ret += "                </td>\n";
			ret += "                <td width='2' background='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_vertical_line_right.gif'><img src='" + Constants.IMAGE_DIRECTORY
					+ "/spacer.gif' border=0 width='2' height='16'></td>\n";
			ret += "              </tr>\n";
			ret += "              <tr>\n";
			ret += "                <td width='19'><img src='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_bottom_left.gif' border=0 width='19' height='16'></td>\n";
			ret += "                <td width='375' background='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/line_horizontal.gif' colspan='3'></td>\n";
			ret += "                <td width='19'><img src='" + Constants.CUSTOM_IMAGE_DIRECTORY + "/join_bottom_right.gif' border=0 width='19' height='16'></td>\n";
			ret += "              </tr>\n";
			ret += "            </table>\n";

			// //////////////////////////////////
			// ID HIDDEN FIELDS SECTION //
			// /////////////////////////////////

			// if(!delimeted_ids.equals(""))
			ret += "              <input type='hidden' name='f_delimeted_ids_" + unique_form_id + "' value='" + delimeted_ids + "'>\n";

			// //////////////////////////////////
			// END ID HIDDEN FIELDS SECTION //
			// /////////////////////////////////

			// ret += "      </form>\n";
			ret += "          </td>\n";
			ret += "        </tr>\n";
			ret += "      </table>\n";
			ret += "    </td>\n";
			ret += "  </tr>\n";
			ret += "</table>";

			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception in displayLinkedItem()!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			ret = "";
		}
		return (ret);
	}
	
	/*
	 * displayUrlThumbnail - takes a URL and returns HTML to display it as a thumbnail. 
	 * currently handles images, PDF and web pages. 
	 * Requires imageUrl, parentURL
	 * */
	public String displayUrlThumbnail(String imageUrl, String parentUrl){
		String ret = "";
		String width = "100px";
		String height = "100px";
		//is it an image?
		if (imageUrl.toLowerCase().endsWith(".gif") ||imageUrl.toLowerCase().endsWith(".jpeg") ||
			imageUrl.toLowerCase().endsWith(".jpg") ||imageUrl.toLowerCase().endsWith(".png") ||
			imageUrl.toLowerCase().endsWith(".bmp")) {
			ret = "<a target='_blank' href='"+parentUrl+"'>"
				 +		"<div style='margin-right:5px; width:"+width+"; height:"+height+"; float:left; background-image: url("+imageUrl+"); background-size: cover;' >"													
				 +		"</div>"													
				 +"</a>";																			
		}
		//is it pdf?
		else if (imageUrl.toLowerCase().endsWith(".pdf")){
		/*	ret = "<a target='_blank' href='"+parentUrl+"'>"
				+		"<div style='margin-right:5px; width:100px; height:100px; float:left;' >"
				+			"<iframe src='http://docs.google.com/gview?url="+imageUrl+"&embedded=true' style='width:"+width+"; height:"+height+";' frameborder='0'></iframe>"
				+		"</div>"
				+ "</a>";*/
		}
		//else display the page
		else {
			ret = "<div style='margin-right:5px; width:160px; height:"+height+"; float:left;' >"
				+		"<div class='iframe-link'>"
				+			"<iframe src='"+imageUrl+"' width='100%' height='500' frameborder='0' scrolling='no' seamless='seamless'></iframe>" 
				+			"<a class='iframe-link' href='"+parentUrl+"' target='_blank'> &nbsp;</a>"
				+		"</div>"
				+ "</div>";
		}
		return ret;
	}
}
