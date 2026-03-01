package model;

import java.sql.Timestamp;

public class VenueBooking {
    private int id;
    private int venueId;
    private int userId;
    private String title;
    private Timestamp startTime;
    private Timestamp endTime;
    private Timestamp createdAt;

    // getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getVenueId() { return venueId; }
    public void setVenueId(int venueId) { this.venueId = venueId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
