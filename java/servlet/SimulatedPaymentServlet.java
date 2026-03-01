package servlet;

import dao.TicketDAO;
import dao.PaymentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ticket/pay-simulate")
public class SimulatedPaymentServlet extends HttpServlet {
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Log what arrived (queryString, params, attrs)
        log("SimulatedPaymentServlet GET queryString=" + req.getQueryString()
                + " param(paymentId)=" + req.getParameter("paymentId")
                + " param(ticketId)=" + req.getParameter("ticketId")
                + " attr(paymentId)=" + req.getAttribute("paymentId")
                + " attr(ticketId)=" + req.getAttribute("ticketId"));

        // Forward to the JSP page
        req.getRequestDispatcher("/ticket-pay-simulate.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Accept either request attributes (forward) or request parameters (redirect)
        Object pidAttr = req.getAttribute("paymentId");
        Object tidAttr = req.getAttribute("ticketId");

        String paymentIdStr = (pidAttr != null) ? String.valueOf(pidAttr).trim() : req.getParameter("paymentId");
        String ticketIdStr  = (tidAttr != null) ? String.valueOf(tidAttr).trim()  : req.getParameter("ticketId");

        if (paymentIdStr != null) paymentIdStr = paymentIdStr.trim();
        if (ticketIdStr != null)  ticketIdStr  = ticketIdStr.trim();

        log("SimulatedPaymentServlet: POST received paymentId=" + paymentIdStr + " ticketId=" + ticketIdStr);

        // Validate inputs: reject null, empty, or literal "null"
        if (paymentIdStr == null || paymentIdStr.isEmpty() || "null".equalsIgnoreCase(paymentIdStr)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid paymentId");
            return;
        }
        if (ticketIdStr == null || ticketIdStr.isEmpty() || "null".equalsIgnoreCase(ticketIdStr)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid ticketId");
            return;
        }

        final int paymentId;
        final int ticketId;
        try {
            paymentId = Integer.parseInt(paymentIdStr);
            ticketId  = Integer.parseInt(ticketIdStr);
        } catch (NumberFormatException nfe) {
            log("SimulatedPaymentServlet: NumberFormatException for paymentId/ticketId", nfe);
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "paymentId and ticketId must be integers");
            return;
        }

        // Simulate payment success
        try {
            boolean updated = paymentDAO.updatePaymentStatus(paymentId, "SUCCESS", "SIM-" + paymentId);
            if (!updated) {
                log("SimulatedPaymentServlet: paymentDAO.updatePaymentStatus returned false for id=" + paymentId);
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment record not found");
                return;
            }

            boolean marked = ticketDAO.markPaid(ticketId);
            if (!marked) {
                log("SimulatedPaymentServlet: ticketDAO.markPaid returned false for ticketId=" + ticketId);
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Ticket not found or could not be marked paid");
                return;
            }

            // Redirect to view ticket
            resp.sendRedirect(req.getContextPath() + "/ticket/view?id=" + ticketId);
        } catch (SQLException sqle) {
            log("SimulatedPaymentServlet: database error", sqle);
            throw new ServletException(sqle);
        }
    }
}
