package content;

import java.io.PrintStream;
import javax.servlet.http.*;
import javax.servlet.jsp.JspWriter;

public class Cookies {

	public Cookies() {
	}

	public boolean addCookie(String p_cookieName, String p_cookieValue, HttpServletResponse p_response, JspWriter p_out) {
		try {
			Cookie cook = new Cookie(p_cookieName, p_cookieValue);
			cook.setMaxAge(0xed4e00);
			cook.setPath("/");
			p_response.addCookie(cook);
		} catch (Exception e) {
			System.out.println("Could not add Cookie " + p_cookieName);
			try {
				p_out.println("Could not add Cookie " + p_cookieName);
				p_out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				p_out.println("Could not add Cookie " + p_cookieName);
				p_out.println("MESSAGE: " + e.getMessage());
				p_out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				p_out.println("CLASS.TOSTRING: " + e.toString());
				p_out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			} catch (Exception exception) {
			}
			boolean flag = false;
			return flag;
		}
		return true;
	}

	public String getCookieValue(String p_name, HttpServletRequest p_request) {
		Cookie cookies[] = p_request.getCookies();
		for (int i = 0; i < cookies.length; i++) {
			Cookie cookie = cookies[i];
			cookie.setPath("/");
			if (p_name.equals(cookie.getName())) {
				return cookie.getValue();
			}
		}

		return "";
	}
}
