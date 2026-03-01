package dao;

import model.Event;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public int createEvent(Event e) throws SQLException {
        String sql = "INSERT INTO events (title, description, venue_id, organizer_id, start_time, end_time, capacity, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getTitle());
            ps.setString(2, e.getDescription());
            if (e.getVenueId() == null) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, e.getVenueId());
            ps.setInt(4, e.getOrganizerId());
            ps.setTimestamp(5, e.getStartTime());
            ps.setTimestamp(6, e.getEndTime());
            ps.setInt(7, e.getCapacity());
            ps.setString(8, e.getStatus());
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
            return -1;
        }
    }

    public boolean updateEvent(Event e) throws SQLException {
        String sql = "UPDATE events SET title = ?, description = ?, venue_id = ?, start_time = ?, end_time = ?, capacity = ?, status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getTitle());
            ps.setString(2, e.getDescription());
            if (e.getVenueId() == null) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, e.getVenueId());
            ps.setTimestamp(4, e.getStartTime());
            ps.setTimestamp(5, e.getEndTime());
            ps.setInt(6, e.getCapacity());
            ps.setString(7, e.getStatus());
            ps.setInt(8, e.getId());
            return ps.executeUpdate() == 1;
        }
    }

    public boolean cancelEvent(int eventId) throws SQLException {
        String sql = "UPDATE events SET status = 'CANCELLED', updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            return ps.executeUpdate() == 1;
        }
    }

    public Event findById(int id) throws SQLException {
        String sql = "SELECT * FROM events WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return toEvent(rs);
            return null;
        }
    }

    public List<Event> listAll() throws SQLException {
        String sql = "SELECT * FROM events ORDER BY start_time DESC";
        List<Event> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(toEvent(rs));
        }
        return list;
    }

    public int countRegistered(int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM event_attendance WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        }
    }

    private Event toEvent(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setId(rs.getInt("id"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        int v = rs.getInt("venue_id");
        if (rs.wasNull()) e.setVenueId(null);
        else e.setVenueId(v);
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
