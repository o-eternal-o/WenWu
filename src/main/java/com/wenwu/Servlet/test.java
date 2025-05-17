package com.wenwu.Servlet;

import com.wenwu.SQL.DatabaseConnector;
import java.sql.ResultSet;
import java.sql.SQLException;

public class test {
    public static void main(String[] args) {
        // 创建 DatabaseConnector 实例
        DatabaseConnector dbConnector = new DatabaseConnector();

        try {
            // 查询 user 表中的 user 和 password 信息
            String sql = "SELECT username, password FROM user";
            ResultSet rs = dbConnector.executeQuery(sql);

            // 遍历结果集并打印 user 和 password
            while (rs.next()) {
                String user = rs.getString("username");
                String password = rs.getString("password");
                System.out.println("Username: " + user + ", Password: " + password);
            }

            // 关闭结果集
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}