package com.admin;

import com.DAO.BookingDAO;
import com.SQL.Booking_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Enumeration;
import java.util.List;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDAO bookingDAO = new BookingDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        try {
            switch (action) {
                case "list":
                    listBookings(request, response);
                    break;
                case "search":
                    searchBookings(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "add":
                    addBooking(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "edit":
                    editBooking(request, response);
                    request.getRequestDispatcher("/admin/function/booking_edit.jsp").forward(request, response);
                    break;
                case "update":
                    updateBooking(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "delete":
                    deleteBooking(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                default:
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("defeat");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void listBookings(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Booking_Bean> list = bookingDAO.listBookings();
        request.setAttribute("bookingList", list);
        request.getRequestDispatcher("/admin/booking_list.jsp").forward(request, response);
    }

    private void searchBookings(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String searchType = request.getParameter("searchType");
        String searchInput = request.getParameter("searchInput");
        List<Booking_Bean> list = bookingDAO.searchBookings(searchType, searchInput);
        request.setAttribute("bookingList", list);
        request.getRequestDispatcher("/admin/booking_list.jsp").forward(request, response);
    }

    private void addBooking(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        int hallId = Integer.parseInt(request.getParameter("hallId"));
        String bookingTime = request.getParameter("bookingTime");
        String status = request.getParameter("status");
        boolean isGroup = "1".equals(request.getParameter("isGroup"));
        String groupSizeStr = request.getParameter("groupSize");
        Integer groupSize = (groupSizeStr == null || groupSizeStr.isEmpty()) ? null : Integer.parseInt(groupSizeStr);
        String createdAt = request.getParameter("createdAt");

        Booking_Bean b = new Booking_Bean();
        b.setUserId(userId);
        b.setHallId(hallId);
        b.setBookingTime(bookingTime);
        b.setStatus(status);
        b.setGroup(isGroup);
        b.setGroupSize(groupSize);
        b.setCreatedAt(createdAt);

        bookingDAO.addBooking(b);
    }

    private void editBooking(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        Booking_Bean b = bookingDAO.getBookingById(bookingId);
        request.setAttribute("booking", b);
    }

    private void updateBooking(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        int hallId = Integer.parseInt(request.getParameter("hallId"));
        String bookingTime = request.getParameter("bookingTime");
        String status = request.getParameter("status");
        boolean isGroup = "1".equals(request.getParameter("isGroup"));
        String groupSizeStr = request.getParameter("groupSize");
        Integer groupSize = (groupSizeStr == null || groupSizeStr.isEmpty()) ? null : Integer.parseInt(groupSizeStr);
        String createdAt = request.getParameter("createdAt");

        Booking_Bean b = new Booking_Bean();
        b.setBookingId(bookingId);
        b.setUserId(userId);
        b.setHallId(hallId);
        b.setBookingTime(bookingTime);
        b.setStatus(status);
        b.setGroup(isGroup);
        b.setGroupSize(groupSize);
        b.setCreatedAt(createdAt);

        bookingDAO.updateBooking(b);
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        bookingDAO.deleteBooking(bookingId);
    }
}