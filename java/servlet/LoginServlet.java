package servlet;

import dao.UserDAO;
import model.User;
import utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO dao = new UserDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username").trim();
        String password = req.getParameter("password");

        try {
            User u = dao.findByUsername(username);
            if (u != null && PasswordUtil.checkPassword(password, u.getPasswordHash())) {
                HttpSession session = req.getSession();
                session.setAttribute("user", u);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                String role = u.getRole();
                if ("ADMIN".equalsIgnoreCase(role)) {
                    resp.sendRedirect(req.getContextPath() + "/admin-dashboard.jsp");
                } else if ("ORGANIZER".equalsIgnoreCase(role)) {
                    resp.sendRedirect(req.getContextPath() + "/organizer-dashboard.jsp");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/participant-dashboard.jsp");
                }
            } else {
                req.setAttribute("error", "Invalid credentials");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
