package form;

import admin.AppConstants;
import admin.Database;
import java.io.PrintStream;
import java.sql.*;
import sun.jdbc.rowset.CachedRowSet;

public class FormElement {

	private String type_name;
	private String display_name;
	private String table_location_row;
	private String table_location_col;
	private String size_length;
	private String html_name;
	private String do_validate;
	private String default_val;
	private String from_clob_default_val;
	private String default_display_val;
	private String from_clob_default_display_val;
	private String num_rows;
	private String num_cols;
	private String element_id;
	private String element_group_id;
	private String is_selected;
	private String is_multiselect;
	private String field_type;
	private String sqlString;
	private CachedRowSet rset;
	private ResultSet clobRset;
	private AppConstants appConstants;
	

	Database db;

	public FormElement(String type_name, String display_name, String table_location_row, String table_location_col, String size_length, String html_name, String do_validate,
			String default_val, String default_display_val, String num_rows, String num_cols, String group_id, String is_selected, String element_id, String is_multiselect,
			String field_type) {
		this.type_name = "";
		this.display_name = "";
		this.table_location_row = "";
		this.table_location_col = "";
		this.size_length = "";
		this.html_name = "";
		this.do_validate = "";
		this.default_val = "";
		from_clob_default_val = "";
		this.default_display_val = "";
		from_clob_default_display_val = "";
		this.num_rows = "";
		this.num_cols = "";
		this.element_id = "";
		element_group_id = "";
		this.is_selected = "";
		this.is_multiselect = "";
		this.field_type = "";
		appConstants = new AppConstants();
		setElementProperties(type_name, display_name, table_location_row, table_location_col, size_length, html_name, do_validate, default_val, default_display_val, num_rows,
				num_cols, group_id, is_selected, element_id, is_multiselect, field_type);
	}

	public FormElement(String element_id, Statement stmt, Database db) {
		type_name = "";
		display_name = "";
		table_location_row = "";
		table_location_col = "";
		size_length = "";
		html_name = "";
		do_validate = "";
		default_val = "";
		from_clob_default_val = "";
		default_display_val = "";
		from_clob_default_display_val = "";
		num_rows = "";
		num_cols = "";
		this.element_id = "";
		element_group_id = "";
		is_selected = "";
		is_multiselect = "";
		field_type = "";
		appConstants = new AppConstants();
		try {
			sqlString = "select type_name,display_name,table_location_row , table_location_col,size_lengt"
					+ "h,html_name , do_validate,num_rows,num_cols ,form_element_group_id , is_selected" + ",is_multiselect, field_type from form_element where form_element_id="
					+ db.plSqlSafeString(element_id);
			rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				sqlString = "select default_display_val, default_val from form_element where form_element_id=" + db.plSqlSafeString(element_id);
				clobRset = db.runSQLResultSet(sqlString, stmt);
				if (clobRset.next()) {
					FormElement _tmp = this;
					if (AppConstants.DATABASE_TYPE == 1) {
						Clob cl = clobRset.getClob("default_display_val");
						if (cl != null) {
							from_clob_default_display_val = cl.getSubString(1L, (int) cl.length());
							if (from_clob_default_display_val == null || from_clob_default_display_val.equals("null")) {
								from_clob_default_display_val = "";
							}
						}
						cl = clobRset.getClob("default_val");
						if (cl != null) {
							from_clob_default_val = cl.getSubString(1L, (int) cl.length());
							if (from_clob_default_val == null || from_clob_default_val.equals("null")) {
								from_clob_default_val = "";
							}
						}
					} else {
						from_clob_default_val = clobRset.getString("default_val");
						from_clob_default_display_val = clobRset.getString("default_display_val");
					}
				}
				setElementProperties(rset.getString("type_name"), rset.getString("display_name"), rset.getString("table_location_row"), rset.getString("table_location_col"),
						rset.getString("size_length"), rset.getString("html_name"), rset.getString("do_validate"), from_clob_default_val, from_clob_default_display_val,
						rset.getString("num_rows"), rset.getString("num_cols"), rset.getString("form_element_group_id"), rset.getString("is_selected"), element_id,
						rset.getString("is_multiselect"), rset.getString("field_type"));
			}
		} catch (Exception e) {
			System.out.println("Trying to query the form_element table - We have an exception!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}

	private void setElementProperties(String type_name, String display_name, String table_location_row, String table_location_col, String size_length, String html_name,
			String do_validate, String default_val, String default_display_val, String num_rows, String num_cols, String group_id, String is_selected, String element_id,
			String is_multiselect, String field_type) {
		this.type_name = db.plSqlSafeString(type_name);
		this.display_name = db.plSqlSafeString(display_name);
		this.table_location_row = db.plSqlSafeString(table_location_row);
		this.table_location_col = db.plSqlSafeString(table_location_col);
		this.size_length = db.plSqlSafeString(size_length);
		this.html_name = db.plSqlSafeString(html_name);
		this.do_validate = db.plSqlSafeString(do_validate);
		this.default_val = db.plSqlSafeString(default_val);
		this.default_display_val = db.plSqlSafeString(default_display_val);
		this.num_rows = db.plSqlSafeString(num_rows);
		this.num_cols = db.plSqlSafeString(num_cols);
		this.element_id = db.plSqlSafeString(element_id);
		element_group_id = db.plSqlSafeString(group_id);
		this.is_selected = db.plSqlSafeString(is_selected);
		this.is_multiselect = db.plSqlSafeString(is_multiselect);
		this.field_type = db.plSqlSafeString(field_type);
	}

	public String getTypeName() {
		if (type_name == null || type_name.equals("null") || type_name.equals("")) {
			type_name = "";
		}
		return type_name;
	}

	public String getDisplayName() {
		if (display_name == null || display_name.equals("null") || display_name.equals("")) {
			display_name = "";
		}
		return display_name;
	}

	public String getTableRowLocation() {
		if (table_location_row == null || table_location_row.equals("null") || table_location_row.equals("")) {
			table_location_row = "";
		}
		return table_location_row;
	}

	public String getTableColLocation() {
		if (table_location_col == null || table_location_col.equals("null") || table_location_col.equals("")) {
			table_location_col = "";
		}
		return table_location_col;
	}

	public String getSizeLength() {
		if (size_length == null || size_length.equals("null") || size_length.equals("")) {
			size_length = "";
		}
		return size_length;
	}

	public String getHtmlName() {
		if (html_name == null || html_name.equals("null") || html_name.equals("")) {
			html_name = "";
		}
		return html_name;
	}

	public String getDoValidate() {
		if (do_validate == null || do_validate.equals("null") || do_validate.equals("")) {
			do_validate = "";
		}
		return do_validate;
	}

	public String getDefaultVal() {
		if (default_val == null || default_val.equals("null") || default_val.equals("")) {
			default_val = "";
		}
		return default_val;
	}

	public String getDefaultDisplayVal() {
		if (default_display_val == null || default_display_val.equals("null") || default_display_val.equals("")) {
			default_display_val = "";
		}
		return default_display_val;
	}

	public String getNumRows() {
		if (num_rows == null || num_rows.equals("null") || num_rows.equals("")) {
			num_rows = "";
		}
		return num_rows;
	}

	public String getNumCols() {
		if (num_cols == null || num_cols.equals("null") || num_cols.equals("")) {
			num_cols = "";
		}
		return num_cols;
	}

	public String getElementId() {
		if (type_name == null || type_name.equals("null") || type_name.equals("")) {
			type_name = "";
		}
		return element_id;
	}

	public String getGroupId() {
		if (element_group_id == null || element_group_id.equals("null") || element_group_id.equals("")) {
			element_group_id = "";
		}
		return element_group_id;
	}

	public String getIsSelected() {
		if (is_selected == null || is_selected.equals("null") || is_selected.equals("")) {
			is_selected = "";
		}
		return is_selected;
	}

	public String getIsMultiSelect() {
		if (is_multiselect == null || is_multiselect.equals("null") || is_multiselect.equals("")) {
			is_multiselect = "";
		}
		return is_multiselect;
	}

	public String getFieldType() {
		if (field_type == null || field_type.equals("null") || field_type.equals("")) {
			field_type = "";
		}
		return field_type;
	}
}
