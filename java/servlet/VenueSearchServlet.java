package servlet;

import dao.VenueDAO;
import model.Venue;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/venue/search")
public class VenueSearchServlet extends HttpServlet {
    private VenueDAO venueDAO = new VenueDAO();
    private static final DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/venue-search.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String start = req.getParameter("start_time");
            String end = req.getParameter("end_time");
            String capStr = req.getParameter("capacity");
            Integer cap = (capStr == null || capStr.isEmpty()) ? null : Integer.valueOf(capStr);

            Timestamp startTs = Timestamp.valueOf(LocalDateTime.parse(start, fmt));
            Timestamp endTs = Timestamp.valueOf(LocalDateTime.parse(end, fmt));

            List<Venue> list = venueDAO.searchAvailable(startTs, endTs, cap);
            req.setAttribute("venues", list);
            req.setAttribute("searchStart", start);
            req.setAttribute("searchEnd", end);
            req.getRequestDispatcher("/venue-search.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
