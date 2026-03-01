package servlet;

import dao.AttendanceDAO;
import dao.EventDAO;
import model.Event;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/event/view")
public class EventViewServlet extends HttpServlet {
    private EventDAO eventDAO = new EventDAO();
    private AttendanceDAO attDAO = new AttendanceDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) { resp.sendRedirect(req.getContextPath() + "/events"); return; }
        try {
            int id = Integer.parseInt(idStr);
            Event e = eventDAO.findById(id);
            req.setAttribute("event", e);
            int registered = eventDAO.countRegistered(id);
            req.setAttribute("registeredCount", registered);

            User u = (User) req.getSession().getAttribute("user");
            boolean registeredByUser = false;
            if (u != null) registeredByUser = attDAO.isRegistered(id, u.getId());
            req.setAttribute("registeredByUser", registeredByUser);

            req.getRequestDispatcher("/event-view.jsp").forward(req, resp);
        } catch (SQLException ex) { throw new ServletException(ex); }
    }
}
