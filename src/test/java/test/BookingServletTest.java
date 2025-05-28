package test;

import com.admin.BookingServlet;
import com.DAO.BookingDAO;
import com.SQL.Booking_Bean;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.PrintWriter;
import java.util.Collections;

import static org.mockito.Mockito.*;

class BookingServletTest {
    private BookingServlet bookingServlet;

    @Mock
    private BookingDAO mockBookingDAO;

    @Mock
    private HttpServletRequest mockRequest;

    @Mock
    private HttpServletResponse mockResponse;

    @Mock
    private RequestDispatcher mockDispatcher;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        bookingServlet = new BookingServlet();
        bookingServlet.bookingDAO = mockBookingDAO; // 使用 Mock 的 BookingDAO
    }

    @Test
    void testListBookings() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("list");
        when(mockBookingDAO.listBookings()).thenReturn(Collections.emptyList());
        when(mockRequest.getRequestDispatcher("/admin/booking_list.jsp")).thenReturn(mockDispatcher);

        bookingServlet.doPost(mockRequest, mockResponse);

        verify(mockRequest).setAttribute("bookingList", Collections.emptyList());
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testAddBooking() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("add");
        when(mockRequest.getParameter("userId")).thenReturn("5");
        when(mockRequest.getParameter("hallId")).thenReturn("5");
        when(mockRequest.getParameter("bookingTime")).thenReturn("2025-10-01 10:00:00");
        when(mockRequest.getParameter("status")).thenReturn("pending");
        when(mockRequest.getParameter("isGroup")).thenReturn("0");
        when(mockRequest.getParameter("createdAt")).thenReturn("2025-09-30 12:00:00");

        // 模拟 HttpServletResponse.getWriter()
        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        bookingServlet.doPost(mockRequest, mockResponse);

        verify(mockBookingDAO).addBooking(any(Booking_Bean.class));
        verify(mockResponse).setContentType("text/plain;charset=UTF-8");
        verify(mockWriter).write("success");
    }
}
