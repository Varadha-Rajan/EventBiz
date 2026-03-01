package servlet;

import dao.VenueBookingDAO;
import dao.VenueBookingDAO.VenueUsageRow;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/venue/report")
public class VenueUsageReportServlet extends HttpServlet {
    private VenueBookingDAO bookingDAO = new VenueBookingDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User user = (s == null) ? null : (User) s.getAttribute("user");
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/venue-report.jsp").forward(req, resp);
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

        try {
            String fromStr = req.getParameter("from_date"); // yyyy-MM-dd
            String toStr = req.getParameter("to_date");
            LocalDate from = (fromStr == null || fromStr.isEmpty()) ? LocalDate.now().minusMonths(1) : LocalDate.parse(fromStr);
            LocalDate to = (toStr == null || toStr.isEmpty()) ? LocalDate.now() : LocalDate.parse(toStr);
            Timestamp fromTs = Timestamp.valueOf(from.atStartOfDay());
            Timestamp toTs = Timestamp.valueOf(to.plusDays(1).atStartOfDay()); // inclusive

            List<VenueUsageRow> rows = bookingDAO.usageReport(fromTs, toTs);
            req.setAttribute("reportRows", rows);
            req.setAttribute("from", fromStr);
            req.setAttribute("to", toStr);
            req.getRequestDispatcher("/venue-report.jsp").forward(req, resp);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
