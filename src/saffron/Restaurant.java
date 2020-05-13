package saffron;

import java.io.Serializable;
import java.util.ArrayList;


public class Restaurant implements Serializable{
	private static final long serialVersionUID = 8984140956739291885L;
	
	private String name;
	private String image_url;
	private String url;
	public Location location;
	private String display_phone;
	private String price;
	private double rating;
	private ArrayList<Category> categories;
	private String id;
	private int added;
	
	public int getAdded() {
		return added;
	}
	public void setAdded(int add) {
		added = add;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setImage_url(String image_url) {
		this.image_url = image_url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public void setLocation(Location location) {
		this.location = location;
	}
	public ArrayList<Category> getCategories() {
		return categories;
	}
	public String getName() {
		return name;
	}
	public String getImage_url() {
		return image_url;
	}
	public String getUrl() {
		return url;
	}
	public String getLocation() {
		return location.getAddress();
	}
	public String getPhone() {
		return display_phone;
	}
	public String getPrice() {
		return price;
	}
	public double getRating() {
		return rating;
	}
}
