package test;

import com.DAO.HallDAO;
import com.SQL.Hall_Bean;
import com.admin.HallServlet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;

import static org.mockito.Mockito.*;

class HallServletTest {
    private HallServlet hallServlet;

    @Mock
    private HallDAO mockHallDAO;

    @Mock
    private HttpServletRequest mockRequest;

    @Mock
    private HttpServletResponse mockResponse;

    @Mock
    private RequestDispatcher mockDispatcher;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        hallServlet = new HallServlet();
        hallServlet.hallDAO = mockHallDAO;
    }

@Test
void testListHalls() throws Exception {
    // 模拟请求参数
    when(mockRequest.getParameter("action")).thenReturn("list");
    when(mockRequest.getRequestDispatcher("/admin/hall_list.jsp")).thenReturn(mockDispatcher);

    // 模拟 DAO 返回的展厅列表
    List<Hall_Bean> mockHallList = Collections.singletonList(new Hall_Bean());
    when(mockHallDAO.listHalls()).thenReturn(mockHallList);

    // 执行测试
    hallServlet.doPost(mockRequest, mockResponse);

    // 验证 DAO 调用
    verify(mockHallDAO).listHalls();
    // 验证请求属性设置
    verify(mockRequest).setAttribute("hallList", mockHallList);
    // 验证页面跳转
    verify(mockDispatcher).forward(mockRequest, mockResponse);
}

    @Test
    void testSearchHalls() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("search");
        when(mockRequest.getParameter("searchType")).thenReturn("type");
        when(mockRequest.getParameter("searchInput")).thenReturn("test");
        when(mockRequest.getRequestDispatcher("/admin/hall_list.jsp")).thenReturn(mockDispatcher);

        List<Hall_Bean> mockHallList = Collections.singletonList(new Hall_Bean());
        when(mockHallDAO.searchHalls("type", "test")).thenReturn(mockHallList);

        hallServlet.doPost(mockRequest, mockResponse);

        verify(mockHallDAO).searchHalls("type", "test");
        verify(mockRequest).setAttribute("hallList", mockHallList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testAddHall() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("add");
        when(mockRequest.getParameter("hallName")).thenReturn("Test Hall");
        when(mockRequest.getParameter("dynasty")).thenReturn("Tang");
        when(mockRequest.getParameter("type")).thenReturn("Artifact");
        when(mockRequest.getParameter("layoutRules")).thenReturn("Rule1");
        when(mockRequest.getParameter("isOpenBooking")).thenReturn("1");
        when(mockRequest.getParameter("bookingStartTime")).thenReturn("09:00");
        when(mockRequest.getParameter("bookingEndTime")).thenReturn("17:00");
        when(mockRequest.getParameter("maxCapacity")).thenReturn("100");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        hallServlet.doPost(mockRequest, mockResponse);

        verify(mockHallDAO).addHall(argThat(hall ->
            "Test Hall".equals(hall.getHallName()) &&
            "Tang".equals(hall.getDynasty()) &&
            "Artifact".equals(hall.getType()) &&
            "Rule1".equals(hall.getLayoutRules()) &&
            hall.isOpenBooking() &&
            "09:00".equals(hall.getBookingStartTime()) &&
            "17:00".equals(hall.getBookingEndTime()) &&
            hall.getMaxCapacity() == 100
        ));
        verify(mockResponse).setContentType("text/plain;charset=UTF-8");
        verify(mockWriter).write("success");
    }

    @Test
    void testUpdateHall() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("update");
        when(mockRequest.getParameter("hallId")).thenReturn("1");
        when(mockRequest.getParameter("hallName")).thenReturn("Updated Hall");
        when(mockRequest.getParameter("dynasty")).thenReturn("Song");
        when(mockRequest.getParameter("type")).thenReturn("Painting");
        when(mockRequest.getParameter("layoutRules")).thenReturn("Rule2");
        when(mockRequest.getParameter("isOpenBooking")).thenReturn("0");
        when(mockRequest.getParameter("bookingStartTime")).thenReturn("10:00");
        when(mockRequest.getParameter("bookingEndTime")).thenReturn("18:00");
        when(mockRequest.getParameter("maxCapacity")).thenReturn("200");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        hallServlet.doPost(mockRequest, mockResponse);

        verify(mockHallDAO).updateHall(argThat(hall ->
            hall.getHallId() == 1 &&
            "Updated Hall".equals(hall.getHallName()) &&
            "Song".equals(hall.getDynasty()) &&
            "Painting".equals(hall.getType()) &&
            "Rule2".equals(hall.getLayoutRules()) &&
            !hall.isOpenBooking() &&
            "10:00".equals(hall.getBookingStartTime()) &&
            "18:00".equals(hall.getBookingEndTime()) &&
            hall.getMaxCapacity() == 200
        ));
        verify(mockResponse).setContentType("text/plain;charset=UTF-8");
        verify(mockWriter).write("success");
    }

    @Test
    void testDeleteHall() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("delete");
        when(mockRequest.getParameter("hallId")).thenReturn("1");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        hallServlet.doPost(mockRequest, mockResponse);

        verify(mockHallDAO).deleteHall(1);
        verify(mockResponse).setContentType("text/plain;charset=UTF-8");
        verify(mockWriter).write("success");
    }

}