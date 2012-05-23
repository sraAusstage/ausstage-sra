package form;

import admin.*;
import java.io.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import sun.jdbc.rowset.CachedRowSet;

public class FormSubscription
{

    private HttpServletRequest m_request;
    private Database m_db;
    private String sqlString;
    private int number_of_subscribers;
    private String absolute_file_path;
    private String file_size;
    private String file_name;
    private CachedRowSet rset;

    public FormSubscription(HttpServletRequest p_request, Database p_db)
    {
        m_request = null;
        m_db = null;
        sqlString = "";
        number_of_subscribers = 0;
        absolute_file_path = "";
        file_size = "";
        file_name = "";
        m_request = p_request;
        m_db = p_db;
    }

    public boolean getRequestedApproval(String group_id)
    {
        try
        {
            Statement stmt = m_db.m_conn.createStatement();
            sqlString = "select group_id from subscription_groups where approval_requested='t' and group_" +
"id="
 + group_id;
            CachedRowSet rset = m_db.runSQL(sqlString, stmt);
            boolean ret;
            if(rset.next())
            {
                ret = true;
            } else
            {
                ret = false;
            }
            stmt.close();
            boolean flag = ret;
            return flag;
        }
        catch(Exception e)
        {
            System.out.println("An exception occurred in FromSubscription.getRequestedApproval().");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
            boolean flag1 = false;
            return flag1;
        }
    }

    public boolean isSubscriptionApproved(String group_id)
    {
        try
        {
            Statement stmt = m_db.m_conn.createStatement();
            sqlString = "select group_id from subscription_groups where is_approved='f' and group_id=" + group_id;
            rset = m_db.runSQL(sqlString, stmt);
            boolean ret;
            if(rset.next())
            {
                ret = false;
            } else
            {
                ret = true;
            }
            stmt.close();
            boolean flag = ret;
            return flag;
        }
        catch(Exception e)
        {
            System.out.println("An exception occurred in isSubscriptionApproved().");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
            boolean flag1 = false;
            return flag1;
        }
    }

    public String copySubscription(String group_id, String real_group_id_val, String is_approved_val, String approval_requested_val, String modified_by_auth_id_val)
    {
        String unApprovedGroupId = "";
        String name_value = "";
        String data_value = "";
        String new_subs_id = "";
        try
        {
            Statement stmt1 = m_db.m_conn.createStatement();
            Statement stmt2 = m_db.m_conn.createStatement();
            Statement stmt3 = m_db.m_conn.createStatement();
            Statement stmt4 = m_db.m_conn.createStatement();
            Statement stmt_for_clob = m_db.m_conn.createStatement();
            sqlString = "select * from subscription_groups where group_id=" + group_id;
            rset = m_db.runSQL(sqlString, stmt1);
            if(rset.next())
            {
                sqlString = "insert into subscription_groups (group_name, real_group_id , is_approved, approv" +
"al_requested, modified_by_auth_id)  values ('"
 + rset.getString("group_name") + "'," + real_group_id_val + ",'" + is_approved_val + "','" + approval_requested_val + "'," + modified_by_auth_id_val + ")";
                m_db.runSQL(sqlString, stmt2);
                unApprovedGroupId = m_db.getInsertedIndexValue(stmt2, "grp_id_seq");
                sqlString = "select * from subscription_groups_rel where group_id=" + group_id;
                CachedRowSet crset1 = m_db.runSQL(sqlString, stmt2);
                if(crset1.next())
                {
                    do
                    {
                        sqlString = "insert into subscription_groups_rel (group_id, subs_id) values (" + unApprovedGroupId + "," + crset1.getString("subs_id") + ")";
                        m_db.runSQL(sqlString, stmt3);
                    } while(crset1.next());
                }
                sqlString = "select subscribers.subs_id, subscribers.name, subscribers.email from subscribers" +
" , subscription_groups_rel where subscription_groups_rel.group_id="
 + group_id + "and subscription_groups_rel.subs_id=subscribers.subs_id";
                crset1 = m_db.runSQL(sqlString, stmt2);
                if(crset1.next())
                {
                    do
                    {
                        sqlString = "insert into subscribers (name, email) values ('" + crset1.getString("name") + "','" + crset1.getString("email") + "')";
                        m_db.runSQL(sqlString, stmt3);
                        new_subs_id = m_db.getInsertedIndexValue(stmt3, "subs_id_seq");
                        sqlString = "update subscription_groups_rel set subs_id=" + new_subs_id + " where group_id=" + unApprovedGroupId + " and subs_id=" + crset1.getString("subs_id");
                        m_db.runSQL(sqlString, stmt4);
                        sqlString = "select name_value, data_value from subscribers where subs_id=" + crset1.getString("subs_id");
                        ResultSet clobRset = m_db.runSQLResultSet(sqlString, stmt_for_clob);
                        if(clobRset.next())
                        {
                            if(AppConstants.DATABASE_TYPE == 1)
                            {
                                Clob cl = clobRset.getClob("name_value");
                                if(cl != null)
                                {
                                    name_value = cl.getSubString(1L, (int)cl.length());
                                    if(name_value == null || name_value.equals("null"))
                                    {
                                        name_value = "";
                                    }
                                }
                                cl = clobRset.getClob("data_value");
                                if(cl != null)
                                {
                                    data_value = cl.getSubString(1L, (int)cl.length());
                                    if(data_value == null || data_value.equals("null"))
                                    {
                                        data_value = "";
                                    }
                                }
                            } else
                            {
                                name_value = clobRset.getString("name_value");
                                data_value = clobRset.getString("data_value");
                            }
                            if(AppConstants.DATABASE_TYPE == 1)
                            {
                                CallableStatement callable = m_db.m_conn.prepareCall("begin UPDATE_NAME_DATA_VALUES ('" + m_db.plSqlSafeString(name_value) + "', '" + m_db.plSqlSafeString(data_value) + "'," + new_subs_id + "); end;");
                                callable.execute();
                                callable.close();
                            } else
                            {
                                sqlString = "update subscribers set name_value='" + m_db.plSqlSafeString(name_value) + "', data_value='" + m_db.plSqlSafeString(data_value) + "' where subs_id=" + new_subs_id;
                                m_db.runSQL(sqlString, stmt4);
                            }
                        }
                    } while(crset1.next());
                }
            }
            stmt1.close();
            stmt2.close();
            stmt3.close();
            stmt4.close();
            stmt_for_clob.close();
        }
        catch(Exception crset1)
        {
            System.out.println("An exception occurred in copySubscription().");
            System.out.println("MESSAGE: " + crset1.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + crset1.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + crset1.toString());
        }
        return unApprovedGroupId;
    }

    public String writeReportFile()
    {
        try
        {
            String outputtext = getSubribersDetails();
            FileTools filetools = new FileTools();
            if(!outputtext.equals(""))
            {
                absolute_file_path = filetools.getAbsoluteFilePath(m_request, "//custom/reports/group_subscription_report.csv");
                FileOutputStream fileOutputStream = new FileOutputStream(absolute_file_path);
                fileOutputStream.write(outputtext.getBytes());
                fileOutputStream.close();
                File file = new File(absolute_file_path);
                file_size = Long.toString(file.length() / (long)1024);
                absolute_file_path = file.getPath();
                file_name = file.getName();
            }
        }
        catch(Exception e)
        {
            System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
            System.out.println("An Exception occured in writeReportFile()");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
            System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
        }
        return Integer.toString(number_of_subscribers);
    }

    private String getSubribersDetails()
    {
        String text_buffer = "";
        try
        {
            Statement stmt = m_db.m_conn.createStatement();
            sqlString = "select subs_id, name, email from subscribers";
            rset = m_db.runSQL(sqlString, stmt);
            if(rset.next())
            {
                do
                {
                    if(text_buffer.equals(""))
                    {
                        text_buffer = "SUBSCRIBER'S ID,NAME,EMAIL\n";
                        text_buffer = text_buffer + (rset.getString("subs_id") + "," + rset.getString("name") + "," + rset.getString("email"));
                    } else
                    {
                        text_buffer = text_buffer + ("\n" + rset.getString("subs_id") + "," + rset.getString("name") + "," + rset.getString("email"));
                    }
                    number_of_subscribers++;
                } while(rset.next());
            }
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
            System.out.println("Exception occured in getSubribersDetails()");
            System.out.println("The query is " + sqlString);
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
            System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
        }
        return text_buffer;
    }

    public String getAbsoluteFilePath()
    {
        return absolute_file_path;
    }

    public String getFileSize()
    {
        if(Integer.parseInt(file_size) == 0)
        {
            file_size = "1";
        }
        return file_size;
    }

    public String getName()
    {
        return file_name;
    }
}
