package com.admin;

import com.SQL.DatabaseConnector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DatabaseConnector dbConnector = new DatabaseConnector();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取统计数据
        int openHallCount = getOpenHallCount(); // 开放展厅数量
        System.out.println("openHallCount: " + openHallCount);
        int relicTotal = getRelicTotal(); // 文物总数
        System.out.println(relicTotal);
        int pendingBookings = getPendingBookingCount(); // 待审预约数量
        System.out.println(pendingBookings);
        int userTotal = getUserTotal(); // 用户总数
        System.out.println(userTotal);

        // 将数据存储到请求范围中
        request.setAttribute("openHallCount", openHallCount);
        request.setAttribute("relicTotal", relicTotal);
        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("userTotal", userTotal);

        // 转发到 admin.jsp 页面
        request.getRequestDispatcher("admin/admin.jsp").forward(request, response);
    }

    /**
     * 统计开放展厅的数量
     * @return 开放展厅的数量
     */
    private int getOpenHallCount() {
        String sql = "SELECT COUNT(*) AS count FROM exhibition_hall WHERE is_open_booking=1";
        try (ResultSet rs = dbConnector.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // 查询失败时返回 0
    }

    /**
     * 统计文物总数
     * @return 文物总数
     */
    private int getRelicTotal() {
        String sql = "SELECT COUNT(*) AS count FROM cultural_relic";
        try (ResultSet rs = dbConnector.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // 查询失败时返回 0
    }

    /**
     * 统计待审预约的数量
     * @return 待审预约的数量
     */
    private int getPendingBookingCount() {
        String sql = "SELECT COUNT(*) AS count FROM booking WHERE status = 'pending'";
        try (ResultSet rs = dbConnector.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // 查询失败时返回 0
    }

    /**
     * 统计用户总数
     * @return 用户总数
     */
    private int getUserTotal() {
        String sql = "SELECT COUNT(*) AS count FROM user";
        try (ResultSet rs = dbConnector.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // 查询失败时返回 0
    }
}