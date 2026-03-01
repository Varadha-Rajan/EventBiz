package servlet;

import dao.VenueDAO;
import model.Venue;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/venue/create")
public class VenueCreateServlet extends HttpServlet {
    private VenueDAO venueDAO = new VenueDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/venue-create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User user = (s == null) ? null : (User) s.getAttribute("user");
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String name = req.getParameter("name");
        String location = req.getParameter("location");
        int capacity = Integer.parseInt(req.getParameter("capacity"));
        String desc = req.getParameter("description");

        Venue v = new Venue();
        v.setName(name);
        v.setLocation(location);
        v.setCapacity(capacity);
        v.setDescription(desc);

        try {
            int id = venueDAO.createVenue(v);
            if (id > 0) resp.sendRedirect(req.getContextPath() + "/venues");
            else { req.setAttribute("error", "Unable to create venue"); req.getRequestDispatcher("/venue-create.jsp").forward(req, resp); }
        } catch (SQLException e) { throw new ServletException(e); }
    }
}
