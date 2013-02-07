package admin;

import java.io.PrintStream;
import java.util.Vector;
import javax.servlet.jsp.JspWriter;

// Referenced classes of package admin:
//            AppConstants, Database

public class FormatPage {

	private Database m_db;
	private AppConstants Constants;
	public String m_fullUserName;
	public String m_firstUserName;
	public String m_sessionTimeout;

	public FormatPage(Database p_db) {
		Constants = new AppConstants();
		m_fullUserName = "";
		m_firstUserName = "";
		m_sessionTimeout = "";
		m_db = p_db;
	}

	public void writeHeader(JspWriter p_out) {

	}

	public void writePageTableHeader(JspWriter p_out, String p_tableTitle) {
		writePageTableHeader(p_out, p_tableTitle, "");
	}

	public void writePageTableHeader(JspWriter p_out, String p_tableTitle, String p_addition_html) {
		try {
			p_out.println("<table border='0' style='border-collapse: collapse' bordercolor='#111111' width=" + "'778' cellspacing='0' cellpadding='0'>");
			p_out.println("  <tr>");

		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writePageTableFooter(JspWriter p_out) {
		try {
			p_out.println("    </td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeTwoColTableHeader(JspWriter p_out, String p_text) {
		try {
			p_out.println("<table border='0' width='500' cellspacing='0' cellpadding='0'>");
			p_out.println("<tr>");
			p_out.println("  <td valign='top' align='left' width='90'><img src='/custom/images/spacer.gif' w" + "idth='90' height='1' border='0'></td>");
			p_out.println("  <td valign='top' align='left' width='125' class='heading'><img src='/custom/ima" + "ges/spacer.gif' width='125' height='1' border='0'></td>");
			p_out.println("  <td valign='top' align='left' width='285' class='bodytext'><img src='/custom/im" + "ages/spacer.gif' width='285' height='1' border='0'></td>");
			p_out.println("</tr>");
			p_out.println("<tr>");
			p_out.println("  <td valign='top' align='left' width='90'><img src='/custom/images/spacer.gif' w" + "idth='90' height='1' border='0'></td>");
			p_out.println("  <td valign='top' align='left' width='125' class='bodytext'>" + p_text + "</td>");
			p_out.println("  <td valign='top' align='left' width='285' class='bodytext'>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeTwoColTableFooter(JspWriter p_out) {
		try {
			p_out.println("</td>");
			p_out.println("</tr>");
			p_out.println("<tr>");
			p_out.println("  <td valign='top' align='left' colspan='3' width='500'><img src='/custom/images/" + "spacer.gif' width='500' height='10' border='0'></td>");
			p_out.println("</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeHTMLHeader(JspWriter p_out) {
		try {
			p_out.println("<table border='0' width='480' cellspacing='0' cellpadding='0'>");
			p_out.println("<tr>");
			p_out.println("  <td valign='top' align='left' width='83'><img src='/custom/images/spacer.gif' w" + "idth='83' height='1' border='0'></td>");
			p_out.println("  <td valign='top' align='left' width='397' class='heading'>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeHTMLFooter(JspWriter p_out) {
		try {
			p_out.println("</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeFooter(JspWriter p_out) {

	}

	public void writeSmallWindowHeader(JspWriter p_out, String p_tableTitle) {
		try {
			p_out.println("<html><head><link rel='stylesheet' type='text/css' href='/admin/admin.css'><titl" + "e></title></head>");
			p_out.println("<body marginwidth='0' marginheight='0' leftmargin='0' topmargin='0'>");
			p_out.println("<table border='0' style='border-collapse: collapse' bordercolor='#111111' width=" + "'100%' cellspacing='0' cellpadding='0' height='50'>");
			p_out.println("<tr>");
			p_out.println("  <td bgcolor='#EDEDED' width='25' align='left'>");
			p_out.println("    <img border='0' src='/custom/images/spacer.gif' width='25' height='25'></td>");
			p_out.println("  <td bgcolor='#EDEDED' width='100%' align='left'>");
			p_out.println("    <font face='Arial' style='font-size: 16pt' color='#949494'>" + p_tableTitle + "</font></td>");
			p_out.println("  <td bgcolor='#EDEDED' width='25' align='left'>");
			p_out.println("    <img border='0' src='/custom/images/spacer.gif' width='25' height='25'></td>");
			p_out.println("</tr>");
			p_out.println("</table>");
			p_out.println("<table border='0' width='530' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF'>");
			p_out.println("<tr>");
			p_out.println("<td width='15' align='left' valign='top'><img border='0' src='/custom/images/spac" + "er.gif' width=15 height=1></td>");
			p_out.println("<td bgcolor='#FFFFFF' class='bodyhead'></td>");
			p_out.println("<td class='bodytext' width=15><img border='0' src='/custom/images/spacer.gif' WID" + "TH='15' HEIGHT='1'></td>");
			p_out.println("</tr>");
			p_out.println("<tr>");
			p_out.println("<tr>");
			p_out.println("<td class='bodytext' width=15><img border='0' src='/custom/images/spacer.gif' WID" + "TH='15' HEIGHT='1'></td>");
			p_out.println("<td class='bodytext' width=500>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeSmallWindowHeader(JspWriter p_out, String p_tableTitle, String p_bodyProperty, String p_title) {
		try {
			p_out.println("<html><head><link rel='stylesheet' type='text/css' href='/admin/admin.css'><titl" + "e>" + p_title + "</title></head>");
			p_out.println("<body marginwidth='0' marginheight='0' leftmargin='0' topmargin='0' " + p_bodyProperty + ">");
			p_out.println("<table border='0' width='100%' cellspacing='0' cellpadding='0' bgcolor='#E3E3E3'" + ">");
			p_out.println("<tr>");
			p_out.println("<td width='30' align='left' valign='top'><img border='0' src='/custom/images/cm_b" + "ox.gif'></td>");
			p_out.println("<td width='100%' align='right' valign='middle'><img border='0' src='/custom/image" + "s/spacer.gif' height='1' width='100%'></td>");
			p_out.println("<td width='30' align='left' valign='middle'><img border='0' src='/custom/images/c" + "m_title.gif'></td>");
			p_out.println("</tr>");
			p_out.println("</table>");
			p_out.println("<table border='0' width='530' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF'>");
			p_out.println("<tr>");
			p_out.println("<td width='15' align='left' valign='top'><img border='0' src='/custom/images/spac" + "er.gif' width=15 height=1></td>");
			p_out.println("<td bgcolor='#FFFFFF' class='bodyhead'>");
			p_out.println("<br>" + p_tableTitle + "</td>");
			p_out.println("<td class='bodytext' width=15><img border='0' src='/custom/images/spacer.gif' WID" + "TH='15' HEIGHT='1'></td>");
			p_out.println("</tr>");
			p_out.println("<tr>");
			p_out.println("<td class='bodytext' width=15><img border='0' src='/custom/images/spacer.gif' WID" + "TH='15' HEIGHT='1'></td>");
			p_out.println("<td class='bodytext' width=500>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeSmallWindowButtons(JspWriter p_out, String p_btn1_img, String p_btn1_js, String p_btn2_img, String p_btn2_js) {
		try {
			if (p_btn1_js.equals("") || p_btn1_js.equals("BACK")) {
				p_btn1_js = "history.back();";
			}
			p_out.println("<table border='0' width='500' cellspacing='0' cellpadding='0'>");
			p_out.println("<tr>");
			p_out.println("<td align='left' valign='middle' width='250'><img border='0' src='/custom/images/" + "spacer.gif' width='250' height='1'></td>");
			p_out.println("<td align='right' valign='middle' width='250'><img border='0' src='/custom/images" + "/spacer.gif' width='250' height='1'></td>");
			p_out.println("</tr>");
			p_out.println("<tr>");
			p_out.println("<td align='left' valign='middle' width='250'>");
			if (!p_btn1_img.equals("")) {
				p_out.println("<a href='JavaScript:" + p_btn1_js + "'><img border='0' src='" + "/custom/images" + "/" + p_btn1_img + "'></a>");
			}
			p_out.println("</td>");
			p_out.println("<td align='right' valign='middle' width='250'>");
			if (!p_btn2_img.equals("")) {
				if (p_btn2_js.equals("") || p_btn2_js.equals("SUBMIT")) {
					p_out.println("<input type=\"image\" border=\"0\" src=\"/custom/images/" + p_btn2_img + "\" style='cursor:hand' onclick=\"forms[0].submit();\">");
				} else {
					p_out.println("<a style='cursor:hand' onclick='" + p_btn2_js + "'><img border=\"0\" src=\"" + "/custom/images" + "/" + p_btn2_img + "\"></a>");
				}
			}
			p_out.println("</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeSmallWindowPageFooter(JspWriter p_out) {
		try {
			p_out.println("</td>");
			p_out.println("<td class='bodytext' width=15><img border='0' src='/custom/images/spacer.gif' WID" + "TH='15' HEIGHT='1'></td>");
			p_out.println("</tr></table></body></html>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeHelper(JspWriter p_out, String p_text, String p_helper_image) {
		try {
			p_out.println("<table border='0' width='500' cellspacing='0' cellpadding='0'>");
			p_out.println("\t<tr>");
			p_out.println("\t\t<td width='70'><img border='0' src='/custom/images/" + p_helper_image + "' WIDTH='70' HEIGHT='31'></td>");
			p_out.println("\t\t<td width='17' bgcolor='#FFFFFF'><img border='0' src='/custom/images/helper_t" + "ab.gif' width='16' height='31'></td>");
			p_out.print("\t\t<td width='5' class='bodyhead' bgcolor='#FFFFFF'>");
			writeImageSpacer(p_out, "3", "1");
			p_out.println("\t\t</td>");
			p_out.println("\t\t<td width='358' class='bodyhead' bgcolor='#FFFFFF'>" + p_text + "</td>");
			p_out.println("\t\t<td width='50' bgcolor='#FFFFFF'>&nbsp;</td>");
			p_out.println("\t</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeImageSpacer(JspWriter p_out, String p_width, String p_height) {
		try {
			p_out.println("<img src='/custom/images/spacer.gif' width='" + p_width + "' height='" + p_height + "'>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeButtons(JspWriter p_out, String p_url_btn1, String p_img_btn1, String p_url_btn2, String p_img_btn2, String p_url_btn3, String p_img_btn3,
			String p_validateFunction_btn3) {
		try {
			if (p_url_btn1.toUpperCase().equals("BACK")) {
				p_url_btn1 = "Javascript:history.back();";
			}
			if (p_url_btn2.toUpperCase().equals("BACK")) {
				p_url_btn2 = "Javascript:history.back();";
			}
			if (p_url_btn3.toUpperCase().equals("BACK")) {
				p_url_btn3 = "Javascript:history.back();";
			}
			if (p_img_btn1.equals("")) {
				p_img_btn1 = "spacer.gif";
			}
			if (p_img_btn2.equals("")) {
				p_img_btn2 = "spacer.gif";
			}
			if (p_img_btn3.equals("")) {
				p_img_btn3 = "spacer.gif";
			}
			p_out.println("<table border='0' style='border-collapse: collapse' bordercolor='#111111' width=" + "'100%' cellspacing='0' cellpadding='0'>");
			p_out.println("  <tr>");
			p_out.println("    <td width='100%'>");
			p_out.println("<table border='0' style='border-collapse: collapse' bordercolor='#111111' width=" + "'550' cellspacing='0' cellpadding='0'>");
			p_out.println("  <tr>");
			p_out.println("    <td align='left' width='10' valign='top' bgcolor='#FFFFFF'></td>");
			if (p_url_btn1.equals("")) {
				p_out.println("<td width='26' bgcolor='#FFFFFF' align='left'><img src='/custom/images/spacer.gif" + "' width='26' height='27' border='0'></td>");
			} else if (p_url_btn1.toUpperCase().equals("SUBMIT")) {
				p_out.println("<td width='26' bgcolor='#FFFFFF'><input type='image' name='go' id='go' src='/custom" + "/images/" + p_img_btn1 + "' border='0'></td>");
			} else {
				p_out.println("<td bgcolor='#FFFFFF'><a href='" + p_url_btn1 + "'><img src='" + "/custom/images" + "/" + p_img_btn1 + "' border='0'></a></td>");
			}
			p_out.println("\t<td width='25' bgcolor='#FFFFFF'><img src='/custom/images/spacer.gif' width='25" + "' height='20' border='0'></td>");
			if (p_url_btn2.equals("")) {
				p_out.println("<td width='26' bgcolor='#FFFFFF'><img src='/custom/images/spacer.gif' width='26' " + "height='27' border='0'></td>");
			} else if (p_url_btn2.toUpperCase().equals("SUBMIT")) {
				p_out.println("<td bgcolor='#FFFFFF'><input type='image' name='go' id='go' src='/custom" + "/images/" + p_img_btn2 + "' border='0'></td>");
			} else {
				p_out.println("<td bgcolor='#FFFFFF'><a href='" + p_url_btn2 + "'><img src='" + "/custom/images" + "/" + p_img_btn2 + "' border='0'></a></td>");
			}
			p_out.println("\t<td bgcolor='#FFFFFF' width='465'><img src='/custom/images/spacer.gif' width='4" + "65' height='27' border='0'></td>");
			if (p_url_btn3.equals("")) {
				p_out.println("<td width='26' bgcolor='#FFFFFF'><img src='/custom/images/spacer.gif' width='26' " + "height='27' border='0'></td>");
			} else if (p_url_btn3.toUpperCase().equals("SUBMIT")) {
				if (p_validateFunction_btn3.equals("")) {
					p_out.println("<td bgcolor='#FFFFFF'><input type='image' name='go' id='go' src='/custom" + "/images/" + p_img_btn3 + "' border='0'></td>");
				} else {
					p_out.println("<td bgcolor='#FFFFFF'><img name='go' id='go' src='/custom/images/" + p_img_btn3 + "' onclick='" + p_validateFunction_btn3
							+ "' style='cursor:hand' border='0'></td>");
				}
			} else {
				p_out.println("<td bgcolor='#FFFFFF'><a href='" + p_url_btn3 + "'><img src='" + "/custom/images" + "/" + p_img_btn3 + "' border='0'></a></td>");
			}
			p_out.println("\t<td bgcolor='#FFFFFF' width='10'><img src='/custom/images/spacer.gif' width='10" + "' height='27' border='0'></td>");
			p_out.println("</tr>");
			p_out.println("</table>");
			p_out.println("</td></tr></table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeButtons(JspWriter p_out, String p_url_btn1, String p_img_btn1, String p_url_btn2, String p_img_btn2, String p_url_btn3, String p_img_btn3) {
		try {
			writeButtons(p_out, p_url_btn1, p_img_btn1, p_url_btn2, p_img_btn2, p_url_btn3, p_img_btn3, "");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeButtons(JspWriter p_out, String p_url_btn1, String p_img_btn1) {
		try {
			writeButtons(p_out, p_url_btn1, p_img_btn1, "", "", "", "", "");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeButtons(JspWriter p_out, String p_url_btn1, String p_img_btn1, String p_url_btn2, String p_img_btn2) {
		try {
			writeButtons(p_out, p_url_btn1, p_img_btn1, p_url_btn2, p_img_btn2, "", "", "");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeText(JspWriter p_out, String p_text) {
		try {
			p_out.println("<table class='message' border='0' width='500' cellspacing='0' cellpadding='0'>");
			p_out.println("<tr>");
			p_out.println("  <td valign='top' align='left' width='90'><img src='/custom/images/spacer.gif' w" + "idth='90' height='1' border='0'></td>");
			p_out.println("  <td valign='top' align='left' width='410' class='bodytext'>" + p_text + "</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeOneButtonMenuLink(JspWriter p_out, String p_text, String p_url, String p_image) {
		try {
			String xurl = "";
			if (p_url.toUpperCase().equals("SUBMIT")) {
				xurl = "<input type='image' src='/custom/images/" + p_image + "' border='0'>";
			} else if (p_url.toUpperCase().equals("BACK")) {
				xurl = "<a href=\"Javascript:history.back();\"><img src='/custom/images/" + p_image + "' border='0'></a>";
			} else {
				String p_type = "";
				String p_tmp = "";
				p_tmp = p_url.toLowerCase();
				if (p_tmp.startsWith("javascript:")) {
					p_type = "style='cursor:hand' onclick";
				} else {
					p_type = "href";
				}
				xurl = "<a " + p_type + "=\"" + p_url + "\"><img src='" + "/custom/images" + "/" + p_image + "' border='0'></a>";
			}
			p_out.println("<table border='0' cellspacing='0' cellpadding='0' width='500'>");
			p_out.println("<tr>");
			p_out.println("<td valign='top' align='left' width='90'><img src='./images/spacer.gif' width='9" + "0' height='17' border='0'></td>");
			p_out.println("<td valign='top' align='left' width='410' class='bodytext'>");
			p_out.println("<table border='0' cellspacing='0' cellpadding='0' width='410'>");
			p_out.println("<tr>");
			p_out.println("  <td width='170' class='bodytext'>" + p_text + "</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			p_out.println("  <td width='55' class='bodytext'>&nbsp;</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			p_out.println("  <td width='55' class='bodytext'>" + xurl + "</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			p_out.println("  <td width='55' class='bodytext'>&nbsp;</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			p_out.println("  <td width='55' class='bodytext'>&nbsp;</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
			p_out.println("</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeListWithButtons(JspWriter p_out, String p_text, String p_url, String p_image) {
		try {
			writeListWithButtons(p_out, p_text, p_url, p_image, "", "");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeListWithButtons(JspWriter p_out, String p_text, String p_url1, String p_image1, String p_url2, String p_image2) {
		try {
			writeListWithButtons(p_out, p_text, p_url1, p_image1, p_url2, p_image2, "", "");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeListWithButtons(JspWriter p_out, String p_text, String p_url1, String p_image1, String p_url2, String p_image2, String p_url3, String p_image3) {
		try {
			writeListWithButtons(p_out, p_text, p_url1, p_image1, p_url2, p_image2, p_url3, p_image3, "", "");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeListWithButtonsHeader(JspWriter p_out, String p_headerText1, String p_headerText2, String p_headerText3, String p_headerText4) {
		try {
			p_out.println("<table border='0' cellspacing='0' cellpadding='0' width='500'>");
			p_out.println("<tr>");
			p_out.println("<td valign='top' align='left' width='90'><img src='./images/spacer.gif' width='9" + "0' height='17' border='0'></td>");
			p_out.println("<td valign='top' align='left' width='410' class='bodytext'>");
			p_out.println("<table border='0' cellspacing='0' cellpadding='0' width='410'>");
			p_out.println("<tr>");
			p_out.println("  <td width='170' class='bodytext'>&nbsp;</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			p_out.println("  <td width='55' class='bodytext'>" + p_headerText1 + "</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			p_out.println("  <td width='55' class='bodytext'>" + p_headerText2 + "</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			p_out.println("  <td width='55' class='bodytext'>" + p_headerText3 + "</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			p_out.println("  <td width='55' class='bodytext'>" + p_headerText4 + "</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
			p_out.println("</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeListWithButtonsFooter(JspWriter jspwriter) {
	}

	public void writeListWithButtons(JspWriter p_out, String p_text, String p_url1, String p_image1, String p_url2, String p_image2, String p_url3, String p_image3, String p_url4,
			String p_image4) {
		try {
			String p_type1 = "";
			String p_type2 = "";
			String p_type3 = "";
			String p_type4 = "";
			String p_tmp1 = "";
			String p_tmp2 = "";
			String p_tmp3 = "";
			String p_tmp4 = "";
			p_tmp1 = p_url1.toLowerCase();
			p_tmp2 = p_url2.toLowerCase();
			p_tmp3 = p_url3.toLowerCase();
			p_tmp4 = p_url4.toLowerCase();
			if (p_tmp1.startsWith("javascript:")) {
				p_type1 = "style='cursor:hand' onclick";
			} else {
				p_type1 = "href";
			}
			if (p_tmp2.startsWith("javascript:")) {
				p_type2 = "style='cursor:hand' onclick";
			} else {
				p_type2 = "href";
			}
			if (p_tmp3.startsWith("javascript:")) {
				p_type3 = "style='cursor:hand' onclick";
			} else {
				p_type3 = "href";
			}
			if (p_tmp4.startsWith("javascript:")) {
				p_type4 = "style='cursor:hand' onclick";
			} else {
				p_type4 = "href";
			}
			p_out.println("<table border='0' cellspacing='0' cellpadding='0' width='500'>");
			p_out.println("<tr>");
			p_out.println("<td valign='top' align='left' width='90'><img src='./images/spacer.gif' width='9" + "0' height='17' border='0'></td>");
			p_out.println("<td valign='top' align='left' width='410' class='bodytext'>");
			p_out.println("<table border='0' cellspacing='0' cellpadding='0' width='410'>");
			p_out.println("<tr>");
			p_out.println("  <td width='170' class='bodytext'>" + p_text + "</td>");
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			if (p_url1.equals("") || p_image1.equals("")) {
				p_out.println("  <td width='55'><img border='0' src='/custom/images/spacer.gif' WIDTH='55' HEIGH" + "T='1'></td>");
			} else {
				p_out.println("  <td width='55'><a " + p_type1 + "=\"" + p_url1 + "\"><img src='" + "/custom/images" + "/" + p_image1 + "' border='0'></a></td>");
			}
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			if (p_url2.equals("") || p_image2.equals("")) {
				p_out.println("  <td width='55'><img border='0' src='/custom/images/spacer.gif' WIDTH='55' HEIGH" + "T='1'></td>");
			} else {
				p_out.println("  <td width='55'><a " + p_type2 + "=\"" + p_url2 + "\"><img src='" + "/custom/images" + "/" + p_image2 + "' border='0'></a></td>");
			}
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			if (p_url3.equals("") || p_image3.equals("")) {
				p_out.println("  <td width='55'><img border='0' src='/custom/images/spacer.gif' WIDTH='55' HEIGH" + "T='1'></td>");
			} else {
				p_out.println("  <td width='55'><a " + p_type3 + "=\"" + p_url3 + "\"><img src='" + "/custom/images" + "/" + p_image3 + "' border='0'></a></td>");
			}
			p_out.println("  <td width='5'><img border='0' src='/custom/images/spacer.gif' WIDTH='5' HEIGHT=" + "'1'></td>");
			if (p_url4.equals("") || p_image4.equals("")) {
				p_out.println("  <td width='55'><img border='0' src='/custom/images/spacer.gif' WIDTH='55' HEIGH" + "T='1'></td>");
			} else {
				p_out.println("  <td width='55'><a " + p_type4 + "=\"" + p_url4 + "\"><img src='" + "/custom/images" + "/" + p_image4 + "' border='0'></a></td>");
			}
			p_out.println("</tr>");
			p_out.println("</table>");
			p_out.println("</td>");
			p_out.println("</tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred when trying to access the JspWriter object");
		}
	}

	public void writeMultiList(JspWriter p_out, String leftBoxName, Vector leftIdArray, Vector leftTextArray, String rightBoxName, Vector rightIdArray, Vector rightTextArray) {
		try {
			String addButtonName = "AddButton" + leftBoxName;
			String removeButtonName = "RemoveButton" + leftBoxName;
			p_out.println("<table border='0' cellpadding='0' cellspacing='0' width='470' class='bodytext'>");
			p_out.println("  <tr>");
			p_out.println("  <td class='bodytext' width='215'>Available<br>");
			p_out.println("    <select multiple size='2' name='" + leftBoxName + "' style='width:215; height:150'>");
			for (int i = 0; i < leftIdArray.size(); i++) {
				p_out.println("      <option VALUE='" + leftIdArray.elementAt(i) + "'>" + leftTextArray.elementAt(i) + "</option>");
			}

			p_out.println("    </select>");
			p_out.println("  </td>");
			p_out.println("  <td width='40' align='center' class='bodytext'>");
			p_out.println("    <a href='Javascript:moveLeftToRight (document.forms[0]." + leftBoxName + ", document.forms[0]." + rightBoxName + ")'>");
			p_out.println("      <img border='0' src='/custom/images/next.gif' alt='add'></a><br>");
			p_out.println("    <a href='Javascript:moveRightToLeft (document.forms[0]." + leftBoxName + ", document.forms[0]." + rightBoxName + ")'>");
			p_out.println("    <img border='0' src='/custom/images/prev.gif' alt='remove'></a>");
			p_out.println("  </td>");
			p_out.println("  <td class='bodytext' width='215'>Currently Selected<br>");
			p_out.println("    <select multiple name='" + rightBoxName + "' style='width:215; height:150'>");
			for (int i = 0; i < rightIdArray.size(); i++) {
				p_out.println("      <option VALUE='" + rightIdArray.elementAt(i) + "'>" + rightTextArray.elementAt(i) + "</option>");
			}

			p_out.println("    </select>");
			p_out.println("  </td>");
			p_out.println("  </tr>");
			p_out.println("</table>");
		} catch (Exception e) {
			System.out.println("An exception occurred in writeMultiList() when trying to access the JspWriter ob" + "ject");
		}
	}

	public Vector subtractArrays(Vector p_allArray, Vector p_subtractArray) {
		try {
			Vector retArray = new Vector();
			for (int i = 0; i <= p_allArray.size() - 1; i++) {
				boolean addToResultsArray = true;
				int j = 0;
				do {
					if (j > p_subtractArray.size() - 1) {
						break;
					}
					if (p_allArray.elementAt(i).equals(p_subtractArray.elementAt(j))) {
						addToResultsArray = false;
						break;
					}
					j++;
				} while (true);
				if (addToResultsArray) {
					retArray.addElement(p_allArray.elementAt(i));
				}
			}

			Vector vector1 = retArray;
			return vector1;
		} catch (Exception e) {
			System.out.println("An exception occurred in subtractArrays()");
		}
		Vector vector = null;
		return vector;
	}
}
