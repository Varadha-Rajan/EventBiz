package servlet;

import dao.TicketDAO;
import dao.PaymentDAO;
import model.Ticket;
import model.Payment;
import model.User;
import utils.TokenUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ticket/purchase")
public class PurchaseTicketServlet extends HttpServlet {
    private final TicketDAO ticketDAO = new TicketDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/ticket-purchase.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User user = (s == null) ? null : (User) s.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String eventIdStr = req.getParameter("event_id");
            String priceStr   = req.getParameter("price");
            if (eventIdStr == null || eventIdStr.trim().isEmpty() ||
                priceStr   == null || priceStr.trim().isEmpty()) {
                log("PurchaseTicketServlet: missing event_id or price (eventId=" + eventIdStr + " price=" + priceStr + ")");
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing event_id or price");
                return;
            }

            int eventId = Integer.parseInt(eventIdStr.trim());
            double price = Double.parseDouble(priceStr.trim());

            // create ticket (PENDING)
            Ticket t = new Ticket();
            t.setTicketCode(TokenUtil.generateTicketCode());
            t.setEventId(eventId);
            t.setUserId(user.getId());
            t.setPrice(price);
            t.setStatus("PENDING");
            int ticketId = ticketDAO.createTicket(t);
            if (ticketId <= 0) {
                log("PurchaseTicketServlet: ticketDAO.createTicket returned " + ticketId);
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to create ticket");
                return;
            }

            // create payment record (INIT)
            Payment p = new Payment();
            p.setTicketId(ticketId);
            p.setAmount(price);
            p.setCurrency("USD");
            p.setProvider("SIMULATED");
            p.setProviderTxnId(null);
            p.setStatus("INIT");
            int paymentId = paymentDAO.createPayment(p);
            if (paymentId <= 0) {
                log("PurchaseTicketServlet: paymentDAO.createPayment returned " + paymentId);
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to create payment record");
                return;
            }

            // LOG produced IDs so you can trace them in Tomcat log
            log("PurchaseTicketServlet created ticketId=" + ticketId + " paymentId=" + paymentId + " for user=" + user.getId());

            // REDIRECT with query string (ensures browser URL contains params and JSP will receive them)
            resp.sendRedirect(req.getContextPath() + "/ticket/pay-simulate?paymentId=" + paymentId + "&ticketId=" + ticketId);
        } catch (NumberFormatException nfe) {
            log("PurchaseTicketServlet: invalid numeric input", nfe);
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid numeric input");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
