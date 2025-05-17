import java.sql.*;

public class JdbcDemo {
    // 数据库连接配置
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cultural_exhibition_db";
    private static final String JDBC_USER = "root";  // 替换为你的数据库用户名
    private static final String JDBC_PASSWORD = "2525";  // 替换为你的数据库密码

    public static void main(String[] args) {
        // 1. 加载驱动（JDBC 4.0+可省略）
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }

        // 2. 建立连接
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD)) {
            System.out.println("数据库连接成功！");

            // 3. 执行查询（示例：查询所有用户）
            String sql = "SELECT * FROM user";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {

                // 4. 处理结果
                while (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String username = rs.getString("username");
                    String role = rs.getString("role");
                    System.out.printf("用户ID: %d, 用户名: %s, 角色: %s%n", userId, username, role);
                }
            }

        } catch (SQLException e) {
            System.err.println("数据库连接失败！");
            e.printStackTrace();
        }
    }
}