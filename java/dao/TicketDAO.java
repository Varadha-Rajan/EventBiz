package dao;

import model.Ticket;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO {

    public int createTicket(Ticket t) throws SQLException {
        String sql = "INSERT INTO tickets (ticket_code, event_id, user_id, price, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getTicketCode());
            ps.setInt(2, t.getEventId());
            ps.setInt(3, t.getUserId());
            ps.setDouble(4, t.getPrice());
            ps.setString(5, t.getStatus());
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
            return -1;
        }
    }

    public Ticket findById(int id) throws SQLException {
        String sql = "SELECT * FROM tickets WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return toTicket(rs);
            }
        }
        return null;
    }

    public Ticket findByCode(String code) throws SQLException {
        String sql = "SELECT * FROM tickets WHERE ticket_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return toTicket(rs);
            }
        }
        return null;
    }

    public List<Ticket> listByUser(int userId) throws SQLException {
        String sql = "SELECT * FROM tickets WHERE user_id = ? ORDER BY created_at DESC";
        List<Ticket> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(toTicket(rs));
            }
        }
        return list;
    }

    public boolean markPaid(int ticketId) throws SQLException {
        String sql = "UPDATE tickets SET status = 'PAID', paid_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            return ps.executeUpdate() == 1;
        }
    }

    private Ticket toTicket(ResultSet rs) throws SQLException {
        Ticket t = new Ticket();
        t.setId(rs.getInt("id"));
        t.setTicketCode(rs.getString("ticket_code"));
        t.setEventId(rs.getInt("event_id"));
        t.setUserId(rs.getInt("user_id"));
        t.setPrice(rs.getDouble("price"));
        t.setStatus(rs.getString("status"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setPaidAt(rs.getTimestamp("paid_at"));
        return t;
    }
}
