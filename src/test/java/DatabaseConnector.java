import java.sql.*;

public class DatabaseConnector {
    // 数据库连接配置
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cultural_exhibition_db";
    private static final String JDBC_USER = "root";  // 替换为你的数据库用户名
    private static final String JDBC_PASSWORD = "2525";  // 替换为你的数据库密码

    /**
     * 获取数据库连接
     * @return Connection 对象
     * @throws SQLException 如果连接失败
     */
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }

    /**
     * 执行查询操作
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
     * 执行更新操作（插入、更新、删除）
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
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        DatabaseConnector dbManager = new DatabaseConnector();

        // 示例：查询用户表
        String querySql = "SELECT * FROM user WHERE role = ?";
        try {
            ResultSet rs = dbManager.executeQuery(querySql, "admin");
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String role = rs.getString("role");
                System.out.printf("用户ID: %d, 用户名: %s, 角色: %s%n", userId, username, role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

//        // 示例：插入新用户
//        String insertSql = "INSERT INTO user (username, role) VALUES (?, ?)";
//        try {
//            int affectedRows = dbManager.executeUpdate(insertSql, "new_user", "user");
//            System.out.println("插入成功，受影响行数：" + affectedRows);
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
    }
}