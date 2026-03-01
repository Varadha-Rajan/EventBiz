package dao;

import model.Venue;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VenueDAO {

    public int createVenue(Venue v) throws SQLException {
        String sql = "INSERT INTO venues (name, location, capacity, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, v.getName());
            ps.setString(2, v.getLocation());
            ps.setInt(3, v.getCapacity());
            ps.setString(4, v.getDescription());
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
            return -1;
        }
    }

    public Venue findById(int id) throws SQLException {
        String sql = "SELECT * FROM venues WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return toVenue(rs);
            }
        }
        return null;
    }

    public List<Venue> listAll() throws SQLException {
        String sql = "SELECT * FROM venues ORDER BY name";
        List<Venue> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(toVenue(rs));
        }
        return list;
    }

    public List<Venue> searchAvailable(Timestamp start, Timestamp end, Integer minCapacity) throws SQLException {
        // Find venues which have no overlapping booking in the requested time range
        String sql = "SELECT v.* FROM venues v " +
                     "WHERE (? IS NULL OR v.capacity >= ?) AND v.id NOT IN (" +
                     "  SELECT venue_id FROM venue_bookings WHERE NOT (end_time <= ? OR start_time >= ?)" +
                     ")";
        List<Venue> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (minCapacity == null) {
                ps.setNull(1, Types.INTEGER);
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(1, minCapacity);
                ps.setInt(2, minCapacity);
            }
            ps.setTimestamp(3, start);
            ps.setTimestamp(4, end);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(toVenue(rs));
            }
        }
        return list;
    }

    private Venue toVenue(ResultSet rs) throws SQLException {
        Venue v = new Venue();
        v.setId(rs.getInt("id"));
        v.setName(rs.getString("name"));
        v.setLocation(rs.getString("location"));
        v.setCapacity(rs.getInt("capacity"));
        v.setDescription(rs.getString("description"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        return v;
    }
}
