package content;

import admin.Database;
import admin.*;
import form.*;
import java.io.PrintStream;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import metadata.Metadata;
import ausstage.Search;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package content:
//            Statistics, SiteMap

public class ContentOutput {

	private Database m_db;
	private AppConstants AppConstants;
	private FormTableLayoutManager ftlm;
	private Page pageObject;
	private HttpServletRequest m_request;
	private VectorTools m_vt;
	private String m_page_title;
	private String m_page_id;
	private String m_sect_id;
	private String m_parent_id;
	private String m_url;
	private String m_description;
	private boolean m_is_approved;
	private String m_real_page_id;
	private String m_modified_by_auth_id;
	private boolean m_approval_requested;
	private String m_layout_template_id;
	private String m_style_file_id;
	private String m_style_file_path;
	private boolean m_is_secure;
	private Vector m_style_elements;

	public ContentOutput(HttpServletRequest p_request, String p_page_id, Database p_db) {
		AppConstants = new AppConstants();
		m_page_title = "";
		boolean foundPage = false;
		Date l_text_body_date = new Date();
		ftlm = new FormTableLayoutManager(p_db);
		m_request = p_request;
		m_db = p_db;
		m_page_id = p_page_id;
		pageObject = new Page(p_db);
		m_vt = new VectorTools();
		m_style_elements = new Vector();
		for (int l_i = 0; l_i <= 16; l_i++) {
			m_style_elements.add("");
		}

		try {
			Date l_text_body_start_date = new Date();
			Date l_text_body_end_date = new Date();
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString = "SELECT * FROM pages WHERE pages.page_id = " + p_page_id;
			CachedRowSet pageRset = m_db.runSQL(sqlString, stmt);
			if (pageRset.next()) {
				foundPage = true;
				m_page_title = pageRset.getString("title");
				m_sect_id = pageRset.getString("sect_id");
				m_parent_id = pageRset.getString("parent_id");
				m_url = pageRset.getString("url");
				m_description = pageRset.getString("description");
				if (pageRset.getString("is_secure").equals("t")) {
					m_is_secure = true;
				} else {
					m_is_secure = false;
				}
				String tempString = pageRset.getString("is_approved");
				if (tempString == null || tempString.equals("t")) {
					m_is_approved = true;
				} else {
					m_is_approved = false;
				}
				m_real_page_id = pageRset.getString("real_page_id");
				m_modified_by_auth_id = pageRset.getString("modified_by_auth_id");
				tempString = pageRset.getString("approval_requested");
				if (tempString == null || tempString.equals("f")) {
					m_approval_requested = false;
				} else {
					m_approval_requested = true;
				}
				m_layout_template_id = pageRset.getString("layout_template_id");
				m_style_file_id = pageRset.getString("style_file_id");
				pageRset.close();
			}
			pageRset.close();
			sqlString = "SELECT * FROM style_files WHERE style_files.style_file_id = " + m_style_file_id;
			pageRset = m_db.runSQL(sqlString, stmt);
			if (pageRset.next()) {
				m_style_file_path = pageRset.getString("style_file_path");
				pageRset.close();
				sqlString = "SELECT style_file_elements.style_element_name, style_file_element_link.style_tar"
						+ "get_id FROM style_file_elements, style_file_element_link WHERE style_file_elemen"
						+ "ts.style_element_id = style_file_element_link.style_element_id AND style_file_el" + "ement_link.style_file_id = " + m_style_file_id + " "
						+ "ORDER BY style_file_element_link.style_target_id";
				for (pageRset = m_db.runSQL(sqlString, stmt); pageRset.next();) {
					int l_i = 0;
					while (l_i < m_style_elements.size()) {
						if (pageRset.getString("style_target_id").equals(Integer.toString(l_i))) {
							m_style_elements.setElementAt(pageRset.getString("style_element_name"), l_i);
							l_i = m_style_elements.size();
						}
						l_i++;
					}
				}

			}
			pageRset.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentOutput constructor.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	private String getMetadata() {
		try {
			Metadata metadata = new Metadata(m_db);
			Statement stmt = m_db.m_conn.createStatement();
			CachedRowSet rset = null;
			int i = 1;
			String l_buffer = "";
			if (m_page_id != null && !m_page_id.equals("null") && !m_page_id.equals("")) {
				rset = metadata.getResourceMetadatas(stmt, "page", m_page_id);
				l_buffer = String.valueOf("<META name=\"IDENTIFIER\" content=\"").concat(String.valueOf(AppConstants.PUBLIC_SITE_URL)) + m_url + "\">\n";
				for (l_buffer = l_buffer + ("<META name=\"TITLE\" content=\"" + m_page_title + "\">\n"); rset.next(); l_buffer = l_buffer
						+ ("<META name=\"" + rset.getString("name") + "\" content=\"" + rset.getString("value") + "\">\n")) {
				}
				rset.close();
			}
			stmt.close();
			String s1 = l_buffer;
			return s1;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentOutput.getMetadata.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s = "";
			return s;
		}
	}

	public String applyStyle(int p_style_target) {
		try {
			if (((String) m_style_elements.elementAt(p_style_target)).length() > 0) {
				String s = " class=\"" + (String) m_style_elements.elementAt(p_style_target) + "\"";
				return s;
			} else {
				String s1 = "";
				return s1;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentOutput.applyStyle");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s2 = "";
			return s2;
		}
	}

	public String applyStyleToForm(String p_form_content) {
		int l_index = 0;
		Common common = new Common();
		String l_parsed_str = "";
		try {
			l_parsed_str = common.ReplaceStrWithStr(p_form_content, "class=INPUT_FIELD", applyStyle(12));
			l_parsed_str = common.ReplaceStrWithStr(l_parsed_str, "class=INPUT_BUTTON", applyStyle(13));
			l_parsed_str = common.ReplaceStrWithStr(l_parsed_str, "class=INPUT_CHECKBOX", applyStyle(14));
			l_parsed_str = common.ReplaceStrWithStr(l_parsed_str, "class=INPUT_TITLE", applyStyle(15));
			l_parsed_str = common.ReplaceStrWithStr(l_parsed_str, "class=INPUT_LABEL", applyStyle(16));
			String s = l_parsed_str;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentOutput.applyStyleToForm");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String headControl() {
		Statistics l_stats = new Statistics(m_db);
		try {
			String l_buffer = "";
			l_buffer = l_buffer + getMetadata();
			l_buffer = l_buffer + genCSSFileLink();
			l_buffer = l_buffer + (String.valueOf("<title>").concat(String.valueOf(AppConstants.SITE_NAME)) + " :: " + m_page_title + "</title>");
			l_stats.logPublicEvent(m_request.getRemoteAddr(), m_page_title);
			String s = l_buffer;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in headControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String genCSSFileLink() {
		try {
			String l_buffer = "";
			l_buffer = l_buffer + ("<link rel=\"stylesheet\" href=\"/css/" + m_style_file_path + "\" type=\"text/css\">");
			String s = l_buffer;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in headControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String textItemControl(String p_item_title, boolean p_preview) {
		try {
			String l_text_body = "";
			String sqlString = "";
			boolean l_proceed = true;
			Date l_start_date = new Date();
			Date l_end_date = new Date();
			Calendar l_now = Calendar.getInstance();
			Calendar l_start_cal = Calendar.getInstance();
			Calendar l_end_cal = Calendar.getInstance();
			Statement l_stmt = m_db.m_conn.createStatement();
			if (p_preview) {
				for (int l_idx = 1; l_idx <= 7; l_idx++) {
					l_text_body = l_text_body + "This is a test body for the preview page. The quick brown fox jumped over the la"
							+ "zy dog. Peter Piper picked a pack of pickled peppers.<br><br>";
				}

				l_text_body = "<span" + applyStyle(4) + ">" + l_text_body + "</span>";
			} else {
				sqlString = "SELECT item_repository.* FROM item_repository, item_layout_text_rel, layout_text" + "_item WHERE layout_text_item.layout_text_item_title = '"
						+ p_item_title + "' " + "AND layout_text_item.layout_text_item_id = item_layout_text_rel.layout_text_item" + "_id " + "AND item_layout_text_rel.page_id = "
						+ m_page_id + " " + "AND item_layout_text_rel.item_id = item_repository.item_id ";
				ResultSet pageRset = m_db.runSQLResultSet(sqlString, l_stmt);
				if (pageRset.next()) {
					l_proceed = true;
					l_start_date = pageRset.getDate("item_start_date");
					l_end_date = pageRset.getDate("item_end_date");
					if (l_start_date != null) {
						l_start_cal.setTime(l_start_date);
						if (!l_now.after(l_start_cal)) {
							l_proceed = false;
						}
					}
					if (l_proceed && l_end_date != null) {
						l_end_cal.setTime(l_end_date);
						if (!l_now.before(l_end_cal)) {
							l_proceed = false;
						}
					}
					if (l_proceed) {
						ContentOutput _tmp = this;
						if (AppConstants.DATABASE_TYPE == 1) {
							Clob cl = pageRset.getClob("item_text");
							if (cl != null) {
								l_text_body = cl.getSubString(1L, (int) cl.length());
								if (l_text_body == null) {
									l_text_body = "";
								}
							} else {
								l_text_body = "";
							}
						} else {
							l_text_body = pageRset.getString("item_text");
						}
						l_text_body = "<span" + applyStyle(4) + ">" + l_text_body + "</span>";
					} else {
						l_text_body = "";
					}
				}
				pageRset.close();
				l_stmt.close();
			}
			String s1 = l_text_body;
			return s1;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in textItemControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s = "";
			return s;
		}
	}

	public String breadCrumbControl(String p_alt_current, boolean p_preview) {
		boolean l_bad_parent = false;
		try {
			if (m_page_id == null || m_page_id.equals("null")) {
				String s = "";
				return s;
			}
			Statement l_stmt = m_db.m_conn.createStatement();
			String l_next_page;
			if (p_preview) {
				l_next_page = "1";
			} else {
				l_next_page = m_page_id;
			}
			String l_buffer = "";
			do {
				CachedRowSet l_rs = m_db.runSQL("SELECT parent.page_id, parent.title, parent.url FROM pages, pages parent WHERE p" + "ages.page_id = " + l_next_page + " "
						+ "AND pages.parent_id = parent.page_id", l_stmt);
				if (l_rs.next()) {
					if (l_rs.getString("url").startsWith("/")) {
						l_buffer = "<a" + applyStyle(1) + " href=\"" + "" + l_rs.getString("url") + "\">" + l_rs.getString("title") + "</a><a" + applyStyle(4) + "> > </a> "
								+ l_buffer;
					} else {
						l_buffer = "<a" + applyStyle(1) + " href=\"" + l_rs.getString("url") + "\">" + l_rs.getString("title") + "</a><a" + applyStyle(4) + "> > </a> " + l_buffer;
					}
					l_next_page = l_rs.getString("page_id");
				} else {
					l_bad_parent = true;
				}
				l_rs.close();
				ContentOutput _tmp = this;
			} while (Integer.parseInt(l_next_page) != AppConstants.ROOT_PAGE && !l_bad_parent);
			if (!p_alt_current.equals("")) {
				l_buffer = l_buffer + ("<a" + applyStyle(2) + ">" + p_alt_current + "</a>");
			} else {
				l_buffer = l_buffer + ("<a" + applyStyle(2) + ">" + m_page_title + "</a>");
			}
			l_stmt.close();
			String s2 = l_buffer;
			return s2;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in breadCrumbControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String discussionBoardControl(boolean p_preview) {
		String l_res = "";
		try {
			String l_action = m_request.getParameter("action");
			String l_chosen_topic = m_request.getParameter("topic");
			String l_post_id = m_request.getParameter("post");
			String l_url = "?xcid=" + m_request.getParameter("xcid");
			if (l_action == null) {
				l_action = "";
			}
			if (l_chosen_topic == null) {
				l_chosen_topic = "";
			}
			if (l_post_id == null) {
				l_post_id = "";
			}
			if (l_url == null) {
				l_url = "";
			}
			l_res = "";
			if (l_action.equals("addPost")) {
				l_res = addNewPostForm(l_url, l_chosen_topic);
			} else if (l_action.equals("savePost")) {
				addNewPost("0", l_chosen_topic);
				l_res = discussionByTopic(l_url, l_chosen_topic);
			} else if (l_action.equals("viewPost")) {
				l_res = viewPost(l_url, l_chosen_topic, l_post_id);
			} else if (l_action.equals("replyPost")) {
				addNewPost(l_post_id, l_chosen_topic);
				l_res = discussionByTopic(l_url, l_chosen_topic);
			} else if (!l_chosen_topic.equals("")) {
				l_res = discussionByTopic(l_url, l_chosen_topic);
			} else {
				l_res = "<a" + applyStyle(4) + ">Welcome to the Discussion Board. Please choose from the topics below:<BR><BR></" + "a>";
				l_res = l_res + displayDiscussionTopics(l_url);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in discussionBoardControl().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return l_res;
	}

	private void addNewPost(String p_parent_id, String p_topic_id) {
		String l_creator = "";
		Date l_date = new Date();
		String l_subject = "";
		String l_content = "";
		String l_sql = "";
		String l_result = "";
		l_creator = m_request.getParameter("f_creator").trim();
		if (l_creator.length() > 100) {
			l_creator = l_creator.substring(0, 99);
		}
		if (l_creator.length() == 0) {
			l_creator = "Anonymous";
		}
		l_subject = m_request.getParameter("f_subject").trim();
		if (l_subject.length() > 100) {
			l_subject = l_subject.substring(0, 99);
		}
		l_content = m_request.getParameter("f_content").trim();
		if (l_content.length() > 4000) {
			l_content = l_content.substring(0, 3999);
		}
		try {
			Statement stmt = m_db.m_conn.createStatement();
			if (l_subject.length() > 0) {
				l_sql = "INSERT INTO discussion_posts (parent_id, topic_id, post_creator, post_date, post" + "_subject, post_content, post_archived) values (" + p_parent_id + ", "
						+ p_topic_id + ", '" + m_db.plSqlSafeString(l_creator) + "', " + m_db.safeDateFormat(l_date, true) + ", '" + m_db.plSqlSafeString(l_subject) + "', '"
						+ m_db.plSqlSafeString(l_content) + "', 'f')";
				m_db.runSQLResultSet(l_sql, stmt);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in addNewPost()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("SQL: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	private String addNewPostForm(String p_url, String p_chosen_topic) {
		String l_postURL = p_url + "&action=savePost&topic=" + p_chosen_topic;
		String l_buffer = "<form name='addPostForm' method='post' action='" + l_postURL + "'>\n";
		l_buffer = l_buffer + "<table border='0' cellspacing='0' cellpadding='0' " + applyStyle(4) + " width='370'>\n";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='70'><b>Post:</b>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='300'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='70'><img src='" + "/images" + "/spacer.gif' width='70' height='10'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='300'><img src='" + "/images" + "/spacer.gif' width='300' height='10'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='70'>Creator:";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='300'><input name='f_creator' " + applyStyle(4) + " type='text' style='width=300px'  maxlength='100'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='370'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='70'>Subject:";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='300'><input name='f_subject' " + applyStyle(4) + " type='text' style='width=300px'  maxlength='100'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='370'><img src='" + "/images" + "/spacer.gif' width='370' height='10'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='70'>Content:";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "<td valign='top' align='left' " + applyStyle(4) + " width='300'><textarea name='f_content' " + applyStyle(4) + " cols=46 rows=10></textarea>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='370'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='70'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "<td valign='top' align='center' " + applyStyle(4) + " width='300'><input name='cancel' type='Button' value='Cancel' onclick='history."
				+ "back();' style='width=70px'>&nbsp;&nbsp;&nbsp;<input name='newpostSubmit' type='" + "Submit' value='Post' style='width=70px'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "<tr>";
		l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='370'><img src='" + "/images" + "/spacer.gif' width='370' height='10'>";
		l_buffer = l_buffer + "</td>";
		l_buffer = l_buffer + "</tr>";
		l_buffer = l_buffer + "</table>";
		l_buffer = l_buffer + "</form>";
		return l_buffer;
	}

	private String viewPost(String p_url, String p_chosen_topic, String p_post_id) {
		Clob post_content_clob = null;
		String post_content = "";
		String l_buffer = "";
		String l_postURL = "";
		String l_clob_sql = "";
		String l_sql = "";
		String post_topic = "";
		Date post_date = null;
		String post_date_formatted = "";
		String post_time_formatted = "";
		SimpleDateFormat formattedDateTime = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
		l_postURL = p_url + "&action=replyPost&topic=" + p_chosen_topic + "&post=" + p_post_id;
		l_buffer = "<form name='addPostForm' method='post' action='" + l_postURL + "'>\n";
		l_buffer = l_buffer + "<table border='0' cellspacing='0' cellpadding='0' " + applyStyle(4) + " width='100%'>\n";
		l_sql = "SELECT post_date, topic_name, post_creator, post_subject FROM discussion_posts, " + "discussion_topics WHERE post_id = " + p_post_id + " "
				+ "AND discussion_posts.topic_id = discussion_topics.topic_id " + "AND post_archived = 'f' ";
		l_clob_sql = "SELECT post_content FROM discussion_posts WHERE  post_id = " + p_post_id;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			CachedRowSet l_rs = m_db.runSQL(l_sql, stmt);
			if (l_rs.next()) {
				ResultSet l_clob_rs = m_db.runSQLResultSet(l_clob_sql, stmt);
				if (l_clob_rs.next()) {
					ContentOutput _tmp = this;
					if (AppConstants.DATABASE_TYPE == 1) {
						post_content_clob = l_clob_rs.getClob("post_content");
						if (post_content_clob != null) {
							post_content = post_content_clob.getSubString(1L, (int) post_content_clob.length());
							if (post_content == null) {
								post_content = "";
							}
						}
					}
				}
				post_date = l_rs.getDate("post_date");
				post_topic = l_rs.getString("topic_name");
				post_date_formatted = formattedDateTime.format(post_date);
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'><b>Topic:</b>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'><a href='" + p_url + "&topic=" + p_chosen_topic + "'>" + post_topic + "</a>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'><b>Post:</b>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'>Creator:";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'>" + l_rs.getString("post_creator");
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'>Date:";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'>" + post_date_formatted;
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'>Subject:";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'>" + l_rs.getString("post_subject");
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'>Content:";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'>" + post_content;
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='20'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'><b>Reply?</b>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'>Creator:";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'><input name='f_creator' " + applyStyle(4)
						+ " type='text' style='width=300px'  maxlength='100'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'>Subject:";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'><input name='f_subject' " + applyStyle(4)
						+ " type='text' style='width=300px'  maxlength='100'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'>Content:";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='400'><textarea name='f_content' " + applyStyle(4) + " cols=46 rows=10></textarea>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' " + applyStyle(4) + " width='50'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "<td valign='top' align='left' " + applyStyle(4) + " width='400'><input name='newpostSubmit' type='Submit' value='Add Reply'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "<td valign='top' colspan='2' " + applyStyle(4) + " width='450'><img src='" + "/images" + "/spacer.gif' width='10' height='10'>";
				l_buffer = l_buffer + "</td>";
				l_buffer = l_buffer + "</tr>";
			} else {
				l_buffer = l_buffer + "Unable to load data, please try again later.";
			}
			l_buffer = l_buffer + "</td>";
			l_buffer = l_buffer + "</tr>";
			l_buffer = l_buffer + "</table>";
			l_buffer = l_buffer + "</form>";
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in viewPost()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("SQL: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return l_buffer;
	}

	private String displayDiscussionTopics(String p_url) {
		String l_sql = "";
		ResultSet l_rs = null;
		String l_buffer = "";
		l_sql = "SELECT topic_id, topic_name FROM discussion_topics WHERE topic_archived = 'f' OR" + "DER by topic_name";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			for (l_rs = m_db.runSQLResultSet(l_sql, stmt); l_rs.next();) {
				l_buffer = l_buffer + "<a href='" + p_url + "&topic=" + l_rs.getString("topic_id") + "'>- " + l_rs.getString("topic_name") + "</a><BR>";
			}

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in displayDiscussionTopics()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("SQL: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		if (l_buffer.length() == 0) {
			l_buffer = "<a" + applyStyle(4) + ">No Topics available - please try again later.</a>";
		}
		return l_buffer;
	}

	private String discussionByTopic(String p_url, String p_chosen_topic) {
		String l_sql = "";
		ResultSet l_rs = null;
		String l_buffer = "";
		String l_threads = "";
		String l_postURL = "";
		l_sql = "SELECT topic_id, topic_name FROM discussion_topics WHERE topic_id = " + p_chosen_topic + " " + "ORDER by topic_name";
		try {
			l_postURL = p_url + "&action=addPost&topic=" + p_chosen_topic;
			Statement stmt = m_db.m_conn.createStatement();
			l_rs = m_db.runSQLResultSet(l_sql, stmt);
			if (l_rs.next()) {
				l_buffer = l_buffer + "<table border='0' cellpadding='0' cellspacing='0' width='100%'>\n";
				l_buffer = l_buffer + "<tr>\n";
				l_buffer = l_buffer + "<td width=50><img src='" + "/images" + "/spacer.gif' width=50 height=10></td>\n";
				l_buffer = l_buffer + "<td></td>\n";
				l_buffer = l_buffer + "</tr>\n";
				l_buffer = l_buffer + "<tr>\n";
				l_buffer = l_buffer + "<td width=50><a" + applyStyle(4) + "><b>Topic: </b></a></td>\n";
				l_buffer = l_buffer + "<td>\n";
				l_buffer = l_buffer + "<a href='" + p_url + "&topic=" + l_rs.getString("topic_id") + "'>" + l_rs.getString("topic_name") + "</a>";
				l_buffer = l_buffer + "</td>\n";
				l_buffer = l_buffer + "</tr>\n";
				l_buffer = l_buffer + "</table>\n";
				l_buffer = l_buffer + discussionThreads(p_url, "0", p_chosen_topic, "0");
			} else {
				l_buffer = l_buffer + "<a" + applyStyle(4) + ">This is not a valid topic. Please try again.</a>";
			}
			l_buffer = l_buffer + "<BR><a" + applyStyle(4) + "><b>Add Post: </b></a><a href='" + l_postURL + "'>click here</a>";
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in discussionByTopic()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("SQL: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return l_buffer + "<BR><BR>";
	}

	private String discussionThreads(String p_url, String p_parent_id, String p_topic_id, String p_level) {
		CachedRowSet l_rs = null;
		String l_sql = "";
		String add_reponse = "";
		String post_id = "";
		String post_subject = "";
		String post_expand = "";
		Date post_date = null;
		String post_date_formatted = "";
		String l_postURL = "";
		String p_buffer = "";
		SimpleDateFormat formattedDateTime = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
		l_sql = String.valueOf(
				"SELECT post_id, post_date, post_subject, post_creator FROM discussion_posts WHER" + "E parent_id     = " + p_parent_id + " " + "AND   topic_id      = "
						+ p_topic_id + " " + "AND   post_archived = 'f' " + "ORDER by post_id ").concat(String.valueOf(AppConstants.POSTS_ORDER));
		try {
			l_postURL = p_url + "&action=addPost&topic=" + p_topic_id;
			Statement stmt = m_db.m_conn.createStatement();
			for (l_rs = m_db.runSQL(l_sql, stmt); l_rs.next();) {
				post_id = l_rs.getString("post_id");
				post_date = l_rs.getDate("post_date");
				post_date_formatted = formattedDateTime.format(post_date);
				post_expand = p_url + "&action=viewPost&topic=" + p_topic_id + "&post=" + post_id;
				post_subject = "<a href='" + post_expand + "'>" + l_rs.getString("post_subject") + "<BR>(by " + l_rs.getString("post_creator") + " - " + post_date_formatted
						+ ")</a>";
				if (!p_parent_id.equals("0")) {
					p_buffer = p_buffer + "<table border='0' cellpadding='0' cellspacing='0' width='100%'>\n";
					p_buffer = p_buffer + "<tr>\n";
					p_buffer = p_buffer + "<td width=" + p_level + "><img src='" + "/images" + "/spacer.gif' width=" + p_level + " height=1></td>\n";
					p_buffer = p_buffer + "<td width=50 valign='top'><img src='" + "/images" + "/spacer.gif' width=50 height=1></td>\n";
					p_buffer = p_buffer + "<td></td>\n";
					p_buffer = p_buffer + "</tr>\n";
					p_buffer = p_buffer + "<tr>\n";
					p_buffer = p_buffer + "<td  valign='top' width=" + p_level + "><img src='" + "/images" + "/spacer.gif' width=" + p_level + " height=1></td>\n";
					p_buffer = p_buffer + "<td valign='top'><a" + applyStyle(4) + "><b>Reply: </b></a></td>\n";
					p_buffer = p_buffer + "<td valign='top'>" + post_subject + "</td>\n";
					p_buffer = p_buffer + "</tr>\n";
					p_buffer = p_buffer + "</table>\n";
				} else {
					p_buffer = p_buffer + "<table border='0' cellpadding='0' cellspacing='0' width='100%'>\n";
					p_buffer = p_buffer + "<tr>\n";
					p_buffer = p_buffer + "<td width=50 valign='top'><img src='" + "/images" + "/spacer.gif' width=50 height=10></td>\n";
					p_buffer = p_buffer + "<td></td>\n";
					p_buffer = p_buffer + "</tr>\n";
					p_buffer = p_buffer + "<tr>\n";
					p_buffer = p_buffer + "<td width=50 valign='top'><a" + applyStyle(4) + "><b>Post: </b></a></td>\n";
					p_buffer = p_buffer + "<td valign='top'>\n";
					p_buffer = p_buffer + post_subject;
					p_buffer = p_buffer + "</td>\n";
					p_buffer = p_buffer + "</tr>\n";
					p_buffer = p_buffer + "</table>\n";
				}
				int i_level = Integer.parseInt(p_level) + 50;
				p_buffer = p_buffer + discussionThreads(p_url, post_id, p_topic_id, Integer.toString(i_level));
			}

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in discussionThreads()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("SQL: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return p_buffer;
	}

	public String dropDownControl(String p_width, String p_left_pos, String p_top_pos, String p_font, String p_font_size, String p_font_lowercase, String p_font_color,
			String p_font_hover_color, String p_back_color, String p_back_hover_color, String p_border_color, String p_seperator_color, String p_display_on_click,
			String p_override_image_keys, boolean p_preview) {
		String l_res = "";
		Vector l_array = new Vector();
		Vector l_spaces_arr = new Vector();
		Vector l_override_images = new Vector();
		FileRepository file_repos = new FileRepository(m_db);
		String l_width = p_width;
		String l_left_pos = p_left_pos;
		String l_top_pos = p_top_pos;
		String l_font = p_font;
		String l_font_size = p_font_size;
		String l_font_lowercase = p_font_lowercase;
		String l_font_color = p_font_color;
		String l_font_hover_color = p_font_hover_color;
		String l_back_color = p_back_color;
		String l_back_hover_color = p_back_hover_color;
		String l_border_color = p_border_color;
		String l_seperator_color = p_seperator_color;
		String l_display_on_click = p_display_on_click;
		try {
			Statement l_stmt1 = m_db.m_conn.createStatement();
			Statement l_stmt2 = m_db.m_conn.createStatement();
			if (l_width.equals("")) {
				l_width = "180";
			}
			if (l_left_pos.equals("")) {
				l_left_pos = "56";
			}
			if (l_top_pos.equals("")) {
				l_top_pos = "85";
			}
			if (l_font.equals("")) {
				l_font = "Verdana";
			}
			if (l_font_size.equals("")) {
				l_font_size = "12";
			}
			if (l_font_lowercase.equals("")) {
				l_font_lowercase = "true";
			}
			if (l_font_color.equals("")) {
				l_font_color = "#000000";
			}
			if (l_font_hover_color.equals("")) {
				l_font_hover_color = "#ff1111";
			}
			if (l_back_color.equals("")) {
				l_back_color = "#FFFFFF";
			}
			if (l_back_hover_color.equals("")) {
				l_back_hover_color = "#ececec";
			}
			if (l_border_color.equals("")) {
				l_border_color = "#000000";
			}
			if (l_seperator_color.equals("")) {
				l_seperator_color = "#000000";
			}
			if (l_display_on_click.equals("")) {
				l_display_on_click = "";
			}
			l_res = "<script LANGUAGE='JavaScript1.2' SRC='/js/hm_loader.js' TYPE='text/javascript'><" + "/script>\n";
			l_res = l_res + "<script LANGUAGE='JavaScript1.2'>\n";
			l_res = l_res + "HM_PG_ChildOverlap = 0;\n";
			l_res = l_res + "HM_PG_ChildOffset  = 0;\n";
			l_res = l_res + "HM_PG_ImageSrc = \"/images/HM_more_arrow_black.gif\";";
			l_res = l_res + "HM_PG_ImageSrcOver = \"/images/HM_more_arrow_black.gif\";";
			l_res = l_res + "HM_PG_ImageSrcLeft = \"/images/HM_more_arrow_black.gif\";";
			l_res = l_res + "HM_PG_ImageSrcLeftOver = \"/images/HM_more_arrow_black.gif\";";
			l_res = l_res + "HM_PG_ImageVertSpace = 2;";
			l_res = l_res + "HM_PG_ChildOverlap = 0;\n";
			l_res = l_res + "HM_PG_ChildOffset  = 0;\n";
			l_res = l_res + "function checkLowerCase(p_string) {\n";
			if (l_font_lowercase.equals("true")) {
				l_res = l_res + "  return(p_string.toLowerCase());}\n";
			} else {
				l_res = l_res + "  return(p_string);}\n";
			}
			l_res = l_res + ("var l_font = '" + l_font + "';\n");
			l_res = l_res + ("var l_font_size = '" + l_font_size + "';\n");
			l_res = l_res + ("var l_font_lowercase = '" + p_font_lowercase + "';\n");
			m_vt.populateFromDelimitedList(l_override_images, p_override_image_keys);
			l_res = l_res + "var l_image_override = new Array(";
			for (int i = 0; i < l_override_images.size(); i++) {
				if (i == 0) {
					l_res = l_res + ("\"" + file_repos.getFilePathFromKey((String) l_override_images.elementAt(i)) + "\"");
				} else {
					l_res = l_res + (",\"" + file_repos.getFilePathFromKey((String) l_override_images.elementAt(i)) + "\"");
				}
			}

			l_res = l_res + ");\n";
			l_res = l_res + ("var l_image_total=" + l_override_images.size() + ";\n");
			l_res = l_res + "if(HM_IsMenu) {\n";
			l_res = l_res + "HM_Array5 = [\n";
			l_res = l_res + ("[" + p_width + ",                          // menu_width\n");
			l_res = l_res + (p_left_pos + ", \t\t\t\t// left_position\n");
			l_res = l_res + (p_top_pos + ",                 // top_position\n");
			l_res = l_res + ("\"" + p_font_color + "\",        // font_color\n");
			l_res = l_res + ("\"" + p_font_hover_color + "\",         // mouseover_font_color\n");
			l_res = l_res + ("\"" + p_back_color + "\",\t\t// background_color\n");
			l_res = l_res + ("\"" + p_back_hover_color + "\",        // mouseover_background_color\n");
			l_res = l_res + ("\"" + p_border_color + "\",        // border_color\n");
			l_res = l_res + ("\"" + p_seperator_color + "\",        // separator_color\n");
			l_res = l_res + "1,                             // top_is_permanent\n";
			l_res = l_res + "1,                             // top_is_horizontal\n";
			l_res = l_res + "0,                             // tree_is_horizontal\n";
			l_res = l_res + "1,                             // position_under\n";
			l_res = l_res + "0,                             // top_more_images_visible\n";
			l_res = l_res + "1,                             // tree_more_images_visible\n";
			l_res = l_res + "\"null\",                      // evaluate_upon_tree_show\n";
			l_res = l_res + "\"null\",                      // evaluate_upon_tree_hide\n";
			l_res = l_res + ",\t\t\t\t\t\t\t    // right_to_left\n";
			l_res = l_res + (p_display_on_click + ",\t\t    // display_on_click\n");
			l_res = l_res + "true,\t\t\t\t\t\t    // top_is_variable_width\n";
			l_res = l_res + ",\t\t\t\t\t\t   \t    // tree_is_variable_width\n";
			l_res = l_res + "],\n";
			String s1 = l_res;
			return s1;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in dropDownControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s = "";
			return s;
		}
	}

	public String familyLinksControl(String p_width, String p_indents, String p_bgcolours, String p_rollover_bgcolours, String p_current_bgcolours,
			String p_current_rollover_bgcolours, String p_divider_colour, String p_padding, String p_lineheight, String p_align, String p_valign, String p_selected_image,
			String p_left_image_key, String p_right_image_key, String p_dividerheight, boolean p_preview) {
		Vector l_indents = new Vector();
		Vector l_bgcolours = new Vector();
		Vector l_rollover_bgcolours = new Vector();
		Vector l_current_bgcolours = new Vector();
		Vector l_current_rollover_bgcolours = new Vector();
		Vector l_bgcol_strs = new Vector();
		Vector l_current_bgcol_strs = new Vector();
		Vector l_left_image_path = new Vector();
		Vector l_right_image_path = new Vector();
		FileRepository file_repos = new FileRepository(m_db);
		Vector l_pages_to_display = new Vector();
		boolean l_displayed_current_page = false;
		try {
			if (m_page_id == null || m_page_id.equals("null")) {
				String s = "";
				return s;
			}
			String l_buffer = "";
			Statement l_stmt = m_db.m_conn.createStatement();
			String l_width;
			if (p_width.length() > 0) {
				l_width = p_width;
			} else {
				ContentOutput _tmp = this;
				l_width = AppConstants.STYLE_LEFTCOLUMN_WIDTH;
			}
			String l_lineheight;
			if (p_lineheight.length() > 0) {
				l_lineheight = p_lineheight;
			} else {
				ContentOutput _tmp1 = this;
				l_lineheight = AppConstants.STYLE_LINEHEIGHT;
			}
			if (p_left_image_key.length() > 0) {
				m_vt.populateFromDelimitedList(l_left_image_path, p_left_image_key);
				for (int l_i = 0; l_i < l_left_image_path.size(); l_i++) {
					if ((l_left_image_path.elementAt(l_i) + "").length() > 0) {
						l_left_image_path.setElementAt(file_repos.getFilePathFromKey(l_left_image_path.elementAt(l_i).toString()), l_i);
					} else {
						l_left_image_path.setElementAt("", l_i);
					}
				}

			} else {
				m_vt.populateFromDelimitedList(l_left_image_path, ",,,,,,,");
			}
			if (p_right_image_key.length() > 0) {
				m_vt.populateFromDelimitedList(l_right_image_path, p_right_image_key);
				for (int l_i = 0; l_i < l_right_image_path.size(); l_i++) {
					if ((l_right_image_path.elementAt(l_i) + "").length() > 0) {
						l_right_image_path.setElementAt(file_repos.getFilePathFromKey(l_right_image_path.elementAt(l_i).toString()), l_i);
					} else {
						l_right_image_path.setElementAt("", l_i);
					}
				}

			} else {
				m_vt.populateFromDelimitedList(l_right_image_path, ",,,,,,,");
			}
			if (p_bgcolours.length() > 0) {
				m_vt.populateFromDelimitedList(l_bgcol_strs, p_bgcolours);
				m_vt.populateFromDelimitedList(l_bgcolours, p_bgcolours);
				int l_style_levels = l_bgcolours.size();
				for (int l_i = 0; l_i < l_bgcolours.size(); l_i++) {
					if (l_bgcolours.elementAt(l_i).toString().toLowerCase().equals("default")) {
						l_bgcol_strs.setElementAt(AppConstants.STYLE_LEFTCOLUMN_BACKGROUNDCOLOR, l_i);
						l_bgcolours.setElementAt(String.valueOf(" bgcolor=\"").concat(String.valueOf(AppConstants.STYLE_LEFTCOLUMN_BACKGROUNDCOLOR)) + "\"", l_i);
					} else {
						l_bgcol_strs.setElementAt(l_bgcolours.elementAt(l_i), l_i);
						l_bgcolours.setElementAt(" bgcolor=\"" + l_bgcolours.elementAt(l_i) + "\"", l_i);
					}
				}

			} else {
				int l_style_levels = 1;
				m_vt.populateFromDelimitedList(l_bgcol_strs, ",,,,,,,");
				m_vt.populateFromDelimitedList(l_bgcolours, ",,,,,,,");
			}
			if (p_rollover_bgcolours.length() > 0) {
				m_vt.populateFromDelimitedList(l_rollover_bgcolours, p_rollover_bgcolours);
				for (int l_i = 0; l_i < l_rollover_bgcolours.size(); l_i++) {
					l_rollover_bgcolours.setElementAt(" onMouseOver=\"this.style.backgroundColor='" + l_rollover_bgcolours.elementAt(l_i)
							+ "';\" onMouseOut=\"this.style.backgroundColor='" + l_bgcol_strs.elementAt(l_i) + "';\"", l_i);
				}

			} else {
				m_vt.populateFromDelimitedList(l_rollover_bgcolours, ",,,,,,,");
			}
			if (p_current_bgcolours.length() > 0) {
				m_vt.populateFromDelimitedList(l_current_bgcol_strs, p_current_bgcolours);
				m_vt.populateFromDelimitedList(l_current_bgcolours, p_current_bgcolours);
				for (int l_i = 0; l_i < l_current_bgcolours.size(); l_i++) {
					if (l_current_bgcolours.elementAt(l_i).toString().toLowerCase().equals("default")) {
						l_current_bgcol_strs.setElementAt(AppConstants.STYLE_LEFTCOLUMN_BACKGROUNDCOLOR, l_i);
						l_current_bgcolours.setElementAt(String.valueOf(" bgcolor=\"").concat(String.valueOf(AppConstants.STYLE_LEFTCOLUMN_BACKGROUNDCOLOR)) + "\"", l_i);
					} else {
						l_current_bgcol_strs.setElementAt(l_current_bgcolours.elementAt(l_i), l_i);
						l_current_bgcolours.setElementAt(" bgcolor=\"" + l_current_bgcolours.elementAt(l_i) + "\"", l_i);
					}
				}

			} else {
				m_vt.populateFromDelimitedList(l_current_bgcol_strs, ",,,,,,,");
				m_vt.populateFromDelimitedList(l_current_bgcolours, ",,,,,,,");
			}
			if (p_current_rollover_bgcolours.length() > 0) {
				m_vt.populateFromDelimitedList(l_current_rollover_bgcolours, p_current_rollover_bgcolours);
				for (int l_i = 0; l_i < l_current_rollover_bgcolours.size(); l_i++) {
					l_current_rollover_bgcolours.setElementAt(" onMouseOver=\"this.style.backgroundColor='" + l_current_rollover_bgcolours.elementAt(l_i)
							+ "';\" onMouseOut=\"this.style.backgroundColor='" + l_current_bgcol_strs.elementAt(l_i) + "';\"", l_i);
				}

			} else {
				m_vt.populateFromDelimitedList(l_current_rollover_bgcolours, ",,,,,,,");
			}
			if (p_indents.length() > 0) {
				m_vt.populateFromDelimitedList(l_indents, p_indents);
			} else {
				m_vt.populateFromDelimitedList(l_indents, "10,10,10,10,10,10,10,10,");
			}
			String l_divider_colour;
			if (p_divider_colour.length() > 0) {
				if (p_divider_colour.toLowerCase().equals("default")) {
					l_divider_colour = String.valueOf(" bgcolor=\"").concat(String.valueOf(AppConstants.STYLE_LEFTCOLUMN_BACKGROUNDCOLOR)) + "\"";
				} else {
					l_divider_colour = " bgcolor=\"" + p_divider_colour + "\"";
				}
			} else {
				l_divider_colour = "";
			}
			String l_padding;
			if (p_padding.length() > 0) {
				l_padding = " cellpadding=\"" + p_padding + "\"";
			} else {
				l_padding = " cellpadding=\"0\"";
			}
			String l_align;
			if (p_align.length() > 0) {
				l_align = " align=\"" + p_align + "\"";
			} else {
				l_align = " align=\"left\"";
			}
			String l_valign;
			if (p_valign.length() > 0) {
				l_valign = " valign=\"" + p_valign + "\"";
			} else {
				l_valign = " valign=\"bottom\"";
			}
			String l_selected_image_path;
			if (p_selected_image.length() > 0) {
				l_selected_image_path = file_repos.getFilePathFromKey(p_selected_image.toLowerCase());
			} else {
				l_selected_image_path = "";
			}
			for (; l_indents.size() < 8; l_indents.add("")) {
			}
			for (; l_bgcolours.size() < 8; l_bgcolours.add("")) {
			}
			for (; l_rollover_bgcolours.size() < 8; l_rollover_bgcolours.add("")) {
			}
			for (; l_current_bgcolours.size() < 8; l_current_bgcolours.add("")) {
			}
			for (; l_current_rollover_bgcolours.size() < 8; l_current_rollover_bgcolours.add("")) {
			}
			for (; l_left_image_path.size() < 8; l_left_image_path.add("")) {
			}
			for (; l_right_image_path.size() < 8; l_right_image_path.add("")) {
			}
			String l_sql = "SELECT page_id FROM pages WHERE parent_id='" + m_page_id + "' and " + "is_approved = 't' and " + "display_in_menu > 0 and " + "hidden_page = 'f'";
			CachedRowSet rset;
			for (rset = m_db.runSQL(l_sql, l_stmt); rset.next(); l_pages_to_display.add(rset.getString("page_id"))) {
			}
			rset.close();
			rset = pageObject.getPage(l_stmt, m_page_id);
			rset.next();
			String l_parent_page_id = rset.getString("parent_id");
			rset.close();
			if (!l_parent_page_id.equals("0")) {
				l_sql = "SELECT page_id FROM pages WHERE parent_id='" + l_parent_page_id + "' and " + "is_approved = 't' and " + "display_in_menu > 0 and " + "hidden_page = 'f'";
				for (rset = m_db.runSQL(l_sql, l_stmt); rset.next(); l_pages_to_display.add(rset.getString("page_id"))) {
				}
				rset.close();
				l_pages_to_display.add(l_parent_page_id);
			}
			do {
				l_sql = "SELECT parent_id FROM pages WHERE page_id='" + l_parent_page_id + "' and " + "is_approved = 't' and " + "display_in_menu > 0 and " + "hidden_page = 'f'";
				rset = m_db.runSQL(l_sql, l_stmt);
				if (!rset.next()) {
					break;
				}
				l_parent_page_id = rset.getString("parent_id");
				if (l_parent_page_id.equals("0")) {
					break;
				}
				l_pages_to_display.add(l_parent_page_id);
				rset.close();
			} while (true);
			rset.close();
			int l_curr_level = 0;
			l_sql = "SELECT page_id, pages.title as title, url FROM pages, sections WHERE parent_id='"
					+ "0' and is_approved = 't' and display_in_menu > 0 and hidden_page = 'f' and pages"
					+ ".sect_id=sections.sect_id ORDER BY sections.order_id, pages.display_in_menu, pag" + "es.title ";
			for (rset = m_db.runSQL(l_sql, l_stmt); rset.next();) {
				String l_page_url;
				if (rset.getString("url").startsWith("/")) {
					l_page_url = "" + rset.getString("url");
				} else {
					l_page_url = rset.getString("url");
				}
				String l_page_title = rset.getString("title");
				String l_curr_page_id = rset.getString("page_id");
				l_pages_to_display.add(l_curr_page_id);
				if (l_curr_page_id.equals(m_page_id)) {
					l_displayed_current_page = true;
					l_buffer = l_buffer
							+ getFamilyLinksPageHTML(l_curr_page_id, l_curr_level, p_width, l_indents.elementAt(l_curr_level).toString(), l_bgcolours.elementAt(l_curr_level)
									.toString(), l_rollover_bgcolours.elementAt(l_curr_level).toString(), l_current_bgcolours.elementAt(l_curr_level).toString(),
									l_current_rollover_bgcolours.elementAt(l_curr_level).toString(), l_divider_colour, l_padding, l_lineheight, l_align, l_valign, 11,
									l_selected_image_path, l_left_image_path.elementAt(l_curr_level).toString(), l_right_image_path.elementAt(l_curr_level).toString(),
									p_dividerheight, l_page_url, l_page_title);
				} else {
					l_buffer = l_buffer
							+ getFamilyLinksPageHTML(l_curr_page_id, l_curr_level, p_width, l_indents.elementAt(l_curr_level).toString(), l_bgcolours.elementAt(l_curr_level)
									.toString(), l_rollover_bgcolours.elementAt(l_curr_level).toString(), l_current_bgcolours.elementAt(l_curr_level).toString(),
									l_current_rollover_bgcolours.elementAt(l_curr_level).toString(), l_divider_colour, l_padding, l_lineheight, l_align, l_valign, 9,
									l_selected_image_path, l_left_image_path.elementAt(l_curr_level).toString(), l_right_image_path.elementAt(l_curr_level).toString(),
									p_dividerheight, l_page_url, l_page_title);
				}
				l_buffer = l_buffer
						+ generateChildren(l_curr_page_id, l_curr_level + 1, l_width, l_indents, l_bgcolours, l_rollover_bgcolours, l_current_bgcolours,
								l_current_rollover_bgcolours, l_divider_colour, l_padding, l_lineheight, l_align, l_valign, l_selected_image_path, l_left_image_path,
								l_right_image_path, p_dividerheight, l_pages_to_display, l_displayed_current_page);
			}

			rset.close();
			l_stmt.close();
			String s2 = l_buffer;
			return s2;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in familyLinksControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	private String generateChildren(String p_page_id, int p_curr_level, String p_width, Vector p_indents, Vector p_bgcolours, Vector p_rollover_bgcolours,
			Vector p_current_bgcolours, Vector p_current_rollover_bgcolours, String p_divider_colour, String p_padding, String p_lineheight, String p_align, String p_valign,
			String p_selected_image_path, Vector p_left_image_path, Vector p_right_image_path, String p_dividerheight, Vector p_pages_to_display, boolean p_displayed_current_page) {
		String l_buffer = "";
		boolean l_displayed_current_page = p_displayed_current_page;
		try {
			Statement l_stmt = m_db.m_conn.createStatement();
			if (p_pages_to_display.contains(p_page_id)) {
				String sqlString = "SELECT page_id, title, url FROM pages WHERE parent_id='" + p_page_id + "' and " + "is_approved = 't' and " + "display_in_menu > 0 and "
						+ "hidden_page = 'f' " + "ORDER BY display_in_menu, title ";
				CachedRowSet rset = m_db.runSQL(sqlString, l_stmt);
				do {
					if (!rset.next()) {
						break;
					}
					String l_page_url;
					if (rset.getString("url").startsWith("/")) {
						l_page_url = "" + rset.getString("url");
					} else {
						l_page_url = rset.getString("url");
					}
					String l_page_title = rset.getString("title");
					String l_curr_page_id = rset.getString("page_id");
					if (p_pages_to_display.contains(l_curr_page_id)) {
						if (p_displayed_current_page) {
							l_buffer = l_buffer
									+ getFamilyLinksPageHTML(l_curr_page_id, p_curr_level, p_width, p_indents.elementAt(p_curr_level).toString(),
											p_bgcolours.elementAt(p_curr_level).toString(), p_rollover_bgcolours.elementAt(p_curr_level).toString(),
											p_current_bgcolours.elementAt(p_curr_level).toString(), p_current_rollover_bgcolours.elementAt(p_curr_level).toString(),
											p_divider_colour, p_padding, p_lineheight, p_align, p_valign, 10, p_selected_image_path, p_left_image_path.elementAt(p_curr_level)
													.toString(), p_right_image_path.elementAt(p_curr_level).toString(), p_dividerheight, l_page_url, l_page_title);
						} else if (l_curr_page_id.equals(m_page_id)) {
							l_displayed_current_page = true;
							l_buffer = l_buffer
									+ getFamilyLinksPageHTML(l_curr_page_id, p_curr_level, p_width, p_indents.elementAt(p_curr_level).toString(),
											p_bgcolours.elementAt(p_curr_level).toString(), p_rollover_bgcolours.elementAt(p_curr_level).toString(),
											p_current_bgcolours.elementAt(p_curr_level).toString(), p_current_rollover_bgcolours.elementAt(p_curr_level).toString(),
											p_divider_colour, p_padding, p_lineheight, p_align, p_valign, 11, p_selected_image_path, p_left_image_path.elementAt(p_curr_level)
													.toString(), p_right_image_path.elementAt(p_curr_level).toString(), p_dividerheight, l_page_url, l_page_title);
						} else {
							l_buffer = l_buffer
									+ getFamilyLinksPageHTML(l_curr_page_id, p_curr_level, p_width, p_indents.elementAt(p_curr_level).toString(),
											p_bgcolours.elementAt(p_curr_level).toString(), p_rollover_bgcolours.elementAt(p_curr_level).toString(),
											p_current_bgcolours.elementAt(p_curr_level).toString(), p_current_rollover_bgcolours.elementAt(p_curr_level).toString(),
											p_divider_colour, p_padding, p_lineheight, p_align, p_valign, 9, p_selected_image_path, p_left_image_path.elementAt(p_curr_level)
													.toString(), p_right_image_path.elementAt(p_curr_level).toString(), p_dividerheight, l_page_url, l_page_title);
						}
						l_buffer = l_buffer
								+ generateChildren(l_curr_page_id, p_curr_level + 1, p_width, p_indents, p_bgcolours, p_rollover_bgcolours, p_current_bgcolours,
										p_current_rollover_bgcolours, p_divider_colour, p_padding, p_lineheight, p_align, p_valign, p_selected_image_path, p_left_image_path,
										p_right_image_path, p_dividerheight, p_pages_to_display, l_displayed_current_page);
					}
				} while (true);
				rset.close();
			}
			l_stmt.close();
			String s = l_buffer;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in generateChildren.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String getFamilyLinksPageHTML(String p_curr_page_id, int p_curr_level, String p_width, String p_indent, String p_bgcolour, String p_rollover_bgcolour,
			String p_current_bgcolour, String p_current_rollover_bgcolour, String p_divider_colour, String p_padding, String p_lineheight, String p_align, String p_valign,
			int p_style, String p_selected_image_path, String p_left_image_path, String p_right_image_path, String p_dividerheight, String p_url, String page_title) {
		String l_buffer = "";
		try {
			if (p_curr_page_id.equals(m_page_id)) {
				p_bgcolour = p_current_bgcolour;
				p_rollover_bgcolour = p_current_rollover_bgcolour;
			}
			l_buffer = l_buffer + ("<table border=\"0\" " + p_padding + " cellspacing=\"0\" ");
			l_buffer = l_buffer + ("width=\"" + p_width + "\"" + "><tr>");
			l_buffer = l_buffer
					+ ("<td width=\"" + p_indent + "\"" + "><img src=\"" + "/images" + "/spacer.gif\" width=\"" + p_indent + "\" height=\"" + p_lineheight + "\"></td>");
			l_buffer = l_buffer
					+ ("<td valign=\"bottom\" width=\"" + (Integer.parseInt(p_width) - Integer.parseInt(p_indent)) + "\"" + p_bgcolour + " " + p_rollover_bgcolour + " " + p_align + ">");
			l_buffer = l_buffer + "<table width='100%' cellpadding='0' cellspacing='0' border='0'><tr>";
			if (!p_left_image_path.equals("")) {
				l_buffer = l_buffer + ("<td><img src='/custom/files" + p_left_image_path + "'></td>");
			}
			l_buffer = l_buffer + "<td width='100%'>";
			if (!p_selected_image_path.equals("") && p_curr_page_id.equals(m_page_id)) {
				l_buffer = l_buffer + ("<img src='/custom/files" + p_selected_image_path + "'>");
			}
			l_buffer = l_buffer + ("<a" + applyStyle(p_style) + " href='" + p_url + "'>" + page_title + "</a></td>");
			if (!p_right_image_path.equals("")) {
				l_buffer = l_buffer + ("<td align='right'><img src='/custom/files" + p_right_image_path + "'></td>");
			}
			l_buffer = l_buffer + "</tr></table>";
			l_buffer = l_buffer + "</td></tr></table>";
			l_buffer = l_buffer + ("<table border=\"0\" " + p_padding + " cellspacing=\"0\" ");
			l_buffer = l_buffer + ("width=\"" + p_width + "\"" + "><tr>");
			l_buffer = l_buffer + ("<td width=\"" + p_indent + "\"" + "><img src=\"" + "/images" + "/spacer.gif\" width=\"" + p_indent + "\" height=\"1\"></td>");
			l_buffer = l_buffer + ("<td width=\"" + (Integer.parseInt(p_width) - Integer.parseInt(p_indent)) + "\">");
			l_buffer = l_buffer
					+ ("<table width='100%' cellpadding='0' cellspacing='0'><tr><td width=\"" + (Integer.parseInt(p_width) - Integer.parseInt(p_indent)) + "\"" + p_divider_colour
							+ " height='" + p_dividerheight + "'><img border=\"0\" src=\"" + "/images" + "/spacer.gif\" WIDTH=\""
							+ (Integer.parseInt(p_width) - Integer.parseInt(p_indent)) + "\" HEIGHT=\"1\"></td></tr></table>");
			l_buffer = l_buffer + "</td></tr>";
			l_buffer = l_buffer + "</table>";
			String s = l_buffer;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getFamilyLinksPageHTML.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String fileLinksControl(String p_width, String p_hpadding, String p_bgcolour, String p_lineheight, boolean p_preview) {
		String sqlString = "";
		String l_file_id = "";
		String l_file_title = "";
		String l_file_size = "";
		String l_file_size_conv = "";
		String l_file_path = "";
		String l_item_title = "";
		String l_item_desc = "";
		String l_control = "";
		String l_version_group = "";
		String l_version_label = "";
		String l_icon = "";
		String l_padding = "";
		try {
			if (p_width.equals("")) {
				p_width = "100%";
			}
			if (p_lineheight.equals("")) {
				p_lineheight = "1";
			}
			if (p_hpadding.equals("")) {
				p_hpadding = "1";
			}
			if (!p_bgcolour.equals("")) {
				p_bgcolour = " bgcolor='" + p_bgcolour + "'";
			}
			l_padding = "<td width='" + p_hpadding + ">" + "<img src='" + "/custom/images" + "/spacer.gif' " + "width='" + p_hpadding + "' height='" + p_lineheight + "'></td>";
			Statement stmt1 = m_db.m_conn.createStatement();
			if (p_preview) {
				ContentOutput _tmp = this;
				if (AppConstants.DATABASE_TYPE == 1) {
					sqlString = "SELECT * FROM (SELECT file_repository.file_repos_id, file_repository.file_title,"
							+ " file_repository.file_size, file_repository.version_group, file_repository.versi"
							+ "on_label, file_repository.file_path, file_types.icon FROM file_repository, file_"
							+ "types WHERE file_repository.filt_id = file_types.filt_id ORDER BY file_repositor" + "y.file_title ASC) WHERE ROWNUM <= 5";
				} else {
					sqlString = "SELECT TOP 5 file_repository.file_repos_id, file_repository.file_title, file_rep"
							+ "ository.file_size, file_repository.version_group, file_repository.version_label,"
							+ " file_repository.file_path, file_types.icon FROM file_repository, file_types WHE"
							+ "RE file_repository.filt_id = file_types.filt_id ORDER by file_repository.file_ti" + "tle ASC";
				}
			} else {
				sqlString = "SELECT file_repository.file_repos_id, file_repository.file_title, file_repositor"
						+ "y.file_size, file_repository.version_group, file_repository.version_label, file_"
						+ "repository.file_path, files_pages_rel.item_title, files_pages_rel.item_desc, fil"
						+ "e_types.icon FROM file_repository, file_types, files_pages_rel WHERE file_reposi"
						+ "tory.file_repos_id = files_pages_rel.file_repos_id AND files_pages_rel.page_id =" + " " + m_page_id + " "
						+ "AND file_repository.filt_id = file_types.filt_id " + "ORDER by file_repository.file_title ASC";
			}
			CachedRowSet rset1;
			for (rset1 = m_db.runSQL(sqlString, stmt1); rset1.next();) {
				l_file_id = rset1.getString("file_repos_id");
				l_file_title = rset1.getString("file_title");
				l_file_size = rset1.getString("file_size");
				l_version_group = rset1.getString("version_group");
				l_version_label = rset1.getString("version_label");
				l_file_path = rset1.getString("file_path");
				l_file_size_conv = Long.toString(Long.parseLong(l_file_size) / (long) 1024);
				l_icon = rset1.getString("icon");
				if (l_control.equals("")) {
					if (p_preview) {
						l_item_title = "Downloadable Files Preview";
						l_item_desc = "This is an example of how the downloadable file control will look.";
					} else {
						l_item_title = rset1.getString("item_title");
						l_item_desc = rset1.getString("item_desc");
					}
					l_control = "<table border='0' width='" + p_width + "' cellspacing='0' cellpadding='0' class='bodytext'" + p_bgcolour + ">";
					if (l_item_title != null && !l_item_title.equals("")) {
						l_control = l_control + "<tr>";
						l_control = l_control + l_padding;
						l_control = l_control + ("<td" + applyStyle(7) + " colspan=2 width='" + p_width + "' valign='top' align='left'>" + l_item_title);
						l_control = l_control + "</td>";
						l_control = l_control + l_padding;
						l_control = l_control + "</tr>";
					}
					l_control = l_control + "<tr>";
					l_control = l_control + l_padding;
					l_control = l_control + ("<td colspan=2 width='" + p_width + "' valign='top' align='left'><img src='" + "/custom/images" + "/spacer.gif' width=100% height=5>");
					l_control = l_control + "</td>";
					l_control = l_control + l_padding;
					l_control = l_control + "</tr>";
				}
				l_control = l_control + "<tr>";
				l_control = l_control + l_padding;
				l_control = l_control + ("<td valign='top' align='left'><img src='/custom/images/" + l_icon + "'>");
				l_control = l_control + "</td>";
				if (!l_version_group.equals("0")) {
					l_control = l_control
							+ ("<td valign='top' align='left'><a" + applyStyle(8) + " href='Javascript://' onclick='Javascript:openVersionHistory();'>" + l_file_title + " ("
									+ l_file_size_conv + " KB)</a>\n");
					l_control = l_control + "<script language='Javascript'>\n";
					l_control = l_control + "<!--\n";
					l_control = l_control + "function openVersionHistory() { \n";
					l_control = l_control
							+ ("window.open('content_repos_history_1.jsp?index=" + l_file_id + "&public=1','view_window','toolbar=no,width=550,height=370,directories=0,status=0" + ",scrollbars=1,menubar=0,location=0,resizable=1'); ");
					l_control = l_control + "}\n";
					l_control = l_control + " //-->\n";
					l_control = l_control + "</script>\n";
				} else {
					l_control = l_control
							+ ("<td valign='top' align='left'><a" + applyStyle(8) + " href='" + "/custom/files" + l_file_path + "' target='_blank'>" + l_file_title + " ("
									+ l_file_size_conv + " KB)</a>");
				}
				l_control = l_control + "</td>";
				l_control = l_control + l_padding;
				l_control = l_control + "</tr>";
				l_control = l_control + "<tr>";
				l_control = l_control + l_padding;
				l_control = l_control + "<td colspan=2 valign='top' align='left'><img src='/custom/images/spacer.gif' widt" + "h=100% height=5>";
				l_control = l_control + "</td>";
				l_control = l_control + l_padding;
				l_control = l_control + "</tr>";
			}

			if (!l_control.equals("")) {
				if (l_item_desc != null && !l_item_desc.equals("")) {
					l_control = l_control + "<tr>";
					l_control = l_control + l_padding;
					l_control = l_control + ("<td" + applyStyle(8) + " colspan=2 valign='top' align='left'>" + l_item_desc);
					l_control = l_control + "</td>";
					l_control = l_control + l_padding;
					l_control = l_control + "</tr>";
				}
				l_control = l_control + "</table>";
			}
			rset1.close();
			stmt1.close();
			String s = l_control;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in fileLinksControl.");
			System.out.println("QUERY: " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String footerLinksControl(String p_orientation, boolean p_preview) {
		Vector l_footer_page_ids = new Vector();
		try {
			String l_separator;
			if (p_orientation.equals("vertical")) {
				l_separator = "<br>";
			} else {
				l_separator = "&nbsp;&nbsp;";
			}
			Statement l_stmt = m_db.m_conn.createStatement();
			String l_buffer;
			if (p_preview) {
				l_buffer = m_request.getParameter("f_footer_page_ids");
				if (l_buffer == null) {
					l_buffer = "";
				}
				if (l_buffer.length() > 0) {
					m_vt.populateFromDelimitedList(l_footer_page_ids, l_buffer);
					l_buffer = "";
					for (int l_idx = 0; l_idx < l_footer_page_ids.size(); l_idx++) {
						String l_sql = "SELECT pages.title, pages.url FROM pages WHERE pages.page_id = " + l_footer_page_ids.elementAt(l_idx);
						CachedRowSet l_rs = m_db.runSQL(l_sql, l_stmt);
						if (l_rs.next()) {
							if (l_rs.getString("url").startsWith("/")) {
								l_buffer = l_buffer
										+ ("<a" + applyStyle(6) + " href=\"" + "" + l_rs.getString("url") + "\">" + l_rs.getString("title").toLowerCase() + "</a>" + l_separator);
							} else {
								l_buffer = l_buffer
										+ ("<a" + applyStyle(6) + " href=\"" + l_rs.getString("url") + "\">" + l_rs.getString("title").toLowerCase() + "</a>" + l_separator);
							}
						}
						l_rs.close();
					}

				}
			} else {
				String l_sql = "SELECT pages.title, pages.url FROM pages, layout_template_links WHERE pages.page"
						+ "_id = layout_template_links.page_id AND layout_template_links.link_section = 'fo" + "oter' AND layout_template_links.layout_template_id = "
						+ m_layout_template_id + " " + "ORDER BY layout_template_links.link_order ASC, pages.title ASC";
				CachedRowSet l_rs = m_db.runSQL(l_sql, l_stmt);
				l_buffer = "";
				while (l_rs.next()) {
					if (l_rs.getString("url").startsWith("/")) {
						l_buffer = l_buffer
								+ ("<a" + applyStyle(6) + " href=\"" + "" + l_rs.getString("url") + "\">" + l_rs.getString("title").toLowerCase() + "</a>" + l_separator);
					} else {
						l_buffer = l_buffer + ("<a" + applyStyle(6) + " href=\"" + l_rs.getString("url") + "\">" + l_rs.getString("title").toLowerCase() + "</a>" + l_separator);
					}
				}
				l_rs.close();
			}
			l_stmt.close();
			String s = l_buffer;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in footerLinksControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String formControl(String p_name, boolean p_preview) {
		try {
			String l_form_body = "";
			String form_layout_id = "";
			String sqlString = "";
			FormProcessManager fpm = new FormProcessManager(m_db);
			Statement l_stmt1 = m_db.m_conn.createStatement();
			Statement l_stmt2 = m_db.m_conn.createStatement();
			if (p_preview) {
				l_form_body = l_form_body + "<form><table width='70'>";
				l_form_body = l_form_body + "<tr><td colspan='3'>Test Form</td></tr>";
				l_form_body = l_form_body + "<tr><td width='20' " + applyStyle(15) + ">name:</td><td width='10'>&nbsp;</td><td width='40'><input " + applyStyle(12)
						+ " type=text value='Test Name'></td></tr>";
				l_form_body = l_form_body + "<tr><td width='20' " + applyStyle(15) + ">Age:</td><td width='10'>&nbsp;</td><td width='40'><input " + applyStyle(12)
						+ " type=text value='Test Age'></td></tr>";
				l_form_body = l_form_body + "<tr><td width='20' " + applyStyle(15) + ">Address:</td><td width='10'>&nbsp;</td><td width='40'><input " + applyStyle(12)
						+ " type=text value='Test Address'></td></tr>";
				l_form_body = l_form_body + "<tr><td width='20' " + applyStyle(15) + ">Phone Number:</td><td width='10'>&nbsp;</td><td width='40'><input " + applyStyle(12)
						+ " type=text value='Test Phone Number'></td></tr>";
				l_form_body = l_form_body + "<tr><td width='20' " + applyStyle(15) + ">Email:</td><td width='10'>&nbsp;</td><td width='40'><input " + applyStyle(12)
						+ " type=text value='Test Email'></td></tr>";
				l_form_body = l_form_body + "<tr><td colspan='3'>&nbsp;</td></tr>";
				l_form_body = l_form_body + "<tr><td align='left'><input " + applyStyle(13) + " type='button' value='Cancel'></td><td align='center'><input " + applyStyle(13)
						+ " type='button' value='Clear'></td><td align='right'><input " + applyStyle(13) + " type='button' value='Submit'></td></tr>";
				l_form_body = l_form_body + "<tr><td colspan='3'>&nbsp;</td></tr>";
				l_form_body = l_form_body + "</table></form>";
				l_form_body = "<span" + applyStyle(4) + ">" + l_form_body + "</span>";
			} else {
				sqlString = "SELECT form_layout.form_layout_id FROM form_layout, form_repository, form_layout" + "_form_rel, layout_form_item WHERE form_layout_form_rel.page_id="
						+ m_page_id + " AND " + "form_layout_form_rel.form_id=form_repository.form_id AND " + "form_repository.form_id=form_layout.form_id AND "
						+ "layout_form_item.layout_form_item_id=form_layout_form_rel.layout_form_item_id AN" + "D " + "layout_form_item.layout_form_item_title='"
						+ m_db.plSqlSafeString(p_name) + "'";
				ResultSet pageRset = m_db.runSQLResultSet(sqlString, l_stmt1);
				if (pageRset.next()) {
					form_layout_id = pageRset.getString("form_layout_id");
					sqlString = "select form_layout_form_rel.flfr_id from form_layout_form_rel,form_process,layou"
							+ "t_form_item where form_layout_form_rel.layout_form_item_id=layout_form_item.layo" + "ut_form_item_id and form_layout_form_rel.page_id=" + m_page_id
							+ " and form_layout_form_rel.flfr_id=" + "form_process.flfr_id";
					CachedRowSet rset = m_db.runSQL(sqlString, l_stmt2);
					if (rset.next()) {
						l_form_body = applyStyleToForm(ftlm.getFinalHtmlFormStr(form_layout_id));
						l_form_body = "<span" + applyStyle(4) + ">" + l_form_body + "<input type='hidden' name='flfr_id' value='" + rset.getString("flfr_id") + "'>"
								+ "\n</form>\n\n</span>";
					} else {
						sqlString = "select form_repository.form_id from form_repository, form_layout where form_repo"
								+ "sitory.form_id=form_layout.form_id and form_layout.form_layout_id=" + form_layout_id;
						rset = m_db.runSQL(sqlString, l_stmt2);
						if (rset.next()) {
							String form_id = rset.getString("form_id");
							Form frm = new Form(m_db);
							if (frm.isSubscriptionForm(form_id, "")) {
								l_form_body = applyStyleToForm(ftlm.getFinalHtmlFormStr(form_layout_id));
								l_form_body = "<span" + applyStyle(4) + ">" + l_form_body + "\n</form>\n\n</span>";
							}
						}
					}
				} else {
					l_form_body = "";
				}
				pageRset.close();
				l_stmt1.close();
				l_stmt2.close();
				if (m_request.getParameter("is_post_to_itself") != null && m_request.getParameter("is_post_to_itself").equals("true")) {
					l_form_body = "<br><br>" + fpm.formProcess(m_request, m_url, m_page_id);
				}
			}
			String s1 = l_form_body;
			return s1;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in formControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s = "";
			return s;
		}
	}

	public String siteMapControl(String addPageJoints) {
		SiteMap sitemap = new SiteMap(m_db);
		try {
			String s = sitemap.getSiteMap(addPageJoints);
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in siteMapControl().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	private String imageGalleryControl(boolean p_preview) {
		try {
			String s = "";
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in imageGalleryControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String headerLinksControl(boolean p_preview) {
		Vector l_header_page_ids = new Vector();
		try {
			Statement l_stmt = m_db.m_conn.createStatement();
			String l_buffer = "";
			if (p_preview) {
				l_buffer = m_request.getParameter("f_header_page_ids");
				if (l_buffer == null) {
					l_buffer = "";
				}
				if (l_buffer.length() > 0) {
					m_vt.populateFromDelimitedList(l_header_page_ids, l_buffer);
					for (int l_idx = 0; l_idx < l_header_page_ids.size(); l_idx++) {
						String l_sql = "SELECT pages.title, pages.url FROM pages WHERE pages.page_id = " + l_header_page_ids.elementAt(l_idx);
						CachedRowSet l_rs = m_db.runSQL(l_sql, l_stmt);
						if (l_rs.next()) {
							if (l_rs.getString("url").startsWith("/")) {
								l_buffer = l_buffer
										+ ("<a" + applyStyle(5) + " href=\"" + "" + l_rs.getString("url") + "\">" + l_rs.getString("title").toLowerCase() + "</a>&nbsp;&nbsp;");
							} else {
								l_buffer = l_buffer
										+ ("<a" + applyStyle(5) + " href=\"" + l_rs.getString("url") + "\">" + l_rs.getString("title").toLowerCase() + "</a>&nbsp;&nbsp;");
							}
						}
						l_rs.close();
					}

				}
			} else {
				String l_sql = "SELECT pages.title, pages.url FROM pages, layout_template_links WHERE pages.page"
						+ "_id = layout_template_links.page_id AND layout_template_links.link_section = 'he" + "ader' AND layout_template_links.layout_template_id = "
						+ m_layout_template_id + " " + "ORDER BY layout_template_links.link_order ASC, pages.title ASC";
				CachedRowSet l_rs;
				for (l_rs = m_db.runSQL(l_sql, l_stmt); l_rs.next();) {
					if (l_rs.getString("url").startsWith("/")) {
						l_buffer = l_buffer + ("<a" + applyStyle(5) + " href=\"" + "" + l_rs.getString("url") + "\">" + l_rs.getString("title").toLowerCase() + "</a>&nbsp;&nbsp;");
					} else {
						l_buffer = l_buffer + ("<a" + applyStyle(5) + " href=\"" + l_rs.getString("url") + "\">" + l_rs.getString("title").toLowerCase() + "</a>&nbsp;&nbsp;");
					}
				}

				l_rs.close();
			}
			l_stmt.close();
			String s = l_buffer;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in headerLinksControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String imageControl(String p_width, String p_height, String p_border, boolean p_preview) {
		try {
			String s = "";
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in imageControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String loginStartControl(boolean p_preview) {
		try {
			String l_redirectPageId = m_request.getParameter("redirectpageid");
			if (l_redirectPageId == null || l_redirectPageId.equals("null") || l_redirectPageId.equals("")) {
				l_redirectPageId = m_page_id;
			}
			String l_buffer = "<form name='public_login' method='POST' action='/public/public_login_check.jsp'>"
					+ "<input name='loginpageid' id='loginpageid' type='hidden' value='" + m_page_id + "'>"
					+ "<input name='redirectpageid' id='redirectpageid' type='hidden' value='" + l_redirectPageId + "'>";
			String l_error = m_request.getParameter("loginerror");
			if (l_error != null) {
				if (!l_error.equals("0") && !l_error.equals("")) {
					l_buffer = l_buffer + "<script language='Javascript'>";
					l_buffer = l_buffer + ("alert ('" + l_error + "');");
					l_buffer = l_buffer + "</script>";
				} else if (l_error.equals("0")) {
					l_buffer = l_buffer + "<script language='Javascript'>";
					l_buffer = l_buffer + "alert ('Successful Login');";
					l_buffer = l_buffer + "</script>";
				}
			}
			String s1 = l_buffer;
			return s1;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loginStartControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s = "";
			return s;
		}
	}

	public String loginEndControl(boolean p_preview) {
		try {
			String s = "</form>";
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loginEndControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String reposImageControl(String p_key, String p_width, String p_height, String p_border, String p_alt, boolean p_preview) {
		String l_sql = "";
		String l_image = "";
		try {
			Statement l_stmt = m_db.m_conn.createStatement();
			l_sql = "SELECT file_path FROM file_repository WHERE file_key = '" + m_db.plSqlSafeString(p_key) + "'";
			CachedRowSet l_rs = m_db.runSQL(l_sql, l_stmt);
			if (l_rs.next()) {
				if (p_border.equals("")) {
					p_border = "0";
				}
				l_image = l_image + ("<img src='/custom/files" + l_rs.getString("file_path") + "'");
				l_image = l_image + (" alt='" + p_alt + "' border='" + p_border + "'");
				if (!p_width.equals("")) {
					l_image = l_image + (" width='" + p_width + "'");
				}
				if (!p_height.equals("")) {
					l_image = l_image + (" height='" + p_height + "'");
				}
				l_image = l_image + ">";
			}
			l_rs.close();
			l_stmt.close();
			String s = l_image;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in reposImageControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String reposTextControl(String p_key, boolean p_preview) {
		String l_sql = "";
		String l_text = "";
		Date l_start_date = new Date();
		Date l_end_date = new Date();
		Calendar l_now = Calendar.getInstance();
		Calendar l_start_cal = Calendar.getInstance();
		Calendar l_end_cal = Calendar.getInstance();
		try {
			Statement l_stmt = m_db.m_conn.createStatement();
			l_sql = "SELECT * FROM item_repository WHERE LOWER(item_title) = '" + m_db.plSqlSafeString(p_key.toLowerCase()) + "'";
			ResultSet l_rs = m_db.runSQLResultSet(l_sql, l_stmt);
			if (l_rs.next()) {
				boolean l_proceed = true;
				l_start_date = l_rs.getDate("item_start_date");
				l_end_date = l_rs.getDate("item_end_date");
				if (l_start_date != null) {
					l_start_cal.setTime(l_start_date);
					if (!l_now.after(l_start_cal)) {
						l_proceed = false;
					}
				}
				if (l_proceed && l_end_date != null) {
					l_end_cal.setTime(l_end_date);
					if (!l_now.before(l_end_cal)) {
						l_proceed = false;
					}
				}
				if (l_proceed) {
					ContentOutput _tmp = this;
					if (AppConstants.DATABASE_TYPE == 1) {
						Clob cl = l_rs.getClob("item_text");
						if (cl != null) {
							l_text = cl.getSubString(1L, (int) cl.length());
							if (l_text == null) {
								l_text = "";
							}
						} else {
							l_text = "";
						}
					} else {
						l_text = l_rs.getString("item_text");
					}
					l_text = "<span" + applyStyle(4) + ">" + l_text + "</span>";
				} else {
					l_text = "";
				}
			}
			l_rs.close();
			l_stmt.close();
			String s = l_text;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in reposTextControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	public String searchControl(HttpServletRequest p_request, String p_button_repos_key, String p_table_width, String p_title_text, String p_helper_text, String p_bg_color,
			String p_page_id, String p_show_search_types, String p_show_results_per_page, String p_show_order_by, String p_show_scope, String p_default_scope,
			String p_show_external_search_checkbox, String p_external_search_checkbox_default, String p_show_natural_lang_button, String p_show_precision_search_button,
			String p_show_metadata_select, boolean p_preview) {
		String ret = "";
		String l_searchresultsURL = "";
		Vector l_metadata_type_vec = new Vector();
		Metadata metadata = new Metadata(m_db);
		try {
			String searchString = p_request.getParameter("str");
			String searchType = p_request.getParameter("type");
			String resultsPerPage = p_request.getParameter("rpp");
			String reposSearchType = p_request.getParameter("rst");
			String orderBy = p_request.getParameter("orderby");
			String l_external_search = p_request.getParameter("external");
			String l_metadata_type[] = p_request.getParameterValues("mdt");
			String l_natural_lang = p_request.getParameter("nat_lang");
			Statement l_stmt = m_db.m_conn.createStatement();
			String sqlString = "select layout_display_file from layout_templates, pages where pages.layout_templ" + "ate_id=layout_templates.layout_template_id and pages.page_id="
					+ p_page_id;
			CachedRowSet rset = m_db.runSQL(sqlString, l_stmt);
			if (rset.next()) {
				l_searchresultsURL = rset.getString("layout_display_file");
			}
			rset.close();
			if (searchString == null) {
				searchString = "";
			}
			if (searchType == null) {
				searchType = "and";
			}
			if (resultsPerPage == null) {
				resultsPerPage = "30";
			}
			if (orderBy == null) {
				orderBy = "title";
			}
			ContentOutput _tmp = this;
			if (AppConstants.DATABASE_TYPE != 1) {
				orderBy = "title";
			}
			if (reposSearchType == null) {
				reposSearchType = p_default_scope;
			}
			if (l_metadata_type != null) {
				if (l_metadata_type.length == 1 && l_metadata_type[0].indexOf(",") >= 0) {
					m_vt.populateFromDelimitedList(l_metadata_type_vec, l_metadata_type[0]);
				} else {
					for (int i = 0; i < l_metadata_type.length; i++) {
						l_metadata_type_vec.addElement(l_metadata_type[i]);
					}

				}
			}
			ret = ret + "<script language='Javascript'>\n\r";
			ret = ret + "<!--\n\r";
			ret = ret + "function startSearch()\n\r";
			ret = ret + "{\n\r";
			ret = ret + "  document.searchForm.submit();\n\r";
			ret = ret + "}\n\r";
			ret = ret + "-->\n\r";
			ret = ret + "</script>\n\r";
			ret = ret + ("<form method='GET' name='searchForm' id='searchForm' action='" + l_searchresultsURL + "'>\n\r");
			ret = ret + ("<table border='0' cellpadding='0' cellspacing='0' width='" + p_table_width + "' bgcolor='" + p_bg_color + "'>\n\r");
			ret = ret + "<tr>\n\r";
			ret = ret + ("  <td valign='middle' bgcolor='" + p_bg_color + "'>\n\r");
			if (!p_title_text.equals("")) {
				ret = ret + ("<a " + applyStyle(4) + ">" + p_title_text + "</a>\n\r");
				ret = ret + "</td>\n\r";
				ret = ret + ("<td valign='middle' bgcolor='" + p_bg_color + "'>\n\r");
				ret = ret + "</td>\n\r";
				ret = ret + "</tr>\n\r";
				ret = ret + "<tr>\n\r";
				ret = ret + ("<td valign='middle' bgcolor='" + p_bg_color + "'>\n\r");
			}
			ret = ret + ("<input" + applyStyle(12) + " type='text' name='str' value='" + searchString + "'>");
			ret = ret + "&nbsp;&nbsp;&nbsp;&nbsp;";
			ret = ret + "</td>\n\r";
			ret = ret + ("<td align='left' valign='middle' bgcolor='" + p_bg_color + "' WIDTH='100%'>\n\r");
			ret = ret + "<a href='Javascript:startSearch();'>";
			if (!p_button_repos_key.equals("")) {
				ret = ret + reposImageControl(p_button_repos_key, "", "", "0", "Search", p_preview);
			} else {
				ret = ret + "<img src='/images/default_search.gif' border='0' alt='Search'>";
			}
			ret = ret + "</a>\n\r";
			ret = ret + "</td>\n\r";
			ret = ret + "</tr>\n\r";
			ret = ret + "<tr>\n\r";
			ret = ret + ("<td " + applyStyle(4) + " colspan='2' width='" + p_table_width + "' bg_color='" + p_bg_color + "'>\n\r");
			if (p_show_search_types.toLowerCase().equals("select")) {
				ret = ret + ("<input " + applyStyle(14) + " type='radio' name='type' value='and' ");
				if (searchType == null || !searchType.equals("or") || !searchType.equals("exact")) {
					ret = ret + "checked";
				}
				ret = ret + ">all words<br>\n\r";
				ret = ret + ("<input " + applyStyle(14) + " type='radio' name='type' value='or' ");
				if (searchType.equals("or")) {
					ret = ret + "checked";
				}
				ret = ret + ">any words<br>\n\r";
				ret = ret + ("<input " + applyStyle(14) + " type='radio' name='type' value='exact' ");
				if (searchType.equals("exact")) {
					ret = ret + "checked";
				}
				ret = ret + ">exact phrase<br>\n\r";
				ContentOutput _tmp1 = this;
				if (AppConstants.DATABASE_TYPE == 1 && p_show_natural_lang_button != null && p_show_natural_lang_button.equals("true")) {
					ret = ret + ("<input " + applyStyle(14) + " type='radio' name='type' value='nat_lang' ");
					if (searchType.equals("nat_lang")) {
						ret = ret + "checked";
					}
					ret = ret + ">Natural Language<br>\n\r";
				}
				if (p_show_precision_search_button != null && p_show_precision_search_button.equals("true")) {
					ret = ret + ("<input " + applyStyle(14) + " type='radio' name='type' value='rich_query' ");
					if (searchType.equals("rich_query")) {
						ret = ret + "checked";
					}
					ret = ret + ">Precision Search<br>\n\r";
				}
				ret = ret + "<br>";
			} else {
				ret = ret + ("<input type='hidden' name='type' value='" + p_show_search_types + "'>");
			}
			if (p_show_results_per_page.toLowerCase().equals("true")) {
				ret = ret + "<table cellpadding=0 cellspacing=0 border=0>\n\r";
				ret = ret + "<tr><td><img src='/images/spacer.gif' width='60' height='1'></td><td><img src='/" + "images/spacer.gif' width='5' height='1'></td><td></td></tr>\n\r";
				ret = ret + ("<tr><td " + applyStyle(4) + " valign='top'>Results<br>per page</td><td></td><td valign='top'>\n\r");
				ret = ret + ("<select name='rpp'" + applyStyle(12) + ">\n\r");
				ret = ret + "  <option value='5' ";
				if (resultsPerPage.equals("5")) {
					ret = ret + "selected";
				}
				ret = ret + ">5</option>\n\r";
				ret = ret + "  <option value='10' ";
				if (resultsPerPage.equals("10")) {
					ret = ret + "selected";
				}
				ret = ret + ">10</option>\n\r";
				ret = ret + "  <option value='20' ";
				if (resultsPerPage.equals("20")) {
					ret = ret + "selected";
				}
				ret = ret + ">20</option>\n\r";
				ret = ret + "  <option value='30' ";
				if (resultsPerPage.equals("30")) {
					ret = ret + "selected";
				}
				ret = ret + ">30</option>\n\r";
				ret = ret + "</select>\n\r";
				ret = ret + "</td></tr></table>";
			} else {
				ret = ret + "<input type='hidden' name='rpp' value='30'>";
			}
			if (p_show_scope.toLowerCase().equals("true")) {
				ret = ret + "<br><table cellpadding=0 cellspacing=0 border=0>\n\r";
				ret = ret + "<tr><td><img src='/images/spacer.gif' width='60' height='1'></td><td><img src='/" + "images/spacer.gif' width='5' height='1'></td><td></td></tr>\n\r";
				ret = ret + ("<tr><td " + applyStyle(4) + ">Scope</td><td></td><td>\n\r");
				ret = ret + ("<select name='rst'" + applyStyle(12) + ">\n\r");
				ret = ret + "  <option value='' ";
				if (reposSearchType.equals("")) {
					ret = ret + "selected";
				}
				ret = ret + ">Web Site</option>\n\r";
				ret = ret + "  <option value='repository' ";
				if (reposSearchType.equals("repository")) {
					ret = ret + "selected";
				}
				ret = ret + ">File Repository</option>\n\r";
				ret = ret + "</select>\n\r";
				ret = ret + "</td></tr></table>";
			} else {
				ret = ret + ("<input type='hidden' name='rst' value='" + reposSearchType + "'>");
			}
			if (p_show_metadata_select.toLowerCase().equals("true")) {
				rset = metadata.getElements(l_stmt);
				if (rset.next()) {
					ret = ret + "<br><table cellpadding=0 cellspacing=0 border=0>\n\r";
					ret = ret + "<tr><td><img src='/images/spacer.gif' width='60' height='1'></td><td><img src='/"
							+ "images/spacer.gif' width='5' height='1'></td><td></td></tr>\n\r";
					ret = ret + ("<tr><td " + applyStyle(4) + " valign='top'>Metadata</td><td></td><td>\n\r");
					ret = ret + ("<select name='mdt'" + applyStyle(12) + " size='5' multiple>\n\r");
					do {
						ret = ret + ("  <option value='" + rset.getString("elem_id") + "' ");
						if (l_metadata_type_vec.contains(rset.getString("elem_id"))) {
							ret = ret + "selected";
						}
						ret = ret + (">" + rset.getString("name") + "</option>\n\r");
					} while (rset.next());
					ret = ret + "</select>\n\r";
					ret = ret + "</td></tr></table>";
				}
				rset.close();
			}
			ContentOutput _tmp2 = this;
			if (AppConstants.DATABASE_TYPE == 1) {
				if (p_show_order_by.equals("true")) {
					ret = ret + "<br><table cellpadding=0 cellspacing=0 border=0>\n\r";
					ret = ret + "<tr><td><img src='/images/spacer.gif' width='60' height='1'></td><td><img src='/"
							+ "images/spacer.gif' width='5' height='1'></td><td></td></tr>\n\r";
					ret = ret + ("<tr><td " + applyStyle(4) + ">Order By</td><td></td><td>\n\r");
					ret = ret + ("<select name='orderby'" + applyStyle(12) + ">\n\r");
					ret = ret + "  <option value='rank' ";
					if (orderBy.equals("rank")) {
						ret = ret + "selected";
					}
					ret = ret + ">Rank</option>\n\r";
					ret = ret + "  <option value='title' ";
					if (orderBy.equals("title")) {
						ret = ret + "selected";
					}
					ret = ret + ">Title</option>\n\r";
					ret = ret + "</select>";
					ret = ret + "</td></tr></table>";
				} else {
					ret = ret + "<input type='hidden' name='orderby' value='rank'>";
				}
			}
			ContentOutput _tmp3 = this;
			if (AppConstants.DATABASE_TYPE == 1) {
				if (p_show_external_search_checkbox != null && p_show_external_search_checkbox.equals("true")) {
					ret = ret + "<br><br><input type='checkbox' name='external' value='true'";
					if (searchString.equals("")) {
						if (p_external_search_checkbox_default != null && p_external_search_checkbox_default.equals("true")) {
							ret = ret + " checked";
						}
					} else if (l_external_search != null && l_external_search.equals("true")) {
						ret = ret + " checked";
					}
					ret = ret + "> Search External Sites";
				} else {
					ret = ret + ("<input type='hidden' name='external' value='" + p_external_search_checkbox_default + "'>");
				}
			}
			ret = ret + "</td>\n\r";
			ret = ret + "</tr>\n\r";
			if (!p_helper_text.equals("")) {
				ret = ret + "<tr>\n\r";
				ret = ret + ("<td colspan='2' width='" + p_table_width + "' bgcolor='" + p_bg_color + "'>");
				ret = ret + ("<a " + applyStyle(4) + ">" + p_helper_text + "</a>\n\r");
				ret = ret + "</td>\n\r";
				ret = ret + "</tr>\n\r";
			}
			ret = ret + "</table>\n\r";
			ret = ret + "<input type='hidden' name='page' value='1'>";
			ret = ret + ("<input type='hidden' name='xcid' value='" + p_page_id + "'>");
			ret = ret + "</form>\n\r";
			l_stmt.close();
			String s = ret;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in searchControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}

	/*
	 * public String searchResultsControl(HttpServletRequest p_request, String
	 * p_altColour, boolean p_preview) { String ret = ""; try { Search
	 * basicSearch = new Search(m_db); String searchString =
	 * p_request.getParameter("str"); String searchType =
	 * p_request.getParameter("type"); DOMUtil l_domUtil = new DOMUtil(); String
	 * l_showXml = p_request.getParameter("showxml"); String l_searchresultsURL
	 * = p_request.getRequestURI(); String l_order =
	 * p_request.getParameter("orderby"); String l_page_id =
	 * p_request.getParameter("xcid"); String l_doco_repos_search_type =
	 * p_request.getParameter("rst"); String l_external_search =
	 * p_request.getParameter("external"); String l_natural_lang =
	 * p_request.getParameter("nat_lang"); String l_metadata_type[] =
	 * p_request.getParameterValues("mdt"); Vector l_metadata_type_vec = new
	 * Vector(); HttpSession l_session = p_request.getSession(true);
	 * if(searchString != null && searchType != null &&
	 * !searchString.equals("null") && !searchString.equals("")) { int
	 * resultsPerPage = Integer.parseInt(p_request.getParameter("rpp")); int
	 * currentPage = Integer.parseInt(p_request.getParameter("page"));
	 * basicSearch.setSearchType(searchType);
	 * basicSearch.setSearchString(searchString);
	 * basicSearch.setResultsPerPage(resultsPerPage);
	 * basicSearch.setSearchResultsPageId(l_page_id); if(l_external_search ==
	 * null || !l_external_search.equals("true")) {
	 * basicSearch.setExternalSearch(false); } else {
	 * basicSearch.setExternalSearch(true); }
	 * basicSearch.setDocoReposSearchType(l_doco_repos_search_type);
	 * if(l_metadata_type != null) { if(l_metadata_type.length == 1 &&
	 * l_metadata_type[0].indexOf(",") >= 0) {
	 * m_vt.populateFromDelimitedList(l_metadata_type_vec, l_metadata_type[0]);
	 * } else { for(int i = 0; i < l_metadata_type.length; i++) {
	 * l_metadata_type_vec.addElement(l_metadata_type[i]); }
	 * 
	 * } } basicSearch.setMetadataElementIds(l_metadata_type_vec);
	 * if(l_session.getAttribute("publicAuthId") != null &&
	 * !l_session.getAttribute("publicAuthId").equals("")) {
	 * basicSearch.setPublicLoggedInAuthor
	 * (l_session.getAttribute("publicAuthId").toString()); }
	 * basicSearch.performSearch(); String l_xml = basicSearch.getXMLResults();
	 * if(l_showXml == null) { boolean l_orderBy; if(l_order == null ||
	 * l_order.equals("title")) { l_orderBy = false; } else { l_orderBy = true;
	 * } ret = ret +
	 * "<form method='POST' name='searchResultsForm' id='searchResultsForm'>\n\r"
	 * ; String l_xsl = basicSearch.generateXSL(currentPage, resultsPerPage,
	 * l_searchresultsURL, l_orderBy, p_altColour, p_request); ret =
	 * DOMUtil.transformXmlWithXsl(l_xml, l_xsl); ret = ret +
	 * ("<input type='hidden' name='xcid' value='" + l_page_id + "'>"); ret =
	 * ret + "</form>\n\r"; } else { ret = l_xml; } } String s1 = ret; return
	 * s1; } catch(Exception e) {
	 * System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
	 * System.out.println("An Exception occured in searchResultsControl.");
	 * System.out.println("MESSAGE: " + e.getMessage());
	 * System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
	 * System.out.println("CLASS.TOSTRING: " + e.toString());
	 * System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<"); String s = ""; return
	 * s; } }
	 */
	public String titleControl(boolean p_preview) {
		try {
			if (p_preview) {
				String s = "<p" + applyStyle(3) + ">Preview Page</p>";
				return s;
			} else {
				String s1 = "<p" + applyStyle(3) + ">" + m_page_title + "</p>";
				return s1;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in titleControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s2 = "";
			return s2;
		}
	}

	public boolean checkPageLoginRequired(HttpSession p_session) {
		try {
			User userObj = new User(m_db);
			if (!m_is_secure) {
				boolean flag = false;
				return flag;
			}
			if (p_session.getAttribute("publicAuthId") == null || p_session.getAttribute("publicAuthId").equals("")) {
				boolean flag2 = true;
				return flag2;
			}
			if (!userObj.checkPublicUserPageRights(p_session.getAttribute("publicAuthId") + "", m_page_id)) {
				boolean flag3 = true;
				return flag3;
			} else {
				boolean flag4 = false;
				return flag4;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentOutput.checkPageLoginRequired");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			boolean flag1 = false;
			return flag1;
		}
	}

	public String netMeetingControl(String p_mode, boolean p_preview) {
		String l_buffer = "";
		try {
			l_buffer = l_buffer + "<object ID=NetMeeting CLASSID='CLSID:3E9BAF2D-7A79-11d2-9334-0000F875AE17'>";
			l_buffer = l_buffer + ("  <PARAM NAME = 'MODE' VALUE = '" + p_mode + "'>");
			l_buffer = l_buffer + "</object>";
			if (p_mode.equals("DataOnly")) {
				l_buffer = l_buffer + "<br><br>";
				l_buffer = l_buffer + "<table cellpadding=0 cellspacing=0 border=0>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "  <td>";
				l_buffer = l_buffer + ("    <input type=text id=CallToAddress " + applyStyle(12) + ">");
				l_buffer = l_buffer + "  </td>";
				l_buffer = l_buffer + "  <td>&nbsp;</td>";
				l_buffer = l_buffer + "  <td>";
				l_buffer = l_buffer
						+ ("    <input type=button " + applyStyle(13) + " value='Call' id=CallToBtn onclick=NetMeeting.CallTo(CallToAddress.value) style=" + "'width:60'>&nbsp;");
				l_buffer = l_buffer + "  </td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "<tr>";
				l_buffer = l_buffer + "  <td></td><td></td>";
				l_buffer = l_buffer + "  <td>";
				l_buffer = l_buffer + ("    <input type=button " + applyStyle(13) + " value='Hang Up' id=HangUpBtn onclick=NetMeeting.LeaveConference() style='width:" + "60'>");
				l_buffer = l_buffer + "  </td>";
				l_buffer = l_buffer + "</tr>";
				l_buffer = l_buffer + "</table>";
			}
			String s = l_buffer;
			return s;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in netMeetingControl.");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			String s1 = "";
			return s1;
		}
	}
}
