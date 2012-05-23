/***************************************************

Company: SRA
 Author: Aaron Keatley
Project: Ausstage

   File: BSService.java

Purpose: Provides access to the Basic Search functionality which a web service can access. 

***************************************************/
package ausstage.services;

import ausstage.AusstageCommon;
import ausstage.Search;

import java.io.FileInputStream;
import java.io.IOException;

import java.sql.Connection;
import java.sql.DriverManager;

import java.util.Properties;

import oracle.jdbc.OracleDriver;

import sun.jdbc.rowset.CachedRowSet;

import ausstage.Database;


public class BSService
{
  Connection         db_conn;
  Database           m_db       = new Database();
  admin.Common       common     = new admin.Common   ();

  Search search;
  String keyword;
  String year;
  String sortBy;
  String sqlSwitch;
  String table;
  String DB_CONNECTION_STRING = "";
  
  public BSService () {
    //create an instance of properties class
    Properties props = new Properties();
    
    //try retrieve data from file
    try {
      props.load(new FileInputStream("BSService.properties"));
      DB_CONNECTION_STRING = props.getProperty("DB_CONNECTION_STRING");
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }

  public String callSearch(String p_keyword ,String p_year ,String p_sortBy ,String p_sqlSwitch ,String p_table)  {
    
      keyword   = p_keyword;
      year      = p_year;
      sortBy    = p_sortBy;
      sqlSwitch = p_sqlSwitch;
      table     = p_table;

    connDatabase();
    search = new Search(m_db,db_conn);
    
    // Make sure that a keyword has been entered. The user may have javascript disabled.
    if (keyword == null ||
        keyword.equals("null") ||
        keyword.equals("")) {
      return "Please enter a keyword";
    } 
    else {
      search.setKeyWord(keyword.trim());
    }
    
    search.setSqlSwitch(sqlSwitch);
    search.setSearchFor(table);
    search.setSortBy(sortBy);

    if(year != null && !year.equals("") && !table.equals("organisation") && !table.equals("venue")){
           
      // Date can be in the form "1996" or "1996-2008"
      String yearFrom        = "";
      String yearTo          = "";
      if (year.length() == 4) {
        yearTo = year;
        yearFrom = year;
      }
      else if (year.length() == 9) {
        yearFrom = year.substring(0, 4);
        yearTo = year.substring(5);
      }
      else {
        return "Please enter a valid date e.g 1997 or 2002-2008" + year;
      }

      if (yearTo.length() == 4 && yearFrom.length() == 4) {
        search.setBetweenFromDate(yearFrom, "01", "01");
        search.setBetweenToDate(yearTo, "12", "31");
      }
    }
    String result ="";
   
    CachedRowSet results =null;
    try{
      if(table.equals("all")){
        results = search.getAll();
      }else if(table.equals("event")){
        results = search.getEvents();
      }else if(table.equals("contributor")){
        results = search.getContributors();
      }else if(table.equals("organisation")){
        results = search.getOrganisations();
      }else if(table.equals("venue")){
        results = search.getVenues();
      }else if(table.equals("resource")){
        results = search.getResources();
      }
      results.first();
      result = "<BASICSEARCHRESULT COUNT = \"" +  results.size() + "\">";
      for(int i=0; i < results.size(); i ++){
        result += results.getString("xml");
        results.next();
      }
      result += "</BASICSEARCHRESULT>";
    }
    catch(java.sql.SQLException e){
      System.out.println( e.getMessage());
    }
    System.out.println(results.size() + " rows returned for " + table);
    disconnectDatabase();

    return result;
  }

  protected String connDatabase()
  {
      try
      {
        if(db_conn != null)
        {
            for(; !db_conn.isClosed(); db_conn.close()) { }
        }

        DriverManager.registerDriver(new OracleDriver());
        
        db_conn = java.sql.DriverManager.getConnection(DB_CONNECTION_STRING, AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
      }
      catch(Exception e)
      {
          System.out.println("Trying to open DB - We have an exception!!!");
          System.out.println("MESSAGE: " + e.getMessage());
          System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
          System.out.println("CLASS.TOSTRING: " + e.toString());
          String s = e.getLocalizedMessage().substring(e.getLocalizedMessage().indexOf(": ") + 2);
          return s;
      }
      return "";
  }


  protected void disconnectDatabase()
  {
      try
      {
          db_conn.close();
      }
      catch(Exception e)
      {
          System.out.println("Trying to close DB - We have an exception!!!");
          System.out.println("MESSAGE: " + e.getMessage());
          System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
          System.out.println("CLASS.TOSTRING: " + e.toString());
      }
  }


}
