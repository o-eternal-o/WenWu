package com.login;

import com.DAO.UserDAO;
import com.SQL.User_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取表单数据
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 使用 DAO 验证用户
        boolean isValidUser = validateUser(username, password);

        if (isValidUser) {
            // 查询用户信息
            User_Bean userInfo = getUserInfo(username);
            if (userInfo != null) {
                int userId = userInfo.getUserId();
                String role = userInfo.getRole();

                // 创建会话并存储用户信息
                HttpSession session = request.getSession();
                session.setAttribute("userid", userId);
                session.setAttribute("username", username);
                session.setAttribute("role", role); // 将角色存储到会话中

                // 根据角色跳转页面
                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/AdminServlet"); // 管理员
                } else {
                    response.sendRedirect(request.getContextPath() + "/VisitorsServlet"); // 普通用户页面
                }
            } else {
                // 用户信息获取失败
                request.setAttribute("errorMessage", "无法获取用户信息，请重试！");
                request.getRequestDispatcher("login.jsp").forward(request, response);
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
        try {
            List<User_Bean> users = userDAO.searchUsers("username", username);
            for (User_Bean user : users) {
                if (user.getPassword().equals(password)) {
                    return true; // 用户名和密码匹配
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // 验证失败
    }

    /**
     * 查询用户信息
     * @param username 用户名
     * @return 包含用户 ID 和角色的 User_Bean 对象
     */
    private User_Bean getUserInfo(String username) {
        try {
            List<User_Bean> users = userDAO.searchUsers("username", username);
            if (!users.isEmpty()) {
                return users.get(0); // 返回第一个匹配的用户
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}