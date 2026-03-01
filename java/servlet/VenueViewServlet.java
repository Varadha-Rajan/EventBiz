package servlet;

import dao.VenueBookingDAO;
import dao.VenueDAO;
import model.Venue;
import model.VenueBooking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/venue/view")
public class VenueViewServlet extends HttpServlet {
    private VenueDAO venueDAO = new VenueDAO();
    private VenueBookingDAO bookingDAO = new VenueBookingDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) { resp.sendRedirect(req.getContextPath() + "/venues"); return; }
        try {
            int id = Integer.parseInt(idStr);
            Venue v = venueDAO.findById(id);
            if (v == null) { resp.sendRedirect(req.getContextPath() + "/venues"); return; }
            List<VenueBooking> bookings = bookingDAO.listBookingsForVenue(id);
            req.setAttribute("venue", v);
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/venue-view.jsp").forward(req, resp);
        } catch (SQLException e) { throw new ServletException(e); }
    }
}
