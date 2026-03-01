package dao;

import model.VenueBooking;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VenueBookingDAO {

    /**
     * Checks for overlapping booking for the same venue.
     * Returns true if there is an overlap (i.e., not available).
     */
    public boolean hasOverlap(int venueId, Timestamp start, Timestamp end) throws SQLException {
        String sql = "SELECT 1 FROM venue_bookings WHERE venue_id = ? AND NOT (end_time <= ? OR start_time >= ?) LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ps.setTimestamp(2, start);
            ps.setTimestamp(3, end);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int createBooking(VenueBooking b) throws SQLException {
        // double-check overlap in transaction to reduce race window
        String checkSql = "SELECT 1 FROM venue_bookings WHERE venue_id = ? AND NOT (end_time <= ? OR start_time >= ?) LIMIT 1";
        String insertSql = "INSERT INTO venue_bookings (venue_id, user_id, title, start_time, end_time) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement check = conn.prepareStatement(checkSql)) {
                check.setInt(1, b.getVenueId());
                check.setTimestamp(2, b.getStartTime());
                check.setTimestamp(3, b.getEndTime());
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) { // overlap exists
                        conn.rollback();
                        return -1;
                    }
                }
            }

            try (PreparedStatement ins = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ins.setInt(1, b.getVenueId());
                ins.setInt(2, b.getUserId());
                ins.setString(3, b.getTitle());
                ins.setTimestamp(4, b.getStartTime());
                ins.setTimestamp(5, b.getEndTime());
                int affected = ins.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return -1;
                }
                try (ResultSet rs = ins.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        conn.commit();
                        return id;
                    }
                }
            }
            conn.rollback();
            return -1;
        }
    }

    public List<VenueBooking> listBookingsForVenue(int venueId) throws SQLException {
        String sql = "SELECT * FROM venue_bookings WHERE venue_id = ? ORDER BY start_time DESC";
        List<VenueBooking> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(toBooking(rs));
            }
        }
        return list;
    }

    public List<VenueBooking> listBookingsForUser(int userId) throws SQLException {
        String sql = "SELECT * FROM venue_bookings WHERE user_id = ? ORDER BY start_time DESC";
        List<VenueBooking> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(toBooking(rs));
            }
        }
        return list;
    }

    private VenueBooking toBooking(ResultSet rs) throws SQLException {
        VenueBooking b = new VenueBooking();
        b.setId(rs.getInt("id"));
        b.setVenueId(rs.getInt("venue_id"));
        b.setUserId(rs.getInt("user_id"));
        b.setTitle(rs.getString("title"));
        b.setStartTime(rs.getTimestamp("start_time"));
        b.setEndTime(rs.getTimestamp("end_time"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        return b;
    }

    /**
     * Venue usage report: simple counts and total hours booked between dates
     */
    public List<VenueUsageRow> usageReport(Timestamp from, Timestamp to) throws SQLException {
        String sql = "SELECT v.id, v.name, COUNT(b.id) AS bookings, SUM(TIMESTAMPDIFF(MINUTE, b.start_time, b.end_time))/60 AS hours " +
                     "FROM venues v LEFT JOIN venue_bookings b ON v.id = b.venue_id AND b.start_time >= ? AND b.end_time <= ? " +
                     "GROUP BY v.id, v.name ORDER BY bookings DESC";
        List<VenueUsageRow> rows = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, from);
            ps.setTimestamp(2, to);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VenueUsageRow r = new VenueUsageRow();
                    r.setVenueId(rs.getInt("id"));
                    r.setVenueName(rs.getString("name"));
                    r.setBookings(rs.getInt("bookings"));
                    r.setHours(rs.getDouble("hours"));
                    rows.add(r);
                }
            }
        }
        return rows;
    }

    // helper inner DTO for usage report
    public static class VenueUsageRow {
        private int venueId;
        private String venueName;
        private int bookings;
        private double hours;
        public int getVenueId() { return venueId; }
        public void setVenueId(int venueId) { this.venueId = venueId; }
        public String getVenueName() { return venueName; }
        public void setVenueName(String venueName) { this.venueName = venueName; }
        public int getBookings() { return bookings; }
        public void setBookings(int bookings) { this.bookings = bookings; }
        public double getHours() { return hours; }
        public void setHours(double hours) { this.hours = hours; }
    }
}
