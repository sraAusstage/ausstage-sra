<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ page
	import="java.sql.Statement,sun.jdbc.rowset.CachedRowSet,java.util.*"%>
<%@ page import="ausstage.Event,ausstage.WorkWorkLink"%>
<%@ page import="ausstage.Work"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import="ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
	admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
	admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
	ausstage.Database db_ausstage = new ausstage.Database();
	int MAX_RESULTS_RETURNED = 1000;

	String sqlString;
	db_ausstage.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
	Statement stmt = db_ausstage.m_conn.createStatement();
	ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator(db_ausstage);

	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);

	Vector filter_display_names = new Vector();
	Vector filter_names = new Vector();
	Vector order_display_names = new Vector();
	Vector order_names = new Vector();
	Vector textarea_db_display_fields = new Vector();
	Vector buttons_names = new Vector();
	Vector buttons_actions = new Vector();
	String list_name;
	String selected_db_sql;
	String list_db_sql;
	String list_db_field_id_name;
	String selected_list_name;
	String selected_list_db_sql;
	String selected_list_db_field_id_name;
	Vector selected_list_db_display_fields = new Vector();
	String comeFromWorkAddeditPage = request.getParameter("f_from_work_add_edit_page");
	String filter_id;
	String filter_work_title;
	String filter_box_selected;
	Work w;
	String isPreviewForEventWork = request.getParameter("isPreviewForEventWork");
	if (isPreviewForEventWork == null){isPreviewForEventWork = "false";}
	String isPreviewForItemWork = request.getParameter("isPreviewForItemWork");
	if (isPreviewForItemWork == null){isPreviewForItemWork = "false";}
	

	Hashtable hidden_fields = new Hashtable();
	Work work = (Work) session.getAttribute("work");
	if (work == null) work = new Work(db_ausstage);
	//we don't want to loose any info added to the work_addedit.jsp form.
	//only set the work attributes if we have come from the addedit page.
	if (comeFromWorkAddeditPage != null && comeFromWorkAddeditPage.equals("true")) {
		work.setWorkAttributes(request);
	}
	boolean fromWorkPage = true;
	boolean isPreviewForWork = false;
	boolean isPartOfThisWork = false;

	if (request.getParameter("isPreviewForWork") == null) {
		isPreviewForWork = true;
		String work_id = request.getParameter("f_select_id");
		String title = request.getParameter("f_select_work_title");
		String alternate_title = request.getParameter("f_alter_work_title");
	}

	if (request.getParameter("fromWorkPage") == null) fromWorkPage = false;

	if (fromWorkPage) work.setWorkAttributes(request);

	String f_workid = work.getId();
	int workId = Integer.parseInt(f_workid);
	hidden_fields.put("f_workid", f_workid);
	hidden_fields.put("isPreviewForEventWork", isPreviewForEventWork);

	String f_select_this_work_id = request.getParameter("f_select_this_work_id");
	String f_unselect_this_work_id = request.getParameter("f_unselect_this_work_id");
	String orderBy = request.getParameter("f_order_by");
	//get me all the works from the current list
	//object in the session.

	Vector <WorkWorkLink> workWorkLinks = work.getWorkWorkLinks();
	//add the selected work to the work  
	if (f_select_this_work_id != null) {
		WorkWorkLink newWWL = new WorkWorkLink(db_ausstage);
		newWWL.setWorkId(f_workid);
		newWWL.setChildId(f_select_this_work_id);
		
		workWorkLinks.add(newWWL);
		work.setWorkWorkLinks(workWorkLinks);
	}
	//remove work from the work
	if (f_unselect_this_work_id != null) {
		for (WorkWorkLink existing : workWorkLinks) {
			if (existing.getChildId().equals(f_unselect_this_work_id)) {
				workWorkLinks.remove(existing);
				break;
			}
		}

		work.setWorkWorkLinks(workWorkLinks);
	}

	// Get the form parameters that are used to create the SQL that determines what
	// will be displayed in the list box (as this page posts to itself
	// when a user performs a search)
	filter_box_selected = request.getParameter("f_box_selected");
	filter_id = request.getParameter("f_search_id");
	filter_work_title = request.getParameter("f_search_work_title");

	filter_display_names.addElement("ID");
	filter_display_names.addElement("Title");
	filter_names.addElement("f_search_id");
	filter_names.addElement("f_search_work_title");

	order_display_names.addElement("Title");
	order_names.addElement("WORK_TITLE");

	list_name = "f_select_this_work_id";
	list_db_field_id_name = "workid";
	textarea_db_display_fields.addElement("output");

	selected_list_name = "f_unselect_this_work_id";
	selected_list_db_field_id_name = "workid";
	selected_list_db_display_fields.addElement("WORK_TITLE");

	/**********************************************************
	you can not edit/add a work through this page.
	i.e you can only link a item to an work, if and only if
	the work already exits.
	 ***********************************************************/

	buttons_names.addElement("Select");
	buttons_names.addElement("Finish");
	buttons_actions.addElement("Javascript:search_form.action='work_work.jsp';search_form.submit();");
	buttons_actions.addElement("Javascript:search_form.action='work_work_functions.jsp';search_form.submit();");

	selected_db_sql = "";
	Vector<WorkWorkLink> selectedWorks = new Vector<WorkWorkLink>();
	Vector temp_vector = new Vector();
	String temp_string = "";
	selectedWorks = work.getWorkWorkLinks();

	//because the vector that gets returned contains only linked
	//work ids as strings we need to create a temp vector
	//for display method displaySearchFilterAndSelector as used below.
	//it expects a vector with a Work id and the Work name.
	//i.e. "4455, Luke Sullivan".

	//for each Work id get name and add the id and the name to a temp vector.
	for (int i = 0; i < selectedWorks.size(); i++) {
		temp_string = work.getWorkInfoForDisplay(Integer.parseInt(selectedWorks.get(i).getChildId()), stmt);
		temp_vector.add(selectedWorks.get(i).getChildId());//add the id to the temp vector.
		temp_vector.add(temp_string);//add the Work name to the temp_vector.
	}
	selectedWorks = temp_vector;
	stmt.close();

	// if first time this form has been loaded
	if (filter_id == null) {

		list_db_sql = "SELECT work.workid, work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ') contribname, "
				+ "concat_ws(', ',work.work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ')) as output " + "FROM work  "
				+ "LEFT JOIN workconlink ON work.workid = workconlink.workid " + "LEFT JOIN contributor ON workconlink.contributorid = contributor.contributorid "
				+ "GROUP BY work.workid " + "ORDER BY LOWER(work_title)";
	} else {
		// Not the first time this page has been loaded
		// i.e the user performed a search
		list_db_sql = "SELECT work.workid, work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ') contribname, "
				+ "concat_ws(', ',work.work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ')) as output " + "FROM work  "
				+ "LEFT JOIN workconlink ON work.workid = workconlink.workid " + "LEFT JOIN contributor ON workconlink.contributorid = contributor.contributorid "
				+ "WHERE ";

		// Add the filters to the SQL
		if (!filter_id.equals("")) list_db_sql += " work.workid=" + filter_id + " and ";
		if (!filter_work_title.equals("")) {
			list_db_sql += " LOWER(work_title) like '%" + db_ausstage.plSqlSafeString(filter_work_title.toLowerCase()) + "%' ";
			list_db_sql += " OR LOWER(alter_work_title) like '%" + db_ausstage.plSqlSafeString(filter_work_title.toLowerCase()) + "%' ";
		} else {
			list_db_sql += " 1=1 ";
		}

		list_db_sql += "group by work.workid order by LOWER(" + request.getParameter("f_order_by") + ")";
	}
	hidden_fields.put("isPreviewForItemWork", isPreviewForItemWork );
	list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
	out.println(htmlGenerator.displaySearchFilterAndSelector(request, "Select Work", "Selected Work", filter_display_names, filter_names, order_display_names, order_names,
			list_name, list_db_sql, list_db_field_id_name, textarea_db_display_fields, selected_list_name, selectedWorks, selected_list_db_field_id_name, buttons_names,
			buttons_actions, hidden_fields, false, MAX_RESULTS_RETURNED));

	db_ausstage.disconnectDatabase();
	pageFormater.writePageTableFooter(out);
	pageFormater.writeFooter(out);
	session.setAttribute("work", work);
%>
<cms:include property="template" element="foot" />