package com.wenwu.Servlet;

import com.wenwu.SQL.DatabaseConnector;

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
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 使用数据库验证用户
        boolean isValidUser = validateUser(username, password);

        if (isValidUser) {
            // 创建会话并存储用户信息
            HttpSession session = request.getSession();
            session.setAttribute("username", username);

            // 登录成功，重定向到欢迎页面
            response.sendRedirect("success.jsp");
        } else {
            // 登录失败，设置错误消息并重定向回登录页面
            request.setAttribute("errorMessage", "用户名或密码错误，请重试！");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
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
}