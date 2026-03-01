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

@WebServlet("/event/create")
public class CreateEventServlet extends HttpServlet {
    private EventDAO dao = new EventDAO();
    private static final DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"); // for input type datetime-local

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        // show create form
        req.getRequestDispatcher("/event-create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String venueIdStr = req.getParameter("venue_id");
        String start = req.getParameter("start_time"); // expects datetime-local value
        String end = req.getParameter("end_time");
        String capStr = req.getParameter("capacity");
        int capacity = Integer.parseInt(capStr == null || capStr.isEmpty() ? "0" : capStr);

        Event e = new Event();
        e.setTitle(title);
        e.setDescription(description);
        if (venueIdStr == null || venueIdStr.isEmpty()) e.setVenueId(null);
        else e.setVenueId(Integer.valueOf(venueIdStr));
        e.setOrganizerId(user.getId());
        e.setStartTime(Timestamp.valueOf(LocalDateTime.parse(start, fmt)));
        e.setEndTime(Timestamp.valueOf(LocalDateTime.parse(end, fmt)));
        e.setCapacity(capacity);
        e.setStatus("SCHEDULED");

        try {
            int id = dao.createEvent(e);
            if (id > 0) {
                resp.sendRedirect(req.getContextPath() + "/event/view?id=" + id);
            } else {
                req.setAttribute("error", "Unable to create event");
                req.getRequestDispatcher("/event-create.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
