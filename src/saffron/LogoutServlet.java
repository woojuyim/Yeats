package saffron;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;


@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public LogoutServlet() {
        super();
    }
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User)request.getSession().getAttribute("logged");
		request.getSession().invalidate();
		//Google User
		if(user.getGoogleUser()) {
			response.sendRedirect("https://www.google.com/accounts/Logout?continue=https://appengine.google.com/_ah/logout?continue=http://localhost:8080/hw4-woojuyim/HomePage.jsp");
		}
		
		//Regular user
		else {
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/HomePage.jsp");
			dispatch.forward(request, response);
		}
	}

}
