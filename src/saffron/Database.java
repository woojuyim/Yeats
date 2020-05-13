package saffron;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Database {
	private static Connection conn = null;
	private static Statement st = null;
	private static PreparedStatement ps = null;
	private static PreparedStatement pr = null;
	private static ResultSet rs = null;
	private static String connection = "jdbc:mysql://localhost/yeats?user=root&password=root&serverTimezone=UTC";

	private static void closeStatements() {
		try {
			if (rs != null) {
				rs.close();
			}
			if (st != null) {
				st.close();
			}
			if (ps != null) {
				ps.close();
			}
			if (pr != null) {
				pr.close();
			}
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException sqle) {
			System.out.println("Error in closing: " + sqle.getMessage());
		}
	}
	// Create account
	public static boolean createAccount(String username, String password, String email) {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(connection);
			st = conn.createStatement();

			// Check if username or email exists
			pr = conn.prepareStatement("SELECT COUNT(1) FROM ACCOUNTS "
					+ "WHERE username = ? OR email = ?");
			pr.setString(1, username);
			pr.setString(2, email);
			rs = pr.executeQuery();
			String val = null;
			while (rs.next()) {
				val = rs.getString("COUNT(1)");
			}
			// No accounts exist so create account
			if (val.contentEquals("0")) {
				ps = conn.prepareStatement("INSERT INTO ACCOUNTS(Username, PW, Email) " + "VALUES (?,?,?)");
				ps.setString(1, username);
				ps.setString(2, password);
				ps.setString(3, email);
				ps.executeUpdate();
				closeStatements();
				return true;
			} else {
				closeStatements();
				return false;
			}
		} catch (SQLException sqle) {
			System.out.println("SQLException in Create: " + sqle.getMessage());
		} catch (ClassNotFoundException e) {
			System.out.println("ClassNotFoundException in IsDatabase: " + e.getMessage());
		} 		
		return false;
	}

	// Login
	public static User login(String username, String password) {
		try {
			ArrayList<String> favorites = new ArrayList<String>();
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			conn = DriverManager.getConnection(connection);
			st = conn.createStatement();
			pr = conn.prepareStatement("SELECT COUNT(1) FROM ACCOUNTS \r\n" + 
							"WHERE username = ? AND PW = ?");
			pr.setString(1, username);
			pr.setString(2, password);
			rs = pr.executeQuery();
			String val = null;
			while (rs.next()) {
				val = rs.getString("COUNT(1)");
			}

			// Account doesn't exist
			if (val.contentEquals("0")) {
				closeStatements();
				return null;
			} 
			//Login
			else {
				ps = conn.prepareStatement("SELECT f.YELP_ID FROM ACCOUNTS a, FAVORITES f "
						+ "WHERE a.ID=f.UID AND a.username=? AND a.PW=?");
				ps.setString(1, username);
				ps.setString(2, password);
				rs = ps.executeQuery();
				while (rs.next()) {
					String ID = rs.getString("YELP_ID");
					favorites.add(ID);
				}
				closeStatements();
				return new User(username, password, favorites);
			}

		} catch (SQLException sqle) {
			System.out.println("SQLException in Login: " + sqle.getMessage());
		} catch (ClassNotFoundException e) {
			System.out.println("ClassNotFoundException in IsDatabase: " + e.getMessage());
		} 
		return null;
	}

	// Add or remove from favorites
	public static boolean changeFavorite(String username, String yelpID) {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(connection);
			st = conn.createStatement();

			// Check if id exists in username
			pr = conn.prepareStatement("SELECT COUNT(1) FROM ACCOUNTS a, Favorites f\r\n"
					+ "WHERE a.username = ? AND a.ID = f.UID AND f.YELP_ID = ?");
			pr.setString(1, username);
			pr.setString(2, yelpID);
			rs = pr.executeQuery();
			String val = null;
			while (rs.next()) {
				val = rs.getString("COUNT(1)");
			}
			// Add to Favorites
			if (val.contentEquals("0")) {
				ps = conn.prepareStatement("INSERT INTO FAVORITES (UID, YELP_ID) SELECT a.ID, ? \r\n"
						+ "FROM ACCOUNTS a WHERE a.username = ?");
				ps.setString(1, yelpID);
				ps.setString(2, username);
				ps.executeUpdate();
				closeStatements();
				return true;
			}
			// Favorites exists so remove from favorites
			else {
				ps = conn.prepareStatement("DELETE f FROM Favorites f, Accounts a\r\n" + 
						"WHERE (a.username = ? AND a.ID = f.UID AND f.YELP_ID = ? AND a.ID <> 0)");
				ps.setString(1, username);
				ps.setString(2, yelpID);
				ps.executeUpdate();
				closeStatements();
				return false;
			}
		} catch (SQLException sqle) {
			System.out.println("SQLException in addFavorite: " + sqle.getMessage());
		} catch (ClassNotFoundException e) {
			System.out.println("ClassNotFoundException in IsDatabase: " + e.getMessage());
		} 
		return false;
	}

	//YelpID is already in the database
	public static boolean isInDatabase(String username, String yelpID) {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(connection);
			st = conn.createStatement();
			// Check if id exists in username
			pr = conn.prepareStatement("SELECT COUNT(1) FROM ACCOUNTS a, Favorites f"
					+ " WHERE a.username = ? AND a.ID = f.UID AND f.YELP_ID = ?");
			pr.setString(1, username);
			pr.setString(2, yelpID);
			rs = pr.executeQuery();
			String val = null;
			while (rs.next()) {
				val = rs.getString("COUNT(1)");
			}
			
			closeStatements();
			// Yelp ID exists in username
			if (!val.contentEquals("0")) {
				return true;
			}
			// ID is not in the database
			else {
				return false;
			}

		} catch (SQLException sqle) {
			System.out.println("SQLException in IsDatabase: " + sqle.getMessage());
		} catch (ClassNotFoundException e) {
			System.out.println("ClassNotFoundException in IsDatabase: " + e.getMessage());
		} 
		return false;
	}
	//Get Favorites for username 
	//May be needed
	public static ArrayList<String> getFavorites(String username) {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(connection);
			// Check if id exists in username
			pr = conn.prepareStatement("SELECT f.YELP_ID FROM ACCOUNTS a, Favorites f WHERE"
					+ " a.username=? AND a.ID=f.UID");
			pr.setString(1, username);
			rs = pr.executeQuery();
			ArrayList<String> val = new ArrayList<String>();
			while (rs.next()) {
				val.add(rs.getString("YELP_ID"));
			}
			// Returns the arraylist of ids
			return val;

		} catch (SQLException sqle) {
			System.out.println("SQLException in getFavorites: " + sqle.getMessage());
		} catch (ClassNotFoundException e) {
			System.out.println("ClassNotFoundException in IsDatabase: " + e.getMessage());
		} 
		return null;
	}
}