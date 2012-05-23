package form;

import admin.Database;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.Statement;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package form:
//            FormTableGenerator, FormTableLayoutManager

public class FormLayoutManager
{

    private String form_layout_id;
    private String FormTableStructure;
    private String sqlString;
    private Database db;
    private Statement stmt;
    private CachedRowSet rset;
    private FormTableLayoutManager ftlm;
    private FormTableGenerator formTableGenerator;

    public FormLayoutManager(String form_layout_id, Database p_db)
    {
        this.form_layout_id = "";
        FormTableStructure = "";
        sqlString = "";
        try
        {
            this.form_layout_id = form_layout_id;
            db = p_db;
            formTableGenerator = new FormTableGenerator(form_layout_id, db);
            FormTableStructure = formTableGenerator.getFormTableStructure();
        }
        catch(Exception e)
        {
            System.out.println("Trying to generate the Html table");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public FormLayoutManager(Database p_db)
    {
        form_layout_id = "";
        FormTableStructure = "";
        sqlString = "";
        try
        {
            db = p_db;
            stmt = db.m_conn.createStatement();
            ftlm = new FormTableLayoutManager(p_db, stmt);
        }
        catch(Exception e)
        {
            System.out.println("Trying to construct FormLayoutManager()");
            System.out.println("MESSAGE: " + e.getMessage());
            System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
            System.out.println("CLASS.TOSTRING: " + e.toString());
        }
    }

    public CachedRowSet getFormLayout(String form_id)
        throws Exception
    {
        sqlString = "select form_layout_id, layout_table_rows, layout_table_cols, layout_table_cellpa" +
"dd, layout_table_cellspace, layout_table_border, layout_table_width, layout_tabl" +
"e_align from form_layout where form_id="
 + form_id;
        try
        {
            rset = db.runSQL(sqlString, stmt);
            if(rset.next())
            {
                FormTableStructure = ftlm.getFormHtmlLayout(rset.getString("form_layout_id"), stmt);
            }
        }
        catch(Exception e)
        {
            System.out.println("Trying to execute getFormLayout()");
            throw e;
        }
        return rset;
    }

    public String CopyFormLayout(String layout_table_rows, String layout_table_cols, String layout_table_cellpadd, String layout_table_cellspace, String layout_table_border, String layout_table_width, String layout_table_align, 
            String form_id, Statement stmt)
        throws Exception
    {
        String form_layout_id = "";
        try
        {
            ftlm.addFormLayout(form_id, layout_table_rows, layout_table_cols, layout_table_cellpadd, layout_table_cellspace, layout_table_border, layout_table_width, layout_table_align, stmt);
            form_layout_id = db.getInsertedIndexValue(stmt, "form_layout_id_seq");
        }
        catch(Exception e)
        {
            System.out.println("Trying to execute CopyFormLayout()");
            throw e;
        }
        return form_layout_id;
    }

    public String getHtmlFormTableStructure()
    {
        return FormTableStructure;
    }

    public String getFormEditControls()
    {
        return formTableGenerator.getFormEditControls(form_layout_id);
    }

    public String getRowColOutput()
    {
        return formTableGenerator.getRowColOutput();
    }
}
