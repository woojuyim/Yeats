package saffron;

public class Location {
	private String address1;
	private String city;
	private String state;
	private String zip_code;

	public String getAddress() {
		return address1 + ", " + city + ", " + state + ", " + zip_code;
	}

	public String getAddress1() {
		return address1;
	}

	public String getCity() {
		return city;
	}

	public String getState() {
		return state;
	}

	public String getZip_code() {
		return zip_code;
	}
}
