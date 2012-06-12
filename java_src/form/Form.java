package form;

import admin.Database;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.Statement;
import java.util.Hashtable;
import java.util.Vector;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package form:
//            FormLayoutManager, FormTableLayoutManager, FormElementsManager, FormElement

public class Form {

	String sqlString;
	Database db;

	public Form(Database p_db) {
		sqlString = "";
		db = p_db;
	}

	public void addForm(Statement stmt, String form_name, String form_method, String submit_caption, String reset_caption, String is_multipart, String cancel_back_caption,
			String is_approved, String real_form_id, String approval_requested, String modified_by_auth_id, String form_type) throws Exception {
		if (is_multipart != null && is_multipart.equals("on")) {
			is_multipart = "y";
		} else {
			is_multipart = "n";
		}
		sqlString = "insert into form_repository (form_name, form_method, submit_caption, reset_capti"
				+ "on, is_multipart, cancel_back_caption, is_approved, real_form_id, approval_reque" + "sted, modified_by_auth_id, form_type) values ('"
				+ form_name + "','"
				+ form_method + "','"
				+ submit_caption + "','"
				+ reset_caption + "','"
				+ is_multipart + "','"
				+ cancel_back_caption + "','"
				+ is_approved + "','"
				+ real_form_id + "','" 
				+ approval_requested + "','" 
				+ modified_by_auth_id + "','" 
				+ form_type + "')";
		try {
			db.runSQL(sqlString, stmt);
		} catch (Exception e) {
			throw e;
		}
	}

	public String copyForm(Statement stmt, String form_id, String is_approved, String real_form_id, String approval_requested, String modified_by_auth_id) throws Exception {
		String unApprovedFormId = "";
		String old_form_layout_id = "";
		String new_group_id = "";
		String old_group_id = "";
		String form_layout_id = "";
		Vector feVector = null;
		Hashtable hashtable = new Hashtable();
		FormLayoutManager flm = new FormLayoutManager(db);
		FormTableLayoutManager ftlm = new FormTableLayoutManager(db, stmt);
		FormElementsManager fem = new FormElementsManager();
		sqlString = "select * from form_repository where form_id=" + form_id;
		try {
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				Statement xstmt = db.m_conn.createStatement();
				addForm(xstmt, rset.getString("form_name"), rset.getString("form_method"), rset.getString("submit_caption"), rset.getString("reset_caption"),
						rset.getString("is_multipart"), rset.getString("cancel_back_caption"), is_approved, real_form_id, approval_requested, modified_by_auth_id,
						rset.getString("form_type"));
				unApprovedFormId = db.getInsertedIndexValue(xstmt, "form_id_seq");
				rset.close();
				rset = flm.getFormLayout(form_id);
				if (rset != null) {
					form_layout_id = flm.CopyFormLayout(rset.getString("layout_table_rows"), rset.getString("layout_table_cols"), rset.getString("layout_table_cellpadd"),
							rset.getString("layout_table_cellspace"), rset.getString("layout_table_border"), rset.getString("layout_table_width"),
							rset.getString("layout_table_align"), unApprovedFormId, stmt);
					old_form_layout_id = rset.getString("form_layout_id");
					ftlm.updateFormHtmlLayout(flm.getHtmlFormTableStructure(), form_layout_id, stmt);
					feVector = fem.getFormElements(old_form_layout_id, db);
					for (int n = 0; n < feVector.size(); n++) {
						FormElement formElement = (FormElement) feVector.elementAt(n);
						old_group_id = formElement.getGroupId();
						if (old_group_id != null && !old_group_id.equals("")) {
							if (!hashtable.isEmpty()) {
								if (!hashtable.containsKey(old_group_id)) {
									new_group_id = getNewInsertedGroupID(old_group_id, form_layout_id, rset, xstmt, stmt);
									hashtable.put(old_group_id, new_group_id);
								} else {
									new_group_id = (String) hashtable.get(old_group_id);
								}
							} else {
								new_group_id = getNewInsertedGroupID(old_group_id, form_layout_id, rset, xstmt, stmt);
								hashtable.put(old_group_id, new_group_id);
							}
						}
						fem.insertFormElement(formElement.getTypeName(), formElement.getHtmlName(), formElement.getDisplayName(), formElement.getTableRowLocation(),
								formElement.getTableColLocation(), formElement.getSizeLength(), formElement.getDoValidate(), formElement.getDefaultVal(),
								formElement.getDefaultDisplayVal(), formElement.getNumRows(), formElement.getNumCols(), new_group_id, formElement.getIsSelected(), form_layout_id,
								formElement.getIsMultiSelect(), formElement.getFieldType(), stmt, db);
					}

					hashtable.clear();
				}
				xstmt.close();
			}
		} catch (Exception e) {
			throw e;
		}
		return unApprovedFormId;
	}

	private String getNewInsertedGroupID(String old_group_id, String form_layout_id, CachedRowSet rset, Statement xstmt, Statement stmt) {
		String new_group_id = "";
		sqlString = "select group_name from form_element_group where form_element_group_id=" + old_group_id;
		try {
			rset = db.runSQL(sqlString, xstmt);
			if (rset.next()) {
				sqlString = "insert into form_element_group (group_name, form_layout_id) values ('" + rset.getString("group_name") + "','" + form_layout_id + "')";
				db.runSQL(sqlString, stmt);
				new_group_id = db.getInsertedIndexValue(xstmt, "form_element_group_id_seq");
			}
		} catch (Exception e) {
			System.out.println("Exception occured in Form.getNewInsertedGroupID()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return new_group_id;
	}

	public void updateForm(Statement stmt, String form_name, String form_method, String submit_caption, String reset_caption, String form_id, String cancel_back_caption,
			String ismultipart, String is_approved, String real_form_id, String approval_requested, String modified_by_auth_id) throws Exception {
		if (ismultipart != null && ismultipart.equals("on")) {
			ismultipart = "y";
		} else {
			ismultipart = "n";
		}
		sqlString = "update form_repository set form_name = '" + form_name + "', form_method = '" + form_method + "', submit_caption = '" + submit_caption + "', reset_caption = '"
				+ reset_caption + "', cancel_back_caption ='" + cancel_back_caption + "', is_multipart ='" + ismultipart + "', is_approved = '" + is_approved
				+ "',  real_form_id = '" + real_form_id + "', approval_requested = '" + approval_requested + "', modified_by_auth_id ='" + modified_by_auth_id
				+ "' where form_id = " + form_id;
		try {
			db.runSQL(sqlString, stmt);
		} catch (Exception e) {
			throw e;
		}
	}

	public boolean deleteForm(String form_id, Statement stmt) {
		String form_layout_id = "";
		boolean retVal = true;
		FormElementsManager fem = new FormElementsManager();
		sqlString = "select form_layout_id from form_layout where form_id=" + form_id;
		try {
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			CachedRowSet xrset;
			if (rset.next()) {
				do {
					form_layout_id = rset.getString("form_layout_id");
					sqlString = "select form_element.form_element_id from form_element, form_layout where form_el" + "ement.form_layout_id=" + form_layout_id;
					xrset = db.runSQL(sqlString, stmt);
					if (xrset.next()) {
						do {
							fem.deleteFormElement(xrset.getString("form_element_id"), "", "", stmt, db);
						} while (xrset.next());
					}
					sqlString = "select form_layout_id from form_element_group where form_layout_id=" + form_layout_id;
					xrset = db.runSQL(sqlString, stmt);
					if (xrset.next()) {
						sqlString = "delete from form_element_group where form_layout_id=" + form_layout_id;
						db.runSQL(sqlString, stmt);
					}
					sqlString = "delete from form_layout where form_layout_id=" + form_layout_id;
					db.runSQL(sqlString, stmt);
				} while (rset.next());
			}
			rset.close();
			sqlString = "select form_layout_form_rel.flfr_id as flfr_id from form_process, form_layout_fo"
					+ "rm_rel where form_layout_form_rel.flfr_id=form_process.flfr_id and form_layout_f" + "orm_rel.form_id=" + form_id;
			for (xrset = db.runSQL(sqlString, stmt); xrset.next(); db.runSQL(sqlString, stmt)) {
				sqlString = "delete from form_process where flfr_id=" + xrset.getString("flfr_id");
			}

			xrset.close();
			sqlString = "delete from form_repository where form_id=" + form_id;
			db.runSQL(sqlString, stmt);
			sqlString = "delete from form_layout_form_rel where form_id=" + form_id;
			db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			retVal = false;
			System.out.println("Trying to delete a form - We have an exception!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return retVal;
	}

	public CachedRowSet getFormSettings(Statement stmt, String form_id) {
		sqlString = "select * from form_repository where form_id=" + form_id;
		try {
			CachedRowSet cachedrowset = db.runSQL(sqlString, stmt);
			return cachedrowset;
		} catch (Exception e) {
			CachedRowSet cachedrowset1 = null;
			return cachedrowset1;
		}
	}

	public boolean isFormApproved(String form_id) {
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select form_id from form_repository where is_approved='f' and form_id=" + form_id;
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			boolean ret;
			if (rset.next()) {
				ret = false;
			} else {
				ret = true;
			}
			rset.close();
			stmt.close();
			boolean flag = ret;
			return flag;
		} catch (Exception e) {
			System.out.println("An exception occurred in isFormApproved().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			boolean flag1 = false;
			return flag1;
		}
	}

	public boolean getRequestedApproval(String form_id) {
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select form_id from form_repository where approval_requested='t' and form_id=" + form_id;
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			boolean ret;
			if (rset.next()) {
				ret = true;
			} else {
				ret = false;
			}
			rset.close();
			stmt.close();
			boolean flag = ret;
			return flag;
		} catch (Exception e) {
			System.out.println("An exception occurred in getRequestedApproval().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			boolean flag1 = false;
			return flag1;
		}
	}

	public boolean isSubscriptionForm(String form_id, String form_layout_id) {
		boolean retVal = false;
		if (!form_id.equals("")) {
			sqlString = "select form_id from form_repository where form_type='subscription' and form_id=" + form_id;
		} else {
			sqlString = "select form_repository.form_id from form_repository, form_layout where form_repo"
					+ "sitory.form_type='subscription' and form_repository.form_id=form_layout.form_id " + "and form_layout.form_layout_id=" + form_layout_id;
		}
		try {
			Statement stmt = db.m_conn.createStatement();
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				retVal = true;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An exception occurred in  Form.isSubscriptionForm().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
		return retVal;
	}

	public static String getMaxNumRowCol(String row_col_type, String form_layout_id, Statement stmt, Database db) {
		String stsqlString;
		if (row_col_type.equals("row")) {
			stsqlString = "select table_location_row from form_element where form_layout_id=" + form_layout_id + " order by table_location_row desc";
		} else {
			stsqlString = "select table_location_col from form_element where form_layout_id=" + form_layout_id + " order by table_location_col desc";
		}
		String s3;
		try {
			CachedRowSet strset = db.runSQL(stsqlString, stmt);
			if (strset.next()) {
				if (row_col_type.equals("row")) {
					String s = strset.getString("table_location_row");
					return s;
				} else {
					String s2 = strset.getString("table_location_col");
					return s2;
				}
			} else {
				String s1 = "0";
				return s1;
			}
		} catch (Exception e) {
			s3 = "0";
		}
		return s3;
	}
}
