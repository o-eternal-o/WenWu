package com.DAO;

import com.SQL.DatabaseConnector;
import com.SQL.User_Bean;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private DatabaseConnector dbConnector = new DatabaseConnector();

    public User_Bean findUserByUsername(String username) throws Exception {
        String query = "SELECT * FROM user WHERE username = ?";
        ResultSet rs = dbConnector.executeQuery(query, username);
        if (rs.next()) {
            User_Bean user = new User_Bean();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setRole(rs.getString("role"));
            user.setRealNameVerified(rs.getBoolean("real_name_verified"));
            user.setCreatedAt(rs.getString("created_at"));
            return user;
        }
        return null;
    }

    public List<User_Bean> listUsers() throws Exception {
        List<User_Bean> users = new ArrayList<>();
        String query = "SELECT * FROM user";
        ResultSet rs = dbConnector.executeQuery(query);
        while (rs.next()) {
            User_Bean user = new User_Bean();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setRole(rs.getString("role"));
            user.setRealNameVerified(rs.getBoolean("real_name_verified"));
            user.setCreatedAt(rs.getString("created_at"));
            users.add(user);
        }
        return users;
    }

    public List<User_Bean> searchUsers(String searchType, String searchInput) throws Exception {
        List<User_Bean> users = new ArrayList<>();
        String query = "SELECT * FROM user WHERE " + searchType + " LIKE ?";
        String param = "%" + searchInput + "%";
        ResultSet rs = dbConnector.executeQuery(query, param);
        while (rs.next()) {
            User_Bean user = new User_Bean();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setRole(rs.getString("role"));
            user.setRealNameVerified(rs.getBoolean("real_name_verified"));
            user.setCreatedAt(rs.getString("created_at"));
            users.add(user);
        }
        return users;
    }

    public void addUser(User_Bean user) throws Exception {
        String query = "INSERT INTO user (username, password, role, real_name_verified, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        dbConnector.executeUpdate(query,
                user.getUsername(),
                user.getPassword(),
                user.getRole(),
                user.isRealNameVerified(),
                user.getCreatedAt());
    }

    public User_Bean getUserById(int userId) throws Exception {
        String query = "SELECT * FROM user WHERE user_id = ?";
        ResultSet rs = dbConnector.executeQuery(query, userId);
        if (rs.next()) {
            User_Bean user = new User_Bean();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setRole(rs.getString("role"));
            user.setRealNameVerified(rs.getBoolean("real_name_verified"));
            user.setCreatedAt(rs.getString("created_at"));
            return user;
        }
        return null;
    }

    public void updateUser(User_Bean user) throws Exception {
        String query = "UPDATE user SET username = ?, password = ?, role = ?, real_name_verified = ?, created_at = ? WHERE user_id = ?";
        dbConnector.executeUpdate(query,
                user.getUsername(),
                user.getPassword(),
                user.getRole(),
                user.isRealNameVerified(),
                user.getCreatedAt(),
                user.getUserId());
    }

    public void deleteUser(int userId) throws Exception {
        String query = "DELETE FROM user WHERE user_id = ?";
        dbConnector.executeUpdate(query, userId);
    }
}