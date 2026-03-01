package dao;

import model.Payment;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PaymentDAO - provides both createPayment returning generated id (int)
 * and listByUser/listAll/sumRevenue/updatePaymentStatus etc.
 */
public class PaymentDAO {

    /**
     * Create payment and return generated payment id (int).
     * This matches the servlet expectation:
     *   int paymentId = paymentDAO.createPayment(p);
     */
    public int createPayment(Payment p) throws SQLException {
        String sql = "INSERT INTO payments (ticket_id, amount, currency, provider, provider_txn_id, status, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getTicketId());
            ps.setDouble(2, p.getAmount());
            ps.setString(3, p.getCurrency());
            ps.setString(4, p.getProvider());
            ps.setString(5, p.getProviderTxnId());
            ps.setString(6, p.getStatus());
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
            return -1;
        }
    }

    // update payment status
    public boolean updatePaymentStatus(int paymentId, String newStatus, String providerTxnId) throws SQLException {
        String sql = "UPDATE payments SET status = ?, provider_txn_id = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, providerTxnId);
            ps.setInt(3, paymentId);
            return ps.executeUpdate() == 1;
        }
    }

    // find payment by ticket id
    public Payment findByTicketId(int ticketId) throws SQLException {
        String sql = "SELECT * FROM payments WHERE ticket_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // list payments for a user (via tickets)
    public List<Payment> listByUser(int userId) throws SQLException {
        String sql = "SELECT p.* FROM payments p JOIN tickets t ON p.ticket_id = t.id WHERE t.user_id = ? ORDER BY p.created_at DESC";
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    // list all payments (admin)
    public List<Payment> listAll() throws SQLException {
        String sql = "SELECT p.* FROM payments p ORDER BY p.created_at DESC";
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // sum revenue in a date range for payments.status = 'SUCCESS'
    public double sumRevenue(Timestamp from, Timestamp to) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount),0) as total FROM payments WHERE status='SUCCESS' AND created_at >= ? AND created_at <= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, from);
            ps.setTimestamp(2, to);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("total");
            }
        }
        return 0d;
    }

    private Payment map(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setTicketId(rs.getInt("ticket_id"));
        p.setAmount(rs.getDouble("amount"));
        p.setCurrency(rs.getString("currency"));
        p.setProvider(rs.getString("provider"));
        p.setProviderTxnId(rs.getString("provider_txn_id"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }
}
