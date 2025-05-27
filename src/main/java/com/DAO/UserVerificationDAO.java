package com.DAO;

import com.SQL.DatabaseConnector;
import com.SQL.UserVerification_Bean;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserVerificationDAO {
    private DatabaseConnector dbConnector = new DatabaseConnector();

    public List<UserVerification_Bean> listVerifications() throws Exception {
        List<UserVerification_Bean> list = new ArrayList<>();
        String query = "SELECT * FROM user_verification";
        ResultSet rs = dbConnector.executeQuery(query);
        while (rs.next()) {
            UserVerification_Bean bean = mapBean(rs);
            list.add(bean);
        }
        return list;
    }

    public List<UserVerification_Bean> searchVerifications(String searchType, String searchInput) throws Exception {
        List<UserVerification_Bean> list = new ArrayList<>();
        String query = "SELECT * FROM user_verification WHERE " + searchType + " LIKE ?";
        String param = "%" + searchInput + "%";
        ResultSet rs = dbConnector.executeQuery(query, param);
        while (rs.next()) {
            UserVerification_Bean bean = mapBean(rs);
            list.add(bean);
        }
        return list;
    }

    public void addVerification(UserVerification_Bean bean) throws Exception {
        String query = "INSERT INTO user_verification (user_id, real_name, phone, id_number, id_image_path, status, submitted_at, reviewed_at, reviewed_by, reject_reason) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        dbConnector.executeUpdate(query,
                bean.getUserId(), bean.getRealName(), bean.getPhone(), bean.getIdNumber(), bean.getIdImagePath(),
                bean.getStatus(), bean.getSubmittedAt(), bean.getReviewedAt(), bean.getReviewedBy(), bean.getRejectReason());
    }

    public UserVerification_Bean getVerificationById(int verificationId) throws Exception {
        String query = "SELECT * FROM user_verification WHERE verification_id = ?";
        ResultSet rs = dbConnector.executeQuery(query, verificationId);
        if (rs.next()) {
            return mapBean(rs);
        }
        return null;
    }

    public void updateVerification(UserVerification_Bean bean) throws Exception {
        String query = "UPDATE user_verification SET user_id=?, real_name=?, phone=?, id_number=?, id_image_path=?, status=?, submitted_at=?, reviewed_at=?, reviewed_by=?, reject_reason=? WHERE verification_id=?";
        System.out.println("Executing SQL: " + query);
        System.out.println("Parameters: " + bean.getUserId() + ", " + bean.getRealName() + ", " + bean.getPhone() + ", " + bean.getIdNumber() + ", " + bean.getIdImagePath() + ", " + bean.getStatus() + ", " + bean.getSubmittedAt() + ", " + bean.getReviewedAt() + ", " + bean.getReviewedBy() + ", " + bean.getRejectReason() + ", " + bean.getVerificationId());
        dbConnector.executeUpdate(query,
                bean.getUserId(), bean.getRealName(), bean.getPhone(), bean.getIdNumber(), bean.getIdImagePath(),
                bean.getStatus(), bean.getSubmittedAt(), bean.getReviewedAt(), bean.getReviewedBy(), bean.getRejectReason(),
                bean.getVerificationId());
    }

    public void deleteVerification(int verificationId) throws Exception {
        String query = "DELETE FROM user_verification WHERE verification_id = ?";
        dbConnector.executeUpdate(query, verificationId);
    }

    private UserVerification_Bean mapBean(ResultSet rs) throws Exception {
        UserVerification_Bean bean = new UserVerification_Bean();
        bean.setVerificationId(rs.getInt("verification_id"));
        bean.setUserId(rs.getInt("user_id"));
        bean.setRealName(rs.getString("real_name"));
        bean.setPhone(rs.getString("phone")); // 新增
        bean.setIdNumber(rs.getString("id_number"));
        bean.setIdImagePath(rs.getString("id_image_path"));
        bean.setStatus(rs.getString("status"));
        bean.setSubmittedAt(rs.getTimestamp("submitted_at"));
        bean.setReviewedAt(rs.getTimestamp("reviewed_at"));
        bean.setReviewedBy((Integer)rs.getObject("reviewed_by"));
        bean.setRejectReason(rs.getString("reject_reason"));
        return bean;
    }

    public UserVerification_Bean getVerificationByUserId(int userId) throws Exception {
        String query = "SELECT * FROM user_verification WHERE user_id = ?";
        ResultSet rs = dbConnector.executeQuery(query, userId);
        if (rs.next()) {
            return mapBean(rs);
        }
        return null;
    }


}