package saffron;


import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("loginusername");
		String password = request.getParameter("loginpassword");
		
		User user = Database.login(username, password);
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/Account.jsp");

		//Login Successful
		if(user != null) {
			user.toAPI();
			user.setGoogleUser(false);
			request.getSession().setAttribute("logged", user);
			dispatch = getServletContext().getRequestDispatcher("/HomePage.jsp");

		}
		//Login Failed
		else {
			request.setAttribute("loginFailed", "Error");
		}
		
		dispatch.forward(request, response);
	}

}
