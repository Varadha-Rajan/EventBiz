package servlet;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User admin = (s == null) ? null : (User) s.getAttribute("user");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<User> users = userDAO.listAll();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/admin-users.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // actions: changeRole, delete
    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User admin = (s == null) ? null : (User) s.getAttribute("user");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("changeRole".equals(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                String role = req.getParameter("role");
                User u = userDAO.findById(userId);
                if (u != null) {
                    u.setRole(role);
                    // naive update: delete+recreate not needed; add updateRole method or implement here
                    String sql = "UPDATE users SET role = ? WHERE id = ?";
                    try (java.sql.Connection conn = utils.DBConnection.getConnection();
                         java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, role);
                        ps.setInt(2, userId);
                        ps.executeUpdate();
                    }
                }
            } else if ("delete".equals(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                userDAO.deleteUser(userId);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
