package saffron;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
	private ArrayList<Data> dataArray;
	private ArrayList<Restaurant> restaurants;

	private String APIKey = "9_h6PjXs8sWY3JO7Jo2BF3wo_x127oWB698h_iffkMIoIRCutVmk-"
			+ "PFYPEz24dpjaunbJBHwb1HHst0F4t-dMKEuFPgiu0faz_2QvYRxAVL77OMfwv148POEmkB1XnYx";
	private static final long serialVersionUID = 1L;

    public SearchServlet() {
        super();
        dataArray = new ArrayList<Data>();
    }
    private void getAPI(String term, String latitude, String longitude, String option) {
		Gson gson = new Gson();
		dataArray.clear();
		BufferedReader br = null;
		try {
			String name = term.replaceAll("\\s+", "-");
			name = name.replaceAll("’", "'");
			URL url = new URL("https://api.yelp.com/v3/businesses/search?term=" + name + "&latitude=" + latitude + "&longitude=" + longitude
					+ "&sort_by=" + option + "&limit=10");

			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setRequestProperty("Authorization","Bearer " + APIKey);
			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
				br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
				Data data = gson.fromJson(br, Data.class);					
				dataArray.add(data);
			} else {
				System.out.println("GET Request did not go through for " + name);
			}
			
		}
		catch(NullPointerException ne) {
			System.out.println("Null pointer exception getting API: " + ne.getMessage());
		}
		catch(IOException io) {
			System.out.println("ioe Exception getting API: " + io.getMessage());
		} finally {
			try {
				if(br!= null) {
					br.close();
				}
			} catch (IOException e) {
				System.out.println("ioe Exception while closing br in API: " + e.getMessage());
			}
		}
	}
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String restaurant = request.getParameter("restaurant");
		String latitude = request.getParameter("latitude");
		String longitude = request.getParameter("longitude");
		String options = request.getParameter("options");
		
		//getAPI("Boba", "34.063950", "-118.265360", "distance");
		getAPI(restaurant, latitude, longitude, options);
		if(dataArray!= null && !dataArray.isEmpty()) {
			restaurants = dataArray.get(0).getData();
			
			//Change url
			for(Restaurant rest: restaurants) {
				String url = rest.getUrl();
				int index = url.indexOf("?");
				//Has ?
				if(index!= -1) {
					String substring = url.substring(0, index);
					rest.setUrl(substring);
				}
			}
		}
		else {
			restaurants = new ArrayList<Restaurant>();
		}
		
		request.setAttribute("restaurant", restaurant);
		request.setAttribute("restArray", restaurants);
		
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/Search.jsp");
		dispatch.forward(request, response);
	}

}
