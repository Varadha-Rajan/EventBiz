package servlet;

import dao.VenueBookingDAO;
import dao.VenueDAO;
import model.Venue;
import model.VenueBooking;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/venue/book")
public class VenueBookingServlet extends HttpServlet {
    private VenueBookingDAO bookingDAO = new VenueBookingDAO();
    private VenueDAO venueDAO = new VenueDAO();
    private static final DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        String vid = req.getParameter("venueId");
        if (vid == null) { resp.sendRedirect(req.getContextPath() + "/venues"); return; }
        try {
            Venue v = venueDAO.findById(Integer.parseInt(vid));
            if (v == null) { resp.sendRedirect(req.getContextPath() + "/venues"); return; }
            req.setAttribute("venue", v);
            req.getRequestDispatcher("/venue-book.jsp").forward(req, resp);
        } catch (SQLException e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User user = (s == null) ? null : (User) s.getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        int venueId = Integer.parseInt(req.getParameter("venue_id"));
        String title = req.getParameter("title");
        String start = req.getParameter("start_time");
        String end = req.getParameter("end_time");

        try {
            Timestamp startTs = Timestamp.valueOf(LocalDateTime.parse(start, fmt));
            Timestamp endTs = Timestamp.valueOf(LocalDateTime.parse(end, fmt));
            // basic validation
            if (!endTs.after(startTs)) {
                req.setAttribute("error", "End time must be after start time");
                req.setAttribute("venue", venueDAO.findById(venueId));
                req.getRequestDispatcher("/venue-book.jsp").forward(req, resp);
                return;
            }

            VenueBooking b = new VenueBooking();
            b.setVenueId(venueId);
            b.setUserId(user.getId());
            b.setTitle(title);
            b.setStartTime(startTs);
            b.setEndTime(endTs);

            int id = bookingDAO.createBooking(b);
            if (id > 0) {
                resp.sendRedirect(req.getContextPath() + "/venue/view?id=" + venueId);
            } else {
                req.setAttribute("error", "Selected slot is not available (overlaps existing booking).");
                req.setAttribute("venue", venueDAO.findById(venueId));
                req.getRequestDispatcher("/venue-book.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
