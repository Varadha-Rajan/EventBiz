package servlet;

import dao.VenueDAO;
import model.Venue;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/venues")
public class VenueListServlet extends HttpServlet {
    private VenueDAO venueDAO = new VenueDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Venue> list = venueDAO.listAll();
            req.setAttribute("venues", list);
            req.getRequestDispatcher("/venues.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
