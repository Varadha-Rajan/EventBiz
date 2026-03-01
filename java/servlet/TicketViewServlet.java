package servlet;

import dao.TicketDAO;
import dao.UserDAO;
import dao.EventDAO;
import model.Ticket;
import model.User;
import model.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ticket/view")
public class TicketViewServlet extends HttpServlet {
    private TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) { resp.sendRedirect(req.getContextPath() + "/"); return; }
        try {
            int id = Integer.parseInt(idStr);
            Ticket t = ticketDAO.findById(id);
            if (t == null) { resp.sendRedirect(req.getContextPath() + "/"); return; }
            req.setAttribute("ticket", t);
            req.getRequestDispatcher("/ticket-view.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
