package com.DAO;

import com.SQL.DatabaseConnector;
import com.SQL.Hall_Bean;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class HallDAO {

    private DatabaseConnector dbConnector = new DatabaseConnector();

    /**
     * 查询所有展厅信息
     */
    public List<Hall_Bean> listHalls() throws Exception {
        List<Hall_Bean> halls = new ArrayList<>();
        String query = "SELECT * FROM halls";
        ResultSet rs = dbConnector.executeQuery(query);
        while (rs.next()) {
            Hall_Bean hall = new Hall_Bean();
            hall.setHallId(rs.getInt("hall_id"));
            hall.setHallName(rs.getString("hall_name"));
            hall.setDynasty(rs.getString("dynasty"));
            hall.setType(rs.getString("type"));
            hall.setLayoutRules(rs.getString("layout_rules"));
            hall.setOpenBooking(rs.getBoolean("is_open_booking"));
            hall.setBookingStartTime(rs.getString("booking_start_time"));
            hall.setBookingEndTime(rs.getString("booking_end_time"));
            hall.setMaxCapacity(rs.getInt("max_capacity"));
            halls.add(hall);
        }
        return halls;
    }

    /**
     * 查询特定展厅信息
     */
    public List<Hall_Bean> searchHalls(String searchType, String searchInput) throws Exception {
        List<Hall_Bean> halls = new ArrayList<>();
        // 使用占位符 ? 构建 SQL 查询，避免 SQL 注入
        String query = "SELECT * FROM halls WHERE " + searchType + " LIKE ?";
        // 在参数中添加通配符
        String param = "%" + searchInput + "%";
        ResultSet rs = dbConnector.executeQuery(query, param);

        while (rs.next()) {
            Hall_Bean hall = new Hall_Bean();
            hall.setHallId(rs.getInt("hall_id"));
            hall.setHallName(rs.getString("hall_name"));
            hall.setDynasty(rs.getString("dynasty"));
            hall.setType(rs.getString("type"));
            hall.setLayoutRules(rs.getString("layout_rules"));
            hall.setOpenBooking(rs.getBoolean("is_open_booking"));
            hall.setBookingStartTime(rs.getString("booking_start_time"));
            hall.setBookingEndTime(rs.getString("booking_end_time"));
            hall.setMaxCapacity(rs.getInt("max_capacity"));
            halls.add(hall);
        }
        return halls;
    }

    /**
     * 添加展厅信息
     */
    public void addHall(Hall_Bean hall) throws Exception {
        String query = "INSERT INTO halls (hall_name, dynasty, type, layout_rules, is_open_booking, booking_start_time, booking_end_time, max_capacity) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        dbConnector.executeUpdate(query,
                hall.getHallName(),
                hall.getDynasty(),
                hall.getType(),
                hall.getLayoutRules(),
                hall.isOpenBooking(),
                hall.getBookingStartTime(),
                hall.getBookingEndTime(),
                hall.getMaxCapacity());
    }

    /**
     * 获取单个展厅信息
     */
    public Hall_Bean getHallById(int hallId) throws Exception {
        String query = "SELECT * FROM halls WHERE hall_id = ?";
        ResultSet rs = dbConnector.executeQuery(query, hallId);
        if (rs.next()) {
            Hall_Bean hall = new Hall_Bean();
            hall.setHallId(rs.getInt("hall_id"));
            hall.setHallName(rs.getString("hall_name"));
            hall.setDynasty(rs.getString("dynasty"));
            hall.setType(rs.getString("type"));
            hall.setLayoutRules(rs.getString("layout_rules"));
            hall.setOpenBooking(rs.getBoolean("is_open_booking"));
            hall.setBookingStartTime(rs.getString("booking_start_time"));
            hall.setBookingEndTime(rs.getString("booking_end_time"));
            hall.setMaxCapacity(rs.getInt("max_capacity"));
            return hall;
        }
        return null;
    }

    /**
     * 修改展厅信息
     */
    public void updateHall(Hall_Bean hall) throws Exception {
        String query = "UPDATE halls SET hall_name = ?, dynasty = ?, type = ?, layout_rules = ?, is_open_booking = ?, booking_start_time = ?, booking_end_time = ?, max_capacity = ? WHERE hall_id = ?";  // 修改为 "hall_id"
        dbConnector.executeUpdate(query,
                hall.getHallName(),
                hall.getDynasty(),
                hall.getType(),
                hall.getLayoutRules(),
                hall.isOpenBooking(),
                hall.getBookingStartTime(),
                hall.getBookingEndTime(),
                hall.getMaxCapacity(),
                hall.getHallId());
    }

    /**
     * 删除展厅信息
     */
    public void deleteHall(int hallId) throws Exception {
        String query = "DELETE FROM halls WHERE hall_id = ?";  // 修改为 "hall_id"
        dbConnector.executeUpdate(query, hallId);
    }
}