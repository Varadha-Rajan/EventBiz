package servlet;

import dao.UserDAO;
import model.User;
import utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username").trim();
        String email = req.getParameter("email").trim();
        String password = req.getParameter("password");
        String role = req.getParameter("role") == null ? "PARTICIPANT" : req.getParameter("role").toUpperCase();

        try {
            if (userDAO.findByUsername(username) != null) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
            if (userDAO.findByEmail(email) != null) {
                req.setAttribute("error", "Email already registered");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            User u = new User();
            u.setUsername(username);
            u.setEmail(email);
            u.setPasswordHash(PasswordUtil.hashPassword(password));
            u.setRole(role);

            boolean ok = userDAO.createUser(u);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/login?registered=true");
            } else {
                req.setAttribute("error", "Registration failed");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
