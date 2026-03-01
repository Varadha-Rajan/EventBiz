package dao;

import model.Event;
import model.User;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AttendanceDAO - backward compatible with older servlet calls.
 * Provides:
 *  - register(eventId, userId)
 *  - unregister(eventId, userId)
 *  - listEventsForUser(userId) -> List<Event>
 *  - listUsersForEvent(eventId) -> List<User>
 *  - countRegistrations(eventId)
 */
public class AttendanceDAO {

    // --- old-style method names used by servlets ---

    public boolean register(int eventId, int userId) throws SQLException {
        return registerUser(userId, eventId);
    }

    public boolean unregister(int eventId, int userId) throws SQLException {
        return unregisterUser(userId, eventId);
    }

    public boolean markAttended(int eventId, int userId) throws SQLException {
        String sql = "UPDATE event_attendance SET attended = TRUE WHERE event_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        }
    }

    // --- clearer/internal methods ---

    public boolean registerUser(int userId, int eventId) throws SQLException {
        String sql = "INSERT INTO event_attendance (user_id, event_id, registered_at) VALUES (?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean unregisterUser(int userId, int eventId) throws SQLException {
        String sql = "DELETE FROM event_attendance WHERE user_id = ? AND event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean isRegistered(int userId, int eventId) throws SQLException {
        String sql = "SELECT 1 FROM event_attendance WHERE user_id = ? AND event_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int countRegistrations(int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM event_attendance WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * BACKWARD-COMPATIBLE: the servlet calls listEventsForUser(userId) expecting List<Event>.
     * This method returns full Event objects for each event the user is registered for.
     */
    public List<Event> listEventsForUser(int userId) throws SQLException {
        String sql = """
            SELECT e.* FROM events e
            JOIN event_attendance ea ON e.id = ea.event_id
            WHERE ea.user_id = ?
            ORDER BY e.start_time DESC
            """;
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    events.add(mapEvent(rs));
                }
            }
        }
        return events;
    }

    /**
     * Admin helper: list full User objects who registered for an event.
     */
    public List<User> listUsersForEvent(int eventId) throws SQLException {
        String sql = "SELECT u.* FROM users u JOIN event_attendance ea ON u.id = ea.user_id WHERE ea.event_id = ? ORDER BY ea.registered_at DESC";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    // don't populate password in UI
                    u.setRole(rs.getString("role"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    users.add(u);
                }
            }
        }
        return users;
    }

    // map events from ResultSet -> Event model
    private Event mapEvent(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setId(rs.getInt("id"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        int vid = rs.getInt("venue_id");
        if (rs.wasNull()) e.setVenueId(null); else e.setVenueId(vid);
        e.setOrganizerId(rs.getInt("organizer_id"));
        e.setStartTime(rs.getTimestamp("start_time"));
        e.setEndTime(rs.getTimestamp("end_time"));
        e.setCapacity(rs.getInt("capacity"));
        e.setStatus(rs.getString("status"));
        e.setCreatedAt(rs.getTimestamp("created_at"));
        e.setUpdatedAt(rs.getTimestamp("updated_at"));
        return e;
    }
}
