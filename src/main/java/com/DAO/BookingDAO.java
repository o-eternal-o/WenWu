package com.DAO;

import com.SQL.DatabaseConnector;
import com.SQL.Booking_Bean;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    private DatabaseConnector dbConnector = new DatabaseConnector();

    public List<Booking_Bean> listBookings() throws Exception {
        List<Booking_Bean> list = new ArrayList<>();
        String query = "SELECT * FROM booking";
        ResultSet rs = dbConnector.executeQuery(query);
        while (rs.next()) {
            Booking_Bean b = new Booking_Bean();
            b.setBookingId(rs.getInt("booking_id"));
            b.setUserId(rs.getInt("user_id"));
            b.setHallId(rs.getInt("hall_id"));
            b.setBookingTime(rs.getString("booking_time"));
            b.setStatus(rs.getString("status"));
            b.setGroup(rs.getBoolean("is_group"));
            b.setGroupSize(rs.getObject("group_size") != null ? rs.getInt("group_size") : null);
            b.setCreatedAt(rs.getString("created_at"));
            list.add(b);
        }
        return list;
    }

    public List<Booking_Bean> searchBookings(String searchType, String searchInput) throws Exception {
        List<Booking_Bean> list = new ArrayList<>();
        String query = "SELECT * FROM booking WHERE " + searchType + " LIKE ?";
        String param = "%" + searchInput + "%";
        ResultSet rs = dbConnector.executeQuery(query, param);
        while (rs.next()) {
            Booking_Bean b = new Booking_Bean();
            b.setBookingId(rs.getInt("booking_id"));
            b.setUserId(rs.getInt("user_id"));
            b.setHallId(rs.getInt("hall_id"));
            b.setBookingTime(rs.getString("booking_time"));
            b.setStatus(rs.getString("status"));
            b.setGroup(rs.getBoolean("is_group"));
            b.setGroupSize(rs.getObject("group_size") != null ? rs.getInt("group_size") : null);
            b.setCreatedAt(rs.getString("created_at"));
            list.add(b);
        }
        return list;
    }

    public void addBooking(Booking_Bean b) throws Exception {
        String query = "INSERT INTO booking (user_id, hall_id, booking_time, status, is_group, group_size, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        dbConnector.executeUpdate(query,
                b.getUserId(),
                b.getHallId(),
                b.getBookingTime(),
                b.getStatus(),
                b.isGroup(),
                b.getGroupSize(),
                b.getCreatedAt());
    }

    public Booking_Bean getBookingById(int bookingId) throws Exception {
        String query = "SELECT * FROM booking WHERE booking_id = ?";
        ResultSet rs = dbConnector.executeQuery(query, bookingId);
        if (rs.next()) {
            Booking_Bean b = new Booking_Bean();
            b.setBookingId(rs.getInt("booking_id"));
            b.setUserId(rs.getInt("user_id"));
            b.setHallId(rs.getInt("hall_id"));
            b.setBookingTime(rs.getString("booking_time"));
            b.setStatus(rs.getString("status"));
            b.setGroup(rs.getBoolean("is_group"));
            b.setGroupSize(rs.getObject("group_size") != null ? rs.getInt("group_size") : null);
            b.setCreatedAt(rs.getString("created_at"));
            return b;
        }
        return null;
    }

    public void updateBooking(Booking_Bean b) throws Exception {
        String query = "UPDATE booking SET user_id = ?, hall_id = ?, booking_time = ?, status = ?, is_group = ?, group_size = ?, created_at = ? WHERE booking_id = ?";
        dbConnector.executeUpdate(query,
                b.getUserId(),
                b.getHallId(),
                b.getBookingTime(),
                b.getStatus(),
                b.isGroup(),
                b.getGroupSize(),
                b.getCreatedAt(),
                b.getBookingId());
    }

    public void deleteBooking(int bookingId) throws Exception {
        String query = "DELETE FROM booking WHERE booking_id = ?";
        dbConnector.executeUpdate(query, bookingId);
    }
}