package com.wenwu.SQL;

import java.sql.*;

public class DatabaseConnector {
    // 数据库连接配置
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cultural_exhibition_db";
    private static final String JDBC_USER = "root";  // 替换为你的数据库用户名
    private static final String JDBC_PASSWORD = "2525";  // 替换为你的数据库密码

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found!", e);
        }
    }


    /**
     * 获取数据库连接
     * @return Connection 对象
     * @throws SQLException 如果连接失败
     */
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }

    /**
     * 执行查询操作并返回结果集
     * @param sql 查询SQL语句
     * @param params 查询参数（可选）
     * @return 查询结果集
     * @throws SQLException 如果执行失败
     */
    public ResultSet executeQuery(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            // 设置参数
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }

            rs = pstmt.executeQuery();
        } catch (SQLException e) {
            closeResources(conn, pstmt, rs);
            throw e;
        }

        return rs;
    }

    /**
     * 执行更新操作（插入、更新、删除）并返回受影响的行数
     * @param sql 更新SQL语句
     * @param params 更新参数（可选）
     * @return 受影响的行数
     * @throws SQLException 如果执行失败
     */
    public int executeUpdate(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int affectedRows = 0;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            // 设置参数
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }

            affectedRows = pstmt.executeUpdate();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return affectedRows;
    }

    /**
     * 关闭数据库资源
     * @param conn 数据库连接
     * @param stmt Statement 对象
     * @param rs 结果集
     */
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage());
        }
    }
}