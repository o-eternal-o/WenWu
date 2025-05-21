package com.DAO;

import com.SQL.DatabaseConnector;
import com.SQL.Feedback_Bean;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    private DatabaseConnector dbConnector = new DatabaseConnector();

    public List<Feedback_Bean> listFeedbacks() throws Exception {
        List<Feedback_Bean> list = new ArrayList<>();
        String query = "SELECT * FROM feedback";
        ResultSet rs = dbConnector.executeQuery(query);
        while (rs.next()) {
            Feedback_Bean fb = new Feedback_Bean();
            fb.setFeedbackId(rs.getInt("feedback_id"));
            fb.setUserId(rs.getInt("user_id"));
            fb.setRelicId(rs.getObject("relic_id") != null ? rs.getInt("relic_id") : null);
            fb.setContent(rs.getString("content"));
            fb.setStatus(rs.getString("status"));
            fb.setResolvedResult(rs.getString("resolved_result"));
            fb.setCreatedAt(rs.getString("created_at"));
            list.add(fb);
        }
        return list;
    }

    public List<Feedback_Bean> searchFeedbacks(String searchType, String searchInput) throws Exception {
        List<Feedback_Bean> list = new ArrayList<>();
        String query = "SELECT * FROM feedback WHERE " + searchType + " LIKE ?";
        String param = "%" + searchInput + "%";
        ResultSet rs = dbConnector.executeQuery(query, param);
        while (rs.next()) {
            Feedback_Bean fb = new Feedback_Bean();
            fb.setFeedbackId(rs.getInt("feedback_id"));
            fb.setUserId(rs.getInt("user_id"));
            fb.setRelicId(rs.getObject("relic_id") != null ? rs.getInt("relic_id") : null);
            fb.setContent(rs.getString("content"));
            fb.setStatus(rs.getString("status"));
            fb.setResolvedResult(rs.getString("resolved_result"));
            fb.setCreatedAt(rs.getString("created_at"));
            list.add(fb);
        }
        return list;
    }

    public void addFeedback(Feedback_Bean fb) throws Exception {
        String query = "INSERT INTO feedback (user_id, relic_id, content, status, resolved_result, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        dbConnector.executeUpdate(query,
                fb.getUserId(),
                fb.getRelicId(),
                fb.getContent(),
                fb.getStatus(),
                fb.getResolvedResult(),
                fb.getCreatedAt());
    }

    public Feedback_Bean getFeedbackById(int feedbackId) throws Exception {
        String query = "SELECT * FROM feedback WHERE feedback_id = ?";
        ResultSet rs = dbConnector.executeQuery(query, feedbackId);
        if (rs.next()) {
            Feedback_Bean fb = new Feedback_Bean();
            fb.setFeedbackId(rs.getInt("feedback_id"));
            fb.setUserId(rs.getInt("user_id"));
            fb.setRelicId(rs.getObject("relic_id") != null ? rs.getInt("relic_id") : null);
            fb.setContent(rs.getString("content"));
            fb.setStatus(rs.getString("status"));
            fb.setResolvedResult(rs.getString("resolved_result"));
            fb.setCreatedAt(rs.getString("created_at"));
            return fb;
        }
        return null;
    }

    public void updateFeedback(Feedback_Bean fb) throws Exception {
        String query = "UPDATE feedback SET user_id = ?, relic_id = ?, content = ?, status = ?, resolved_result = ?, created_at = ? WHERE feedback_id = ?";
        dbConnector.executeUpdate(query,
                fb.getUserId(),
                fb.getRelicId(),
                fb.getContent(),
                fb.getStatus(),
                fb.getResolvedResult(),
                fb.getCreatedAt(),
                fb.getFeedbackId());
    }

    public void deleteFeedback(int feedbackId) throws Exception {
        String query = "DELETE FROM feedback WHERE feedback_id = ?";
        dbConnector.executeUpdate(query, feedbackId);
    }
}