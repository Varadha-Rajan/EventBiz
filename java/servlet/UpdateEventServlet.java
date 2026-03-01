package servlet;

import dao.EventDAO;
import model.Event;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/event/update")
public class UpdateEventServlet extends HttpServlet {
    private EventDAO dao = new EventDAO();
    private static final DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) { resp.sendRedirect(req.getContextPath() + "/events"); return; }
        try {
            Event e = dao.findById(Integer.parseInt(idStr));
            req.setAttribute("event", e);
            req.getRequestDispatcher("/event-edit.jsp").forward(req, resp);
        } catch (SQLException ex) { throw new ServletException(ex); }
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        try {
            Event e = new Event();
            e.setId(Integer.parseInt(req.getParameter("id")));
            e.setTitle(req.getParameter("title"));
            e.setDescription(req.getParameter("description"));
            String vid = req.getParameter("venue_id");
            e.setVenueId((vid == null || vid.isEmpty()) ? null : Integer.valueOf(vid));
            e.setStartTime(Timestamp.valueOf(LocalDateTime.parse(req.getParameter("start_time"), fmt)));
            e.setEndTime(Timestamp.valueOf(LocalDateTime.parse(req.getParameter("end_time"), fmt)));
            e.setCapacity(Integer.parseInt(req.getParameter("capacity")));
            e.setStatus(req.getParameter("status"));
            e.setOrganizerId(user.getId()); // keep same organizer (could check ownership)

            boolean ok = dao.updateEvent(e);
            if (ok) resp.sendRedirect(req.getContextPath() + "/event/view?id=" + e.getId());
            else { req.setAttribute("error", "Update failed"); req.setAttribute("event", e); req.getRequestDispatcher("/event-edit.jsp").forward(req, resp); }
        } catch (SQLException ex) { throw new ServletException(ex); }
    }
}
