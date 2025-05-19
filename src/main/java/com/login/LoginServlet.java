package com.login;

import com.SQL.DatabaseConnector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DatabaseConnector dbConnector = new DatabaseConnector();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取表单数据

        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 使用数据库验证用户
        boolean isValidUser = validateUser(username, password);

        if (isValidUser) {
            // 查询用户角色
            String role = getUserRole(username);

            // 创建会话并存储用户信息
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", role); // 将角色存储到会话中

            // 根据角色跳转页面
            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/AdminServlet"); // 管理员
            } else {
                response.sendRedirect(request.getContextPath() + "/visitors.jsp"); // 普通用户页面
            }
        } else {
            // 登录失败，设置错误消息并重定向回登录页面
            request.setAttribute("errorMessage", "用户名或密码错误，请重试！");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * 验证用户凭据
     * @param username 用户名
     * @param password 密码
     * @return 如果用户有效则返回 true，否则返回 false
     */
    private boolean validateUser(String username, String password) {
        String sql = "SELECT * FROM user WHERE username = ? AND password = ?";

        try (ResultSet rs = dbConnector.executeQuery(sql, username, password)) {
            return rs.next();  // 如果结果集中有数据，则表示用户凭证有效
        } catch (SQLException e) {
            e.printStackTrace();
            return false;  // 出现异常时视为验证失败
        }
    }

    /**
     * 查询用户角色
     * @param username 用户名
     * @return 用户角色（如 admin 或其他）
     */
    private String getUserRole(String username) {
        String sql = "SELECT role FROM user WHERE username = ?";
        String role = "user"; // 默认角色为普通用户

        try (ResultSet rs = dbConnector.executeQuery(sql, username)) {
            if (rs.next()) {
                role = rs.getString("role"); // 获取角色列的值
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return role; // 返回角色值
    }
}