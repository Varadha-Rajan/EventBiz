package servlet;

import dao.AttendanceDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/event/attendees")
public class AdminAttendeesServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User admin = (s == null) ? null : (User) s.getAttribute("user");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String id = req.getParameter("id");
        if (id == null) { resp.sendRedirect(req.getContextPath() + "/admin/users"); return; }
        try {
            int eventId = Integer.parseInt(id);
            List<User> users = attendanceDAO.listUsersForEvent(eventId);
            req.setAttribute("attendees", users);
            req.setAttribute("eventId", eventId);
            req.getRequestDispatcher("/admin-attendees.jsp").forward(req, resp);
        } catch (SQLException e) { throw new ServletException(e); }
    }
}
