package form;

import admin.*;
import content.ContentOutput;
import java.io.PrintStream;
import java.sql.*;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package form:
//            FormElementsManager, FormTableLayoutManager, Form, FormElement

public class FormProcessManager
{

    private String htmlEmailHeader;
    private String htmlEmailFooter;
    private String htmlEmail;
    private String textEmail;
    private String sqlString;
    private FormTableLayoutManager ftlm;
    private FormElementsManager fem;
    private Database db;
    private Statement stmt;

    public FormProcessManager(Database p_db)
    {
        htmlEmailHeader = "<html><head></head><body><table align='center'>";
        htmlEmailFooter = "</table></body></html>";
        htmlEmail = "";
        textEmail = "";
        sqlString = "";
        fem = new FormElementsManager();
        try
        {
            db = p_db;
            stmt = db.m_conn.createStatement();
            ftlm = new FormTableLayoutManager(db, stmt);
        }
        catch(Exception e)
        {
            System.out.println("Trying to construct FormProcessManager");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public int getEmptyElementIndex(Vector id_email_name_vec_arr[])
    {
        int index = 0;
        if(id_email_name_vec_arr[0] == null)
        {
            index = 0;
        } else
        {
            int i = 0;
            do
            {
                if(i >= id_email_name_vec_arr.length)
                {
                    break;
                }
                if(id_email_name_vec_arr[i] == null || id_email_name_vec_arr[i].isEmpty())
                {
                    index = i;
                    break;
                }
                i++;
            } while(true);
        }
        return index;
    }

    public int getTempFormProcessId(Vector id_email_name_vec_arr[])
    {
        String current_id = "";
        int temp_id = 1;
        Enumeration enuma = null;
        for(int i = 0; i < id_email_name_vec_arr.length && id_email_name_vec_arr[i] != null; i++)
        {
            if(id_email_name_vec_arr[i].isEmpty())
            {
                continue;
            }
            enuma = id_email_name_vec_arr[i].elements();
            current_id = enuma.nextElement().toString();
            if((current_id != null || !current_id.equals("")) && Integer.parseInt(current_id) > temp_id)
            {
                temp_id = Integer.parseInt(current_id);
            }
        }

        return ++temp_id;
    }

    public void addEmailFormProcess(String flfr_id, String process_buffer)
    {
        StringTokenizer strTokenizer = null;
        StringTokenizer name_and_email = null;
        try
        {
            stmt = db.m_conn.createStatement();
            if(process_buffer.indexOf("|") != -1)
            {
                for(strTokenizer = new StringTokenizer(process_buffer, "|"); strTokenizer.hasMoreTokens(); db.runSQL(sqlString, stmt))
                {
                    name_and_email = new StringTokenizer(strTokenizer.nextToken().toString(), ",");
                    sqlString = "insert into form_process (flfr_id, name, url_or_email) values ('" + flfr_id + "','" + name_and_email.nextToken().toString() + "','" + name_and_email.nextToken().toString() + "')";
                }

            } else
            if(process_buffer.indexOf(",") != -1)
            {
                name_and_email = new StringTokenizer(process_buffer, ",");
                sqlString = "insert into form_process (flfr_id, name, url_or_email) values ('" + flfr_id + "','" + name_and_email.nextToken().toString() + "','" + name_and_email.nextToken().toString() + "')";
                db.runSQL(sqlString, stmt);
                stmt.close();
            } else
            {
                if(process_buffer != null && process_buffer.equals("true"))
                {
                    sqlString = "insert into form_process (is_confirm_req, flfr_id) values ('t'," + flfr_id + ")";
                } else
                {
                    sqlString = "insert into form_process (is_confirm_req, flfr_id) values (''," + flfr_id + ")";
                }
                db.runSQL(sqlString, stmt);
                stmt.close();
            }
        }
        catch(Exception e)
        {
            System.out.println("Exception occured in addEmailFormProcess()");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public void updateFormProcess(String old_frm_layout_frm_rel_id, String frm_layout_frm_rel_id, String is_confirm_req)
    {
        try
        {
            stmt = db.m_conn.createStatement();
            sqlString = "select flfr_id from form_process where flfr_id=" + old_frm_layout_frm_rel_id;
            CachedRowSet rst = db.runSQL(sqlString, stmt);
            if(rst.next())
            {
                if(is_confirm_req != null && is_confirm_req.equals("true"))
                {
                    sqlString = "update form_process set is_confirm_req='t', flfr_id=" + frm_layout_frm_rel_id + " where flfr_id=" + old_frm_layout_frm_rel_id;
                    db.runSQL(sqlString, stmt);
                } else
                {
                    sqlString = "update form_process set is_confirm_req='', flfr_id=" + frm_layout_frm_rel_id + " where flfr_id=" + old_frm_layout_frm_rel_id;
                    db.runSQL(sqlString, stmt);
                }
            } else
            {
                addEmailFormProcess(frm_layout_frm_rel_id, is_confirm_req);
            }
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println("Exception occured in updateFormProcess()");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public void deleteFormProcess(String form_process_id, String flfr_id)
    {
        try
        {
            stmt = db.m_conn.createStatement();
            if(form_process_id.equals(""))
            {
                sqlString = "delete from form_process where flfr_id=" + flfr_id;
                db.runSQL(sqlString, stmt);
            } else
            {
                sqlString = "delete from form_process where form_process_id=" + form_process_id;
                db.runSQL(sqlString, stmt);
            }
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println("Exception occured in deleteFormProcess()");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public void insertFormProcess(String frm_layout_frm_rel_id, String added_process)
    {
        try
        {
            stmt = db.m_conn.createStatement();
            if(added_process != null && added_process.equals("true"))
            {
                sqlString = "insert into form_process (is_confirm_req, flfr_id) values ('t', " + frm_layout_frm_rel_id + ")";
                db.runSQL(sqlString, stmt);
            } else
            {
                sqlString = "insert into form_process (is_confirm_req, flfr_id) values ('', " + frm_layout_frm_rel_id + ")";
                db.runSQL(sqlString, stmt);
            }
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println("Exception occured in insertFormProcess()");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public String addToSubscribersGroupTable(String display_name)
    {
        Statement stmt = null;
        CachedRowSet rset = null;
        String subs_grp_id = "";
        String subs_grp_ids = "";
        try
        {
            if(display_name.indexOf("|") == -1)
            {
                sqlString = "select group_id from subscription_groups where group_name='" + display_name + "'";
                stmt = db.m_conn.createStatement();
                rset = db.runSQL(sqlString, stmt);
                if(!rset.next())
                {
                    sqlString = "insert into subscription_groups (group_name) values ('" + display_name + "')";
                    db.runSQL(sqlString, stmt);
                    subs_grp_id = db.getInsertedIndexValue(stmt, "grp_id_seq");
                    subs_grp_ids = subs_grp_ids + subs_grp_id;
                } else
                {
                    subs_grp_ids = subs_grp_ids + rset.getString("group_id");
                }
            } else
            {
                for(StringTokenizer strTokenizer = new StringTokenizer(display_name, "|"); strTokenizer.hasMoreTokens();)
                {
                    String disp_name = strTokenizer.nextToken();
                    sqlString = "select group_id from subscription_groups where LOWER(group_name)='" + disp_name.toLowerCase() + "'";
                    stmt = db.m_conn.createStatement();
                    rset = db.runSQL(sqlString, stmt);
                    if(!rset.next())
                    {
                        sqlString = "insert into subscription_groups (group_name) values ('" + disp_name + "')";
                        db.runSQL(sqlString, stmt);
                        subs_grp_id = db.getInsertedIndexValue(stmt, "grp_id_seq");
                        if(subs_grp_ids.equals(""))
                        {
                            subs_grp_ids = subs_grp_ids + subs_grp_id;
                        } else
                        {
                            subs_grp_ids = subs_grp_ids + ("," + subs_grp_id);
                        }
                    } else
                    if(subs_grp_ids.equals(""))
                    {
                        subs_grp_ids = subs_grp_ids + rset.getString("group_id");
                    } else
                    {
                        subs_grp_ids = subs_grp_ids + ("," + rset.getString("group_id"));
                    }
                }

            }
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println("Trying to insert a group_name in addToSubscribersGroupTable() table");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
        return subs_grp_ids;
    }

    public String addToSubscribersTable(String subscribers_name, String subscribers_email, Hashtable non_group_subscription)
    {
        Statement stmt = null;
        String subs_id = "0";
        String val_array[] = null;
        CachedRowSet rset = null;
        Enumeration enuma = null;
        String name_val_buff = "";
        String data_val_buff = "";
        boolean is_non_group_subscription_exist = false;
        AppConstants appConstants = new AppConstants();
        try
        {
            stmt = db.m_conn.createStatement();
            if(!non_group_subscription.isEmpty())
            {
                is_non_group_subscription_exist = true;
                for(enuma = non_group_subscription.keys(); enuma.hasMoreElements();)
                {
                    Object k = enuma.nextElement();
                    Object v = non_group_subscription.get(k);
                    if(name_val_buff.equals("") && data_val_buff.equals(""))
                    {
                        name_val_buff = (String)k;
                        if(v instanceof String[])
                        {
                            val_array = (String[])v;
                            int x = 0;
                            while(x < val_array.length) 
                            {
                                if(data_val_buff.equals(""))
                                {
                                    data_val_buff = val_array[x];
                                } else
                                {
                                    data_val_buff = data_val_buff + ("|" + val_array[x]);
                                }
                                x++;
                            }
                        } else
                        {
                            data_val_buff = data_val_buff + (String)v;
                        }
                    } else
                    {
                        name_val_buff = name_val_buff + ("|" + (String)k);
                        if(v instanceof String[])
                        {
                            val_array = (String[])v;
                            int i = 0;
                            while(i < val_array.length) 
                            {
                                data_val_buff = data_val_buff + ("|" + val_array[i]);
                                i++;
                            }
                        } else
                        {
                            data_val_buff = data_val_buff + ("|" + (String)v);
                        }
                    }
                }

            }
            sqlString = "select subs_id from subscribers where LOWER(name)='" + subscribers_name.toLowerCase() + "' and LOWER(email)='" + subscribers_email.toLowerCase() + "'";
            rset = db.runSQL(sqlString, stmt);
            if(rset.next())
            {
                subs_id = rset.getString("subs_id");
                if(is_non_group_subscription_exist)
                {
                    if(AppConstants.DATABASE_TYPE == 1)
                    {
                        CallableStatement callable = db.m_conn.prepareCall("begin UPDATE_NAME_DATA_VALUES ('" + db.plSqlSafeString(name_val_buff) + "', '" + db.plSqlSafeString(data_val_buff) + "'," + subs_id + "); end;");
                        callable.execute();
                        callable.close();
                    } else
                    {
                        sqlString = "update subscribers SET name_value='" + db.plSqlSafeString(name_val_buff) + "', data_value='" + db.plSqlSafeString(data_val_buff) + "' where subs_id=" + subs_id;
                        db.runSQL(sqlString, stmt);
                    }
                }
            } else
            {
                sqlString = "insert into subscribers (name, email) values ('" + db.plSqlSafeString(subscribers_name) + "','" + db.plSqlSafeString(subscribers_email) + "')";
                db.runSQL(sqlString, stmt);
                subs_id = db.getInsertedIndexValue(stmt, "subs_id_seq");
                if(is_non_group_subscription_exist)
                {
                    if(AppConstants.DATABASE_TYPE == 1)
                    {
                        CallableStatement callable = db.m_conn.prepareCall("begin UPDATE_NAME_DATA_VALUES ('" + db.plSqlSafeString(name_val_buff) + "', '" + db.plSqlSafeString(data_val_buff) + "'," + subs_id + "); end;");
                        callable.execute();
                        callable.close();
                    } else
                    {
                        sqlString = "update subscribers SET name_value='" + db.plSqlSafeString(name_val_buff) + "', data_value='" + db.plSqlSafeString(data_val_buff) + "' where subs_id=" + subs_id;
                        db.runSQL(sqlString, stmt);
                    }
                }
            }
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println("Trying to insert a details into subscribers\ntable in addToSubscribersTable()");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
        return subs_id;
    }

    public void updateSubscriptionGroupsRel(String subscribers_id, String subs_grp_ids)
    {
        Statement stmt = null;
        CachedRowSet rset = null;
        String id = "";
        try
        {
            stmt = db.m_conn.createStatement();
            if(subs_grp_ids.indexOf(",") != -1)
            {
                StringTokenizer st_subs_grp_ids = new StringTokenizer(subs_grp_ids, ",");
                do
                {
                    if(!st_subs_grp_ids.hasMoreTokens())
                    {
                        break;
                    }
                    id = st_subs_grp_ids.nextToken();
                    sqlString = "select subs_id from subscription_groups_rel where group_id=" + id + " and subs_id=" + subscribers_id;
                    rset = db.runSQL(sqlString, stmt);
                    if(!rset.next())
                    {
                        sqlString = "insert into subscription_groups_rel (subs_id, group_id) values (" + subscribers_id + ", " + id + ")";
                        db.runSQL(sqlString, stmt);
                    }
                } while(true);
            } else
            if(!subs_grp_ids.equals(""))
            {
                sqlString = "select subs_id from subscription_groups_rel where group_id=" + subs_grp_ids + " and subs_id=" + subscribers_id;
                rset = db.runSQL(sqlString, stmt);
                if(!rset.next())
                {
                    sqlString = "insert into subscription_groups_rel (subs_id, group_id) values (" + subscribers_id + ", " + subs_grp_ids + ")";
                    db.runSQL(sqlString, stmt);
                }
            }
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println("Exception occured in updateSubscriptionGroupsRel()");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public void setEmailBody(String display_name, String type_name, String html_name, String default_val, String default_val_from_DB, String default_display_val, String is_multiselect, 
            String default_val_array[], boolean is_part_of_group, String group_id, boolean is_subscription_form)
    {
        String x_default_val = "";
        String label = "";
        int arrSize = 0;
        boolean found = false;
        if(type_name.equals("textbox"))
        {
            if(!default_val.equals(""))
            {
                textEmail += "\n" + display_name + " : " + default_val;
                htmlEmail += "\n<tr><td>" + display_name + ":</td><td>&nbsp;&nbsp;</td><td>" + default_val + "</td></tr>";
            }
        } else
        if(type_name.equals("textarea"))
        {
            if(!default_val.equals(""))
            {
                if(default_val.length() > 50)
                {
                    x_default_val = breakLargeText(default_val, "50", "text");
                    textEmail += "\n" + display_name + " : " + x_default_val;
                    x_default_val = breakLargeText(default_val, "50", "html");
                    htmlEmail += "\n<tr><td>" + display_name + ":</td><td>&nbsp;&nbsp;</td><td>" + x_default_val + "</td></tr>";
                } else
                {
                    textEmail += "\n" + display_name + " : " + default_val;
                    htmlEmail += "\n<tr><td>" + display_name + ":</td><td>&nbsp;&nbsp;</td><td>" + default_val + "</td></tr>";
                }
            }
        } else
        if(type_name.equals("checkbox"))
        {
            if(is_part_of_group && default_val_array != null)
            {
                label = fem.getLabel(group_id, db);
                if(label.equals(""))
                {
                    textEmail += " LABEL_NOT_IN_GROUP ";
                    htmlEmail += " LABEL_NOT_IN_GROUP ";
                } else
                {
                    textEmail += "\n" + label + " :";
                    htmlEmail += "\n<tr><td>" + label + " :</td><td>&nbsp;&nbsp;</td><td>";
                }
                for(int i = 0; i < default_val_array.length; i++)
                {
                    textEmail += "\n" + default_val_array[i];
                    htmlEmail += "<br>" + default_val_array[i];
                }

                htmlEmail += "<br></td></tr>";
            } else
            if(!default_val.equals(""))
            {
                textEmail += "\n" + display_name + " : " + default_val;
                htmlEmail += "\n<tr><td>" + display_name + " :</td><td>&nbsp;&nbsp;</td><td>" + default_val + "</td></tr>";
            } else
            if(is_part_of_group)
            {
                label = fem.getLabel(group_id, db);
                textEmail += "\n" + label + " : NONE.";
                htmlEmail += "\n<tr><td>" + label + " : NONE.</td><td>&nbsp;&nbsp;</td><td>";
            }
        } else
        if(type_name.equals("radiobutton"))
        {
            if(!default_val.equals(""))
            {
                label = fem.getLabel(group_id, db);
                if(label.equals(""))
                {
                    textEmail += " LABEL_NOT_IN_GROUP ";
                    htmlEmail += " LABEL_NOT_IN_GROUP ";
                } else
                {
                    textEmail += "\n" + label + " : " + default_val;
                    htmlEmail += "\n<tr><td>" + label + ":</td><td>&nbsp;&nbsp;</td><td>" + default_val + "</td></tr>";
                }
            }
        } else
        if(type_name.equals("pulldown"))
        {
            if(!default_val.equals(""))
            {
                textEmail += "\n" + display_name + " : " + default_val;
                htmlEmail += "\n<tr><td>" + display_name + ":</td><td>&nbsp;&nbsp;</td><td>" + default_val + "</td></tr>";
            }
        } else
        if(is_multiselect != null && is_multiselect.toUpperCase().equals("TRUE"))
        {
            if(default_val_array.length > 0)
            {
                textEmail += "\n" + display_name + " :";
                htmlEmail += "\n<tr><td>" + display_name + ":</td><td>&nbsp;&nbsp;</td><td>";
                arrSize = ftlm.getArraySizeFromDelimetedStr(default_val_from_DB, "|");
                String default_val_from_DBArray[] = new String[arrSize];
                default_val_from_DBArray = ftlm.splitIntoArray(default_val_from_DB, "|");
                arrSize = ftlm.getArraySizeFromDelimetedStr(default_display_val, "|");
                String defaultDisplayValArray[] = new String[arrSize];
                defaultDisplayValArray = ftlm.splitIntoArray(default_display_val, "|");
label0:
                for(int i = 0; i < default_val_array.length; i++)
                {
                    int x = 0;
                    do
                    {
                        if(x >= default_val_from_DBArray.length)
                        {
                            continue label0;
                        }
                        if(default_val_array[i].equals(default_val_from_DBArray[x]))
                        {
                            textEmail += "\n" + default_val_array[i];
                            htmlEmail += "<br>" + default_val_array[i];
                            continue label0;
                        }
                        x++;
                    } while(true);
                }

                htmlEmail += "<br></td></tr>";
            }
        } else
        if(is_multiselect != null && !is_multiselect.equals("") && is_multiselect.toUpperCase().equals("FALSE") && !default_val.equals(""))
        {
            textEmail += "\n" + display_name + " : " + default_val;
            htmlEmail += "\n<tr><td>" + display_name + ":</td><td>&nbsp;&nbsp;</td><td>" + default_val + "</td></tr>";
        }
    }

    private String breakLargeText(String largeText, String breakPointIndex, String format)
    {
        String retStr = "";
        int counter = 0;
        int breakIndex = Integer.parseInt(breakPointIndex);
        for(int i = 0; i < largeText.length(); i++)
        {
            counter = i;
            if(counter == breakIndex)
            {
                if(format.equals("html"))
                {
                    retStr = retStr + "<br>";
                } else
                {
                    retStr = retStr + "\n\t\t";
                }
                counter += breakIndex;
            }
            retStr = retStr + largeText.charAt(i);
        }

        return retStr;
    }

    public String getEmailBody(String bodyFormat)
    {
        if(bodyFormat.toUpperCase().equals("HTML"))
        {
            return htmlEmailHeader + htmlEmail + htmlEmailFooter;
        } else
        {
            return textEmail;
        }
    }

    public boolean isConfirmRequired(String form_id)
    {
        boolean retVal = false;
        try
        {
            Statement stmt = db.m_conn.createStatement();
            sqlString = "select flfr_id from form_layout_form_rel where form_id=" + form_id;
            CachedRowSet rset = db.runSQL(sqlString, stmt);
            if(rset.next())
            {
                sqlString = "select is_confirm_req from form_process where is_confirm_req='t' and flfr_id=" + rset.getString("flfr_id");
                rset = db.runSQL(sqlString, stmt);
                if(rset.next())
                {
                    retVal = true;
                }
            }
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println("An exception occurred in isConfirmRequired().");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
        return retVal;
    }

    public void copyFormProcess(String old_page_id, String new_page_id, String new_flfr_id)
    {
        String sqlString = "select form_process.name,form_process.url_or_email ,form_process.is_confirm_req " +
"from form_process,form_layout_form_rel where form_process.flfr_id=form_layout_fo" +
"rm_rel.flfr_id and form_layout_form_rel.page_id="
 + old_page_id;
        try
        {
            Statement stmt = db.m_conn.createStatement();
            sqlString = "";
            for(CachedRowSet rset = db.runSQL(sqlString, stmt); rset.next();)
            {
                sqlString = "insert into form_process (name, url_or_email, is_confirm_req, flfr_id) values ('" + rset.getString("name") + "','" + rset.getString("url_or_email") + "','" + rset.getString("is_confirm_req") + "'," + new_flfr_id + ")";
            }

            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println("An exception occurred in copyFormProcess().");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public String formProcess(HttpServletRequest p_request, String p_url, String p_page_id)
    {
        Vector feVector = null;
        CachedRowSet rset = null;
        Hashtable non_group_subscription = new Hashtable();
        FormElementsManager fem = new FormElementsManager();
        SendMail mailer = new SendMail();
        Form frm = new Form(db);
        ContentOutput contentoutput = new ContentOutput(p_request, p_page_id, db);
        String form_id = p_request.getParameter("form_id");
        String flfr_id = p_request.getParameter("flfr_id");
        String htmlEmailMessage = "";
        String textEmailMessage = "";
        String recipientEmailAddress = "";
        String default_val_from_DB = "";
        String strConfirmationMsg = "";
        String strReferrer = "";
        String sqlString = "";
        String form_layout_id = "";
        String type_name = "";
        String html_name = "";
        String group_id = "";
        String default_val = "";
        String default_display_val = "";
        String display_name = "";
        String is_multiselect = "";
        String is_selected = "";
        String recipientNameList = "";
        String singular_or_plural_recipient = "";
        String subscriber_id = "";
        String displayNames = "";
        String subscribers_name = "";
        String subscribers_email = "";
        String subscribers_id = "";
        String subs_ids = "";
        String formTableAlignment = "";
        String rad_delimitedStr_html_name = "";
        String chk_delimitedStr_html_name = "";
        String default_val_array[] = null;
        int counter = 0;
        boolean rad_html_name_was_used = false;
        boolean chk_html_name_was_used = false;
        boolean is_part_of_group = false;
        boolean is_in_edit_mode = false;
        boolean is_subscription_form = false;
        boolean email_confirmation_required = isConfirmRequired(form_id);
        try
        {
            Statement stmt = db.m_conn.createStatement();
            if(frm.isSubscriptionForm(form_id, ""))
            {
                is_subscription_form = true;
            }
            sqlString = "select form_layout_id from form_layout where form_id=" + form_id;
            rset = db.runSQL(sqlString, stmt);
            if(rset.next())
            {
                form_layout_id = rset.getString("form_layout_id");
                formTableAlignment = ftlm.getTableAlign(form_layout_id, stmt);
                feVector = fem.getFormElements(form_layout_id, db);
                for(int n = 0; n < feVector.size(); n++)
                {
                    FormElement formElement = (FormElement)feVector.elementAt(n);
                    display_name = formElement.getDisplayName();
                    type_name = formElement.getTypeName();
                    html_name = formElement.getHtmlName();
                    is_multiselect = formElement.getIsMultiSelect();
                    default_display_val = formElement.getDefaultDisplayVal();
                    default_val_from_DB = formElement.getDefaultVal();
                    if((type_name.equals("radiobutton") || type_name.equals("checkbox")) && (html_name == null || html_name.equals("")))
                    {
                        group_id = formElement.getGroupId();
                        html_name = fem.getElementGroupName(group_id, db);
                        is_part_of_group = true;
                        if(type_name.equals("radiobutton"))
                        {
                            if(!rad_delimitedStr_html_name.equals(""))
                            {
                                rad_delimitedStr_html_name = rad_delimitedStr_html_name + "|";
                                if(rad_delimitedStr_html_name.indexOf(html_name) == -1)
                                {
                                    rad_delimitedStr_html_name = rad_delimitedStr_html_name + html_name;
                                    rad_html_name_was_used = false;
                                } else
                                {
                                    rad_html_name_was_used = true;
                                }
                            } else
                            {
                                rad_delimitedStr_html_name = rad_delimitedStr_html_name + html_name;
                            }
                        }
                        if(type_name.equals("checkbox"))
                        {
                            if(!chk_delimitedStr_html_name.equals(""))
                            {
                                chk_delimitedStr_html_name = chk_delimitedStr_html_name + "|";
                                if(chk_delimitedStr_html_name.indexOf(html_name) == -1)
                                {
                                    chk_delimitedStr_html_name = chk_delimitedStr_html_name + html_name;
                                    chk_html_name_was_used = false;
                                } else
                                {
                                    chk_html_name_was_used = true;
                                }
                            } else
                            {
                                chk_delimitedStr_html_name = chk_delimitedStr_html_name + html_name;
                            }
                        }
                    }
                    if(is_multiselect != null && is_multiselect.toUpperCase().equals("TRUE"))
                    {
                        default_val_array = p_request.getParameterValues(html_name);
                        default_val = "";
                    } else
                    if(!type_name.equals("label"))
                    {
                        if(type_name.equals("checkbox") && is_part_of_group)
                        {
                            default_val_array = p_request.getParameterValues(html_name);
                            default_val = "";
                        } else
                        {
                            default_val = p_request.getParameter(html_name);
                        }
                    }
                    if(default_val == null || default_val.equals("null"))
                    {
                        default_val = "";
                    }
                    if(type_name.equals("label"))
                    {
                        continue;
                    }
                    if(type_name.equals("radiobutton"))
                    {
                        if(rad_html_name_was_used || default_val.equals(""))
                        {
                            continue;
                        }
                        if(is_subscription_form)
                        {
                            displayNames = fem.getChosenFormItem(form_layout_id, default_val_array, default_val, "", type_name, db);
                            non_group_subscription.put(displayNames, default_val);
                            if(email_confirmation_required)
                            {
                                setEmailBody("", type_name, html_name, default_val, default_val_from_DB, default_display_val, is_multiselect, default_val_array, is_part_of_group, group_id, is_subscription_form);
                            }
                        } else
                        {
                            setEmailBody("", type_name, html_name, default_val, default_val_from_DB, default_display_val, is_multiselect, default_val_array, is_part_of_group, group_id, is_subscription_form);
                        }
                        continue;
                    }
                    if(type_name.equals("checkbox"))
                    {
                        if(chk_html_name_was_used)
                        {
                            continue;
                        }
                        if(is_subscription_form)
                        {
                            if(html_name.toLowerCase().startsWith("subs_"))
                            {
                                displayNames = fem.getChosenFormItem(form_layout_id, default_val_array, default_val, "", type_name, db);
                                subs_ids = addToSubscribersGroupTable(displayNames);
                            } else
                            if(default_val.equals(""))
                            {
                                displayNames = fem.getChosenFormItem(form_layout_id, default_val_array, default_val, "", type_name, db);
                                non_group_subscription.put(displayNames, fem.m_default_val_str_array);
                            } else
                            {
                                displayNames = display_name;
                                non_group_subscription.put(displayNames, default_val);
                            }
                            if(email_confirmation_required)
                            {
                                setEmailBody(display_name, type_name, html_name, default_val, default_val_from_DB, default_display_val, is_multiselect, default_val_array, is_part_of_group, group_id, is_subscription_form);
                            }
                        } else
                        {
                            setEmailBody(display_name, type_name, html_name, default_val, default_val_from_DB, default_display_val, is_multiselect, default_val_array, is_part_of_group, group_id, is_subscription_form);
                        }
                        continue;
                    }
                    if(is_subscription_form)
                    {
                        if(!default_val.equals(""))
                        {
                            if(html_name.equals("subscription_name") || html_name.equals("subscription_email"))
                            {
                                if(html_name.equals("subscription_name"))
                                {
                                    subscribers_name = default_val;
                                } else
                                {
                                    subscribers_email = default_val;
                                }
                            } else
                            {
                                non_group_subscription.put(display_name, default_val);
                            }
                        } else
                        {
                            displayNames = fem.getChosenFormItem(form_layout_id, default_val_array, default_val, default_display_val, type_name, db);
                            non_group_subscription.put(displayNames, default_val_array);
                        }
                        if(email_confirmation_required)
                        {
                            setEmailBody(display_name, type_name, html_name, default_val, default_val_from_DB, default_display_val, is_multiselect, default_val_array, is_part_of_group, group_id, is_subscription_form);
                        }
                    } else
                    {
                        setEmailBody(display_name, type_name, html_name, default_val, default_val_from_DB, default_display_val, is_multiselect, default_val_array, is_part_of_group, group_id, is_subscription_form);
                    }
                }

            }
            textEmailMessage = getEmailBody(AppConstants.FORM_SUBMISSION_EMAIL_FORMAT);
            if(!is_subscription_form)
            {
                if(!textEmailMessage.equals("") && textEmailMessage.indexOf("LABEL_NOT_IN_GROUP") == -1)
                {
                    sqlString = "select name, url_or_email from form_process where flfr_id=" + flfr_id;
                    rset = db.runSQL(sqlString, stmt);
                    if(rset.next())
                    {
                        stmt.close();
                        try
                        {
                            do
                            {
                                recipientEmailAddress = rset.getString("url_or_email");
                                mailer.sendEmail(recipientEmailAddress, AppConstants.EMAIL_FORM_SUBJECT_HEADER, textEmailMessage, AppConstants.EMAIL_FORM_SENDER_ADDRESS);
                                if(counter != 0)
                                {
                                    recipientNameList = recipientNameList + ", ";
                                }
                                recipientNameList = recipientNameList + rset.getString("name");
                                counter++;
                            } while(rset.next());
                            recipientNameList = recipientNameList + ".&nbsp;";
                            if(counter > 1)
                            {
                                singular_or_plural_recipient = "These recipients";
                            } else
                            {
                                singular_or_plural_recipient = "This recipient";
                            }
                            strConfirmationMsg = "<p" + contentoutput.applyStyle(4) + " align='" + formTableAlignment + "'>You have successfully sent an email to <b>" + recipientNameList + "</b>" + singular_or_plural_recipient + " should receive your form information shortly.</p>";
                        }
                        catch(Exception e)
                        {
                            System.out.println("Trying to send an email - We have an exception!");
                            System.out.println("MESSAGE: " + e.getMessage());
                            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
                            System.out.println("CLASS.TOSTRING: " + e.toString());
                            strConfirmationMsg = "<p " + contentoutput.applyStyle(4) + " align='" + formTableAlignment + "'>An error occurred while sending an email to <b>" + recipientEmailAddress + "</b>." + "<br>Email sending was aborted.</p>";
                        }
                    } else
                    {
                        strConfirmationMsg = "<p" + contentoutput.applyStyle(4) + " align='" + formTableAlignment + "'>Email Sending Form Process did not execute," + " because there are no recipient found for this process.</p>";
                    }
                } else
                {
                    strConfirmationMsg = "<p" + contentoutput.applyStyle(4) + " align='" + formTableAlignment + "'>Sending Email form processing did not execute due to following errors " + "that may have occurred.<br><br>&nbsp;&nbsp;&nbsp;The form may have been incomple" +
"te.<br>"
 + "&nbsp;&nbsp;&nbsp;The form author may have created the form with errors.<br><br>" + "Please go back and complete the form and if problem persists,<br>" + "please notify the owner of this website.</p>";
                }
            } else
            {
                subscribers_id = addToSubscribersTable(subscribers_name, subscribers_email, non_group_subscription);
                if(email_confirmation_required && (!textEmailMessage.equals("") && textEmailMessage.indexOf("LABEL_NOT_IN_GROUP") == -1))
                {
                    textEmailMessage = "The following information has been submitted:\n\n" + textEmailMessage + "\n\n\nIf any of the above information is incorrect,\n" + "or you wish to update your details, please go to\n" + AppConstants.PUBLIC_SITE_URL + p_url;
                    mailer.sendEmail(subscribers_email, "Subscription Acknowledgement", textEmailMessage, AppConstants.EMAIL_FORM_SENDER_ADDRESS);
                }
                updateSubscriptionGroupsRel(subscribers_id, subs_ids);
                strConfirmationMsg = "<p" + contentoutput.applyStyle(4) + " align='" + formTableAlignment + "'>Your subscription request was successfully submitted.";
                if(email_confirmation_required)
                {
                    strConfirmationMsg = strConfirmationMsg + "<br>&nbsp;&nbsp;&nbsp; You should receive an email shortly confirming your subsc" +
"ription details.</p>"
;
                } else
                {
                    strConfirmationMsg = strConfirmationMsg + "</p>";
                }
            }
        }
        catch(Exception e)
        {
            System.out.println("Trying to create an email body - We have an exception!!!");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
            strConfirmationMsg = "<p " + contentoutput.applyStyle(4) + " align='" + formTableAlignment + "'>Form Process did not execute due to following errors " + "that may have occurred.<br><br>&nbsp;&nbsp;&nbsp;The form may have been incomple" +
"te.<br>"
 + "&nbsp;&nbsp;&nbsp;The form author may have created the form with errors.<br><br>" + "Please go back and complete the form and if problem persists,<br>" + "please notify the owner of this website.</p>";
        }
        return strConfirmationMsg;
    }
}
