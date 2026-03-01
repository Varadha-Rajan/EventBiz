package servlet;

import dao.EventDAO;
import dao.PaymentDAO;
import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private EventDAO eventDAO = new EventDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        model.User admin = (s == null) ? null : (model.User) s.getAttribute("user");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // default: last 30 days
        LocalDate to = LocalDate.now();
        LocalDate from = to.minusDays(30);
        req.setAttribute("from", from.toString());
        req.setAttribute("to", to.toString());

        try {
            int totalUsers = userDAO.listAll().size();
            int totalEvents = eventDAO.listAll().size();
            double revenue = paymentDAO.sumRevenue(Timestamp.valueOf(from.atStartOfDay()), Timestamp.valueOf(to.plusDays(1).atStartOfDay()));
            Map<String,Object> stats = new HashMap<>();
            stats.put("totalUsers", totalUsers);
            stats.put("totalEvents", totalEvents);
            stats.put("revenue", revenue);
            req.setAttribute("stats", stats);
            req.getRequestDispatcher("/admin-reports.jsp").forward(req, resp);
        } catch (SQLException e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        model.User admin = (s == null) ? null : (model.User) s.getAttribute("user");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String fromStr = req.getParameter("from");
            String toStr = req.getParameter("to");
            LocalDate from = (fromStr == null || fromStr.isEmpty()) ? LocalDate.now().minusDays(30) : LocalDate.parse(fromStr);
            LocalDate to = (toStr == null || toStr.isEmpty()) ? LocalDate.now() : LocalDate.parse(toStr);

            int totalUsers = userDAO.listAll().size();
            int totalEvents = eventDAO.listAll().size();
            double revenue = paymentDAO.sumRevenue(Timestamp.valueOf(from.atStartOfDay()), Timestamp.valueOf(to.plusDays(1).atStartOfDay()));

            Map<String,Object> stats = new HashMap<>();
            stats.put("totalUsers", totalUsers);
            stats.put("totalEvents", totalEvents);
            stats.put("revenue", revenue);

            req.setAttribute("stats", stats);
            req.setAttribute("from", from.toString());
            req.setAttribute("to", to.toString());
            req.getRequestDispatcher("/admin-reports.jsp").forward(req, resp);
        } catch (SQLException e) { throw new ServletException(e); }
    }
}
