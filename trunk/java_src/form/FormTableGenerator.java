package form;

import admin.AppConstants;
import admin.Database;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.Statement;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package form:
//            FormTableLayoutManager, Form

public class FormTableGenerator extends FormTableLayoutManager
{

    String htmlFormTableHeader;
    String htmlFormTableFooter;
    String htmlFormFooter;
    String form_layout_id;
    String finalFormHeader;
    String finalFormHtmlStr;
    String htmlFormHeadEnder;
    String finalhtmlFormFooter;
    String finalhtmlFormTableHeader;
    String finalJavaScript;
    String onSubmitEvent;
    String RowCol;
    String htmlFormTable;

    public FormTableGenerator(String form_layout_id, Database db)
    {
        super(db);
        htmlFormTableHeader = "";
        htmlFormTableFooter = "";
        htmlFormFooter = "";
        this.form_layout_id = "";
        finalFormHeader = "";
        finalFormHtmlStr = "";
        htmlFormHeadEnder = "";
        finalhtmlFormFooter = "";
        finalhtmlFormTableHeader = "";
        finalJavaScript = "";
        onSubmitEvent = "";
        RowCol = "";
        htmlFormTable = "";
        AppConstants appConstants = new AppConstants();
        this.form_layout_id = form_layout_id;
        htmlFormTableFooter = "</table>\n";
        String rows = "";
        String cols = "";
        String cellpadd = "";
        String cellspace = "";
        String border = "";
        String width = "";
        String align = "";
        String l_cellpadd = "";
        String l_cellspace = "";
        String l_border = "";
        String l_width = "";
        String l_align = "";
        String form_id = "";
        String form_name = "";
        String form_type = "";
        String form_method = "";
        String is_multipart = "";
        String submit_caption = "";
        String reset_caption = "";
        String cancel_back_caption = "";
        String htmlFormHeader = "";
        Form frm = new Form(db);
        try
        {
            Statement stmt = db.m_conn.createStatement();
            CachedRowSet rset = getTableSettings(form_layout_id, stmt);
            rset.next();
            rows = rset.getString("layout_table_rows");
            cols = rset.getString("layout_table_cols");
            form_id = rset.getString("form_id");
            cellpadd = rset.getString("layout_table_cellpadd");
            cellspace = rset.getString("layout_table_cellspace");
            border = rset.getString("layout_table_border");
            width = rset.getString("layout_table_width");
            align = rset.getString("layout_table_align");
            if(cellpadd == null || cellpadd.equals(""))
            {
                cellpadd = "";
            } else
            {
                l_cellpadd = "cellpadding='" + cellpadd + "'";
            }
            if(cellspace == null || cellspace.equals(""))
            {
                cellspace = "";
            } else
            {
                l_cellspace = "cellspacing='" + cellspace + "'";
            }
            if(border == null || border.equals(""))
            {
                border = "";
            } else
            {
                l_border = "border='" + border + "'";
            }
            if(width == null || width.equals(""))
            {
                width = "";
            } else
            {
                l_width = "width='" + width + "'";
            }
            if(align == null || align.equals("") || align.toUpperCase().equals("NONE"))
            {
                align = "";
            } else
            {
                l_align = "align='" + align + "'";
            }
            rset = frm.getFormSettings(stmt, form_id);
            rset.next();
            form_name = rset.getString("form_name");
            form_type = rset.getString("form_type");
            form_method = rset.getString("form_method");
            is_multipart = rset.getString("is_multipart");
            submit_caption = rset.getString("submit_caption");
            reset_caption = rset.getString("reset_caption");
            cancel_back_caption = rset.getString("cancel_back_caption");
            if(is_multipart != null && !is_multipart.equals("") && is_multipart.toUpperCase().equals("Y"))
            {
                htmlFormHeadEnder = " enctype='MULTIPART/FORM-DATA'>\n";
            } else
            {
                htmlFormHeadEnder = ">\n";
            }
            if(submit_caption == null || submit_caption.equals(""))
            {
                submit_caption = "";
            }
            if(reset_caption == null || reset_caption.equals(""))
            {
                reset_caption = "";
            }
            if(is_multipart == null || is_multipart.equals(""))
            {
                is_multipart = "";
            }
            if(cancel_back_caption == null || cancel_back_caption.equals(""))
            {
                cancel_back_caption = "";
            }
            RowCol = getLayoutTableStructure(form_layout_id, width, rows, cols);
            finalhtmlFormTableHeader = "<table " + l_width + " " + l_cellpadd + " " + l_cellspace + " " + l_border + " " + l_align + ">\n";
            finalJavaScript = getFinalJavaScriptValidator();
            if(!finalJavaScript.equals(""))
            {
                onSubmitEvent = "onsubmit='Javascript:return validateForm();'";
            }
            finalFormHeader = "\n<form name='" + form_name + "' method='" + form_method + "' action='' " + onSubmitEvent + " " + htmlFormHeadEnder + "\n" + "<input type='hidden' name='form_id' value='" + form_id + "'>\n" + "<input type='hidden' name='is_post_to_itself' value='true'>\n" + "\n\t" + finalhtmlFormTableHeader;
            finalFormHtmlStr = finalFormHeader + getFinalHtmlFormStr("");
            finalhtmlFormFooter = "\n<tr><td colspan='" + cols + "'>\n" + finalhtmlFormTableHeader + "<tr>\n<td align='left'>" + "<input class=INPUT_BUTTON type='button' onclick='Javascript:history.back();' val" +
"ue='"
 + cancel_back_caption + "'></td>\n<td align='center'><input class=INPUT_BUTTON type='reset' value='" + reset_caption + "'></td>\n<td align='right'><input class=INPUT_BUTTON type='submit' value='" + submit_caption + "'></td>\n</tr>" + htmlFormTableFooter + "\n</td></tr>" + htmlFormTableFooter;
            finalFormHtmlStr += finalhtmlFormFooter;
            updateFormHtmlLayout(finalJavaScript + finalFormHtmlStr, form_layout_id, stmt);
            htmlFormTableHeader = "<table width='" + width + "' cellpadding='0' cellspacing='0' border='1' align='center'>\n";
            htmlFormHeader = "\n\n<form method='POST' name='editForm' action='content_form_edit_element_locati" +
"on.jsp'>\n<input type='hidden' name='element_id' value=''>\n<input type='hidden'" +
" name='form_layout_id' value='"
 + form_layout_id + "'>\n" + "<input type='hidden' name='direction' value=''>\n" + "<input type='hidden' name='form_id' value='" + form_id + "'>\n" + "<input type='hidden' name='form_name' value='" + form_name + "'>\n" + "<input type='hidden' name='form_type' value='" + form_type + "'>\n" + "<input type='hidden' name='isreturned' value='true'>\n" + "<input type='hidden' name='isAdded' value=''>\n" + "<input type='hidden' name='layout' value=''>\n";
            htmlFormTable = htmlFormHeader + getFormEditControls(form_layout_id) + htmlFormTableHeader + RowCol + htmlFormTableFooter;
            stmt.close();
        }
        catch(Exception e)
        {
            System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
            System.out.println("Trying to generate a form table - We have an exception!!!");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
            System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
        }
    }

    public String getFormTableStructure()
    {
        return htmlFormTable;
    }

    public String getFormEditControls()
    {
        return getFormEditControls(form_layout_id);
    }

    public String getRowColOutput()
    {
        return RowCol;
    }
}
