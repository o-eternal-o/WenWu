package com.visitors;

import com.DAO.BookingDAO;
import com.SQL.Booking_Bean;
import com.SQL.DatabaseConnector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.ResultSet;
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
        if (session == null || session.getAttribute("userid") == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "用户未登录");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userid");
            int hallId = Integer.parseInt(request.getParameter("hallId"));
            String bookingTime = request.getParameter("bookingTime");
            boolean isGroup = "on".equals(request.getParameter("isGroup"));
            int groupSize = 0;

            if (isGroup) {
                String groupSizeParam = request.getParameter("groupSize");
                if (groupSizeParam != null && !groupSizeParam.isEmpty()) {
                    groupSize = Integer.parseInt(groupSizeParam);
                }
            }

            // 验证 hall_id 是否存在
            if (!isHallIdValid(hallId)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的展厅ID");
                return;
            }

            Booking_Bean booking = new Booking_Bean();
            booking.setUserId(userId);
            booking.setHallId(hallId);
            booking.setBookingTime(bookingTime);
            booking.setStatus("pending");
            booking.setGroup(isGroup);
            booking.setGroupSize(groupSize);
            booking.setCreatedAt(new Timestamp(System.currentTimeMillis()).toString());

            bookingDAO.addBooking(booking);

            request.setAttribute("message", "预约提交成功，请等待审核。");
            request.setAttribute("currentStep", 2);
            request.getRequestDispatcher("/visitors/Booking.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的输入数据");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器错误");
        }
    }

    private boolean isHallIdValid(int hallId) throws Exception {
        String query = "SELECT COUNT(*) FROM halls WHERE hall_id = ?";
        ResultSet rs = new DatabaseConnector().executeQuery(query, hallId);
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
        return false;
    }
}
