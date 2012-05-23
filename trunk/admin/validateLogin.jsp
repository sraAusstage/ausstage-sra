<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*,sun.jdbc.rowset.*"%>
<%
  //admin.Database db = (admin.Database) session.getAttribute("db");
  admin.Database db;
  admin.AppConstants AppConstants = new admin.AppConstants();

  if (session.getAttribute("db") == null)
  {
    db = new admin.Database();
    session.setAttribute("db",db);
  }
  else
    db = (admin.Database) session.getAttribute("db");


  admin.ValidateLogin login = new admin.ValidateLogin();
  session.setAttribute("login",login);

  admin.FormatPage pageFormater = new admin.FormatPage (db);
  session.setAttribute("pageFormater",pageFormater);

  String sqlString;
  CachedRowSet rset;
  String fun_id;
  String fun_name;
  String fun_name_conv;
  String fun_url;
  String fun_cat;
  int count_id;
  String count_id_conv;

  if (!login.authenticateUser(request.getParameter ("user_name"),
                              request.getParameter ("user_password"), db)) {

    response.sendRedirect ("/admin/content_login.jsp" + login.loginResult);
  }
  else
  {

    // Setup the session variables
    session.setAttribute ("userName", login.m_user);
    session.setAttribute ("fullUserName", login.m_fullUserName);
    session.setAttribute ("authId", login.m_userId);
    session.setAttribute ("isAdmin", login.m_isAdmin);
    session.setAttribute ("loginOK", "true");

    if (login.m_isAdmin.equals("true")) {
        sqlString = "SELECT * FROM author_functions where is_custom='f' ORDER BY fun_cat, fun_order";
    }
    else {
        sqlString = "SELECT author_functions.*  " +
                    "FROM author_functions, author_roles_function_rights, author_roles_rel " +
                    "WHERE author_roles_rel.auth_id = " + login.m_userId + " " + 
                    "AND author_roles_rel.role_id = author_roles_function_rights.role_id " +
                    "AND author_roles_function_rights.fun_id = author_functions.fun_id " + 
                    "AND is_custom='f' " + 
                    "ORDER by fun_cat, fun_order";
    }

    Statement stmt = db.m_conn.createStatement ();
    rset = db.runSQL (sqlString, stmt);
    count_id = 0;
    while(rset.next()) {
        fun_id = rset.getString("fun_id");
        fun_name = rset.getString("fun_name");
        fun_url = rset.getString("fun_url");
        fun_cat = rset.getString("fun_cat");
        session.setAttribute ("fun_id_" + count_id, fun_id);
        session.setAttribute ("fun_name_" + count_id, fun_name);
        session.setAttribute ("fun_url_" + count_id, fun_url);
        session.setAttribute ("fun_cat_" + count_id, fun_cat);
        count_id ++;
    }

    count_id_conv = count_id + "";
    session.setAttribute ("fun_count", count_id_conv);

    pageFormater.m_fullUserName   = login.m_fullUserName;
    pageFormater.m_firstUserName  = login.m_firstUserName;
    pageFormater.m_sessionTimeout = "1800";  // The time for the session to time out
                                           // (1800sec = 30 miniutes)


    response.sendRedirect ("/custom/welcome.jsp");
    stmt.close ();
  }
%>
