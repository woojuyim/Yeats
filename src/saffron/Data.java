package saffron;

import java.util.ArrayList;

public class Data {
	private ArrayList<Restaurant> businesses;

	public Data(ArrayList<Restaurant> businesses) {
		this.businesses = businesses;
	}

	public ArrayList<Restaurant> getData() {
		return businesses;
	}
}
