<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import="org.opencms.jsp.*,com.opencms.file.*,java.util.*" %>
 
<%!
//private static final String NAVDIRECTIONKEY = "NavDirection";
private static final String NAVDIRECTIONKEY = "Title";

public void buildSiteMap(CmsJspActionElement cms, 
  String uri, java.io.Writer out, boolean onlyShowCurrent, String currentFolder, String currentPage, int indent) throws Exception { 
  String desc;
  String navText = "";
  int fromIndex = 0;
  int toIndex = 0;
  int navTextMaxLen = 25;

  List navList = cms.getNavigation().getNavigationForFolder(uri);
  
  // Check direction
  if (cms.property(NAVDIRECTIONKEY, uri, "down").equals("up")) { java.util.Collections.reverse(navList); }

  if (navList.size() > 0) 
  {
    Iterator navItem = navList.iterator();
    CmsJspNavElement nav, link;
    String target;
    String spacer = "";
    while (navItem.hasNext())
    {
      nav = (CmsJspNavElement) navItem.next();  
      if (nav.getNavTreeLevel() > indent+1) {
      	spacer = " expanded";
      }
      if (nav != null) 
      {
        navText = nav.getNavText();
        toIndex = navText.indexOf("<");
        if (toIndex > navTextMaxLen || toIndex == -1) {toIndex = navTextMaxLen;}

        if (navText.length() > toIndex)
        {
          fromIndex = navText.indexOf(" ", toIndex);
          if (fromIndex < toIndex) {fromIndex = toIndex;}
          navText = navText.substring(0, fromIndex)+" ...";
        }

        if (nav.isFolderLink()) 
        {
          link = getFolderLink(cms, nav.getResourceName());
          if (link == null) {
            target = nav.getResourceName().substring("/system/modules/au.edu.flinders.ausstage".length());
          } else {
            target = link.getResourceName().substring("/system/modules/au.edu.flinders.ausstage".length());
          }

          if (currentFolder.indexOf(nav.getResourceName()) > -1)
          {
            out.write("<li><a class='family_links_current current" + spacer + "' href='" + target + "'>" + navText + "</a></li>\n");
          } else {
            out.write("<li><a class='family_links_current" + spacer + "' href='" + target + "'>" + navText + "</a></li>\n");
          }
          if ( (currentFolder.indexOf(nav.getResourceName()) > -1 && onlyShowCurrent) || !onlyShowCurrent) buildSiteMap(cms, nav.getResourceName(), out, onlyShowCurrent, currentFolder, currentPage, indent);
        } else {
          if (nav.getResourceName().equals(currentPage))
          {
            out.write("<li><a href='?' class='current family_links_current" + spacer + "'>" + navText + "</a></li>\n");
          } else {
            out.write("<li><a class='family_links_current" + spacer + "' href='" + nav.getResourceName().substring("/system/modules/au.edu.flinders.ausstage".length()) + "' >" + navText + "</a></li>\n");
          }
        }
      }
    }
  }
}

public CmsJspNavElement getFolderLink(org.opencms.jsp.CmsJspActionElement cms, String folderUri)
{
  List navList = cms.getNavigation().getNavigationForFolder(folderUri);
  CmsJspNavElement nav;
  Iterator navItem;
  CmsJspNavElement link;
  // Check direction
  if (cms.property(NAVDIRECTIONKEY, folderUri, "down").equals("up")) { java.util.Collections.reverse(navList); }
  if (cms.property("default-file",folderUri)!=null && !cms.property("default-file",folderUri).equals("")) {
    return null;
  }
 
  if (navList.size() > 0) 
  {
    // First check files
    navItem = navList.iterator();
    while (navItem.hasNext()) {
      nav = (CmsJspNavElement) navItem.next();
      if (nav != null && !nav.isFolderLink()) {
        return nav;
      }
    }

    // then check folders
    navItem = navList.iterator();
    while (navItem.hasNext()) {
      nav = (CmsJspNavElement) navItem.next();
      if (nav != null && nav.isFolderLink()) {
        link = getFolderLink(cms, nav.getResourceName());
        if (link != null) {
          return link;
        }
      }
    }
  }
  // No valid link found ... return null
  return null;
}
%>
<%

//CmsJspActionElement cms = new CmsJspActionElement(pageContext, request, response);

 
String startingFolder = "/system/modules/au.edu.flinders.ausstage/pages/learn/";

String currentFolder = cms.getRequestContext().getFolderUri();
String currentMenuPage = cms.getRequestContext().getUri();
int indent = (new StringTokenizer(startingFolder,"/")).countTokens() - 1;

buildSiteMap(cms, startingFolder, out, true, currentFolder, currentMenuPage, indent);

%>