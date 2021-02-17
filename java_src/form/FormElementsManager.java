package form;

import admin.AppConstants;
import admin.Database;
import java.io.PrintStream;
import java.sql.*;
import java.util.Vector;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package form:
//            FormElement, FormTableLayoutManager

public class FormElementsManager {

	private String sqlString;
	private String release_label_form_element_id;
	private CachedRowSet rset;
	private ResultSet clobRset;
	private AppConstants appConstants;
	public String m_default_val_str_array[];

	public FormElementsManager() {
		sqlString = "";
		release_label_form_element_id = "";
		appConstants = new AppConstants();
	}

	public Vector getFormElements(String form_layout_id, Database db) {
		Vector form_elementsVector = null;
		int num = 0;
		int counter = 0;
		String type_name = "";
		String html_name = "";
		String display_name = "";
		String table_location_row = "";
		String table_location_col = "";
		String size_length = "";
		String do_validate = "";
		String default_val = "";
		String default_display_val = "";
		String num_rows = "";
		String num_cols = "";
		String element_id = "";
		String group_id = "";
		String is_selected = "";
		String num_elements = "";
		String is_multiselect = "";
		String field_type = "";
		try {
			Statement stmt = db.m_conn.createStatement();
			Statement stmt_for_clob = db.m_conn.createStatement();
			sqlString = "select count(*) as counter from form_element where form_layout_id=" + db.plSqlSafeString(form_layout_id);
			rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				num_elements = rset.getString("counter");
				if (num_elements == null || num_elements.equals("0")) {
					num_elements = "0";
				}
				form_elementsVector = new Vector(Integer.parseInt(num_elements));
				if (!num_elements.equals("0")) {
					sqlString = "select type_name,html_name,display_name,table_location_row,table_location_col,si"
							+ "ze_length,do_validate,num_rows,num_cols,form_element_id,form_element_group_id,is"
							+ "_selected,is_multiselect,field_type from form_element where form_layout_id=" + db.plSqlSafeString(form_layout_id) + " order by table_location_row";
					rset = db.runSQL(sqlString, stmt);
					rset.next();
					do {
						type_name = rset.getString("type_name");
						html_name = rset.getString("html_name");
						display_name = rset.getString("display_name");
						table_location_row = rset.getString("table_location_row");
						table_location_col = rset.getString("table_location_col");
						size_length = rset.getString("size_length");
						do_validate = rset.getString("do_validate");
						num_rows = rset.getString("num_rows");
						num_cols = rset.getString("num_cols");
						element_id = rset.getString("form_element_id");
						group_id = rset.getString("form_element_group_id");
						is_selected = rset.getString("is_selected");
						is_multiselect = rset.getString("is_multiselect");
						field_type = rset.getString("field_type");
						default_display_val = "";
						default_val = "";
						sqlString = "select default_display_val, default_val from form_element where form_element_id=" + db.plSqlSafeString(element_id);
						clobRset = db.runSQLResultSet(sqlString, stmt_for_clob);
						if (clobRset.next()) {
							FormElementsManager _tmp = this;
							if (AppConstants.DATABASE_TYPE == 1) {
								Clob cl = clobRset.getClob("default_display_val");
								if (cl != null) {
									default_display_val = cl.getSubString(1L, (int) cl.length());
									if (default_display_val == null || default_display_val.equals("null")) {
										default_display_val = "";
									}
								}
								cl = clobRset.getClob("default_val");
								if (cl != null) {
									default_val = cl.getSubString(1L, (int) cl.length());
									if (default_val == null || default_val.equals("null")) {
										default_val = "";
									}
								}
							} else {
								default_val = clobRset.getString("default_val");
								default_display_val = clobRset.getString("default_display_val");
							}
						}
						FormElement formElement = new FormElement(type_name, display_name, table_location_row, table_location_col, size_length, html_name, do_validate,
								default_val, default_display_val, num_rows, num_cols, group_id, is_selected, element_id, is_multiselect, field_type);
						form_elementsVector.addElement(formElement);
					} while (rset.next());
				}
			} else {
				stmt.close();
				stmt_for_clob.close();
				Vector vector = null;
				return vector;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("Getting all the form elements & storing them into vector - We have an exception!" + "!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return form_elementsVector;
	}

	public String getOccupiersID(Database db, String rowLocation, String colLocation, String form_layout_id) {
		String form_element_id = "0";
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select table_location_row, table_location_col, form_element_id from form_element" + " where table_location_row=" + db.plSqlSafeString(rowLocation) + " and "
					+ "table_location_col= " + db.plSqlSafeString(colLocation) + " and form_layout_id=" + db.plSqlSafeString(form_layout_id);
			rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				form_element_id = rset.getString("form_element_id");
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("Finding out if the table cell is occupied by a form element - We have an excepti" + "on!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return form_element_id;
	}

	public void updateFormElementColLocation(String col, String element_id, Statement stmt, Database db) {
		sqlString = "update form_element set table_location_col='" +  db.plSqlSafeString(col) + "' where form_element_id=" +  db.plSqlSafeString(element_id);
		try {
			db.runSQL(sqlString, stmt);
		} catch (Exception e) {
			System.out.println("Exception occured in updateFormElementColLocation().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}

	public void updateFormElementRowLocation(String row, String element_id, Statement stmt, Database db) {
		sqlString = "update form_element set table_location_row='" + db.plSqlSafeString(row) + "' where form_element_id=" + db.plSqlSafeString(element_id);
		try {
			db.runSQL(sqlString, stmt);
		} catch (Exception e) {
			System.out.println("Exception occured in updateFormElementRowLocation().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}

	public boolean insertFormElement(String type_name, String html_name, String display_name, String table_location_row, String table_location_col, String size_length,
			String do_validate, String default_val, String default_display_val, String num_rows, String num_cols, String element_group_id, String is_selected,
			String form_layout_id, String is_multiselect, String field_type, Statement stmt, Database db) {
		boolean retVal = true;
		sqlString = "insert into form_element (type_name, html_name, display_name, table_location_row"
				+ ", table_location_col, size_length, do_validate, num_rows, num_cols, form_element"
				+ "_group_id, is_selected, form_layout_id, is_multiselect, field_type) values ('"
				+ db.plSqlSafeString(type_name)
				+ "','"
				+ db.plSqlSafeString(html_name)
				+ "','"
				+ db.plSqlSafeString(display_name)
				+ "','"
				+ db.plSqlSafeString(table_location_row)
				+ "','"
				+ db.plSqlSafeString(table_location_col)
				+ "','"
				+ db.plSqlSafeString(size_length)
				+ "','"
				+ db.plSqlSafeString(do_validate)
				+ "','"
				+ db.plSqlSafeString(num_rows)
				+ "','"
				+ db.plSqlSafeString(num_cols)
				+ "','"
				+ db.plSqlSafeString(element_group_id)
				+ "','"
				+ db.plSqlSafeString(is_selected)
				+ "','"
				+ db.plSqlSafeString(form_layout_id)
				+ "','"
				+ db.plSqlSafeString(is_multiselect)
				+ "','"
				+ db.plSqlSafeString(field_type) + "')";
		try {
			db.runSQL(sqlString, stmt);
			String new_form_element_id = db.getInsertedIndexValue(stmt, "form_element_id_seq");
			try {
				if (AppConstants.DATABASE_TYPE == 1) {
					CallableStatement callable = db.m_conn.prepareCall("begin UPDATE_DEFAULT_VAL (" + db.plSqlSafeString(new_form_element_id) + ", '" + db.plSqlSafeString(default_val) + "'); end;");
					callable.execute();
					callable = db.m_conn.prepareCall("begin UPDATE_DEFAULT_DISPLAY_VAL (" + db.plSqlSafeString(new_form_element_id) + ", '" + db.plSqlSafeString(default_display_val) + "'); end;");
					callable.execute();
					callable.close();
				} else {
					sqlString = "update form_element set default_val='" + db.plSqlSafeString(default_val) + "', default_display_val='" + db.plSqlSafeString(default_display_val)
							+ "' where form_element_id=" + db.plSqlSafeString(new_form_element_id);
					db.runSQL(sqlString, stmt);
				}
			} catch (Exception e) {
				System.out.println("Trying to insert/update the default_val & default_display_val\nin the form_eleme" + "nt table - We have an exception!!!");
				throw e;
			}
		} catch (Exception e) {
			retVal = false;
			System.out.println("Trying to insert a form element - We have an exception!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return retVal;
	}

	public boolean updateFormElement(String form_element_id, String type_name, String html_name, String display_name, String table_location_row, String table_location_col,
			String size_length, String do_validate, String default_val, String default_display_val, String num_rows, String num_cols, String element_group_id, String is_selected,
			String is_multiselect, String field_type, Statement stmt, Database db) {
		boolean retVal = true;
		sqlString = "update form_element set type_name='" + db.plSqlSafeString(type_name) + "',html_name='" + db.plSqlSafeString(html_name) + "', display_name='" + db.plSqlSafeString(display_name)
				+ "', table_location_row='" + db.plSqlSafeString(table_location_row) + "', table_location_col='" + db.plSqlSafeString(table_location_col) + "', size_length='" 
				+ db.plSqlSafeString(size_length) + "', do_validate='"
				+ db.plSqlSafeString(do_validate) + "', num_rows='" + db.plSqlSafeString(num_rows) + "', num_cols='" + db.plSqlSafeString(num_cols) 
				+ "', form_element_group_id='" + db.plSqlSafeString(element_group_id) + "', is_selected='" + db.plSqlSafeString(is_selected)
				+ "', is_multiselect= '" + db.plSqlSafeString(is_multiselect) + "', field_type='" + db.plSqlSafeString(field_type) + "' where form_element_id=" + db.plSqlSafeString(form_element_id);
		try {
			db.runSQL(sqlString, stmt);
			try {
				if (AppConstants.DATABASE_TYPE == 1) {
					CallableStatement callable = db.m_conn.prepareCall("begin UPDATE_DEFAULT_VAL (" + db.plSqlSafeString(form_element_id) + ", '" + db.plSqlSafeString(default_val) + "'); end;");
					callable.execute();
					callable = db.m_conn.prepareCall("begin UPDATE_DEFAULT_DISPLAY_VAL (" + db.plSqlSafeString(form_element_id) + ", '" + db.plSqlSafeString(default_display_val) + "'); end;");
					callable.execute();
					callable.close();
				} else {
					sqlString = "update form_element set default_val='" + db.plSqlSafeString(default_val) + "', default_display_val='" + db.plSqlSafeString(default_display_val)
							+ "' where form_element_id=" + db.plSqlSafeString(form_element_id);
					db.runSQL(sqlString, stmt);
				}
			} catch (Exception e) {
				System.out.println("Trying to update the default_val & default_display_val in\nthe form_element tabl" + "e - We have an exception!!!");
				throw e;
			}
		} catch (Exception e) {
			retVal = false;
			System.out.println("Trying to update a form element - We have an exception!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return retVal;
	}

	public boolean deleteFormElement(String form_element_id, String element_type, String form_layout_id, Statement stmt, Database db) {
		boolean retVal = true;
		FormElement fe = new FormElement(form_element_id, stmt, db);
		String form_element_group_id = fe.getGroupId();
		if (form_element_group_id == null) {
			form_element_group_id = "";
		}
		if (element_type.equals("radiobutton") || element_type.equals("checkbox") && !form_element_group_id.equals("")) {
			sqlString = "select form_element_id from form_element where not form_element_id=" + db.plSqlSafeString(form_element_id) + " and form_element_group_id=" + db.plSqlSafeString(form_element_group_id)
					+ " and not type_name='label' and form_layout_id=" + db.plSqlSafeString(form_layout_id);
			try {
				rset = db.runSQL(sqlString, stmt);
				if (!rset.next()) {
					try {
						if (hasLabel(form_element_group_id, db)) {
							sqlString = "update form_element set form_element_group_id='' where form_element_id=" + db.plSqlSafeString(release_label_form_element_id);
							db.runSQL(sqlString, stmt);
						}
					} catch (Exception e) {
						throw e;
					}
				}
			} catch (Exception e) {
				retVal = false;
				System.out.println("Trying to get the form_element_id that has\nform_element_group_id equal to " + form_element_group_id);
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
			}
		}
		sqlString = "delete from form_element where form_element_id=" + db.plSqlSafeString(form_element_id);
		try {
			db.runSQL(sqlString, stmt);
		} catch (Exception e) {
			retVal = false;
			System.out.println("Trying to delete a form element - We have an exception!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return retVal;
	}

	public String DelFromDelimitedStr(String delimitedStr, String strToDel, String delimeter) {
		String d = "";
		String newStr = "";
		String tempStr = "";
		for (int z = 0; z < delimitedStr.length(); z++) {
			d = delimitedStr.substring(z, z + 1);
			if (d.equals(delimeter)) {
				if (tempStr.equals(strToDel)) {
					tempStr = "";
				} else {
					newStr = newStr + (tempStr + d);
					tempStr = "";
				}
			} else {
				tempStr = tempStr + d;
			}
		}

		if (!tempStr.equals("")) {
			if (tempStr.equals(strToDel)) {
				newStr = newStr.substring(0, newStr.length() - 1);
			} else {
				newStr = newStr + tempStr;
			}
		}
		return newStr;
	}

	public String getElementGroupName(String element_group_id, Database db) {
		String retStr = "";
		sqlString = "select group_name from form_element_group where form_element_group_id=" +  db.plSqlSafeString(element_group_id);
		try {
			Statement stmt = db.m_conn.createStatement();
			rset = db.runSQL(sqlString, stmt);
			rset.next();
			retStr = rset.getString("group_name");
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to get the group_name from the form_element_group table");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return retStr;
	}

	public boolean isLabelRequired(String form_layout_id, Database db) {
		boolean retBool = false;
		sqlString = "select form_element_group_id from form_element where form_element_group_id is no"
				+ "t null and (type_name='radiobutton' or type_name='checkbox') and form_layout_id=" + db.plSqlSafeString(form_layout_id);
		try {
			Statement stmt = db.m_conn.createStatement();
			rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				do {
					if (hasLabel(rset.getString("form_element_group_id"), db)) {
						continue;
					}
					retBool = true;
					break;
				} while (rset.next());
			} else {
				retBool = false;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to check if label is required");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return retBool;
	}

	private boolean hasLabel(String form_element_group_id, Database db) throws Exception {
		boolean retBool = false;
		sqlString = "select form_element_id from form_element where form_element_group_id=" + db.plSqlSafeString(form_element_group_id) + " " + "and type_name='label'";
		try {
			Statement stmt = db.m_conn.createStatement();
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				release_label_form_element_id = rset.getString("form_element_id");
				retBool = true;
			}
			stmt.close();
			boolean flag = retBool;
			return flag;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to check if this group of element has a label");
			System.out.println("The query is " + sqlString);
			throw e;
		}
	}

	public String getChosenFormItem(String form_layout_id, String default_val_array[], String single_val, String default_display_val, String element_type, Database db) {
		String def_val = "";
		int arrSize = 0;
		int index = 0;
		Clob cl = null;
		String id = "";
		String default_val = "";
		String formElement_ids = "";
		String chosenFormItemNames = "";
		boolean is_array = false;
		FormTableLayoutManager ftlm = new FormTableLayoutManager(db);
		if ((default_val_array instanceof String[]) && default_val_array != null) {
			m_default_val_str_array = new String[default_val_array.length];
			is_array = true;
		}
		try {
			sqlString = "select form_element_id, default_val from form_element where type_name='" + db.plSqlSafeString(element_type) + "' and form_layout_id=" + db.plSqlSafeString(form_layout_id);
			Statement stmt = db.m_conn.createStatement();
			clobRset = db.runSQLResultSet(sqlString, stmt);
			if (clobRset.next()) {
				do {
					FormElementsManager _tmp = this;
					if (AppConstants.DATABASE_TYPE == 1) {
						cl = clobRset.getClob("default_val");
						id = clobRset.getString("form_element_id");
						if (cl != null) {
							def_val = cl.getSubString(1L, (int) cl.length());
							if (def_val == null || def_val.equals("null")) {
								def_val = "";
							}
						}
					} else {
						def_val = clobRset.getString("default_val");
						id = clobRset.getString("form_element_id");
					}
					if (is_array) {
						for (int i = 0; i < default_val_array.length; i++) {
							if (def_val.indexOf("|") == -1) {
								if (def_val.equals(default_val_array[i])) {
									if (chosenFormItemNames.equals("")) {
										chosenFormItemNames = getDisplayName(id, "", db);
									} else {
										chosenFormItemNames = chosenFormItemNames + ("|" + getDisplayName(id, "", db));
									}
									m_default_val_str_array[index++] = def_val;
								}
							} else {
								arrSize = ftlm.getArraySizeFromDelimetedStr(def_val, "|");
								String def_val_array[] = new String[arrSize];
								def_val_array = ftlm.splitIntoArray(def_val, "|");
								arrSize = ftlm.getArraySizeFromDelimetedStr(default_display_val, "|");
								String default_display_val_array[] = new String[arrSize];
								default_display_val_array = ftlm.splitIntoArray(default_display_val, "|");
								for (int x = 0; x < def_val_array.length; x++) {
									if (!default_val_array[i].equals(def_val_array[x])) {
										continue;
									}
									if (chosenFormItemNames.equals("")) {
										chosenFormItemNames = default_display_val_array[x];
									} else {
										chosenFormItemNames = chosenFormItemNames + ("|" + default_display_val_array[x]);
									}
								}

							}
						}

					} else if (single_val.equals(def_val)) {
						chosenFormItemNames = getDisplayName(id, "", db);
						break;
					}
					def_val = "";
				} while (clobRset.next());
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Exception occured in getChosenFormItem()");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return chosenFormItemNames;
	}

	public String getDisplayName(String element_id, String default_val, Database db) {
		String retStr = "";
		sqlString = "select display_name from form_element where form_element_id=" + db.plSqlSafeString(element_id);
		try {
			Statement stmt = db.m_conn.createStatement();
			rset = db.runSQL(sqlString, stmt);
			rset.next();
			retStr = rset.getString("display_name");
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to get the display_name (form_element.display_name)");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return retStr;
	}

	public String getLabel(String group_id, Database db) {
		String retStr = "";
		sqlString = "select default_val from form_element where form_element_group_id=" + db.plSqlSafeString(group_id) + " and type_name='label'";
		try {
			Statement stmt = db.m_conn.createStatement();
			clobRset = db.runSQLResultSet(sqlString, stmt);
			if (clobRset.next()) {
				FormElementsManager _tmp = this;
				if (AppConstants.DATABASE_TYPE == 1) {
					Clob cl = clobRset.getClob("default_val");
					if (cl != null) {
						retStr = cl.getSubString(1L, (int) cl.length());
						if (retStr == null || retStr.equals("null")) {
							retStr = "";
						}
					}
				} else {
					retStr = clobRset.getString("default_val");
				}
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to get the label caption (form_element.default_val)");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return retStr;
	}

	public String getMultiCheckBoxDispName(String group_id, String x_default_val, Database db) {
		String retStr = "";
		sqlString = "select display_name from form_element where form_element_group_id=" + db.plSqlSafeString(group_id)  + " and default_val='" + db.plSqlSafeString(x_default_val)  + "' and type_name='checkbox'";
		try {
			Statement stmt = db.m_conn.createStatement();
			rset = db.runSQL(sqlString, stmt);
			rset.next();
			retStr = rset.getString("display_name");
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to get the grouped checkbox\ndisplay_name (form_element.display_name)");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return retStr;
	}

	public boolean isElementExist(String form_layout_id, String element_type, String html_name, Database db) {
		boolean retVal = false;
		if (form_layout_id.equals("")) {
			form_layout_id = "0";
		}
		sqlString = "Select form_element_id from form_element where type_name='" + db.plSqlSafeString(element_type) + "' and html_name='" + db.plSqlSafeString(html_name) + "' and form_layout_id=" + db.plSqlSafeString(form_layout_id);
		try {
			Statement stmt = db.m_conn.createStatement();
			rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				retVal = true;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Exception occured in isElementExist()");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return retVal;
	}
}
