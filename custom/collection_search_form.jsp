<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%admin.AppConstants ausstage_search_appconstants_for_collection_form = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<cms:include property="template" element="head" />
<jsp:useBean id="admin_db_for_collection_form" class="ausstage.Database" scope="application">
<%admin_db_for_collection_form.connDatabase(ausstage_search_appconstants_for_collection_form.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_collection_form.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean><%content.ContentOutput ausstage_search_page_output_for_collection_form = new content.ContentOutput(request, request.getParameter("xcid"), admin_db_for_collection_form);%>

<%

  String search_within_search_for_collection_form = request.getParameter("f_search_within_search");
  String xcid_for_collection_form = request.getParameter("xcid");

  // set the search_within_search_for_collection_form variable
  if(search_within_search_for_collection_form == null){search_within_search_for_collection_form ="";}
  

    ///////////////////////////////////
    //    DISPLAY SEARCH PAGE
    //////////////////////////////////

%>
  <form name="searchform" id="searchform" method="post" action ="<%=AusstageCommon.collection_index_search_result_page%>" onsubmit="return checkFileds();">
  <input type="hidden" name="xcid" value="<%=xcid_for_collection_form%>">
<%
  if(!search_within_search_for_collection_form.equals(""))
    out.println("<input type='hidden' name='f_search_within_search' value='"+ search_within_search_for_collection_form + "'>");
  
%>
<style>
.search_text
{
  font-family:Verdana;
  font-size:11px;
  color:#FFFFFF;
  font-weight:normal;
  text-decoration:none;
  font-style:normal;
}

.fsearch {
	padding:0px;
	padding-left:0px;
	font-size: 10px;
	color: #000;
	border-left: 1px solid #5D9149;
	border-right: 1px solid #629047;
	border-bottom: 1px solid #648F48;
	border-top: 1px solid #639148;
}
</style>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="550">
  <tr>
    <td align="left" valign="top" bgcolor="#A0CA75">
    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
      <tr>
        <td rowspan="2" align="left" valign="top">
        <img border="0" src="/images/spacer.gif" width="24" height="24"></td>
        <td align="left" valign="top" colspan="2"><b>
        <font face="Verdana" color="#FFFFFF" size="1">Enter your 
        keyword(s):</font></b></td>
      </tr>
      <tr>
        <td align="left" width=100%>
          <table cellspacing=0 cellpadding=0 border=0 width=100%>
          <tr>
            <td><img border="0" src="/custom/files/ausstagehomebigarrow.gif"></td>
            <td class="search_text" width=100% align=right valign=top>
              <br>
              <table cellpadding=0 cellspacing=0 border=0 width=100%>
              <tr>
                <td>&nbsp;&nbsp;&nbsp;</td>
                <td class="search_text" valign=top>
                  <table cellpadding=0 cellspacing=0 border=0>
                  <tr>
                    <td>
                      <input type="text" name="f_keyword" size="34" class="fsearch" maxlength="60">
                    </td>
                    <td>&nbsp;</td>
                    <td>
                      <a href="javascript:onclick=document.searchform.submit();" onMouseOut="MM_swapImgRestore();" onMouseOver="MM_swapImage('Image1','','/custom/files/ausstage_home_searchon.gif',1);" name="babbtn">
                      <input type="image" border="0" src="/custom/files/ausstagehomesearchbutton.gif" name="Image1"></a>
                    </td>
                    </tr>
                    <tr>
                      <td colspan=3 class="search_text">
                        <input type="radio" name="f_sql_switch" value="and" checked>and&nbsp;
                        <input type="radio" name="f_sql_switch" value="or">or&nbsp;
                        <input type="radio" name="f_sql_switch" value="exact">exact phrase
                      </td>
                    </tr>
                    </table>
                </td>
              </tr>
              </form>
              </table>
            </td>
          </tr>
          </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>



  <script language="javascript">
  <!--

    function checkFileds(){

      var msg ="";
      if(isBlank(document.searchform.f_keyword.value)){
        msg += "\t- Keyword\n";
      }

      if(msg != ""){
        alert("You have not entered the correct value(s) for\n" + msg + "Please press OK and fill in the required field(s).");
        return(false);
      }else{
        return(true);
      }
    }
    
   function isBlank(s) {
     if((s == null)||(s == "")) 
      return true;
     for(var i=0;i<s.length;i++) {
      var c=s.charAt(i);
      if((c != ' ') && (c !='\n') && (c != '\t')) return false;
     }
     return true;
   }

  function isInteger (s){
    var i;
    var c;


      // Search through string's characters one by one
      // until we find a non-numeric character.
      // When we do, return false; if we don't, return true.

      for (i = 0; i < s.length; i++){   
          // Check that current character is number.
          c = s.charAt(i);
          if (!isDigit(c)) 
            return false;
      }
      // All characters are numbers.
      return true;
  }

  function isDigit (c){
    return ((c >= "0") && (c <= "9"))
  }
  MM_preloadImages('/custom/ausstage/images/ausstage_home_searchon.gif');

  function MM_preloadImages() { 
   var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
     var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
     if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
  }

  function MM_swapImgRestore() { 
   var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
  }

  function MM_findObj(n, d) { 
   var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
     d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
   if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
   for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
  }

  function MM_swapImage() {

   var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
  }
  //-->
  </script>
<cms:include property="template" element="foot" />