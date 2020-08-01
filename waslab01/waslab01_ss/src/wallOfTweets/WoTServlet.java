package wallOfTweets;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.Locale;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class WoTServlet
 */
@WebServlet("/")
public class WoTServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Locale currentLocale = new Locale("en");
	String ENCODING = "ISO-8859-1";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public WoTServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			Vector<Tweet> tweets = Database.getTweets();
			if(request.getHeader("Accept").equals("text/plain")) printPLAINresult(tweets, response); 
			else printHTMLresult(tweets, request, response);
		}

		catch (SQLException ex ) {
			throw new ServletException(ex);
		}
	}

	


	private void printPLAINresult(Vector<Tweet> tweets, HttpServletResponse response) throws IOException {
		// TODO Auto-generated method stub
		DateFormat dateFormatter = DateFormat.getDateInstance(DateFormat.FULL, currentLocale);
		DateFormat timeFormatter = DateFormat.getTimeInstance(DateFormat.DEFAULT, currentLocale);

		PrintWriter  out = response.getWriter ( );
		for (Tweet tweet: tweets) {
			out.print("tweet #" + tweet.getTwid() + ": " + tweet.getAuthor() + ": ");
			String messDate = dateFormatter.format(tweet.getDate());
			String timeDate = timeFormatter.format(tweet.getDate());
			out.println(tweet.getText() + " [" + messDate +" " + timeDate + "]" );
		}
	}



	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// This method does NOTHING but redirect to the main page
		Long num= null;
		PrintWriter  out = response.getWriter ( );
		String autor = request.getParameter("author");
		String text = request.getParameter("tweet_text");
		String TwtId = request.getParameter("TwtId");
		Cookie [] cookies = request.getCookies();
		
		if(TwtId != null) {
			if(cookies.length != 0) {
				for(Cookie c: cookies) {
					if(c.getValue().equals(MD5(TwtId))) {
					Database.deleteTweet(Long.parseLong(TwtId));
					}
				}
			}
		}
		else {
			try {
				num = Database.insertTweet(autor, text);
				Cookie c = new Cookie(String.valueOf(num), MD5(String.valueOf(num)));
				response.addCookie(c);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if(request.getHeader("Accept").equals("text/plain")) { 
			out.print(String.valueOf(num));
		}
		else response.sendRedirect(request.getContextPath());
	}
	
	private void printHTMLresult (Vector<Tweet> tweets, HttpServletRequest req, HttpServletResponse res) throws IOException
	{
		DateFormat dateFormatter = DateFormat.getDateInstance(DateFormat.FULL, currentLocale);
		DateFormat timeFormatter = DateFormat.getTimeInstance(DateFormat.DEFAULT, currentLocale);
		res.setContentType ("text/html");
		res.setCharacterEncoding(ENCODING);
		PrintWriter  out = res.getWriter ( );
		out.println("<!DOCTYPE html>");
		out.println("<html>");
		out.println("<head><title>Wall of Tweets</title>");
		out.println("<link href=\"wallstyle.css\" rel=\"stylesheet\" type=\"text/css\" />");
		out.println("</head>");
		out.println("<body class=\"wallbody\">");
		out.println("<h1>Wall of Tweets</h1>");
		out.println("<div class=\"walltweet\">"); 
		out.println("<form method=\"post\">");
		out.println("<table border=0 cellpadding=2>");
		out.println("<tr><td>Your name:</td><td><input name=\"author\" type=\"text\" size=70></td><td></td></tr>");
		out.println("<tr><td>Your tweet:</td><td><textarea name=\"tweet_text\" rows=\"2\" cols=\"70\" wrap></textarea></td>"); 
		out.println("<td><input type=\"submit\" name=\"action\" value=\"Tweet!\"></td></tr>"); 
		out.println("</table></form></div>");
		String currentDate = "None";
		for (Tweet tweet: tweets) {
			String messDate = dateFormatter.format(tweet.getDate());
			if (!currentDate.equals(messDate)) {
				out.println("<br><h3>...... " + messDate + "</h3>");
				currentDate = messDate;
			}
			out.println("<div class=\"wallitem\">");
			out.println("<h4><em>" + tweet.getAuthor() + "</em> @ "+ timeFormatter.format(tweet.getDate()) +"</h4>");
			out.println("<p>" + tweet.getText() + "</p>");
			
			out.println("<form action=\"wot\" method=\"post\">");
			out.println("<table border=0 cellpadding=2>");
			out.println("<input type=\"submit\" name=\"action\" value=\"Delete\">");
			out.println("<tr><td><input type=\"hidden\" name=\"TwtId\" value="+tweet.getTwid()+"></td></tr>");
			out.println("</table></form>"); 
			
			out.println("</div>");
		}
		out.println ( "</body></html>" );
	}

	@SuppressWarnings("null")
	public static String MD5(String id) {
		BigInteger resumenNumero = null;
        try {
            byte[] bytesDelMensaje = id.getBytes();

            MessageDigest resumenDelMensaje = null;
            resumenDelMensaje = MessageDigest.getInstance("MD5");
            byte[] bytesDelResumen = resumenDelMensaje.digest(bytesDelMensaje);

            resumenNumero = new BigInteger(1, bytesDelResumen);
            return resumenNumero.toString(16);

        } catch (NoSuchAlgorithmException e) {}
		return resumenNumero.toString(16);
    }

}
