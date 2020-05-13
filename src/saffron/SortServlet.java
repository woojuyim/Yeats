package saffron;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SortServlet")
public class SortServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public SortServlet() {
        super();
    }

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, NullPointerException {
		
    	String sorted = request.getParameter("sort");
		User user = (User)request.getSession().getAttribute("logged");
		PrintWriter out = response.getWriter();
		
		
		user.sort(sorted);
		for(Restaurant rest: user.getRestaurants()) {
			out.println(rest.getId());
			out.println(rest.getImage_url());
			out.println(rest.getName());
			out.println(rest.getLocation());
			out.println(rest.getUrl());
		}
	}

}
