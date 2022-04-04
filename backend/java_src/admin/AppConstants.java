package admin;

import javax.servlet.http.*;

//import oracle.jdbc.OracleDriver;
import admin.IniFile;
// Referenced classes of package admin:
//            FileTools, DatabaseType

public class AppConstants implements DatabaseType {

	public static boolean LOAD_FROM_INI_FILE = true;
	public static final int MAX_NUMBER_SECTIONS = 13;
	public static final int MAX_NUMBER_FUNCTIONS = 6;
	public static final int MAX_NUMBER_UNAPPROVED_PAGES_PER_SECTION = 500;
	public static final String XML_FILE_TYPE_ID = "18";
	public static final String DEFAULT_TEMPLATE = "1";
	public static final String DEFAULT_STYLE = "1";
	public static final boolean ENABLE_METADATA = true;
	public static final boolean ENABLE_FORMS = true;
	public static final String DYNAMIC_MENU_INCLUDE_FILE = "dynamic_menu.js";
	public static final String FUN_LOGIN = "-1";
	public static final String FUN_ADD_OR_MODIFY_PAGE = "0";
	public static final String FUN_ADD_PAGE = "1";
	public static final String FUN_MODIFY_PAGE = "2";
	public static final String FUN_DELETE_PAGE = "3";
	public static final String FUN_SECTIONS = "4";
	public static final String FUN_APPROVAL = "5";
	public static final String FUN_SUBSCRIBERS = "6";
	public static final String FUN_USER_USER = "9";
	public static final String FUN_USER_GROUP = "10";
	public static final String FUN_ADD_FORM = "12";
	public static final String FUN_MODIFY_FORM = "13";
	public static final String FUN_DELETE_FORM = "14";
	public static final String FUN_LAYOUT_TEMPLATE = "19";
	public static final String FUN_REPOS = "20";
	public static final String FUN_STATS = "21";
	public static final String FUN_STYLE = "22";
	public static final String FUN_META_THES = "30";
	public static final String FUN_META_ELEM = "31";
	public static final String CONTEXT_ROOT = "";
	public static final String ADMIN_DIRECTORY = "/admin";
	public static final String IMAGE_DIRECTORY = "/custom/images";
	public static final String REPOS_FILE_UPLOADS = "/custom/files";
	public static final String REPOS_FILE_DIRECTORY = "/custom/files";
	public static final String PUBLIC_STYLE_SHEET_LOCATION = "/public";
	public static final String LAYOUT_TEMP_FILE_PATH = "/custom/temp";
	public static final String LAYOUT_TEMPLATE_FILE_PATH = "/custom/templates";
	public static final String REPORTS_FILE_PATH = "/custom/reports";
	public static final String TEMP_FILE_LOCATION_FOR_SERVER = "/admin/temp";
	public static final String TEMP_FILE_LOCATION_FOR_CLIENT = "/temp";
	public static final String FILE_LOCATION_FOR_SERVER = "/public/uploaded_files";
	public static final String PUBLIC_IMAGE_DIRECTORY = "/images";
	public static final String PUBLIC_CSS_DIRECTORY = "/css";
	public static final String PUBLIC_JS_DIRECTORY = "/js";
	public static final int MAX_NUMBER_ADMINISTRATORS = 0;
	public static final int MAX_NUMBER_AUTHORS = 0;
	public static final int MIN_NUMBER_ADMINISTRATORS = 1;
	public static final int MIN_NUMBER_CHARS_IN_PASSWORD = 6;
	public static final String USER_ADMIN = "1";
	public static final String USER_GROUP = "2";
	public static final String USER_GENERAL = "3";
	public static final String USER_SITE = "4";
	public static final String GROUP_GROUP_ADMINS = "1";
	public static final String ADMINISTRATOR_AUTH_ID = "1";
	public static final String PAGE_GENERAL = "1";
	public static final String PAGE_LAYOUT = "2";
	public static final String PAGE_STYLE = "3";
	public static final String PAGE_METADATA = "4";
	public static final String PAGE_SITEUSERS = "5";
	public static final String PAGE_CONTENT = "6";
	public static final String PAGE_FORM = "7";
	public static final String PAGE_FILE = "8";
	public static final String EMAIL_CANCEL_PERIOD_SUB_PAGE = "/functionPages/subscribe_cancel_confirm.jsp";
	public static final String EMAIL_CANCEL_ALL_SUB_PAGE = "/functionPages/subscribe_unsub_confirm.jsp";
	public static final String GROUP_SUBSCRIPTION_REPORT_FILE_NAME = "group_subscription_report.csv";
	public static final String GROUP_SUBSCRIPTION_REPORTS_FILE_PATH = "/custom/reports/group_subscription_report.csv";
	public static final int ST_BREAD_CRUMBS_LINK = 1;
	public static final int ST_BREAD_CRUMBS_CURRENT = 2;
	public static final int ST_PAGE_TITLE = 3;
	public static final int ST_PAGE_BODY = 4;
	public static final int ST_PAGE_HEADER_LINKS = 5;
	public static final int ST_PAGE_FOOTER_LINKS = 6;
	public static final int ST_FILES_HEADING = 7;
	public static final int ST_FILES_LINK = 8;
	public static final int ST_FAMILY_LINKS_SIBLINGS = 9;
	public static final int ST_FAMILY_LINKS_CHILDREN = 10;
	public static final int ST_FAMILY_LINKS_CURRENT = 11;
	public static final int ST_FORM_FIELD = 12;
	public static final int ST_FORM_BUTTON = 13;
	public static final int ST_FORM_CHECKBOX = 14;
	public static final int ST_FORM_TITLES = 15;
	public static final int ST_FORM_LABELS = 16;
	public static final int ST_COUNT = 16;
	public static String STYLE_TOPBANNER_BACKGROUNDCOLOR = "#7591AC";
	public static String STYLE_NAVIGATION_BACKGROUNDCOLOR = "#526F8A";
	public static String STYLE_NAVIGATION_FONTCOLOR = "#FFFFFF";
	public static String STYLE_NAVIGATION_HOVERCOLOR = "#FFFFFF";
	public static String STYLE_FONTCOLOR = "#526F8A";
	public static String STYLE_LINKCOLOR = "#2D4358";
	public static String STYLE_HOVERCOLOR = "#A7D000";
	public static String STYLE_LEFTCOLUMN_WIDTH = "200";
	public static String STYLE_LEFTCOLUMN_BACKGROUNDCOLOR = "#FFFFFF";
	public static String STYLE_LEFTCOLUMN_DIVIDERCOLOR = "#C2D6E9";
	public static String STYLE_MIDDLECOLUMN_WIDTH = "99%";
	public static String STYLE_MIDDLECOLUMN_BACKGROUNDCOLOR = "#FFFFFF";
	public static String STYLE_RIGHTCOLUMN_WIDTH = "200";
	public static String STYLE_RIGHTCOLUMN_PADDING = "10";
	public static String STYLE_RIGHTCOLUMN_BACKGROUNDCOLOR = "#C2D6E9";
	public static String STYLE_INDENTWIDTH = "10";
	public static String STYLE_LINEHEIGHT = "20";
	public static String STYLE_NAVIGATION_MENU_SPACERS = "";
	public static String STYLE_NAVIGATION_MENU_ITEM_PAD_TEXT = "&nbsp;&nbsp;";
	public static String FORM_EDIT_CELL_PREVIOUS_BACK_GRND_COLOR = "#FFFFFF";
	public static String FORM_EDIT_CELL_CURRENT_BACK_GRND_COLOR = "#CDCDCD";
	public static String FORM_DEFAULT_CELLSPACING = "0";
	public static String FORM_DEFAULT_CELLPADDING = "0";
	public static String FORM_DEFAULT_TABLE_BORDER = "0";
	public static String FORM_DEFAULT_TABLE_WIDTH = "600";
	public static String FORM_DEFAULT_MAX_TABLE_ROWS = "30";
	public static String FORM_DEFAULT_MAX_TABLE_COLS = "10";
	public static String FORM_SUBMISSION_EMAIL_FORMAT = "text";
	public static int MAX_NUM_EMAIL_FOR_STANDARD_FORM_PROCESS = 20;
	public static String SITE_MAP_PAGE_ICON = "page.gif";
	public static final String MISS_SPELLING_SEARCH = "true";
	public static final String USE_THESAURUS_SEARCH = "true";
	public static final int VERSION_RESOURCE_TYPE_LAYOUT = 1;
	public static final int VERSION_RESOURCE_TYPE_STYLE = 2;
	public static final int VERSION_RESOURCE_TYPE_PAGE = 3;
	public static final int VERSION_RESOURCE_TYPE_FILE = 4;
	public static final int VERSION_RESOURCE_TYPE_FORM = 5;
	public static final int VERSION_RESOURCE_TYPE_TEXT = 6;
	public static final String VERSION_STATUS_EDIT = "e";
	public static final String VERSION_STATUS_CURRENT = "c";
	public static final String VERSION_STATUS_ARCHIVE = "a";
	public static final String WORKFLOW_REQUEST_TYPE_ADD = "add";
	public static final String WORKFLOW_REQUEST_TYPE_EDIT = "edit";
	public static final String WORKFLOW_REQUEST_TYPE_DELETE = "delete";
	public static final String WORKFLOW_STATE_APPROVED = "approved";
	public static final String WORKFLOW_STATE_DECLINED = "declined";
	public static final String WORKFLOW_STATE_PENDING = "pending";
	public static String SITE_NAME;
	public static int ROOT_PAGE;
	public static String HOME_PAGE_URL;
	public static String HOME_PAGE_TEMPLATE_NAME;
	public static String PUBLIC_SITE_URL;
	public static String PUBLIC_LOGIN_PAGE;
	public static String RETURN_TO_TOP_IMAGE_KEY;
	public static String DATE_FORMAT_STRING;
	public static String PASSWORD_ENCRYPTION_KEY;
	public static int DATABASE_TYPE = 4;
	public static String DB_CONNECTION_STRING;	
	public static String DB_READONLY_CONNECTION_STRING;
	public static String DB_READONLY_USER_NAME;
	public static String DB_READONLY_USER_PASSWORD;
	public static String DB_PUBLIC_USER_NAME;
	public static String DB_PUBLIC_USER_PASSWORD;
	public static String DB_ADMIN_USER_NAME;
	public static String DB_ADMIN_USER_PASSWORD;
	public static boolean LINK_TO_CUSTOM_MAIN_PAGE;
	public static String LINK_TO_CUSTOM_MAIN_PAGE_NAME;
	public static String CUSTOM_DISPLAY_NAME;
	public static String CUSTOM_IMAGE_DIRECTORY;
	public static int EDITOR_TYPE;
	public static String POSTS_ORDER;
	public static boolean LDAP_ENABLED;
	public static String LDAP_GROUP;
	public static String LDAP_ROLE;
	public static String LDAP_HOST;
	public static int LDAP_PORT;
	public static String LDAP_BASE_DN;
	public static int LDAP_TRADITIONAL;
	public static int LDAP_INTERNET;
	public static int LDAP_OTHER_STRUCTURE;
	public static int LDAP_STRUCTURE;
	public static String LDAP_USER_SURNAME;
	public static String LDAP_USER_GIVEN_NAME;
	public static String LDAP_USER_DEPT;
	public static boolean SSO_ENABLED;
	public static int SSO_FROM_WINDOWS;
	public static int SSO_FROM_LINUX;
	public static int SSO_FROM_MAC;
	public static int SSO_FROM_OTHER;
	public static int SSO_USER_ID_SOURCE;
	public static String STATS_SERVER;
	public static String EMAIL_SENDER_ADDRESS;
	public static String EMAIL_SUBJECT_HEADER;
	public static String EMAIL_BODY_PART_1;
	public static String EMAIL_BODY_PART_2;
	public static String EMAIL_FORM_SENDER_ADDRESS;
	public static String EMAIL_FORM_SUBJECT_HEADER;
	public static String EMAIL_FORM_RECEIVER_FIELD_NAME;
	public static String EMAIL_FORM_BUTTON_FIELD_NAME;
	public static String EMAIL_FORM_TITLE_FIELD_NAME;
	public static String EMAIL_MAIL_HOST;
	public static String SUGGESTED_TERM_INDEX_NAME;
	public static String EXTERNAL_SEARCH;
	public static String OPEN_PAGE_RESULTS_IN_NEW_WIN;
	public static String OPEN_EXT_SEARCH_RESULTS_IN_NEW_WIN;
	public static String OPEN_FILE_RESULTS_IN_NEW_WIN;
	public static String OPEN_FILE_MORE_RESULTS_IN_NEW_WIN;
	public static String OPEN_FILE_HTML_RESULTS_IN_NEW_WIN;
	public static String OPEN_META_RESULTS_IN_NEW_WIN;
	public static String DISPLAY_SUGGESTED_SEARCH_LINK;
	public static String DISPLAY_HTML_VERSION_LINK;
	public static String DISPLAY_HTML_PAGINATION_VERSION_LINK;
	public static boolean WORKFLOW_ENABLED;
	public static boolean WORKFLOW_UNANIMOUS_APPROVAL;
	public static int WORKFLOW_DAYS_AFTER_COMPLETION;
	public static String GOOGLE_KEY;

	public AppConstants() {
	}

	public AppConstants(HttpServletRequest p_request) {
		try {
			if (DATABASE_TYPE == 1) {
				// DriverManager.registerDriver(new OracleDriver());
			} else if (DATABASE_TYPE == 2) {
				Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();
			} else if (DATABASE_TYPE == 3) {
				Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
			} else {

				Class.forName("com.mysql.jdbc.Driver").newInstance();
			}
			loadFromIniFile(p_request);
		} catch (Exception e) {
			System.out.println("Trying to set DB connection string - We have an exception!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}

	public void loadFromIniFile(HttpServletRequest p_request) {
		try {
			if (LOAD_FROM_INI_FILE) {

				// FileTools fileTools = new FileTools();
				IniFile iniFile = new IniFile();

				iniFile.readIni("C:/AusStage Without OpenCMS/cmjava.ini");
				//this will be important for PROD???
				//iniFile.readIni("/opt/ausstage/cmjava.ini");
				
				iniFile.setHeader("GENERAL");
				SITE_NAME = iniFile.getItem("SITE_NAME");
				ROOT_PAGE = Integer.parseInt(iniFile.getItem("ROOT_PAGE"));
				HOME_PAGE_TEMPLATE_NAME = iniFile.getItem("HOME_PAGE_TEMPLATE_NAME");
				HOME_PAGE_URL = "/" + HOME_PAGE_TEMPLATE_NAME + ROOT_PAGE;
				PUBLIC_SITE_URL = iniFile.getItem("PUBLIC_SITE_URL");
				PUBLIC_LOGIN_PAGE = iniFile.getItem("PUBLIC_LOGIN_PAGE");
				DATE_FORMAT_STRING = iniFile.getItem("DATE_FORMAT");
				RETURN_TO_TOP_IMAGE_KEY = iniFile.getItem("RETURN_TO_TOP_IMAGE_KEY");
				PASSWORD_ENCRYPTION_KEY = iniFile.getItem("PASSWORD_ENCRYPTION_KEY");
				iniFile.setHeader("DATABASE");
				DB_PUBLIC_USER_NAME = iniFile.getItem("DB_PUBLIC_USER_NAME");
				DB_PUBLIC_USER_PASSWORD = iniFile.getItem("DB_PUBLIC_USER_PASSWORD");
				DB_ADMIN_USER_NAME = iniFile.getItem("DB_ADMIN_USER_NAME");
				DB_ADMIN_USER_PASSWORD = iniFile.getItem("DB_ADMIN_USER_PASSWORD");
				DB_CONNECTION_STRING = iniFile.getItem("DB_CONNECTION_STRING");
				DB_READONLY_CONNECTION_STRING = iniFile.getItem("DB_READONLY_CONNECTION_STRING");
				DB_READONLY_USER_NAME = iniFile.getItem("DB_READONLY_USER_NAME");
				DB_READONLY_USER_PASSWORD = iniFile.getItem("DB_READONLY_USER_PASSWORD");

				iniFile.setHeader("CUSTOM");
				LINK_TO_CUSTOM_MAIN_PAGE = (new Boolean(iniFile.getItem("LINK_TO_CUSTOM_MAIN_PAGE"))).booleanValue();
				LINK_TO_CUSTOM_MAIN_PAGE_NAME = iniFile.getItem("LINK_TO_CUSTOM_MAIN_PAGE_NAME");
				CUSTOM_DISPLAY_NAME = iniFile.getItem("CUSTOM_DISPLAY_NAME");
				CUSTOM_IMAGE_DIRECTORY = iniFile.getItem("CUSTOM_IMAGE_DIRECTORY");
				iniFile.setHeader("EDITOR");
				EDITOR_TYPE = Integer.parseInt(iniFile.getItem("EDITOR_TYPE"));
				iniFile.setHeader("DISCUSSION BOARD");
				POSTS_ORDER = iniFile.getItem("POSTS_ORDER");
				iniFile.setHeader("LDAP");
				LDAP_ENABLED = (new Boolean(iniFile.getItem("LDAP_ENABLED"))).booleanValue();
				LDAP_GROUP = iniFile.getItem("LDAP_GROUP");
				LDAP_ROLE = iniFile.getItem("LDAP_ROLE");
				LDAP_HOST = iniFile.getItem("LDAP_HOST");
				LDAP_PORT = Integer.parseInt(iniFile.getItem("LDAP_PORT"));
				LDAP_BASE_DN = iniFile.getItem("LDAP_BASE_DN");
				LDAP_TRADITIONAL = Integer.parseInt(iniFile.getItem("LDAP_TRADITIONAL"));
				LDAP_INTERNET = Integer.parseInt(iniFile.getItem("LDAP_INTERNET"));
				LDAP_OTHER_STRUCTURE = Integer.parseInt(iniFile.getItem("LDAP_OTHER_STRUCTURE"));
				String ldapStructure = iniFile.getItem("LDAP_STRUCTURE");
				if (ldapStructure.equals("LDAP_TRADITIONAL")) {
					LDAP_STRUCTURE = LDAP_TRADITIONAL;
				} else if (ldapStructure.equals("LDAP_INTERNET")) {
					LDAP_STRUCTURE = LDAP_INTERNET;
				} else {
					LDAP_STRUCTURE = LDAP_OTHER_STRUCTURE;
				}
				LDAP_USER_SURNAME = iniFile.getItem("LDAP_USER_SURNAME");
				LDAP_USER_GIVEN_NAME = iniFile.getItem("LDAP_USER_GIVEN_NAME");
				LDAP_USER_DEPT = iniFile.getItem("LDAP_USER_DEPT");
				iniFile.setHeader("SINGLE SIGN ON");
				SSO_ENABLED = (new Boolean(iniFile.getItem("SSO_ENABLED"))).booleanValue();
				SSO_FROM_WINDOWS = Integer.parseInt(iniFile.getItem("SSO_FROM_WINDOWS"));
				SSO_FROM_LINUX = Integer.parseInt(iniFile.getItem("SSO_FROM_LINUX"));
				SSO_FROM_MAC = Integer.parseInt(iniFile.getItem("SSO_FROM_MAC"));
				SSO_FROM_OTHER = Integer.parseInt(iniFile.getItem("SSO_FROM_OTHER"));
				String ssoSource = iniFile.getItem("SSO_USER_ID_SOURCE");
				if (ssoSource.equals("SSO_FROM_WINDOWS")) {
					SSO_USER_ID_SOURCE = SSO_FROM_WINDOWS;
				} else if (ssoSource.equals("SSO_FROM_LINUX")) {
					SSO_USER_ID_SOURCE = SSO_FROM_LINUX;
				} else if (ssoSource.equals("SSO_FROM_MAC")) {
					SSO_USER_ID_SOURCE = SSO_FROM_MAC;
				} else {
					SSO_USER_ID_SOURCE = SSO_FROM_OTHER;
				}
				iniFile.setHeader("STATISTICS");
				STATS_SERVER = iniFile.getItem("STATS_SERVER");
				iniFile.setHeader("SUBSCRIPTION");
				EMAIL_SENDER_ADDRESS = iniFile.getItem("EMAIL_SENDER_ADDRESS");
				EMAIL_SUBJECT_HEADER = iniFile.getItem("EMAIL_SUBJECT_HEADER");
				EMAIL_BODY_PART_1 = iniFile.getItem("EMAIL_BODY_PART_1");
				EMAIL_BODY_PART_2 = iniFile.getItem("EMAIL_BODY_PART_2");
				iniFile.setHeader("FORM");
				EMAIL_FORM_SENDER_ADDRESS = iniFile.getItem("EMAIL_FORM_SENDER_ADDRESS");
				EMAIL_FORM_SUBJECT_HEADER = iniFile.getItem("EMAIL_FORM_SUBJECT_HEADER");
				EMAIL_FORM_RECEIVER_FIELD_NAME = iniFile.getItem("EMAIL_FORM_RECEIVER_FIELD_NAME");
				EMAIL_FORM_BUTTON_FIELD_NAME = iniFile.getItem("EMAIL_FORM_BUTTON_FIELD_NAME");
				EMAIL_FORM_TITLE_FIELD_NAME = iniFile.getItem("EMAIL_FORM_TITLE_FIELD_NAME");
				EMAIL_MAIL_HOST = iniFile.getItem("EMAIL_MAIL_HOST");
				iniFile.setHeader("SEARCH");
				SUGGESTED_TERM_INDEX_NAME = iniFile.getItem("SUGGESTED_TERM_INDEX_NAME");
				EXTERNAL_SEARCH = iniFile.getItem("EXTERNAL_SEARCH");
				OPEN_PAGE_RESULTS_IN_NEW_WIN = iniFile.getItem("OPEN_PAGE_RESULTS_IN_NEW_WIN");
				OPEN_EXT_SEARCH_RESULTS_IN_NEW_WIN = iniFile.getItem("OPEN_EXT_SEARCH_RESULTS_IN_NEW_WIN");
				OPEN_FILE_RESULTS_IN_NEW_WIN = iniFile.getItem("OPEN_FILE_RESULTS_IN_NEW_WIN");
				OPEN_FILE_MORE_RESULTS_IN_NEW_WIN = iniFile.getItem("OPEN_FILE_MORE_RESULTS_IN_NEW_WIN");
				OPEN_FILE_HTML_RESULTS_IN_NEW_WIN = iniFile.getItem("OPEN_FILE_HTML_RESULTS_IN_NEW_WIN");
				OPEN_META_RESULTS_IN_NEW_WIN = iniFile.getItem("OPEN_META_RESULTS_IN_NEW_WIN");
				DISPLAY_SUGGESTED_SEARCH_LINK = iniFile.getItem("DISPLAY_SUGGESTED_SEARCH_LINK");
				DISPLAY_HTML_VERSION_LINK = iniFile.getItem("DISPLAY_HTML_VERSION_LINK");
				DISPLAY_HTML_PAGINATION_VERSION_LINK = iniFile.getItem("DISPLAY_HTML_PAGINATION_VERSION_LINK");
				iniFile.setHeader("WORKFLOW");
				WORKFLOW_ENABLED = (new Boolean(iniFile.getItem("WORKFLOW_ENABLED"))).booleanValue();
				WORKFLOW_UNANIMOUS_APPROVAL = (new Boolean(iniFile.getItem("WORKFLOW_UNANIMOUS_APPROVAL"))).booleanValue();
				WORKFLOW_DAYS_AFTER_COMPLETION = Integer.parseInt(iniFile.getItem("WORKFLOW_DAYS_AFTER_COMPLETION"));
				LOAD_FROM_INI_FILE = false;
				iniFile.setHeader("API KEYS");
				GOOGLE_KEY = iniFile.getItem("GOOGLE_KEY");
			}
		} catch (Exception e) {
			System.out.println("An exception occurred in loadFromIniFile()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}

}