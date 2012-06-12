package content;

import java.io.PrintStream;
import java.sql.*;
import javax.servlet.jsp.JspWriter;

// Referenced classes of package content:
//            Database

public class PageTemplate {

	String IMAGE_DIRECTORY;
	String ROOT_DIRECTORY;
	String ITEM_IMAGE_LOCATION;
	String FILE_LOCATION;
	String THEME_IMAGES_DIRECTORY;
	String URL_SUBSCRIBE;
	String CLASS_FILES_DIRECTORY;
	final String FUNCTION_PAGE_ABOUT_US = "113";
	public String m_fullUserName;
	public String m_sessionTimeout;
	public Database db;
	private int m_link_type_count;

	public PageTemplate(Database p_db) {
		IMAGE_DIRECTORY = "";
		URL_SUBSCRIBE = "/functionPages/subscribe.jsp";
		m_fullUserName = "";
		m_sessionTimeout = "";
		m_link_type_count = 0;
		db = p_db;
		IMAGE_DIRECTORY = "/public/images/site/";
		ROOT_DIRECTORY = "/public";
		ITEM_IMAGE_LOCATION = "/public/item_images";
		FILE_LOCATION = "/public/uploaded_files";
		THEME_IMAGES_DIRECTORY = "/public/images/pic_section";
		CLASS_FILES_DIRECTORY = "";
	}

	public void writePageLocation(JspWriter p_out, String p_pageTitles[], String p_pageURLs[]) {
		try {
			for (int levelCounter = 0; levelCounter < p_pageTitles.length; levelCounter++) {
				if (!p_pageTitles[levelCounter].equals("")) {
					if (levelCounter != 0) {
						p_out.println(" > ");
					}
					p_out.println("<a href='" + ROOT_DIRECTORY + p_pageURLs[levelCounter] + "'>" + p_pageTitles[levelCounter] + "</a>");
				}
				levelCounter++;
			}

		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object : writePageLoca" + "tion()");
		}
	}

	public String determineParentPages(String p_page_id, String pageIds[], String pageTitles[], String pageURLs[]) {
		String currentPageLevel = "";
		try {
			PageTemplate _tmp = this;
			Statement stmt = Database.m_conn.createStatement();
			db.connectDatabase();
			String sqlString = "select * from pages where page_id=" + p_page_id;
			ResultSet rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				currentPageLevel = rset.getString("page_level");
				if (currentPageLevel.equals("3")) {
					pageIds[2] = p_page_id;
					pageURLs[2] = rset.getString("url");
					pageTitles[2] = rset.getString("title");
					pageIds[1] = rset.getString("parent_id");
					sqlString = "select * from pages where page_id=" + pageIds[1];
					rset.close();
					rset = db.runSQL(sqlString, stmt);
					if (rset.next()) {
						pageIds[0] = rset.getString("parent_id");
						pageTitles[1] = rset.getString("title");
						pageURLs[1] = rset.getString("url");
						sqlString = "select * from pages where page_id=" + pageIds[0];
						rset.close();
						rset = db.runSQL(sqlString, stmt);
						if (rset.next()) {
							pageTitles[0] = rset.getString("title");
							pageURLs[0] = rset.getString("url");
						} else {
							System.out.println("An error occurred when trying to access the database object : determineParentPag" + "es()");
						}
					} else {
						System.out.println("An error occurred when trying to access the database object : determineParentPag" + "es()");
					}
				} else if (currentPageLevel.equals("2")) {
					pageIds[0] = rset.getString("parent_id");
					pageIds[1] = p_page_id;
					pageTitles[1] = rset.getString("title");
					pageURLs[1] = rset.getString("url");
					pageIds[2] = "";
					pageTitles[2] = "";
					pageURLs[2] = "";
					sqlString = "select * from pages where page_id=" + pageIds[0];
					rset.close();
					rset = db.runSQL(sqlString, stmt);
					if (rset.next()) {
						pageIds[0] = rset.getString("title");
						pageURLs[0] = rset.getString("url");
						rset.close();
					} else {
						System.out.println("An error occurred when trying to access the database object : determineParentPag" + "es()");
					}
				} else {
					pageIds[0] = p_page_id;
					pageTitles[0] = rset.getString("title");
					pageURLs[0] = rset.getString("url");
					pageIds[1] = "";
					pageTitles[1] = "";
					pageURLs[1] = "";
					pageIds[2] = "";
					pageTitles[2] = "";
					pageURLs[1] = "";
					rset.close();
				}
			} else {
				System.out.println("Page does not exist. : determineParentPages()");
				currentPageLevel = "0";
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the database object : determineParen" + "tPages()");
		}
		db.closeDatabase();
		return currentPageLevel;
	}

	public void writeItemImage(JspWriter p_out, String p_image) {
		try {
			if (p_image != null && !p_image.equals("")) {
				p_out.println("<img src='" + ITEM_IMAGE_LOCATION + "/" + p_image + "' border='0'>");
			}
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object : writeItemImag" + "e()");
		}
	}

	public void writeItemTextAndImage(JspWriter p_out, String p_image, String p_image_width, String p_image_height, String p_text) {
		try {
			String image_width;
			if (p_image_width == null || p_image_width.equals("") || p_image_width.equals("0")) {
				image_width = "";
			} else {
				image_width = "width='" + p_image_width + "'";
			}
			String image_height;
			if (p_image_height == null || p_image_height.equals("") || p_image_height.equals("0")) {
				image_height = "";
			} else {
				image_height = "height='" + p_image_height + "'";
			}
			if (p_image != null && !p_image.equals("")) {
				p_out.println("<p align='justify' class='body'>");
				if (p_image.toLowerCase().endsWith(".swf")) {
					p_out.println("<embed " + image_height + " " + image_width + " src='" + ITEM_IMAGE_LOCATION + "/" + p_image
							+ "' quality='high' bgcolor='#FFFFFF' TYPE='application/x-shockwave-flash' PLUGINSP"
							+ "AGE='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=Shoc" + "kwaveFlash'>");
				} else {
					p_out.println("<img align='right' src='" + ITEM_IMAGE_LOCATION + "/" + p_image + "' border='0' " + image_height + " " + image_width + ">");
				}
				p_out.println(p_text + "</p>");
				p_out.println("<p class='smallbody'>&nbsp;</p>");
			} else {
				p_out.println("<p align='justify' class='body'>" + p_text + "</p>");
				p_out.println("<p class='smallbody'>&nbsp;</p>");
			}
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object : writeItemText" + "AndImage()");
		}
	}

	public void writeItemRelatedLinks(JspWriter p_out, String p_item_id) {
		try {
			PageTemplate _tmp = this;
			Statement stmt = Database.m_conn.createStatement();
			db.connectDatabase();
			String sqlString = "select related_links.page_id as pageId, pages.title as pageTitle, pages.url as u" + "rl from related_links, pages where related_links.pagi_id="
					+ p_item_id + " and related_links.page_id=pages.page_id order by rell_id asc";
			ResultSet rset = db.runSQL(sqlString, stmt);
			String out_text;
			for (out_text = ""; rset.next(); out_text = out_text
					+ ("<br><a class='altbluenet' id='altbluenet' href='" + ROOT_DIRECTORY + rset.getString("url") + "'>" + rset.getString("pageTitle") + "</a><br>")) {
			}
			rset.close();
			if (!out_text.equals("")) {
				p_out.println(preAuxItemStruct());
				p_out.println("<span class='subhead'>Related Information</span><br>" + out_text);
				p_out.println(postAuxItemStruct());
				m_link_type_count++;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object or database obj" + "ect : writeItemRelatedLinks()");
		}
		db.closeDatabase();
	}

	public void writeItemEmailLinks(JspWriter p_out, String p_item_id) {
		try {
			PageTemplate _tmp = this;
			Statement stmt = Database.m_conn.createStatement();
			db.connectDatabase();
			String sqlString = "select address, description from email_links where pagi_id=" + p_item_id + " order by emai_id asc";
			ResultSet rset = db.runSQL(sqlString, stmt);
			String out_text;
			for (out_text = ""; rset.next(); out_text = out_text
					+ ("<br><a class='altbluenet' id='altbluenet' href='mailto:" + rset.getString("address") + "'>" + rset.getString("description") + "</a><br>")) {
			}
			rset.close();
			if (!out_text.equals("")) {
				p_out.println(preAuxItemStruct());
				p_out.println("<span class='subhead'>Emails</span><br>" + out_text);
				p_out.println(postAuxItemStruct());
				m_link_type_count++;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object or database obj" + "ect : writeItemEmailLinks()");
		}
		db.closeDatabase();
	}

	public void writeItemURLLinks(JspWriter p_out, String p_item_id) {
		try {
			PageTemplate _tmp = this;
			Statement stmt = Database.m_conn.createStatement();
			db.connectDatabase();
			String sqlString = "select title, address, description from url_links where pagi_id=" + p_item_id + " order by urll_id asc";
			ResultSet rset = db.runSQL(sqlString, stmt);
			String out_text;
			for (out_text = ""; rset.next(); out_text = out_text + ("<br>" + rset.getString("description") + "<br>")) {
				String address = rset.getString("address");
				if (address.indexOf("http://") == -1) {
					address = "http://" + address;
				}
				out_text = out_text
						+ ("<br><a name='" + rset.getString("title") + "' class='altbluenet' target='_blank' id='altbluenet' href='" + address + "'>" + rset.getString("title") + "</a>");
			}

			rset.close();
			if (!out_text.equals("")) {
				p_out.println(preAuxItemStruct());
				p_out.println("<span class='subhead'>Links</span><br>" + out_text);
				p_out.println(postAuxItemStruct());
				m_link_type_count++;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object or database obj" + "ect : writeItemURLLinks()");
		}
		db.closeDatabase();
	}

	public void writeItemFiles(JspWriter p_out, String p_item_id) {
		try {
			PageTemplate _tmp = this;
			Statement stmt = Database.m_conn.createStatement();
			db.connectDatabase();
			String sqlString = "SELECT files.file_id, files.title, files.description, files.content, files.file_"
					+ "size, file_types.extension, file_types.icon, (SELECT COUNT(periodicals.peri_id) "
					+ "FROM periodicals WHERE type_lov_id='file' AND resource_sip=files.file_id) AS is_" + "peri FROM files, file_types WHERE pagi_id=" + p_item_id + " "
					+ "AND files.filt_id=file_types.filt_id " + "ORDER BY files.title ASC";
			ResultSet rset = db.runSQL(sqlString, stmt);
			String out_text = "";
			while (rset.next()) {
				if (rset.getString("is_peri").equals("0")) {
					if (rset.getString("extension").equals("xml")) {
						out_text = out_text + "<br><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td valig" + "n='top' width='70'>";
						out_text = out_text
								+ ("<a name='" + rset.getString("title") + "' class='altbluenet' id='altbluenet' href=\"Javascript:viewXML('" + rset.getString("content") + "')\">");
						out_text = out_text
								+ ("<img alt='" + rset.getString("content") + " (" + rset.getString("file_size") + " bytes) " + rset.getString("extension") + "' border='0' src='"
										+ IMAGE_DIRECTORY + "icons/" + rset.getString("icon") + "'>");
						out_text = out_text + "</a></td><td valign='top' class='smallbody' width='225'>";
						out_text = out_text
								+ ("<a name='" + rset.getString("title") + "' class='altbluenet' id='altbluenet' href=\"Javascript:viewXML('" + rset.getString("content") + "')\">");
						out_text = out_text
								+ (rset.getString("title") + "</a><br>" + rset.getString("description") + " ("
										+ Long.toString(Long.parseLong(rset.getString("file_size")) / (long) 1024) + " kb)<br>");
						out_text = out_text + "</td><td>&nbsp;</td></tr></table>";
					} else {
						out_text = out_text + "<br><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td valig" + "n='top' width='70'>";
						out_text = out_text
								+ ("<a name='" + rset.getString("title") + "' class='altbluenet' id='altbluenet' target='_blank' href='" + FILE_LOCATION + "/"
										+ rset.getString("content") + "'>");
						out_text = out_text
								+ ("<img alt='" + rset.getString("content") + " (" + rset.getString("file_size") + " bytes) " + rset.getString("extension") + "' border='0' src='"
										+ IMAGE_DIRECTORY + "icons/" + rset.getString("icon") + "'>");
						out_text = out_text + "</a></td><td valign='top' class='smallbody' width='225'>";
						out_text = out_text
								+ ("<a name='" + rset.getString("title") + "' class='altbluenet' id='altbluenet' target='_blank' href='" + FILE_LOCATION + "/"
										+ rset.getString("content") + "'>");
						out_text = out_text
								+ (rset.getString("title") + "</a><br>" + rset.getString("description") + " ("
										+ Long.toString(Long.parseLong(rset.getString("file_size")) / (long) 1024) + " kb)<br>");
						out_text = out_text + "</td><td>&nbsp;</td></tr></table>";
					}
				} else if (rset.getString("extension").equals("xml")) {
					out_text = out_text + "<br><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td valig" + "n='top' width='70'>";
					out_text = out_text
							+ ("<a name='" + rset.getString("title") + "' class='altbluenet' id='altbluenet' href=\"Javascript:viewXML('" + rset.getString("content") + "')\">");
					out_text = out_text
							+ ("<img alt='" + rset.getString("content") + " (" + rset.getString("file_size") + " bytes) " + rset.getString("extension") + "' border='0' src='"
									+ IMAGE_DIRECTORY + "icons/" + rset.getString("icon") + "'>");
					out_text = out_text + "</a></td><td valign='top' class='smallbody' width='225'>";
					out_text = out_text
							+ ("<a name='" + rset.getString("title") + "' class='altbluenet' id='altbluenet' href=\"Javascript:viewXML('" + rset.getString("content") + "')\">");
					out_text = out_text
							+ (rset.getString("title") + "</a><br>" + rset.getString("description") + " ("
									+ Long.toString(Long.parseLong(rset.getString("file_size")) / (long) 1024) + " kb)<br>");
					out_text = out_text
							+ ("</td><td><a href='" + ROOT_DIRECTORY + URL_SUBSCRIBE + "?id=" + rset.getString("file_id")
									+ "&type=file'><img border='0' alt='Register your interest in \"" + rset.getString("title") + "\"' src='" + IMAGE_DIRECTORY + "icons/attention.gif'></a>&nbsp;&nbsp;</td></tr></table>");
				} else {
					out_text = out_text + "<br><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td valig" + "n='top' width='70'>";
					out_text = out_text
							+ ("<a name='" + rset.getString("title") + "' class='altbluenet' id='altbluenet' target='_blank' href='" + FILE_LOCATION + "/"
									+ rset.getString("content") + "'>");
					out_text = out_text
							+ ("<img alt='" + rset.getString("content") + " (" + rset.getString("file_size") + " bytes) " + rset.getString("extension") + "' border='0' src='"
									+ IMAGE_DIRECTORY + "icons/" + rset.getString("icon") + "'>");
					out_text = out_text + "</a></td><td valign='top' class='smallbody' width='225'>";
					out_text = out_text
							+ ("<a name='" + rset.getString("title") + "' class='altbluenet' id='altbluenet' target='_blank' href='" + FILE_LOCATION + "/"
									+ rset.getString("content") + "'>");
					out_text = out_text
							+ (rset.getString("title") + "</a><br>" + rset.getString("description") + " ("
									+ Long.toString(Long.parseLong(rset.getString("file_size")) / (long) 1024) + " kb)<br>");
					out_text = out_text
							+ ("</td><td><a href='" + ROOT_DIRECTORY + URL_SUBSCRIBE + "?id=" + rset.getString("file_id")
									+ "&type=file'><img border='0' alt='Register your interest in \"" + rset.getString("title") + "\"' src='" + IMAGE_DIRECTORY + "icons/attention.gif'></a>&nbsp;&nbsp;</td></tr></table>");
				}
			}
			rset.close();
			if (!out_text.equals("")) {
				p_out.println(preAuxItemStruct());
				p_out.println("<span class='subhead'>Files</span><br>" + out_text);
				p_out.println(postAuxItemStruct());
				m_link_type_count++;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object or database obj" + "ect : writeItemFiles()");
		}
		db.closeDatabase();
	}

	public String preAuxItemStruct() {
		String out_text;
		if (m_link_type_count % 2 == 0) {
			out_text = "<tr><td class='smallbody' width='50%' valign='top'>";
		} else {
			out_text = "<td class='smallbody' width='50%' valign='top'>";
		}
		return out_text;
	}

	public String postAuxItemStruct() {
		String out_text;
		if (m_link_type_count % 2 == 0) {
			out_text = "</td>";
		} else {
			out_text = "</td></tr><tr><td>&nbsp;</td><td>&nbsp;<br>&nbsp;<br></td></tr>";
		}
		return out_text;
	}

	public void writePageContentFooter(JspWriter p_out) {
		try {
			p_out.println("</td>");
			p_out.println("<td width='46%'>&nbsp;</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
			p_out.println("</td></tr></table>");
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%'><tr><td width='10" + "0%'><img border='0' src='" + IMAGE_DIRECTORY
					+ "inside/int_darkblue_spacer.gif' width='100%' height='1'></td>" + "</tr>" + "</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object : writePageCont" + "entFooter()");
		}
	}

	public void writeBlueSeperator(JspWriter p_out) {
		try {
			p_out.println("<table border='0' width='748' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='100%' class='spacertext6'>&nbsp;</td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
			p_out.println("<table border='0' width='748' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='155' bgcolor='#FFFFFF'><img border='0' src='" + IMAGE_DIRECTORY + "spacer.gif' width='1' height='1'></td>");
			p_out.println("    <td width='593' bgcolor='#D9DFF0'><img border='0' src='" + IMAGE_DIRECTORY + "spacer.gif' width='1' height='1'></td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
			p_out.println("<table border='0' width='748' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='100%' class='spacertext6'>&nbsp;</td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception - PageTemplate.writeBlueSeperator()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void writeParagraph(JspWriter p_out, String p_txt) {
		try {
			p_out.println("<table border='0' width='100%' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF'" + ">");
			p_out.println("  <tr>");
			p_out.println("    <td width='5%' class='spacertext6'>&nbsp;</td>");
			p_out.println("    <td width='95%' class='spacertext6'>");
			p_out.println("      <p class='body'>" + p_txt + "</p>");
			p_out.println("    </td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception - PageTemplate.writeParagraph()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public String ReplaceStrWithStr(String p_text, String p_new_text, String p_old_text) {
		int j = 0;
		String ret = p_text;
		for (; (j = ret.indexOf(p_old_text, j)) >= 0; j += p_new_text.length()) {
			ret = ret.substring(0, j) + p_new_text + ret.substring(j + p_old_text.length());
		}

		return ret;
	}

	public void writeSideMenu(JspWriter p_out, String p_page_id, String p_lvlOnePageId, String p_lvlTwoPageId, String p_lvlThreePageId) {
		try {
			PageTemplate _tmp = this;
			Statement stmt1 = Database.m_conn.createStatement();
			PageTemplate _tmp1 = this;
			Statement stmt2 = Database.m_conn.createStatement();
			String sqlString1 = "SELECT * FROM pages where page_level=2 and (is_approved is null or is_approved='" + "t') and parent_id=" + p_lvlOnePageId
					+ " order by title, page_id asc";
			db.connectDatabase();
			ResultSet rset2ndLevel = db.runSQL(sqlString1, stmt1);
			p_out.println("<table border='0' width='100%' cellspacing='0' cellpadding='0'>");
			int divCounter = 1;
			for (; rset2ndLevel.next(); p_out.println("</td></tr><tr><td><img src='" + IMAGE_DIRECTORY + "spacer.gif' height='10' width='1'></td></tr>")) {
				String sqlString2 = "SELECT * FROM pages where page_level=3 and (is_approved is null or is_approved='" + "t') and parent_id=" + rset2ndLevel.getString("page_id")
						+ " order by title, page_id asc";
				ResultSet rset3rdLevel = db.runSQL(sqlString2, stmt2);
				boolean more3rdLevelRecs = rset3rdLevel.next();
				boolean selectedDiv = false;
				p_out.println("<tr><td valign='top' width='15'>");
				if (p_lvlTwoPageId.equals(rset2ndLevel.getString("page_id"))) {
					p_out.println("&nbsp;<a class='sidemenu' name='anc" + divCounter + "' id='anc" + divCounter + "' href='Javascript:if (!NS4){toogleSideMenu (div" + divCounter
							+ ", anc" + divCounter + ")}'>-</a>");
					selectedDiv = true;
				} else {
					p_out.println("&nbsp;<a class='sidemenu' name='anc" + divCounter + "' id='anc" + divCounter + "' href='Javascript:if (!NS4){toogleSideMenu (div" + divCounter
							+ ", anc" + divCounter + ")}'>+</a>");
				}
				p_out.println("</td><td>");
				if (p_page_id.equals(rset2ndLevel.getString("page_id"))) {
					p_out.println("<a class='sidemenuselected' href='" + ROOT_DIRECTORY + rset2ndLevel.getString("url") + "'>" + rset2ndLevel.getString("title") + "</a>");
				} else {
					p_out.println("<a class='sidemenu' href='" + ROOT_DIRECTORY + rset2ndLevel.getString("url") + "'>" + rset2ndLevel.getString("title") + "</a>");
				}
				if (selectedDiv) {
					p_out.println("<div id='div" + divCounter + "' name='div" + divCounter + "' STYLE='position:relative;'>");
				} else {
					p_out.println("<div id='div" + divCounter + "' name='div" + divCounter + "' STYLE='position:relative; display:none'><NOLAYER>");
				}
				p_out.println("<table border='0' width='100%' cellspacing='0' cellpadding='0'>");
				for (; more3rdLevelRecs && rset3rdLevel.getString("parent_id").equals(rset2ndLevel.getString("page_id")); more3rdLevelRecs = rset3rdLevel.next()) {
					if (p_lvlThreePageId.equals(rset3rdLevel.getString("page_id"))) {
						p_out.println("<tr><td width='15'>&nbsp;</td><td><a class='sidemenuselectedsmall' href='" + ROOT_DIRECTORY + rset3rdLevel.getString("url") + "'>"
								+ rset3rdLevel.getString("title") + "</a></td></tr>");
					} else {
						p_out.println("<tr><td width='15'>&nbsp;</td><td><a class='sidemenusmall' href='" + ROOT_DIRECTORY + rset3rdLevel.getString("url") + "'>"
								+ rset3rdLevel.getString("title") + "</a></td></tr>");
					}
				}

				rset3rdLevel.close();
				p_out.println("</table>");
				if (!selectedDiv) {
					p_out.println("</NOLAYER>");
				}
				p_out.println("</div>");
				divCounter++;
			}

			p_out.println("</table>");
			rset2ndLevel.close();
			stmt2.close();
			sqlString1 = "SELECT peri_id FROM periodicals WHERE resource_sip=" + p_page_id + " AND type_lov_id='page'";
			ResultSet rset = db.runSQL(sqlString1, stmt1);
			if (rset.next()) {
				p_out.println("<table border='0' width='100%' cellspacing='0' cellpadding='0'>");
				for (int i = 0; i < 2; i++) {
					p_out.println("<tr>");
					p_out.println("<td class='bluenet' width='100%'>&nbsp;</a></td>");
					p_out.println("</tr>");
				}

				p_out.println("<tr>");
				p_out.println("<td class='smallbody' width='100%'>&nbsp;&nbsp;To register your<br>&nbsp;&nbsp;i"
						+ "nterest in this <br>&nbsp;&nbsp;page, <a class='altbluenet' class='altbluenet' h" + "ref='" + ROOT_DIRECTORY + URL_SUBSCRIBE + "?id=" + p_page_id
						+ "&type=page'>click here ></a></td>");
				p_out.println("</tr></table>");
			}
			rset.close();
			stmt1.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception - PageTemplate.writeParagraph()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void writePageMetadata(JspWriter p_out, String p_page_id) {
		try {
			PageTemplate _tmp = this;
			Statement stmt = Database.m_conn.createStatement();
			String sqlString = "select item_metadatas.standard_id, item_metadatas.content, element.name from ite"
					+ "m_metadatas, resources, element where resources.resource_type='page' and resourc" + "es.object_id=" + p_page_id + " "
					+ "and resources.reso_id=item_metadatas.reso_id " + "and item_metadatas.element_id=element.element_id";
			ResultSet rset;
			for (rset = db.runSQL(sqlString, stmt); rset.next(); p_out.println("<meta http-equiv=\"" + rset.getString("standard_id") + "." + rset.getString("name")
					+ "\" content=\"" + rset.getString("content") + "\">")) {
			}
			rset.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("We have an exception - writePageMetadata.writeParagraph()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void writeTopPic(JspWriter p_out) {
		try {
			p_out.println("<script language='JavaScript'>");
			p_out.println("<!--");
			p_out.println("NS4 = (document.layers) ? 1:0;");
			p_out.println("MAC = (navigator.platform.indexOf('Mac') != -1) ? 1:0;");
			p_out.println("function toogleSideMenu(p_div, p_anc) {");
			p_out.println("  if (p_div.style.display == '') {");
			p_out.println("    p_div.style.display='none';");
			p_out.println("    p_anc.innerHTML = '+';");
			p_out.println("  }");
			p_out.println("  else {");
			p_out.println("    p_div.style.display='';");
			p_out.println("    p_anc.innerHTML = '-'; }");
			p_out.println("}");
			p_out.println("// -->");
			p_out.println("</script>");
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='200'><img src='" + IMAGE_DIRECTORY + "logo.gif' alt='Logo' border='0' WIDTH='200' HEIGHT='124'></td>");
			p_out.println("    <td width='574'><img src='" + IMAGE_DIRECTORY + "top_banner.jpg' alt='Top Banner' border='0' WIDTH='574' HEIGHT='124'></td>  ");
			p_out.println("    <td width='100%' bgcolor='#7591AC'></td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='100%' bgcolor='#FFFFFF'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='Spacer' border='0' WIDTH='100%' HEIGHT='1'></td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred in writeTopPic().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}

	public void writeTopNav(JspWriter p_out) {
		try {
			PageTemplate _tmp = this;
			Statement stmt = Database.m_conn.createStatement();
			String sqlString = "select count(*) as counter from sections";
			ResultSet rset2 = db.runSQL(sqlString, stmt);
			rset2.next();
			int sectionCounter = rset2.getInt("counter") - 1;
			rset2.close();
			sqlString = "select url, pages.title as title, sections.title as section_title from pages, se"
					+ "ctions where page_level=1 and is_function='f' and (is_approved='t' or is_approve"
					+ "d is null) and pages.sect_id=sections.sect_id order by pages.sect_id asc";
			ResultSet rset = db.runSQL(sqlString, stmt);
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%' bgcolor='#526F8A'" + ">");
			p_out.println("  <tr>");
			p_out.println("    <td width='220'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='Spacer' border='0' WIDTH='220' HEIGHT='30'></td>");
			p_out.println("    <td width='544' align='left'>");
			p_out.println("    <table border='0' cellpadding='0' cellspacing='0' width='544'>");
			p_out.println("    \t<tr valign='bottom' align='left'>");
			p_out.println("    \t\t<td width='544' align='left'>");
			for (; rset.next() && sectionCounter > 0; p_out.println("<a class='nav' href='" + ROOT_DIRECTORY + rset.getString("url") + "'> " + rset.getString("section_title")
					+ "</a>&nbsp;&nbsp;")) {
				sectionCounter--;
			}

			rset.close();
			stmt.close();
			p_out.println("        </td>");
			p_out.println("      </tr>");
			p_out.println("    </table>");
			p_out.println("    </td>");
			p_out.println("    <td width='99%'></td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='100%' bgcolor='#FFFFFF'><img src='" + IMAGE_DIRECTORY + "site/spacer.gif' alt='Spacer' border='0' WIDTH='100%' HEIGHT='1'></td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred in writeTopNav().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}

	public void writePageContent(JspWriter p_out, String p_page_id, String p_pageIds[], String p_pageTitles[], String p_pageURL[]) {
		try {
			PageTemplate _tmp = this;
			Statement stmt = Database.m_conn.createStatement();
			p_out.println("<form action='" + ROOT_DIRECTORY + "/forms/form_process.jsp' method='post'>");
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
			p_out.println("<tr>");
			p_out.println("  <td width='10' valign='top' bgcolor='#FFFFFF'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='10' height='20'>");
			p_out.println("  <td width='190' valign='top' bgcolor='#FFFFFF'>");
			p_out.println("  <table border='0' cellpadding='0' cellspacing='0' width='190' bgcolor='#FFFFFF" + "'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='190' bgcolor='#FFFFFF'>");
			writeSideMenu(p_out, p_page_id, p_pageIds[0], p_pageIds[1], p_pageIds[2]);
			p_out.println("    </td>");
			p_out.println("  </tr>");
			p_out.println("  <tr>");
			p_out.println("    <td width='190' bgcolor='#C2D6E9'><img border='0' src='" + IMAGE_DIRECTORY
					+ "spacer.gif' alt='navigation design element' WIDTH='190' HEIGHT='1'></td>");
			p_out.println("  </tr>");
			p_out.println("  <tr>");
			p_out.println("    <td>");
			p_out.println("    </td>");
			p_out.println("  </tr>");
			p_out.println("  </table>");
			p_out.println("  <table border='0' cellpadding='0' cellspacing='0' width='190' bgcolor='#FFFFFF" + "'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='190' bgcolor='#FFFFFF'><img border='0' src='" + IMAGE_DIRECTORY + "spacer.gif' WIDTH='190' HEIGHT='1'></td>");
			p_out.println("  </tr>");
			p_out.println("  </table>");
			p_out.println("  </td>");
			p_out.println("  <td width='20' bgcolor='#FFFFFF'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='20' height='5'></td>");
			p_out.println("  <td width='99%' valign='top' bgcolor='#FFFFFF'>");
			writePageLocation(p_out, p_pageTitles, p_pageURL);
			p_out.println("  <table border='0' cellpadding='0' cellspacing='0' width='100%' bgcolor='#FFFFF" + "F'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='99%' valign='top'><a class='body'>");
			if (!p_page_id.equals("0")) {
				String sqlString = "select * from page_items where page_id=" + p_page_id + " order by title asc";
				ResultSet rset;
				for (rset = db.runSQL(sqlString, stmt); rset.next(); p_out.println("<p class='smallbody'>&nbsp;</p>")) {
					p_out.println("<table border='0' width='500' cellspacing='0'>");
					p_out.println("<tr>");
					p_out.println("<td>");
					Clob cl = rset.getClob("text");
					String itemText;
					if (cl != null) {
						itemText = cl.getSubString(1L, (int) cl.length());
					} else {
						itemText = "";
					}
					writeItemTextAndImage(p_out, "", "", "", itemText);
					p_out.println("</td>");
					p_out.println("</tr>");
					p_out.println("</table>");
					m_link_type_count = 0;
					p_out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
					String pageId = rset.getString("pagi_id");
					writeItemFiles(p_out, pageId);
					writeItemURLLinks(p_out, pageId);
					writeItemRelatedLinks(p_out, pageId);
					writeItemEmailLinks(p_out, pageId);
					p_out.println("</table><br>");
					p_out.println("<table border='0' width='100%' cellspacing='0' cellpadding='0'>");
					p_out.println("<tr>");
					p_out.println("<td width='100%' bgcolor='#D9DFF0'></td>");
					p_out.println("</tr>");
					p_out.println("</table>");
				}

				rset.close();
				stmt.close();
				p_out.println("</form>");
			} else {
				p_out.println("<table border='0' width='500' cellspacing='0'>");
				p_out.println("<tr>");
				p_out.println("<td>This page has been deleted, please delete this link.");
				p_out.println("</td>");
				p_out.println("</tr>");
				p_out.println("</table>");
			}
			p_out.println("    </a>");
			p_out.println("    </td>");
			p_out.println("    <td width='150' valign='top'>");
			p_out.println("    </td>");
			p_out.println("  </tr>");
			p_out.println("  </table>");
			p_out.println("  </td>");
			p_out.println("  <td width='200' valign='top' bgcolor='#C2D6E9'>");
			p_out.println("    <img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='200' height='20'>");
			p_out.println("    <img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='200' height='20'>\t\t");
			p_out.println("  </td>");
			p_out.println("</tr>");
			p_out.println("</table>");
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
			p_out.println("<tr>");
			p_out.println("  <td width='220' valign='middle'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='220' height='10'></td>");
			p_out.println("  <td width='99%' valign='middle'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='99%' height='10'></td>");
			p_out.println("  <td width='200' valign='middle'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='200' height='10'></td>");
			p_out.println("</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object or database obj" + "ect : writePageContent()");
		}
		db.closeDatabase();
	}

	public void writeFooter(JspWriter p_out) {
		try {
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
			p_out.println("  <tr>");
			p_out.println("  <td width='220' valign='middle'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='220' height='10'></td>");
			p_out.println("  <td width='99%' valign='middle'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='99%' height='10'></td>");
			p_out.println("  <td width='200' valign='middle'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='200' height='10'></td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
			p_out.println("  <tr>");
			p_out.println("  <td width='220' valign='middle'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='220' height='25'></td>");
			p_out.println("  <td width='99%' valign='middle'><a class='body'><a href='/public/content/show_"
					+ "search.asp?xcid=6'>search</a>&nbsp;&nbsp;<a href='/public/content/show_input.asp"
					+ "?xcid=7'>feedback</a>&nbsp;&nbsp;<a href='/public/content/show_content.asp?xcid="
					+ "8'>copyright</a>&nbsp;&nbsp;<a href='/public/content/show_content.asp?xcid=9'>di"
					+ "sclaimer</a>&nbsp;&nbsp;<a href='/public/content/show_input.asp?xcid=10'>subscri" + "be</a></td>");
			p_out.println("  <td width='200' valign='middle'><img src='" + IMAGE_DIRECTORY + "spacer.gif' alt='spacer' width='200' height='25'></td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred in writeTopNav().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}
}
