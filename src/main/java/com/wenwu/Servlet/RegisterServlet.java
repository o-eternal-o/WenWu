package com.wenwu.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置请求编码为UTF-8，防止中文乱码
        request.setCharacterEncoding("UTF-8");

        // 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String captchaInput = request.getParameter("captchaInput");

        // 获取Session中的验证码
        HttpSession session = request.getSession();
        String generatedCaptcha = (String) session.getAttribute("captcha");

        // 存储错误信息
        StringBuilder errorMessage = new StringBuilder();

        // 验证验证码
        if (generatedCaptcha == null || !generatedCaptcha.equalsIgnoreCase(captchaInput)) {
            errorMessage.append("验证码错误，请重试！<br>");
        }

        // 验证用户名格式
        if (username == null || !username.matches("[A-Za-z0-9]{4,16}")) {
            errorMessage.append("用户名格式不正确，请输入4-16位字母或数字。<br>");
        }

        // 验证密码格式
        if (password == null || !password.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,20}$")) {
            errorMessage.append("密码格式不正确，请至少包含字母和数字，长度为8-20位。<br>");
        }

        // 验证两次密码是否一致
        if (!password.equals(confirmPassword)) {
            errorMessage.append("两次输入的密码不一致，请重新输入。<br>");
        }

        // 如果有错误信息，返回错误提示
        if (errorMessage.length() > 0) {
            request.setAttribute("errorMessage", errorMessage.toString());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 数据库操作：保存用户信息（此处仅模拟）
        boolean isRegistered = saveUserToDatabase(username, password);

        if (isRegistered) {
            // 注册成功，跳转到登录页面或显示成功消息
            request.setAttribute("successMessage", "注册成功，请登录！");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            // 注册失败
            request.setAttribute("errorMessage", "注册失败，请稍后再试！");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    /**
     * 模拟将用户信息保存到数据库的方法
     *
     * @param username 用户名
     * @param password 密码
     * @return 是否保存成功
     */
    private boolean saveUserToDatabase(String username, String password) {
        // 实际开发中，这里应该使用JDBC或ORM框架（如Hibernate、MyBatis）与数据库交互
        System.out.println("Saving user to database: " + username + ", " + password);
        // 模拟返回true表示保存成功
        return true;
    }
}