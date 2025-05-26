// src/main/java/com/visitors/VisitorsHomeServlet.java
package com.visitors;

import com.DAO.UserDAO;
import com.DAO.BookingDAO;
import com.DAO.FeedbackDAO;
import com.DAO.UserVerificationDAO;
import com.SQL.Feedback_Bean;
import com.SQL.UserVerification_Bean;
import com.SQL.User_Bean;
import com.SQL.Booking_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/visitors/home")
public class VisitorsHomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userid");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            UserDAO userDAO = new UserDAO();
            BookingDAO bookingDAO = new BookingDAO();
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            UserVerificationDAO verificationDAO = new UserVerificationDAO();

            User_Bean user = userDAO.getUserById(userId);
            List<Booking_Bean> userBookings = bookingDAO.listBookings()
                    .stream().filter(b -> b.getUserId() == userId).collect(Collectors.toList());
            // 查询当前用户的反馈记录
            List<Feedback_Bean> userFeedbacks = feedbackDAO.listFeedbacks()
                .stream().filter(f -> f.getUserId() == userId).collect(Collectors.toList());

            UserVerification_Bean verification = verificationDAO.getVerificationByUserId(userId);

            int bookingCount = userBookings.size();
            int feedbackCount = feedbackDAO.listFeedbacks().stream().filter(f -> f.getUserId() == userId).toArray().length;

            request.setAttribute("user", user);
            request.setAttribute("bookingCount", bookingCount);
            request.setAttribute("feedbackCount", feedbackCount);
            request.setAttribute("bookingList", userBookings);
            request.setAttribute("feedbackList", userFeedbacks);
            request.setAttribute("verification", verification);

            request.getRequestDispatcher("/visitors/visitors_home.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "用户信息加载失败");
        }
    }
}