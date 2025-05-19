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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/HallServlet")
public class HallServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DatabaseConnector dbConnector = new DatabaseConnector();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求参数
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addHall(request, response);
        } else if ("update".equals(action)) {
            updateHall(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("list".equals(action)) {
            listHalls(request, response);
        } else if ("edit".equals(action)) {
            editHall(request, response);
        }
    }

    // 新增展厅
    private void addHall(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String hallName = request.getParameter("hallName");
        String location = request.getParameter("location");
        String description = request.getParameter("description");

        String sql = "INSERT INTO exhibition_hall (hall_name, location, description) VALUES (?, ?, ?)";
        try {
            dbConnector.executeUpdate(sql, hallName, location, description);
            response.sendRedirect("HallServlet?action=list"); // 跳转到列表页面
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "新增失败");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    // 编辑展厅
    private void updateHall(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int hallId = Integer.parseInt(request.getParameter("hallId"));
        String hallName = request.getParameter("hallName");
        String location = request.getParameter("location");
        String description = request.getParameter("description");

        String sql = "UPDATE exhibition_hall SET hall_name=?, location=?, description=? WHERE hall_id=?";
        try {
            dbConnector.executeUpdate(sql, hallName, location, description, hallId);
            response.sendRedirect("HallServlet?action=list"); // 跳转到列表页面
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "编辑失败");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    // 展厅列表
    private void listHalls(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sql = "SELECT * FROM exhibition_hall";
        try (ResultSet rs = dbConnector.executeQuery(sql)) {
            List<Hall> halls = new ArrayList<>();
            while (rs.next()) {
                Hall hall = new Hall(); // 确保 Hall 类具有无参构造函数
                hall.setHallId(rs.getInt("hall_id")); // 确保 Hall 类包含 setHallId 方法
                hall.setHallName(rs.getString("hall_name")); // 确保 Hall 类包含 setHallName 方法
                hall.setLocation(rs.getString("location")); // 确保 Hall 类包含 setLocation 方法
                hall.setDescription(rs.getString("description")); // 确保 Hall 类包含 setDescription 方法
                halls.add(hall);
            }
            request.setAttribute("halls", halls);
            request.getRequestDispatcher("hall_list.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取展厅列表失败");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    // 加载展厅信息（用于编辑）
    private void editHall(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int hallId = Integer.parseInt(request.getParameter("hallId"));

        String sql = "SELECT * FROM exhibition_hall WHERE hall_id=?";
        try (ResultSet rs = dbConnector.executeQuery(sql, hallId)) {
            if (rs.next()) {
                Hall hall = new Hall();
                hall.setHallId(rs.getInt("hall_id"));
                hall.setHallName(rs.getString("hall_name"));
                hall.setLocation(rs.getString("location"));
                hall.setDescription(rs.getString("description"));
                request.setAttribute("hall", hall);
                request.getRequestDispatcher("hall_edit.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "未找到指定展厅");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "加载展厅信息失败");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}