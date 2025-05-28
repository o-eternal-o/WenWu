package test;

import com.DAO.UserVerificationDAO;
import com.SQL.UserVerification_Bean;
import com.admin.UserVerificationServlet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

class UserVerificationServletTest {
    private UserVerificationServlet servlet;
    private HttpServletRequest mockRequest;
    private HttpServletResponse mockResponse;
    private RequestDispatcher mockDispatcher;
    private UserVerificationDAO mockDAO;

    @BeforeEach
    void setUp() {
        mockRequest = mock(HttpServletRequest.class);
        mockResponse = mock(HttpServletResponse.class);
        mockDispatcher = mock(RequestDispatcher.class);
        mockDAO = mock(UserVerificationDAO.class);

        servlet = new UserVerificationServlet();
        servlet.dao = mockDAO;
    }

    @Test
    void testList() throws Exception {
        List<UserVerification_Bean> mockList = Arrays.asList(new UserVerification_Bean(), new UserVerification_Bean());
        when(mockDAO.listVerifications()).thenReturn(mockList);
        when(mockRequest.getParameter("action")).thenReturn("list");
        when(mockRequest.getRequestDispatcher("/admin/user_verification_list.jsp")).thenReturn(mockDispatcher);

        servlet.doPost(mockRequest, mockResponse);

        verify(mockDAO).listVerifications();
        verify(mockRequest).setAttribute("verificationList", mockList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testSearch() throws Exception {
        List<UserVerification_Bean> mockList = Collections.singletonList(new UserVerification_Bean());
        when(mockRequest.getParameter("action")).thenReturn("search");
        when(mockRequest.getParameter("searchType")).thenReturn("realName");
        when(mockRequest.getParameter("searchInput")).thenReturn("John");
        when(mockDAO.searchVerifications("realName", "John")).thenReturn(mockList);
        when(mockRequest.getRequestDispatcher("/admin/user_verification_list.jsp")).thenReturn(mockDispatcher);

        servlet.doPost(mockRequest, mockResponse);

        verify(mockDAO).searchVerifications("realName", "John");
        verify(mockRequest).setAttribute("verificationList", mockList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testAdd() throws Exception {
        Part mockPart = mock(Part.class);
        when(mockRequest.getParameter("action")).thenReturn("add");
        when(mockRequest.getParameter("userId")).thenReturn("1");
        when(mockRequest.getParameter("realName")).thenReturn("John Doe");
        when(mockRequest.getParameter("phone")).thenReturn("123456789");
        when(mockRequest.getParameter("idNumber")).thenReturn("ID123456");
        when(mockRequest.getParameter("status")).thenReturn("PENDING");
        when(mockRequest.getPart("idImage")).thenReturn(mockPart);

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        servlet.doPost(mockRequest, mockResponse);

        ArgumentCaptor<UserVerification_Bean> captor = ArgumentCaptor.forClass(UserVerification_Bean.class);
        verify(mockDAO).addVerification(captor.capture());
        UserVerification_Bean capturedBean = captor.getValue();

        assertEquals(1, capturedBean.getUserId());
        assertEquals("John Doe", capturedBean.getRealName());
        assertEquals("123456789", capturedBean.getPhone());
        assertEquals("ID123456", capturedBean.getIdNumber());
        assertEquals("PENDING", capturedBean.getStatus());

        verify(mockWriter).write("success");
    }

    @Test
    void testEdit() throws Exception {
        UserVerification_Bean mockBean = new UserVerification_Bean();
        when(mockRequest.getParameter("action")).thenReturn("edit");
        when(mockRequest.getParameter("verificationId")).thenReturn("1");
        when(mockDAO.getVerificationById(1)).thenReturn(mockBean);
        when(mockRequest.getRequestDispatcher("/admin/function/user_verification_edit.jsp")).thenReturn(mockDispatcher);

        servlet.doPost(mockRequest, mockResponse);

        verify(mockDAO).getVerificationById(1);
        verify(mockRequest).setAttribute("verification", mockBean);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testUpdate() throws Exception {
        Part mockPart = mock(Part.class);
        when(mockRequest.getParameter("action")).thenReturn("update");
        when(mockRequest.getParameter("verificationId")).thenReturn("1");
        when(mockRequest.getParameter("userId")).thenReturn("1");
        when(mockRequest.getParameter("realName")).thenReturn("Updated Name");
        when(mockRequest.getParameter("phone")).thenReturn("987654321");
        when(mockRequest.getParameter("idNumber")).thenReturn("ID654321");
        when(mockRequest.getParameter("status")).thenReturn("APPROVED");
        when(mockRequest.getPart("idImage")).thenReturn(mockPart);

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        servlet.doPost(mockRequest, mockResponse);

        ArgumentCaptor<UserVerification_Bean> captor = ArgumentCaptor.forClass(UserVerification_Bean.class);
        verify(mockDAO).updateVerification(captor.capture());
        UserVerification_Bean capturedBean = captor.getValue();

        assertEquals(1, capturedBean.getVerificationId());
        assertEquals(1, capturedBean.getUserId());
        assertEquals("Updated Name", capturedBean.getRealName());
        assertEquals("987654321", capturedBean.getPhone());
        assertEquals("ID654321", capturedBean.getIdNumber());
        assertEquals("APPROVED", capturedBean.getStatus());

        verify(mockWriter).write("success");
    }

    @Test
    void testDelete() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("delete");
        when(mockRequest.getParameter("verificationId")).thenReturn("1");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        servlet.doPost(mockRequest, mockResponse);

        verify(mockDAO).deleteVerification(1);
        verify(mockWriter).write("success");
    }
}
