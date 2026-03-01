package servlet;

import dao.PaymentDAO;
import dao.TicketDAO;
import model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/payments")
public class AdminPaymentsServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();
    private TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        model.User admin = (s == null) ? null : (model.User) s.getAttribute("user");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Payment> payments = paymentDAO.listAll();
            req.setAttribute("payments", payments);
            req.getRequestDispatcher("/admin-payments.jsp").forward(req, resp);
        } catch (SQLException e) { throw new ServletException(e); }
    }

    // refund action
    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        model.User admin = (s == null) ? null : (model.User) s.getAttribute("user");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("refund".equals(action)) {
                int paymentId = Integer.parseInt(req.getParameter("paymentId"));
                // mark payment refunded
                boolean ok = paymentDAO.updatePaymentStatus(paymentId, "REFUNDED", "REF-"+paymentId);
                // also mark related ticket refunded (simple SQL)
                String sql = "UPDATE tickets t JOIN payments p ON t.id = p.ticket_id SET t.status = 'REFUNDED' WHERE p.id = ?";
                try (java.sql.Connection conn = utils.DBConnection.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, paymentId);
                    ps.executeUpdate();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/payments");
        } catch (Exception ex) { throw new ServletException(ex); }
    }
}
