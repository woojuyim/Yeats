package saffron;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FavoriteServlet")
public class FavoriteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FavoriteServlet() {
        super();
    }

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, NullPointerException {
		String username = request.getParameter("username");
		String yelp = request.getParameter("favorite");
		
		User user = (User)request.getSession().getAttribute("logged");
		Restaurant rest = (Restaurant)request.getSession().getAttribute("restaurant");
		
		boolean added = Database.changeFavorite(username, yelp);

		if(added) {
			user.addFavorites(yelp);
			user.addRestaurants(rest);
		}
		else {
			user.removefromFavorites(yelp);
			user.removeRestaurants(rest);

		}
	}

}
