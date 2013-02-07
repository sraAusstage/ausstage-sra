package form;

import admin.AppConstants;
import admin.Database;
import java.io.PrintStream;
import java.sql.*;
import java.util.Vector;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package form:
//            FormElementsManager, FormValidationManager, FormElement

public class FormTableLayoutManager {

	private Database db;
	private String sqlString;
	private String finalHtmlFormStr;
	private String finalJavaScriptStr;
	private FormElementsManager formElementsManager;
	private AppConstants appConstants;
	private FormValidationManager fvm;
	private ResultSet rset;
	private Statement stmt;

	public FormTableLayoutManager(Database p_db) {
		finalHtmlFormStr = "";
		finalJavaScriptStr = "";
		appConstants = new AppConstants();
		try {
			db = p_db;
			sqlString = "";
			formElementsManager = new FormElementsManager();
			fvm = new FormValidationManager(db);
		} catch (Exception exception) {
		}
	}

	public FormTableLayoutManager(Database p_db, Statement p_stmt) {
		finalHtmlFormStr = "";
		finalJavaScriptStr = "";
		appConstants = new AppConstants();
		try {
			db = p_db;
			stmt = p_stmt;
		} catch (Exception exception) {
		}
	}

	public String getFinalHtmlFormStr(String form_layout_id) {
		if (form_layout_id != null && !form_layout_id.equals("") && !form_layout_id.equals("null")) {
			String htmlformlayout = "";
			try {
				Statement stmt = db.m_conn.createStatement();
				sqlString = "select htmlformlayout from form_layout where form_layout_id=" + form_layout_id;
				rset = db.runSQLResultSet(sqlString, stmt);
				if (rset.next()) {
					FormTableLayoutManager _tmp = this;
					if (AppConstants.DATABASE_TYPE == 1) {
						Clob cl = rset.getClob("htmlformlayout");
						if (cl != null) {
							htmlformlayout = cl.getSubString(1L, (int) cl.length());
							if (htmlformlayout == null) {
								htmlformlayout = "";
							}
						}
					} else {
						htmlformlayout = rset.getString("htmlformlayout");
					}
				}
				finalHtmlFormStr = htmlformlayout;
				stmt.close();
			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("Trying to get the CLOB htmlformlayout from the form_layout table");
				System.out.println("The query is " + sqlString);
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
		return finalHtmlFormStr;
	}

	public void addFormLayout(String form_id, String rows, String cols, String cellpadd, String cellspace, String tabel_border, String tabel_width, String tabel_align,
			Statement stmt) {
		sqlString = "insert into form_layout (form_id, layout_table_rows, layout_table_cols, layout_t"
				+ "able_cellpadd, layout_table_cellspace, layout_table_border, layout_table_width, " + "layout_table_align) values ('" + form_id + "','" + rows + "','" + cols
				+ "','" + cellpadd + "','" + cellspace + "','" + tabel_border + "','" + tabel_width + "','" + tabel_align + "')";
		try {
			db.runSQLResultSet(sqlString, stmt);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to add form layout into form_layout table");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void updateFormLayout(String form_layout_id, String rows, String cols, String cellpadd, String cellspace, String tabel_border, String tabel_width, String table_align,
			Statement stmt) {
		sqlString = "update form_layout set layout_table_rows='" + rows + "', layout_table_cols='" + cols + "', layout_table_cellpadd='" + cellpadd + "', layout_table_cellspace='"
				+ cellspace + "', layout_table_border='" + tabel_border + "', layout_table_width='" + tabel_width + "', layout_table_align='" + table_align
				+ "' where form_layout_id=" + form_layout_id;
		try {
			db.runSQLResultSet(sqlString, stmt);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to update the form layout in the form_layout table");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void updateFormHtmlLayout(String finalFormHtmlStr, String form_layout_id, Statement stmt) {
		try {
			if (AppConstants.DATABASE_TYPE == 1) {
				CallableStatement callable = db.m_conn.prepareCall("begin UPDATE_HTMLFORMLAYOUT (" + form_layout_id + ", '" + db.plSqlSafeString(finalFormHtmlStr) + "'); end;");
				callable.execute();
				callable.close();
			} else {
				sqlString = "update form_layout set htmlformlayout='" + db.plSqlSafeString(finalFormHtmlStr) + "' where form_layout_id=" + form_layout_id;
				db.runSQL(sqlString, stmt);
			}
		} catch (Exception e) {
			System.out.println("Trying to update the htmlformlayout in the form_layout table - We have an except" + "ion!!!");
		}
	}

	public void insertFormHtmlLayout(String finalFormHtmlStr, String form_layout_id, Statement stmt) {
		try {
			if (AppConstants.DATABASE_TYPE == 1) {
				CallableStatement callable = db.m_conn.prepareCall("begin INSERT_HTMLFORMLAYOUT ('" + db.plSqlSafeString(finalFormHtmlStr) + "'); end;");
				callable.execute();
				callable.close();
			} else {
				sqlString = "insert into form_layout (htmlformlayout) values (" + finalFormHtmlStr + ")";
				db.runSQL(sqlString, stmt);
			}
		} catch (Exception e) {
			System.out.println("Trying to execute a stored procedure - We have an exception!!!");
		}
	}

	public String getFormHtmlLayout(String form_layout_id, Statement stmt) {
		String itemText = "";
		sqlString = "select htmlformlayout from form_layout where form_layout_id=" + form_layout_id;
		try {
			rset = db.runSQLResultSet(sqlString, stmt);
			rset.next();
			FormTableLayoutManager _tmp = this;
			if (AppConstants.DATABASE_TYPE == 1) {
				Clob cl = rset.getClob("htmlformlayout");
				if (cl != null) {
					itemText = cl.getSubString(1L, (int) cl.length());
					if (itemText == null) {
						itemText = "";
					}
				}
			} else {
				itemText = rset.getString("htmlformlayout");
			}
		} catch (Exception e) {
			System.out.println("Trying to execute FormTableLayoutManager.getFormHtmlLayout()");
			String s = null;
			return s;
		}
		return itemText;
	}

	public boolean isFormHtmlLayoutEmpty(String form_layout_id, Statement stmt) {
		String itemText = "";
		sqlString = "select htmlformlayout from form_layout where form_layout_id=" + form_layout_id;
		try {
			rset = db.runSQLResultSet(sqlString, stmt);
			rset.next();
			FormTableLayoutManager _tmp = this;
			if (AppConstants.DATABASE_TYPE == 1) {
				Clob cl = rset.getClob("htmlformlayout");
				if (cl != null) {
					boolean flag1 = false;
					return flag1;
				} else {
					boolean flag4 = true;
					return flag4;
				}
			}
			itemText = rset.getString("htmlformlayout");
			if (itemText != null) {
				boolean flag = false;
				return flag;
			} else {
				boolean flag2 = true;
				return flag2;
			}
		} catch (Exception e) {
			System.out.println("Trying to execute FormTableLayoutManager.isFormHtmlLayoutEmpty()");
		}
		boolean flag3 = true;
		return flag3;
	}

	public CachedRowSet getTableSettings(String form_layout_id, Statement stmt) {
		CachedRowSet ret = null;
		sqlString = "select form_layout_id, layout_table_rows, layout_table_cols, layout_table_cellpa"
				+ "dd, layout_table_cellspace, layout_table_border, layout_table_width, layout_tabl" + "e_align, form_id from form_layout where form_layout_id=" + form_layout_id;
		try {
			ret = db.runSQL(sqlString, stmt);
		} catch (Exception e) {
			System.out.println("Exception occured in getTableSettings()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return ret;
	}

	public String getTableAlign(String form_layout_id, Statement stmt) {
		String tableAlignment = "left";
		try {
			CachedRowSet rset = getTableSettings(form_layout_id, stmt);
			if (rset.next()) {
				tableAlignment = rset.getString("layout_table_align");
			}
		} catch (Exception e) {
			System.out.println("Exception occured in getTableAlign()");
		}
		return tableAlignment;
	}

	public String getLayoutTableStructure(String form_layout_id, String layout_table_width, String rows, String cols) {
		int elementIndex = 0;
		int numRow = Integer.parseInt(rows);
		int numCol = Integer.parseInt(cols);
		String numTableCol = cols;
		String RowColTag = "";
		String type_name = "";
		String display_name = "";
		String table_row_location = "";
		String table_col_location = "";
		String size_length = "";
		String html_name = "";
		String do_validate = "";
		String default_val = "";
		String default_display_val = "";
		String num_rows = "";
		String num_cols = "";
		String element_id = "";
		String is_selected = "";
		String element_group_id = "";
		String is_multiselect = "";
		String field_type = "";
		String temp_html_names = "";
		boolean foundElementLocation = false;
		if (layout_table_width == null || layout_table_width.equals("")) {
			layout_table_width = "0";
		}
		Vector form_elements_vec = formElementsManager.getFormElements(form_layout_id, db);
		foundElementLocation = false;
		for (int r = 1; r < numRow + 1; r++) {
			RowColTag = RowColTag + "<tr>\n";
			finalHtmlFormStr += "<tr>\n";
			for (int c = 1; c < numCol + 1; c++) {
				RowColTag = RowColTag + "\t<td ";
				finalHtmlFormStr += "\t<td ";
				foundElementLocation = false;
				if (form_elements_vec.size() > 0) {
					int n = 0;
					do {
						if (n >= form_elements_vec.size()) {
							break;
						}
						FormElement formElement = (FormElement) form_elements_vec.elementAt(n);
						type_name = formElement.getTypeName();
						display_name = formElement.getDisplayName();
						table_row_location = formElement.getTableRowLocation();
						table_col_location = formElement.getTableColLocation();
						size_length = formElement.getSizeLength();
						html_name = formElement.getHtmlName();
						do_validate = formElement.getDoValidate();
						default_val = formElement.getDefaultVal();
						default_display_val = formElement.getDefaultDisplayVal();
						num_rows = formElement.getNumRows();
						num_cols = formElement.getNumCols();
						element_id = formElement.getElementId();
						is_selected = formElement.getIsSelected();
						element_group_id = formElement.getGroupId();
						is_multiselect = formElement.getIsMultiSelect();
						field_type = formElement.getFieldType();
						if (type_name == null || type_name.equals("")) {
							type_name = "";
						}
						if (display_name == null || display_name.equals("")) {
							display_name = "";
						}
						if (size_length == null || size_length.equals("")) {
							size_length = "";
						}
						if (html_name == null || html_name.equals("")) {
							html_name = "";
						}
						if (do_validate == null || do_validate.equals("")) {
							do_validate = "";
						}
						if (num_rows == null || num_rows.equals("")) {
							num_rows = "";
						}
						if (num_cols == null || num_cols.equals("")) {
							num_cols = "";
						}
						if (element_id == null || element_id.equals("")) {
							element_id = "";
						}
						if (is_selected == null || is_selected.equals("")) {
							is_selected = "";
						}
						if (is_multiselect == null || is_multiselect.equals("")) {
							is_multiselect = "";
						}
						if (element_group_id == null || element_group_id.equals("")) {
							element_group_id = "";
						}
						if (default_val == null || default_val.equals("")) {
							default_val = "";
						}
						if (default_display_val == null || default_display_val.equals("")) {
							default_display_val = "";
						}
						if (Integer.parseInt(table_row_location) == r && Integer.parseInt(table_col_location) == c) {
							foundElementLocation = true;
							break;
						}
						n++;
					} while (true);
					if (do_validate.equals("y")) {
						if (!temp_html_names.equals("")) {
							temp_html_names = temp_html_names + "|";
						}
						if (temp_html_names.indexOf(html_name) == -1) {
							temp_html_names = temp_html_names + html_name;
							finalJavaScriptStr += fvm.buildJavaScriptValidatator(form_layout_id, html_name, field_type, display_name, default_val);
						}
					}
				}
				if (foundElementLocation) {
					RowColTag = RowColTag
							+ LayoutRenderrer(form_layout_id, layout_table_width, size_length, display_name, type_name, html_name, default_val, num_rows, num_cols,
									default_display_val, element_id, numTableCol, is_selected, element_group_id, is_multiselect);
					RowColTag = RowColTag + "\t</td>\n";
					finalHtmlFormStr += "\t</td>\n";
				} else {
					RowColTag = RowColTag
							+ ("><div onclick=\"setAddElementLocation('" + r + "','" + c + "','" + form_layout_id
									+ "'); styleBkrnd(this);\" onmouseover=\"this.style.cursor='hand';\">"
									+ "<table width='100%' border='0' cellspacing='0' cellpadding='0'><tr>\n<td>&nbsp;\n" + "</td>\n</tr>\n</table>\n</div>\n</td>\n");
					finalHtmlFormStr += ">&nbsp;</td>\n";
				}
			}

			RowColTag = RowColTag + "</tr>\n";
			finalHtmlFormStr += "</tr>\n";
		}

		form_elements_vec.clear();
		return RowColTag;
	}

	private String LayoutRenderrer(String form_layout_id, String layout_table_width, String size_length, String display_name, String type_name, String html_name,
			String default_val, String rows, String cols, String default_display_val, String element_id, String numTableCol, String is_selected, String element_group_id,
			String is_multiselect) {
		String RowColTag = "";
		String htmlElement = "";
		String temp_rowcoltag = "";
		if (type_name.equals("label")) {
			RowColTag = ">" + getLayoutRenderedHeader(default_val, type_name, form_layout_id, element_id);
			finalHtmlFormStr += "><table border='0' cellspacing='0' cellpadding='0'>\n<tr>\n<td class=INPUT_LABEL" + ">" + default_val + getLayoutRenderedFooter() + "\n";
			RowColTag = RowColTag + (htmlElement + getLayoutRenderedFooter() + getElementOnclickControlEnd());
		} else {
			htmlElement = getHtmlElement(type_name, size_length, html_name, default_val, rows, cols, default_display_val, is_selected, element_group_id, is_multiselect,
					form_layout_id, element_id);
			RowColTag = ">" + getLayoutRenderedHeader(display_name, type_name, form_layout_id, element_id);
			temp_rowcoltag = ">" + getElementOnclickControlBegin(form_layout_id, element_id) + getLayoutRenderedHeader(display_name, type_name, form_layout_id, element_id)
					+ htmlElement;
			finalHtmlFormStr += RowColTag + htmlElement + getLayoutRenderedFooter();
			temp_rowcoltag = temp_rowcoltag + (getLayoutRenderedFooter() + getElementOnclickControlEnd());
			RowColTag = temp_rowcoltag;
		}
		return RowColTag;
	}

	private String getLayoutRenderedHeader(String display_name, String type_name, String form_layout_id, String element_id) {
		String LayoutRenderedHeader = "";
		String temp_display_name = "";
		if (type_name.equals("label")) {
			LayoutRenderedHeader = "<table width='100%' border='0' cellspacing='0' cellpadding='0'>\n<tr>\n<td class" + "=INPUT_LABEL>" + display_name;
			LayoutRenderedHeader = getElementOnclickControlBegin(form_layout_id, element_id) + LayoutRenderedHeader;
		} else {
			LayoutRenderedHeader = "<table width='100%' border='0' cellspacing='0' cellpadding='0'>\n<tr>\n<td valig" + "n='top' align='left' class=INPUT_TITLE>" + display_name
					+ "</td>\n" + "</tr>\n<tr>\n<td valign='top' align='left'>";
		}
		return LayoutRenderedHeader;
	}

	private String getLayoutRenderedFooter() {
		String LayoutRenderedFooter = "";
		LayoutRenderedFooter = "</td>\n</tr>\n</table>\n";
		return LayoutRenderedFooter;
	}

	private String getElementOnclickControlBegin(String form_layout_id, String element_id) {
		return "<div onclick=\"setElementID(" + element_id + "); " + "styleBkrnd(this);\" onmouseover=\"this.style.cursor='hand';\">";
	}

	private String getElementOnclickControlEnd() {
		return "</div>\n";
	}

	private String getHtmlElement(String TypeName, String sizeLength, String htmlName, String defaultVal, String rows, String cols, String default_display_val, String is_selected,
			String element_group_id, String is_multiselect, String form_layout_id, String element_id) {
		String htmlElement = "";
		String subStr = "";
		boolean isPartOfGroup = false;
		if (TypeName.toUpperCase().equals("TEXTBOX")) {
			htmlElement = htmlElement + ("\t\t<input class=INPUT_FIELD type='text' name='" + htmlName + "' size='" + sizeLength + "' value='" + defaultVal + "'>\n");
		} else if (TypeName.toUpperCase().equals("TEXTAREA")) {
			htmlElement = htmlElement + ("\t\t<textarea class=INPUT_FIELD name='" + htmlName + "' cols='" + cols + "' rows='" + rows + "'>" + defaultVal + "</textarea>");
		} else if (TypeName.toUpperCase().equals("PULLDOWN")) {
			htmlElement = htmlElement
					+ ("\t\t\n<select class=INPUT_FIELD name='" + htmlName + "' size='1'>" + getParsedValue(defaultVal, TypeName, default_display_val, false, subStr, is_selected) + "\n\t\t</select>");
		} else if (TypeName.toUpperCase().equals("SELECTION")) {
			if (!is_multiselect.equals("") && is_multiselect.toUpperCase().equals("TRUE")) {
				subStr = "MULTIPLE";
			}
			htmlElement = htmlElement
					+ ("\t\t\n<select class=INPUT_FIELD name='" + htmlName + "' " + subStr + " size='" + sizeLength + "'>\n"
							+ getParsedValue(defaultVal, TypeName, default_display_val, false, subStr, is_selected) + "\n\t\t</select>");
		} else if (TypeName.toUpperCase().equals("CHECKBOX")) {
			if (!element_group_id.equals("")) {
				htmlName = formElementsManager.getElementGroupName(element_group_id, db);
			}
			if (!is_selected.equals("") && is_selected.toUpperCase().equals("TRUE")) {
				subStr = "CHECKED";
			}
			htmlElement = htmlElement + ("\t\t<input class=INPUT_CHECKBOX type='checkbox' " + subStr + " name='" + htmlName + "' value='" + defaultVal + "'>\n");
		} else if (TypeName.toUpperCase().equals("RADIOBUTTON")) {
			if (!element_group_id.equals("")) {
				htmlName = formElementsManager.getElementGroupName(element_group_id, db);
				isPartOfGroup = true;
			}
			if (!is_selected.equals("") && is_selected.toUpperCase().equals("TRUE")) {
				if (isPartOfGroup) {
					unSelectOtherButton(element_id, element_group_id, form_layout_id);
				}
				subStr = "CHECKED";
			}
			htmlElement = htmlElement + ("\t\t<input class=INPUT_CHECKBOX type='radio' " + subStr + " name='" + htmlName + "' value='" + defaultVal + "'>\n");
		} else {
			htmlElement = htmlElement + "\n";
		}
		return htmlElement;
	}

	protected String getFormEditControls(String form_layout_id) {
		String formEditCtrl = "<table align='center' border='0'>\n<tr><td align='center'>&nbsp;</td><td align='"
				+ "center'><a align='center' href=\"#\" onclick=\"return SubmitCheck('U');\"><img a"
				+ "lign='center' src='/custom/images/big_up.gif' alt=up border=0></a></td><td>&nbsp;"
				+ "</td></tr>\n<tr><td align='right'><a href=\"#\" align='right' onclick=\"return S"
				+ "ubmitCheck('L');\"><img align='right' src='/custom/images/prev.gif' alt=left bord"
				+ "er=0></a></td><td>&nbsp;</td><td align='left'><a href=\"#\" align='left' onclick"
				+ "=\"return SubmitCheck('R');\"><img align='left' src='/custom/images/next.gif' alt"
				+ "=right border=0></a></td></tr>\n<tr><td>&nbsp;</td><td align='center'><a href=\""
				+ "#\" align='center' onclick=\"return SubmitCheck('D');\"><img align='center' src="
				+ "'/custom/images/big_down.gif' alt=down border=0></a></td><td>&nbsp;</td></tr>\n</"
				+ "form>\n<tr><td colspan='3'>&nbsp;</td></tr><tr><td align='right'><a href=\"#\" o"
				+ "nclick=\"SubmitCheck('add');\"><img src='/custom/images/add_big.gif' alt=add bord"
				+ "er=0></a></td><td>&nbsp;</td>\n<td align='left'><a href=\"#\" onclick=\"SubmitCh"
				+ "eck('edit');\"><img src='/custom/images/edit_big.gif' alt=edit border=0></a></td>"
				+ "</tr>\n<tr><td align='right'><a href=\"#\" onclick=\"SubmitCheck('delete');\"><i"
				+ "mg src='/custom/images/delete_big.gif' alt=delete border=0></a></td><td>&nbsp;</t"
				+ "d>\n<td align='left'><a href=\"#\" onclick=\"TableEdit();\"><img src='/admin/ima"
				+ "ges/table_big.gif' alt='edit table' border=0></a></td></tr>\n<tr><td>&nbsp;</td>" + "<td align='center'><a href=\"#\" onclick=\"ViewForm('" + form_layout_id
				+ "');\"><img src='" + "/custom/images" + "/view.gif' alt='view form' border=0></a></td>\n" + "<td>&nbsp;</td></tr></table>";
		return formEditCtrl;
	}

	private void unSelectOtherButton(String element_id, String element_group_id, String form_layout_id) {
		if (element_id != null && !element_id.equals("") && element_group_id != null && !element_group_id.equals("") && form_layout_id != null && !form_layout_id.equals("")) {
			sqlString = "select form_element_id, is_selected, form_element_group_id, form_layout_id from " + "form_element where form_layout_id= " + form_layout_id + " "
					+ "and not form_element_id=" + element_id + " and is_selected='true'";
			try {
				Statement stmt = db.m_conn.createStatement();
				Statement x_stmt = db.m_conn.createStatement();
				CachedRowSet rset = db.runSQL(sqlString, stmt);
				if (rset.next()) {
					do {
						if (rset.getString("form_element_group_id") != null && rset.getString("form_element_group_id").equals(element_group_id)) {
							sqlString = "update form_element set is_selected='false' where form_element_id=" + rset.getString("form_element_id");
							db.runSQL(sqlString, x_stmt);
						}
					} while (rset.next());
				}
				stmt.close();
				x_stmt.close();
			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("Trying to unselect a radio button in the form_element table");
				System.out.println("The query is " + sqlString);
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
	}

	public int getArraySizeFromDelimetedStr(String delimetedStr, String delimeter) {
		String s = "";
		int arrSize = 0;
		if (delimetedStr != null && !delimetedStr.equals("")) {
			for (int o = 0; o < delimetedStr.length(); o++) {
				s = delimetedStr.substring(o, o + 1);
				if (s.equals(delimeter)) {
					arrSize++;
				}
			}

			arrSize++;
		}
		return arrSize;
	}

	public String[] splitIntoArray(String delimitedStr, String delimeter) {
		int x = 0;
		int arrSize = 0;
		String tempStr = "";
		String c = "";
		if (delimeter != null && !delimeter.equals("")) {
			arrSize = getArraySizeFromDelimetedStr(delimitedStr, delimeter);
		}
		String the_array[] = new String[arrSize];
		if (delimeter != null && !delimeter.equals("")) {
			for (int z = 0; z < delimitedStr.length(); z++) {
				c = delimitedStr.substring(z, z + 1);
				if (c.equals(delimeter)) {
					the_array[x] = tempStr;
					x++;
					tempStr = "";
				} else {
					tempStr = tempStr + c;
				}
			}

			the_array[x] = tempStr.trim();
		}
		return the_array;
	}

	public String getParsedValue(String defaultVal, String typeName, String default_display_val, boolean isEdit, String multiselect, String is_selected) {
		String retString = "";
		String tempStrVal = "";
		String tempStrDisplay = "";
		String v = "";
		String d = "";
		String selected = "";
		int arrSize = getArraySizeFromDelimetedStr(default_display_val, "|");
		int x = 0;
		String arrayVal[] = new String[arrSize];
		String arrayDisp[] = new String[arrSize];
		String isSelected[] = new String[arrSize];
		boolean noDefaultVal = false;
		boolean oneAlreadySelected = false;
		if (default_display_val != null && !default_display_val.equals("") && !default_display_val.toUpperCase().equals("NULL")) {
			if (typeName.toUpperCase().equals("PULLDOWN") || typeName.toUpperCase().equals("SELECTION")) {
				arrayDisp = splitIntoArray(default_display_val, "|");
				isSelected = splitIntoArray(is_selected, "|");
				x = 0;
				if (defaultVal != null && !defaultVal.equals("") && !defaultVal.toUpperCase().equals("NULL")) {
					for (int i = 0; i < defaultVal.length(); i++) {
						v = defaultVal.substring(i, i + 1);
						if (v.equals("|")) {
							if (isSelected[x].toUpperCase().equals("TRUE")) {
								if (!multiselect.equals("")) {
									if (multiselect.toUpperCase().equals("MULTIPLE")) {
										selected = "SELECTED";
									} else {
										if (!oneAlreadySelected) {
											selected = "SELECTED";
										}
										oneAlreadySelected = true;
									}
								} else {
									selected = "SELECTED";
								}
							}
							arrayVal[x] = "\n\t\t\t<option value='" + tempStrVal + "' " + selected + ">" + arrayDisp[x] + "</option>";
							x++;
							selected = "";
							tempStrVal = "";
						} else {
							tempStrVal = tempStrVal + v;
						}
					}

				} else {
					noDefaultVal = true;
					for (int i = 0; i < arrayDisp.length; i++) {
						arrayVal[i] = "\n\t\t\t<option value='" + arrayDisp[i] + "'>" + arrayDisp[i] + "</option>";
					}

				}
				if (!noDefaultVal) {
					if (isSelected[x].toUpperCase().equals("TRUE")) {
						if (!multiselect.equals("")) {
							if (multiselect.toUpperCase().equals("MULTIPLE")) {
								selected = "SELECTED";
							} else {
								if (!oneAlreadySelected) {
									selected = "SELECTED";
								}
								oneAlreadySelected = true;
							}
						} else {
							selected = "SELECTED";
						}
					}
					arrayVal[x] = "\n\t\t\t<option value='" + tempStrVal + "' " + selected + ">" + arrayDisp[x] + "</option>";
				}
			}
			for (x = 0; x < arrayVal.length; x++) {
				retString = retString + ("\t\t\t" + arrayVal[x] + "\n");
			}

		}
		return retString;
	}

	public String getFinalJavaScriptValidator() {
		String FinalJavaScriptValidator = "";
		if (!finalJavaScriptStr.equals("")) {
			FinalJavaScriptValidator = fvm.getJavaScriptValidator(finalJavaScriptStr);
		}
		return FinalJavaScriptValidator;
	}
}
