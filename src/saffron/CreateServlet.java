package saffron;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CreateServlet")
public class CreateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String username = request.getParameter("signupusername");
		String password = request.getParameter("signuppassword");
		String email = request.getParameter("email");
		boolean success = Database.createAccount(username, password, email);
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/Account.jsp");

		// Create Account success
		if (success) {
			User user = Database.login(username, password);
			user.setGoogleUser(false);
			request.getSession().setAttribute("logged", user);
			dispatch = getServletContext().getRequestDispatcher("/HomePage.jsp");
		}

		// Create Failed
		else {
			request.setAttribute("createFailed", "Error");
		}

		dispatch.forward(request, response);
	}
}