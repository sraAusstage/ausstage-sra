package form;

import admin.Database;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.Statement;
import sun.jdbc.rowset.CachedRowSet;

public class FormValidationManager {

	private Database db;
	private CachedRowSet rset;
	private String sqlString;
	private String finalJavaScriptStr;

	public FormValidationManager(Database p_db) {
		sqlString = "";
		finalJavaScriptStr = "";
		db = p_db;
	}

	public String buildJavaScriptValidatator(String form_layout_id, String html_name, String field_type, String display_name, String default_value) {
		String strJavaScript = "";
		String form_name = "";
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select form_repository.form_name from form_repository, form_layout where form_la" + "yout.form_id=form_repository.form_id and form_layout.form_layout_id="
					+ db.plSqlSafeString(form_layout_id);
			rset = db.runSQL(sqlString, stmt);
			rset.next();
			form_name = rset.getString("form_name");
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Exception occured in FormValidationManager.buildJavaScriptValidatator()");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		if (field_type.equals("n")) {
			strJavaScript = strJavaScript + ("  \nif(!isInteger(document." + form_name + "." + html_name + ".value)){\n");
			strJavaScript = strJavaScript + ("    xmsg += '\\t" + display_name + " - requires numeric format\\n';\n");
			strJavaScript = strJavaScript + ("    document." + form_name + "." + html_name + ".value = '" + default_value + "';\n");
			strJavaScript = strJavaScript + "  }\n";
		} else if (field_type.equals("e")) {
			strJavaScript = strJavaScript + ("  \nif(!checkMail(document." + form_name + "." + html_name + ".value,false)){\n");
			strJavaScript = strJavaScript + ("   xmsg += '\\t" + display_name + " - requires email address format\\n';\n");
			strJavaScript = strJavaScript + ("   document." + form_name + "." + html_name + ".value = '" + default_value + "';\n");
			strJavaScript = strJavaScript + "  }\n";
		} else if (field_type.equals("i")) {
			strJavaScript = strJavaScript + ("  \nif(!isURL(document." + form_name + "." + html_name + ".value)){\n");
			strJavaScript = strJavaScript + ("    xmsg += '\\t" + display_name + " - requires internet address (URL) format\\n';\n");
			strJavaScript = strJavaScript + ("    document." + form_name + "." + html_name + ".value = '" + default_value + "';\n");
			strJavaScript = strJavaScript + "  }\n";
		} else if (field_type.equals("t")) {
			strJavaScript = strJavaScript + ("  \nif(isBlank(document." + form_name + "." + html_name + ".value)){\n");
			strJavaScript = strJavaScript + ("    xmsg += '\\t" + display_name + " - can not be empty\\n';\n");
			strJavaScript = strJavaScript + ("    document." + form_name + "." + html_name + ".value = '" + default_value + "';\n");
			strJavaScript = strJavaScript + "  }\n";
		}
		return strJavaScript;
	}

	public String getJavaScriptValidator(String FinalJavaScriptValidator) {
		String printFinalJavaScript = "";
		String javaScriptFunctionHeader = "function validateForm(){\nvar xmsg ='';\n";
		String javaScriptFunctionFooter = "}\n";
		String javaScriptHeader = "<script language='JavaScript'><!--\n";
		String javaScriptFooter = "\n//--></script>";
		if (!FinalJavaScriptValidator.equals("")) {
			FinalJavaScriptValidator = javaScriptFunctionHeader + FinalJavaScriptValidator;
			FinalJavaScriptValidator = FinalJavaScriptValidator + "  \nif(xmsg != ''){\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "    alert('You seem to have entered incorrect value(s) in the following field(s)" + ".\\n\\n' + xmsg + \n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "          '\\n\\nPlease click OK and remedy the error(s).');\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "    xmsg ='';\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "    return(false);\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "  }else{\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "    return(true);\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "  }\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + javaScriptFunctionFooter;
			FinalJavaScriptValidator = FinalJavaScriptValidator + "function isInteger (s){\n var i;\n var c;\n for (i = 0; i < s.length; i++){\n   "
					+ "    c = s.charAt(i);\n       if (!isDigit(c))\n         return false;\n }\n  ret" + "urn true;\n}\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "function checkMail(email_field, produce_alert){\n var ret_bool = true;\n var x ="
					+ " '';\n x = email_field;\n if(!x == ''){\n   var filter  = /^([a-zA-Z0-9_\\.\\-])"
					+ "+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9])+$/;\n   if (filter.test(x)){\n     ret_"
					+ "bool = true;\n   }   else{\n     if(produce_alert)\n       alert('NO! Incorrect "
					+ "email address');\n     ret_bool = false;\n   }\n }else{\n   if(produce_alert)\n "
					+ "    alert('please enter an email address');\n   ret_bool = false;\n }\n return (" + "ret_bool);\n}\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "function isURL(argvalue){\n  var ret_bool = true;\n  if (argvalue.indexOf(' ') !"
					+ "= -1)\n    ret_bool = false;\n  else if (argvalue.indexOf('http://') == -1)\n   "
					+ " ret_bool = false;\n  else if (argvalue == 'http://')\n    ret_bool = false;\n  "
					+ "else if (argvalue.indexOf('http://') > 0)\n    ret_bool = false;\n  argvalue = a"
					+ "rgvalue.substring(7, argvalue.length);\n  if (argvalue.indexOf('.') == -1)\n    "
					+ "ret_bool = false;\n  else if (argvalue.indexOf('.') == 0)\n    ret_bool = false;"
					+ "\n  else if (argvalue.charAt(argvalue.length - 1) == '.')\n    ret_bool = false;"
					+ "\n  if (argvalue.indexOf('/') != -1) {\n    argvalue = argvalue.substring(0, arg"
					+ "value.indexOf('/'));\n    if (argvalue.charAt(argvalue.length - 1) == '.')\n    "
					+ "  ret_bool = false;\n  }\n  if (argvalue.indexOf(':') != -1) {\n   if (argvalue."
					+ "indexOf(':') == (argvalue.length - 1))\n      ret_bool = false;\n   else if (arg"
					+ "value.charAt(argvalue.indexOf(':') + 1) == '.')\n      ret_bool = false;\n   arg"
					+ "value = argvalue.substring(0, argvalue.indexOf(':'));\n   if (argvalue.charAt(ar"
					+ "gvalue.length - 1) == '.')\n      ret_bool = false;\n  }\n     return ret_bool;\n" + " }\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "function isDigit (c){\n return ((c >= '0') && (c <= '9'));\n}\n";
			FinalJavaScriptValidator = FinalJavaScriptValidator + "function isBlank(s){\n if((s == null)||(s == \"\"))\n   return true;\n else\n   " + "return false;\n}\n";
			printFinalJavaScript = javaScriptHeader + FinalJavaScriptValidator + javaScriptFooter;
		}
		return printFinalJavaScript;
	}
}
