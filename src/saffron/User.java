package saffron;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import com.google.gson.Gson;

public class User {
	private String APIKey = "9_h6PjXs8sWY3JO7Jo2BF3wo_x127oWB698h_iffkMIoIRCutVmk-"
			+ "PFYPEz24dpjaunbJBHwb1HHst0F4t-dMKEuFPgiu0faz_2QvYRxAVL77OMfwv148POEmkB1XnYx";
	private String username;
	private String password;
	private String email;
	private boolean isGoogleUser;
	private ArrayList<String> favorites;
	private ArrayList<Restaurant> restaurants;

	public User(String username, String password, ArrayList<String> favorites) {
		this.username = username;
		this.password = password;
		this.favorites = favorites;
		restaurants = new ArrayList<Restaurant>();
	}
	public User(String username, String email) {
		this.username = username;
		this.email = email;
		restaurants = new ArrayList<Restaurant>();
	}
	
	Comparator<Restaurant> comparebyAZ = (Restaurant r1, Restaurant r2) -> r1.getName().compareTo(r2.getName());
	Comparator<Restaurant> comparebylowestRating = (Restaurant r1, Restaurant r2) -> Double.compare(r1.getRating(),
			r2.getRating());
	Comparator<Restaurant> comparebyleastrecent = (Restaurant r1, Restaurant r2) -> {
		int index1 = 0, index2 = 0;
		for (int i = 0; i < favorites.size(); ++i) {
			if (favorites.get(i).contentEquals(r1.getId())) {
				index1 = i;
			}
			if (favorites.get(i).contentEquals(r2.getId())) {
				index2 = i;
			}
		}
		return Integer.compare(index1, index2);
	};

	public void sort(String val) {
		if (val.contentEquals("AZ")) {
			Collections.sort(restaurants, comparebyAZ);
		}
		else if (val.contentEquals("ZA")) {
			Collections.sort(restaurants, comparebyAZ.reversed());
		}
		else if (val.contentEquals("lowest")) {
			Collections.sort(restaurants,comparebylowestRating);
		}
		else if (val.contentEquals("highest")) {
			Collections.sort(restaurants,comparebylowestRating.reversed());
		}
		else if (val.contentEquals("leastrecent")) {
			Collections.sort(restaurants,comparebyleastrecent);
		}
		else if (val.contentEquals("mostrecent")) {
			Collections.sort(restaurants,comparebyleastrecent.reversed());
		}
	}

	public void toAPI() {
		restaurants.clear();
		if (favorites == null || favorites.isEmpty()) {
			return;
		}
		Gson gson = new Gson();
		BufferedReader br = null;
		try {
			for (String fav : favorites) {
				URL url = new URL("https://api.yelp.com/v3/businesses/" + fav);
				HttpURLConnection connection = (HttpURLConnection) url.openConnection();
				connection.setRequestMethod("GET");
				connection.setRequestProperty("Authorization", "Bearer " + APIKey);
				if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
					br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
					Restaurant r = gson.fromJson(br, Restaurant.class);
					restaurants.add(r);
				} else {
					System.out.println("GET Request did not go through");
				}
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
	}

	public ArrayList<Restaurant> getRestaurants() {
		return restaurants;
	}

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}

	public String getEmail() {
		return email;
	}

	public void addFavorites(String fav) {
		favorites.add(fav);
	}

	public void removefromFavorites(String fav) {
		favorites.remove(fav);
	}
	public void addRestaurants(Restaurant fav) {
		restaurants.add(fav);
	}

	public void removeRestaurants(Restaurant fav) {
		for(int i =0; i < restaurants.size(); ++i) {
			if(restaurants.get(i).getName().equalsIgnoreCase(fav.getName())){
				restaurants.remove(i);
				break;
			}
		}
	}
	public ArrayList<String> getFavorites() {
		return favorites;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setFavorites(ArrayList<String> favorites) {
		this.favorites = favorites;
	}
	public boolean getGoogleUser() {
		return isGoogleUser;
	}
	public void setGoogleUser(boolean isGoogleUser) {
		this.isGoogleUser = isGoogleUser;
	}

}
