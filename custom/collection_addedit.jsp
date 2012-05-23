<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "ausstage.WebLinks, java.sql.*, sun.jdbc.rowset.*, ausstage.Collection, admin.Common, java.util.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin     login             = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage        pageFormater      = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database          db_ausstage       = new ausstage.Database ();
  ausstage.Collection     collectionObj     = new ausstage.Collection(db_ausstage);
  ausstage.Entity         entityObj         = new ausstage.Entity(db_ausstage);
  ausstage.CollInfoAccess collInfoAccessObj = new ausstage.CollInfoAccess(db_ausstage);
  ausstage.Materials      materialsObj      = new ausstage.Materials(db_ausstage);
  ausstage.MaterialLink   materialLinkObj   = new ausstage.MaterialLink(db_ausstage);
  ausstage.WebLinks       webLinksObj       = new ausstage.WebLinks(db_ausstage);
  String                  mode              = "";

  int                   collectionInformationId   = 0;
  Vector                allMaterialLinks          = new Vector();
  String                collection_information_id = null;
  CachedRowSet          rset;

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  // Are we editting, adding, or coming back from editting Web Links?
  mode = request.getParameter ("mode");
  if (mode == null) // Have come back from editting WebLinks
  {
    mode = (String)session.getAttribute("collectionMode");
    collectionObj = (Collection)session.getAttribute("collectionObj");
    collection_information_id = collectionObj.getCollectionInformationId ();
    try {collectionInformationId = Integer.parseInt(collection_information_id);}
    catch(Exception e) {}
    allMaterialLinks = collectionObj.getMaterialsVector();
  }
  else
  {
    collection_information_id = request.getParameter ("f_id");
    try {collectionInformationId = Integer.parseInt(collection_information_id);}
    catch(Exception e) {}
    mode = "add"; // Mode is really "add" if no collection information id was selected.
    // if editing
    if (collection_information_id != null)
    {
      mode = "edit";
      collectionObj.load(collectionInformationId);
      allMaterialLinks = materialLinkObj.getMaterialLinksForCollection(
                                collectionInformationId);
    }
  }

  %>
  <form name='thisForm' action='collection_addedit_process.jsp' method='post'>
  <input type='hidden' name='h_collection_id' value='<%=collection_information_id%>'>
  <%
  	pageFormater.writeHelper(out, "Enter the Collection Details", "helpers_no1.gif");
    out.println("<input type=\"hidden\" name=\"f_id\" value=\"" + collection_information_id + "\">");

    // Entities
    pageFormater.writeTwoColTableHeader(out, "ID");
    if(collection_information_id != null && !collection_information_id.equals(""))
      out.println(collection_information_id);
    pageFormater.writeTwoColTableFooter(out);
    pageFormater.writeTwoColTableHeader(out, "Entity");
    out.println("<select name=\"f_entity\" size=\"1\" class=\"line250\">");
    rset = entityObj.getEntities (stmt);

    // Display all of the Entities
    while (rset.next())
    {
      out.print("<option value='" + rset.getString ("entity_id") + "'");

      if (collectionObj.getEntity().equals(rset.getString("entity_id")))
        out.print(" selected");
      out.print(">" + rset.getString ("name") + "</option>");
    }
    rset.close ();
    
    out.println("</select>");
    out.println("<a href=\"entity_admin.jsp?f_from=collection_addedit&coll_id=" + collection_information_id + "\"><img border='0' src='" + AppConstants.IMAGE_DIRECTORY + "/edit.gif'></a>");
    pageFormater.writeTwoColTableFooter(out);

    pageFormater.writeTwoColTableHeader(out, "Collection Name");
    out.println("<input type=\"text\" name=\"f_collection_name\" size=\"20\" class=\"line300\" maxlength=100 value=\"" + collectionObj.getCollectionName() + "\">");
    pageFormater.writeTwoColTableFooter(out);

    pageFormater.writeTwoColTableHeader(out, "Description");
    out.println("<textarea name='f_description' rows='5' cols='10' class='line300'>" + collectionObj.getDescription() + "</textarea>");
    pageFormater.writeTwoColTableFooter(out);

    pageFormater.writeTwoColTableHeader(out, "Size");
    out.println("<input type=\"text\" name=\"f_size\" size=\"20\" class=\"line300\" maxlength=200 value=\"" + collectionObj.getSize() + "\">");
    pageFormater.writeTwoColTableFooter(out);

    pageFormater.writeTwoColTableHeader(out, "Location");
    out.println("<input type=\"text\" name=\"f_location\" size=\"20\" class=\"line300\" maxlength=100 value=\"" + collectionObj.getLocation() + "\">");
    pageFormater.writeTwoColTableFooter(out);

    // Accesses
    pageFormater.writeTwoColTableHeader(out, "Access");
    out.println("<select name=\"f_access\" size=\"1\" class=\"line300\">");
    rset = collInfoAccessObj.getCollInfoAccesses ();

    // Display all of the Accesses
    while (rset.next())
    {
      out.print("<option value='" + rset.getString ("collection_info_access_id") + "'");

      if (collectionObj.getAccess().equals(rset.getString("collection_info_access_id")))
        out.print(" selected");
      out.print(">" + rset.getString ("coll_access") + "</option>");
    }
    rset.close ();
    
    out.println("</select>");
    pageFormater.writeTwoColTableFooter(out);

    pageFormater.writeTwoColTableHeader(out, "Other Access Details");
    out.println("<input type=\"text\" name=\"f_access_other_detail\" size=\"20\" class=\"line300\" maxlength=100 value=\"" + collectionObj.getAccessOtherDetail() + "\">");
    pageFormater.writeTwoColTableFooter(out);

    pageFormater.writeTwoColTableHeader(out, "Related Sources");
    out.println("<textarea name='f_related_sources' rows='5' cols='10' class='line300'>" + collectionObj.getRelatedSources() + "</textarea>");
    pageFormater.writeTwoColTableFooter(out);

    pageFormater.writeTwoColTableHeader(out, "Comments");
    out.println("<textarea name=\"f_comments\" rows='5' cols='10' class='line300'>" + collectionObj.getComments() + "</textarea>");
    pageFormater.writeTwoColTableFooter(out);
    // Web Links
    pageFormater.writeTwoColTableHeader(out, "On Line Sources (0 or many)");

    Vector allWebLinks = null;
    if (mode.equals("add"))
      allWebLinks = (Vector)session.getAttribute("allWebLinks");
    else
      rset = webLinksObj.getAllWebLinks (stmt);

    // Display all of the Web Links for this Collection
    if (mode.equals("add") && allWebLinks != null)
    {
      for (int i=0; i < allWebLinks.size(); i++)
      {
        webLinksObj = (ausstage.WebLinks)allWebLinks.get(i);
        out.print(webLinksObj.getWebLinksName() + "<br>");
      }
    }
    else
    {
      while (rset.next())
      {
        if (rset.getInt("collection_information_id") == collectionInformationId)
          out.print(rset.getString("weblinks") + "<br>");
      }
      rset.close ();
    }
    
    out.print("<td width=30><a style='cursor:hand' " +
              "onclick=\"Javascript:thisForm.action='web_links_admin.jsp?mode=" + mode + "';" +
              "thisForm.submit();\"><img border='0' src='" +
              AppConstants.IMAGE_DIRECTORY + "/edit.gif'></a></td>");
    pageFormater.writeTwoColTableFooter(out);

    // Materials
    // Now display all Materials records, highlighting those relating to this Collection.
    pageFormater.writeTwoColTableHeader(out, "Materials (0 or many)");
    out.println("<select name='f_materials' size='7' class='line300' multiple>");
    
    rset = materialsObj.getAllMaterials (stmt);

   // Display all of the Materials
    while (rset.next())
    {
      out.print("<option value='" + rset.getInt("material_id") + "'");

      if (allMaterialLinks.contains(new Integer(rset.getInt("material_id"))))
        out.print(" selected");
      out.print(">" + rset.getString ("materials") + "</option>");
    }
    rset.close ();
    
    out.println("</select>");
    pageFormater.writeTwoColTableFooter(out);

    Common common = new Common();

    pageFormater.writeTwoColTableHeader(out, "Date Entered");
    out.print(common.formatDate(collectionObj.getDateEntered(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Updated");
    out.print(common.formatDate(collectionObj.getDateUpdated(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Input Person");
    out.print(collectionObj.getInputPerson());
    pageFormater.writeTwoColTableFooter(out);
    
    db_ausstage.disconnectDatabase();
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
    pageFormater.writeFooter(out);
  %>
</form><cms:include property="template" element="foot" />
