package saffron;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GoogleServlet")
public class GoogleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public GoogleServlet() {
        super();
    }

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String id = request.getParameter("id");
		
		//Create and login
		//Works even if there is an existing account
		Database.createAccount(name, id, email);
		User user = Database.login(name, id);
		
		user.toAPI();
		user.setGoogleUser(true);
		
		request.getSession().setAttribute("logged", user);	
		
    }

}
