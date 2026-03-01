package servlet;

import dao.EventDAO;
import model.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/events")
public class EventListServlet extends HttpServlet {
    private EventDAO dao = new EventDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Event> list = dao.listAll();
            req.setAttribute("events", list);
            req.getRequestDispatcher("/events.jsp").forward(req, resp);
        } catch (SQLException ex) { throw new ServletException(ex); }
    }
}
