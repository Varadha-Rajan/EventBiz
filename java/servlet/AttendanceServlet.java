package servlet;

import dao.AttendanceDAO;
import dao.EventDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/event/attend")
public class AttendanceServlet extends HttpServlet {
    private AttendanceDAO attDAO = new AttendanceDAO();
    private EventDAO eventDAO = new EventDAO();

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        int eventId = Integer.parseInt(req.getParameter("event_id"));
        String action = req.getParameter("action"); // "register" or "unregister" or "mark_attended"

        try {
            if ("register".equals(action)) {
                // check capacity
                int registered = eventDAO.countRegistered(eventId);
                Integer capacity = eventDAO.findById(eventId).getCapacity();
                if (capacity != null && registered >= capacity) {
                    req.getSession().setAttribute("message", "Event is full.");
                } else {
                    attDAO.register(eventId, u.getId());
                }
            } else if ("unregister".equals(action)) {
                attDAO.unregister(eventId, u.getId());
            } else if ("mark_attended".equals(action)) {
                // typically admin/organizer action — we allow for simple marking here
                attDAO.markAttended(eventId, u.getId());
            }
            resp.sendRedirect(req.getContextPath() + "/event/view?id=" + eventId);
        } catch (SQLException ex) { throw new ServletException(ex); }
    }
}
