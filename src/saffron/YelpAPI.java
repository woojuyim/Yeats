package saffron;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import com.google.gson.Gson;

public class YelpAPI {
	private static String APIKey = "9_h6PjXs8sWY3JO7Jo2BF3wo_x127oWB698h_iffkMIoIRCutVmk-"
			+ "PFYPEz24dpjaunbJBHwb1HHst0F4t-dMKEuFPgiu0faz_2QvYRxAVL77OMfwv148POEmkB1XnYx";
	
	public static Restaurant toAPI(String r) {
		Gson gson = new Gson();
		BufferedReader br = null;
		try {
			URL url = new URL("https://api.yelp.com/v3/businesses/" + r);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setRequestProperty("Authorization", "Bearer " + APIKey);
			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
				br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
				Restaurant value = gson.fromJson(br, Restaurant.class);
				return value;
			} else {
				System.out.println("GET Request did not go through");
			}
		} catch (NullPointerException ne) {
			System.out.println("Null pointer exception getting API: " + ne.getMessage());
		} catch (IOException io) {
			System.out.println("ioe Exception getting API: " + io.getMessage());
		} finally {
			try {
				br.close();
			} catch (IOException e) {
				System.out.println("ioe Exception getting API: " + e.getMessage());
			}
		}
		return null;
	}
}
