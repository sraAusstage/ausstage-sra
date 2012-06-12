package content;

import admin.AppConstants;
import admin.Database;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import sun.jdbc.rowset.CachedRowSet;

public class SiteMap
{

    public Database db;
    private String SiteMapResultForDisplay;
    private int SiteMapNodeID;
    private AppConstants AppConstants;
    private String page_icon;

    public SiteMap(Database p_db)
    {
        SiteMapResultForDisplay = "";
        SiteMapNodeID = 0;
        AppConstants = new AppConstants();
        page_icon = AppConstants.SITE_MAP_PAGE_ICON;
        db = p_db;
    }

    public String getSiteMap(String addPageJoints)
    {
        try
        {
            updateSiteMapForDisplay(addPageJoints);
        }
        catch(Exception e)
        {
            System.out.println("An exception occurred trying to display the public site map");
        }
        return SiteMapResultForDisplay;
    }

    private void updateSiteMapForDisplay(String addpagejoints)
    {
        String sqlString = "";
        String m_parent_id = "";
        String m_url = "";
        String sect_id = "";
        String linkBASE = "";
        String linkBASE_orig = "";
        String c_sqlString = "";
        int tmpNodeID = 0;
        int parentNode = 0;
        int SubParentNode = 0;
        Map c_sectionAccess = new HashMap();
        try
        {
            linkBASE = "";
            linkBASE_orig = linkBASE;
            Statement stmt1 = db.m_conn.createStatement();
            Statement c_stmt1 = db.m_conn.createStatement();
            c_sqlString = "select sections.title, sections.sect_id from sections";
            CachedRowSet rset3;
            String c_sect_id;
            String c_sect_title;
            for(rset3 = db.runSQL(c_sqlString, c_stmt1); rset3.next(); c_sectionAccess.put(c_sect_id, c_sect_title))
            {
                c_sect_id = rset3.getString("sect_id");
                c_sect_title = rset3.getString("title");
            }

            if(c_sectionAccess.isEmpty())
            {
                c_sectionAccess.put("0", "0");
            }
            rset3.close();
            c_stmt1.close();
            SiteMapResultForDisplay = "<style type=text/css>\n";
            SiteMapResultForDisplay += " #tree a {\tcolor: #000;\ttext-decoration: none;}\n";
            SiteMapResultForDisplay += " #tree img {\tborder: 0px;\twidth: 19px;\theight: 16px;}\n";
            SiteMapResultForDisplay += "</style>\n";
            SiteMapResultForDisplay += "<script type='text/javascript' src='/js/tree.js'></script>\n";
            SiteMapResultForDisplay += "<script type='text/javascript'>\n";
            SiteMapResultForDisplay += "<!--\n";
            SiteMapResultForDisplay += " var Tree = new Array();\n";
            SiteMapResultForDisplay += " // nodeId | parentNodeId | nodeName | nodeUrl | iconName\n";
            sqlString = "SELECT pages.*, sections.order_id, sections.sect_id FROM pages, sections WHERE p" +
"ages.parent_id = 0 AND pages.sect_id = sections.sect_id AND pages.is_approved = " +
"'t' AND pages.hidden_page= 'f' ORDER by sections.order_id"
;
            CachedRowSet rset1 = db.runSQL(sqlString, stmt1);
            for(SiteMapNodeID = 0; rset1.next(); SiteMapNodeID++)
            {
                m_parent_id = rset1.getString("page_id");
                m_url = rset1.getString("url");
                sect_id = rset1.getString("sect_id");
                linkBASE = linkBASE_orig;
                tmpNodeID = SiteMapNodeID + 1;
                SiteMap _tmp = this;
                String pageImage = AppConstants.SITE_MAP_PAGE_ICON;
                String tmpURL = linkBASE + "" + m_url;
                SiteMapResultForDisplay += "Tree[" + SiteMapNodeID + "] = \"" + tmpNodeID + "|0|" + rset1.getString("title") + "|" + tmpURL + "|" + pageImage + "\";\n";
                generateChildNodesForDisplay(m_parent_id, tmpNodeID, linkBASE, c_sectionAccess);
            }

            rset1.close();
            stmt1.close();
            SiteMapResultForDisplay += "//-->\n";
            SiteMapResultForDisplay += "</script>\n";
            SiteMapResultForDisplay += "<table border='0' cellspacing='0' cellpadding='0'>\n";
            SiteMapResultForDisplay += " <tr>\n";
            SiteMapResultForDisplay += "  <td>\n";
            SiteMapResultForDisplay += "   <div id='tree' align='left'>\n";
            SiteMapResultForDisplay += "    <script type='text/javascript'>\n";
            SiteMapResultForDisplay += "     <!--\n";
            SiteMapResultForDisplay += "      createTree(Tree, '" + page_icon + "', '" + addpagejoints + "');\n";
            SiteMapResultForDisplay += "     //-->\n";
            SiteMapResultForDisplay += "    </script>\n";
            SiteMapResultForDisplay += "   </div>\n";
            SiteMapResultForDisplay += "  </td>\n";
            SiteMapResultForDisplay += " </tr>\n";
            SiteMapResultForDisplay += "</table>\n";
        }
        catch(Exception e)
        {
            System.out.println("An exception occurred trying to generate the SiteMap: " + e.toString());
        }
    }

    private void generateChildNodesForDisplay(String m_parent_id, int parentNode, String linkBASE, Map c_sectionAccess)
    {
        String siteMap = "";
        String sqlString = "";
        String real_page_id = "";
        String m_url = "";
        int tmpNodeID = 0;
        try
        {
            Statement stmt1 = db.m_conn.createStatement();
            sqlString = "SELECT * FROM pages WHERE parent_id = " + m_parent_id + " AND is_approved = 't'";
            CachedRowSet rset1;
            for(rset1 = db.runSQL(sqlString, stmt1); rset1.next(); generateChildNodesForDisplay(m_parent_id, tmpNodeID, linkBASE, c_sectionAccess))
            {
                m_url = rset1.getString("url");
                String sect_id = rset1.getString("sect_id");
                m_parent_id = rset1.getString("page_id");
                String pageImage = "page.gif";
                String tmpURL = linkBASE + "" + m_url;
                SiteMapNodeID++;
                tmpNodeID = SiteMapNodeID + 1;
                SiteMapResultForDisplay += "Tree[" + SiteMapNodeID + "] = \"" + tmpNodeID + "|" + parentNode + "|" + rset1.getString("title") + "|" + tmpURL + "|" + pageImage + "\";\n";
            }

            rset1.close();
            stmt1.close();
        }
        catch(Exception e)
        {
            System.out.println("An exception occurred trying to generate public site map child nodes.");
        }
    }
}
