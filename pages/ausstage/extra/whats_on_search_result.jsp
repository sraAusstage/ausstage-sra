<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.util.Calendar, java.util.StringTokenizer, java.text.SimpleDateFormat, java.sql.*, sun.jdbc.rowset.*, ausstage.*"%>
<%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%>

<%!
public String concatFields(Vector fields, String token) {
  String ret = "";
  for (int i=0; i<fields.size(); i++) {
    if (fields.elementAt(i) != null) {
        if (!(fields.elementAt(i)).equals("") && !ret.equals("")) {
          ret += token;
        }
        ret += fields.elementAt(i);
    }
  }

  return ret;
}

public String formatDate(String day, String month, String year)
{

  if (year == null || year == "" ){
    return "";
  
  }
  Calendar calendar = Calendar.getInstance();
  

   
  SimpleDateFormat formatter = new SimpleDateFormat();
  if (month == null || month == "" ){
    formatter.applyPattern("yyyy");
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
  
  }
  else if(day == null || day == "" ){
    formatter.applyPattern("MMM yyyy");
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
    
  }
  else{
    formatter.applyPattern("dd MMM yyyy");
    calendar.set(Calendar.DAY_OF_MONTH  ,new Integer(day).intValue());
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
  }

  java.util.Date date = calendar.getTime();
  
  
  String result = formatter.format(date);
  //System.out.println(result + " " + day + month + year);

  return result;

}
%>

<%

  ausstage.Database          db_ausstage_for_result       = new ausstage.Database ();
  admin.Common            common                       = new admin.Common   ();
  db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
 
  CachedRowSet crset                     = null;
  Search search;
  String formatted_date                  = "";
  String m_state                         = request.getParameter("f_state");
  String page_num                        = request.getParameter("f_page_num");
  String recset_count                    = request.getParameter("f_recset_count");
  int l_int_page_num                     = 0;
  State state                            = new State(db_ausstage_for_result);
  SimpleDateFormat formatPattern         = new SimpleDateFormat("dd/MM/yyyy");
  boolean do_print                       = false;  
  
  int counter;
  int start_trigger;
  int curr_row = 0;      
  search = new Search(db_ausstage_for_result);
   

  if(page_num != null){
    if(Integer.parseInt(page_num) > 1)
      curr_row = Integer.parseInt(page_num) * 10 - 10;
      
  }else{
    recset_count = search.getRecordCount();
  }
  
  if(m_state == null || m_state.equals("") )
    out.println("<p >Select a state from the drop-down list to see current and forthcoming coming events.&nbsp;&nbsp;<br>Find an event that you're interested in, then click on the event to find out more.&nbsp;&nbsp;<br><br><br><br><br><br>" +
                  "</p>");
  else{
    crset = search.getWhatsOn(m_state);

    if(crset != null && crset.next()){

      // get the number of rows returned (1st time only)
      if(page_num == null){
        crset.last();
        recset_count = Integer.toString(crset.getRow());
        crset.first();         
      }

      out.println("     <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");

      // DISPLAY NUMBER OF RESULTS
      out.println("      <tr>");
      out.println("       <td colspan=\"11\" >");
      out.println("       <b>Search Results</b></td>");
      out.println("      </tr>");
      out.println("      <tr>");
      out.println("       <td colspan=\"11\"  >");

      // SPECIFY THE MESSAGE WHETHER OR NOT THE SEARCH WITHIN RESULT WAS ACTIVATED
        out.println("       Your search found " + recset_count + " result(s). Click Event Name to view details.");
      // DISPLAY HEADERS AND TITLES
      out.println("       </td>");
      out.println("      </tr>");          
      out.println("      <tr>");
      out.println("       <td colspan=\"9\">&nbsp;</td>");
      out.println("      </tr>");
      out.println("      <tr>");
      out.println("       <td width=\"30%\" ><b>Event Name</b></td>");
      out.println("       <td>&nbsp;</td>");
      out.println("       <td width=\"41%\" ><b>Venue</b></td>");
      out.println("       <td>&nbsp;</td>");
      /*out.println("       <td width=\"11%\" ><b>Suburb</b></td>");
      out.println("       <td>&nbsp;</td>");*/
      out.println("       <td width=\"12%\" ><b>From</b></td>");
      out.println("       <td>&nbsp;</td>");
      out.println("       <td width=\"12%\" ><b>To</b></td>");
      out.println("      </tr>");
      out.println("      <tr>");
      out.println("       <td colspan=\"9\"></td>");
      out.println("      </tr>");
      out.println("      <tr>");
      out.println("       <td colspan=\"9\"></td>");
      out.println("      </tr>");

      counter       = 0;
      start_trigger = 0;
      do_print = false;

    

      // DISPLAY SEARCH RESULT(S)
      do{
        
        if(page_num == null){
          do_print = true;
        }else if(page_num.equals("1")){
          do_print = true;
        }else{
          if((Integer.parseInt(page_num) * 10 - 10) == start_trigger)
            do_print = true;
        }
        
        if(do_print){

          String bgcolour = "";
          if ((counter%2) == 0 ) // is it odd or even number???
            bgcolour = "bgcolor='#e3e3e3'";
          else
            bgcolour = "bgcolor='#FFFFFF'";
            
        
          out.println("      <tr>");            
          out.println("       <td " + bgcolour +  " valign=\"top\" ><a href=\"" + AusstageCommon.event_index_search_result_drill_page + "?f_event_id=" + crset.getString("eventid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("event_name") + " (" + crset.getString("eventid") + ")" + "</a></td>");
          out.println("       <td " + bgcolour +  " >&nbsp;</td>");
          out.println("       <td " + bgcolour +  " valign=\"top\" >" + crset.getString("venue_name") + "");
         // out.println("       <td " + bgcolour +  ">&nbsp;</td>");
         // out.println("       <td " + bgcolour +  " valign=\"top\" >");

          if(crset.getString("suburb") != null && !crset.getString("suburb").equals(""))
            out.println(", " + crset.getString("suburb"));
          out.println("       </td>");
          out.println("       <td " + bgcolour +  " >&nbsp;</td>");
          
          out.println("       <td " + bgcolour +  " valign=\"top\" >");
          formatted_date = "";
          Event eventObj = new Event(db_ausstage_for_result);            
          CachedRowSet event_crset = eventObj.getEventsById(crset.getString("eventid"));  
          event_crset.next();
          out.println(formatDate(event_crset.getString("DDFIRST_DATE"), event_crset.getString("MMFIRST_DATE"),event_crset.getString("YYYYFIRST_DATE") ));
          out.println("</td>");
          
          out.println("<td " + bgcolour +  ">&nbsp;</td>");
          out.println("<td " + bgcolour +  " valign=\"top\">");
          out.println(formatDate(event_crset.getString("DDLAST_DATE"), event_crset.getString("MMLAST_DATE"),event_crset.getString("YYYYLAST_DATE") ));
          out.println(      "</td></tr>");

          counter++;
                      
          if(counter == 10)
            break;
          }
          
          start_trigger++;
          
        }while(crset.next());

       
        // PAGINATION DISPLAY //
        String unrounded_page_num = "";
        int rounded_num_pages     = 0;
        int remainder_num         = 0;
        int int_page_num          = 0;
        int i                     = 1;

        if(Integer.parseInt(recset_count) > 10) {
          out.println("      <tr>");
          out.println("       <td colspan=\"9\">&nbsp;</td>");
          out.println("      </tr>");
          out.println("      <tr>");
          out.println("       <td align=\"center\" colspan=\"9\" >");

          unrounded_page_num  = Double.toString(Double.parseDouble(Integer.toString(Integer.parseInt(recset_count))) / Double.parseDouble("10"));
          rounded_num_pages   = Integer.parseInt(unrounded_page_num.substring(0, unrounded_page_num.indexOf(".")));     // ie. 5.4 will return 5    
          remainder_num       = Integer.parseInt(unrounded_page_num.substring(unrounded_page_num.indexOf(".") + 1, unrounded_page_num.indexOf(".") + 2)); // ie. 5.4 will return 4          


          if(remainder_num > 0)
            rounded_num_pages++; // add another page if remainder > 0

          // convert the page_num to a useful mathematical type
          // and use it as the start number for our page numbering
          if(page_num != null){
            int_page_num = Integer.parseInt(page_num);

            // find the middle number so that if 10 is
            // hit(or the 'Next' & 'Previous' number)
            // the page number will display
            // 6 7 8 9 10 11 12 13 14 15
            if(int_page_num >= 10)
              i = int_page_num - 4;
          }


          
          out.println("<b>Result Page</b>:&nbsp;&nbsp;");
          
          // write Previous
          if(int_page_num > 1)
            out.println("<a href=\"" + request.getRequestURI() + 
                        
                        "&f_state=" + m_state + 
                        "&f_page_num=" + (int_page_num - 1) + 
                        "&f_recset_count=" + recset_count +
                        "\">Previous</a>&nbsp;");

          
          // write page numbers
          counter = 0;
          for(; i < rounded_num_pages + 1; i++){
            String highlight_number_str = "";

            if(int_page_num == i)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else if(page_num == null && i == 1)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else
              highlight_number_str = Integer.toString(i);
              
            out.println("<a href=\"" + request.getRequestURI() + 
                         
                        "&f_state=" + m_state + 
                        "&f_page_num=" + i +
                        "&f_recset_count=" + recset_count +
                        "\">" + highlight_number_str + "</a>&nbsp;");

            counter++;
            if(counter == 10)
              break;
          }

          // write Next
          if(page_num != null){
            if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
              out.println("<a href=\"" + request.getRequestURI() + 
                          
                          "&f_state=" + m_state + 
                          "&f_page_num=" + (int_page_num + 1) +
                          "&f_recset_count=" + recset_count +
                          "\">Next</a>");
            }
          }else{
            out.println("<a href=\"" + request.getRequestURI() + 
                        
                        "&f_state=" + m_state +  
                        "&f_page_num=" + (int_page_num + 2) +
                        "&f_recset_count=" + recset_count +
                        "\">Next</a>");
          }
          out.println("       </td>");
          out.println("      </tr>");
        } 
        
        out.println("      <tr>");
        out.println("       <td colspan='7'><br><br>");
        out.println("       </td>");
        out.println("      </tr> ");
        
        out.println("     </table>");
     
      }else{
        out.println("<p >Your search did not return any result.<br><br><br><br><br></p>");
      }

    }
    
%>
