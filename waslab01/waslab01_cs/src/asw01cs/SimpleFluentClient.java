package asw01cs;


import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

//This code uses the Fluent API

public class SimpleFluentClient {

	private static String URI = "http://localhost:8080/waslab01_ss/";

	public final static void main(String[] args) throws Exception {
    	
    	/* Insert code for Task #4 here */

		//Request.Get("http://targethost/homepage").execute().returnContent();
		
		String TwtId = (Request.Post("http://localhost:8080/waslab01_ss/").bodyForm(Form.form()
				.add("author", "Benito").add("tweet_text", "perla").build()).addHeader("Accept","text/plain")
				.execute().returnContent()).asString();
		System.out.println(TwtId);
		
    	System.out.println(Request.Get(URI).addHeader("Accept","text/plain").execute().returnContent());
    	
    	Request.Post("http://targethost/login").bodyForm(Form.form()
    			.add("TwtId",  TwtId).build()).addHeader("Accept","Delete");
    	
    	/* Insert code for Task #5 here */
    }

	
}
