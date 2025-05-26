package com.visitors;

import com.DAO.UserDAO;
import com.DAO.UserVerificationDAO;
import com.SQL.User_Bean;
import com.SQL.UserVerification_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/updateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Integer userId = (Integer) request.getSession().getAttribute("userid");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");

        try {
            // 更新用户名
            UserDAO userDAO = new UserDAO();
            User_Bean user = userDAO.getUserById(userId);
            user.setUsername(username);
            userDAO.updateUser(user);

            // 更新电话
            UserVerificationDAO verificationDAO = new UserVerificationDAO();
            UserVerification_Bean verification = verificationDAO.getVerificationByUserId(userId);
            if (verification != null) {
                verification.setPhone(phone);
                verificationDAO.updateVerification(verification);
            }

            // 更新session中的用户名
            request.getSession().setAttribute("username", username);

            response.sendRedirect(request.getContextPath() + "/visitors/home");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "信息修改失败");
        }
    }
}