package com.visitors;

import com.DAO.BookingDAO;
import com.SQL.Booking_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/bookingServlet")
public class bookingServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            int currentStep = 1;
            String message = "请填写预约信息。";

            request.setAttribute("currentStep", currentStep);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/visitors/Booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userid");
        int hallId = Integer.parseInt(request.getParameter("hallId"));
        String bookingTime = request.getParameter("bookingTime");
        boolean isGroup = "on".equals(request.getParameter("isGroup"));
        Integer groupSize = isGroup ? Integer.parseInt(request.getParameter("groupSize")) : null;

        Booking_Bean booking = new Booking_Bean();
        booking.setUserId(userId);
        booking.setHallId(hallId);
        booking.setBookingTime(bookingTime);
        booking.setStatus("pending");
        booking.setGroup(isGroup);
        booking.setGroupSize(groupSize);
        booking.setCreatedAt(new Timestamp(System.currentTimeMillis()).toString());

        try {
            bookingDAO.addBooking(booking);
            request.setAttribute("message", "预约提交成功，请等待审核。");
            request.setAttribute("currentStep", 2);
            request.getRequestDispatcher("/visitors/Booking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器错误");
        }
    }
}
