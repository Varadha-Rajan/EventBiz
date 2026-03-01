package servlet;

import dao.EventDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/event/cancel")
public class CancelEventServlet extends HttpServlet {
    private EventDAO dao = new EventDAO();

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        int id = Integer.parseInt(req.getParameter("id"));
        try {
            // (Optional) check organizerId or admin rights here
            boolean ok = dao.cancelEvent(id);
            resp.sendRedirect(req.getContextPath() + "/event/view?id=" + id);
        } catch (SQLException ex) { throw new ServletException(ex); }
    }
}
