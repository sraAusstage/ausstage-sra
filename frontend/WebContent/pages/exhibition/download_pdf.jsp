<%@ page contentType="application/pdf; charset=UTF-8"%><%@ page import = "java.net.*, java.io.*"%><%
        URL url= new URL("http://sam.arts.unsw.edu.au/media/SAMFile/ARTS1120_Introduction_to_TPS_2014_pdf_FINAL.pdf");
        BufferedReader in = new BufferedReader(
        new InputStreamReader(url.openStream()));

        String inputLine;
        while ((inputLine = in.readLine()) != null)
            System.out.println(inputLine);
        in.close();
%>