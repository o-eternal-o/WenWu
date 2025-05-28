package test;

import com.DAO.UserDAO;
import com.SQL.User_Bean;
import com.admin.UserServlet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

class UserServletTest {
    private UserServlet userServlet;
    private HttpServletRequest mockRequest;
    private HttpServletResponse mockResponse;
    private RequestDispatcher mockDispatcher;
    private UserDAO mockUserDAO;

    @BeforeEach
    void setUp() {
        mockRequest = mock(HttpServletRequest.class);
        mockResponse = mock(HttpServletResponse.class);
        mockDispatcher = mock(RequestDispatcher.class);
        mockUserDAO = mock(UserDAO.class);

        userServlet = new UserServlet();
        userServlet.userDAO = mockUserDAO;
    }

    @Test
    void testListUsers() throws Exception {
        List<User_Bean> mockUserList = Arrays.asList(new User_Bean(), new User_Bean());
        when(mockUserDAO.listUsers()).thenReturn(mockUserList);
        when(mockRequest.getParameter("action")).thenReturn("list");
        when(mockRequest.getRequestDispatcher("/admin/user_list.jsp")).thenReturn(mockDispatcher);

        userServlet.doPost(mockRequest, mockResponse);

        verify(mockUserDAO).listUsers();
        verify(mockRequest).setAttribute("userList", mockUserList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testSearchUsers() throws Exception {
        List<User_Bean> mockUserList = Collections.singletonList(new User_Bean());
        when(mockRequest.getParameter("action")).thenReturn("search");
        when(mockRequest.getParameter("searchType")).thenReturn("username");
        when(mockRequest.getParameter("searchInput")).thenReturn("testUser");
        when(mockUserDAO.searchUsers("username", "testUser")).thenReturn(mockUserList);
        when(mockRequest.getRequestDispatcher("/admin/user_list.jsp")).thenReturn(mockDispatcher);

        userServlet.doPost(mockRequest, mockResponse);

        verify(mockUserDAO).searchUsers("username", "testUser");
        verify(mockRequest).setAttribute("userList", mockUserList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testAddUser() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("add");
        when(mockRequest.getParameter("username")).thenReturn("testUser");
        when(mockRequest.getParameter("password")).thenReturn("password123");
        when(mockRequest.getParameter("role")).thenReturn("visitor");
        when(mockRequest.getParameter("realNameVerified")).thenReturn("1");
        when(mockRequest.getParameter("createdAt")).thenReturn("2023-01-01 12:00:00");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        userServlet.doPost(mockRequest, mockResponse);

        ArgumentCaptor<User_Bean> captor = ArgumentCaptor.forClass(User_Bean.class);
        verify(mockUserDAO).addUser(captor.capture());
        User_Bean capturedUser = captor.getValue();

        assertEquals("testUser", capturedUser.getUsername());
        assertEquals("password123", capturedUser.getPassword());
        assertEquals("visitor", capturedUser.getRole());
        assertEquals(true, capturedUser.isRealNameVerified());
        assertEquals("2023-01-01 12:00:00", capturedUser.getCreatedAt());

        verify(mockWriter).write("success");
    }

    @Test
    void testEditUser() throws Exception {
        User_Bean mockUser = new User_Bean();
        when(mockRequest.getParameter("action")).thenReturn("edit");
        when(mockRequest.getParameter("userId")).thenReturn("1");
        when(mockUserDAO.getUserById(1)).thenReturn(mockUser);
        when(mockRequest.getRequestDispatcher("/admin/function/user_edit.jsp")).thenReturn(mockDispatcher);

        userServlet.doPost(mockRequest, mockResponse);

        verify(mockUserDAO).getUserById(1);
        verify(mockRequest).setAttribute("user", mockUser);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testUpdateUser() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("update");
        when(mockRequest.getParameter("userId")).thenReturn("1");
        when(mockRequest.getParameter("username")).thenReturn("updatedUser");
        when(mockRequest.getParameter("password")).thenReturn("newPassword");
        when(mockRequest.getParameter("role")).thenReturn("admin");
        when(mockRequest.getParameter("realNameVerified")).thenReturn("0");
        when(mockRequest.getParameter("createdAt")).thenReturn("2023-01-02 12:00:00");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        userServlet.doPost(mockRequest, mockResponse);

        ArgumentCaptor<User_Bean> captor = ArgumentCaptor.forClass(User_Bean.class);
        verify(mockUserDAO).updateUser(captor.capture());
        User_Bean capturedUser = captor.getValue();

        assertEquals(1, capturedUser.getUserId());
        assertEquals("updatedUser", capturedUser.getUsername());
        assertEquals("newPassword", capturedUser.getPassword());
        assertEquals("admin", capturedUser.getRole());
        assertEquals(false, capturedUser.isRealNameVerified());
        assertEquals("2023-01-02 12:00:00", capturedUser.getCreatedAt());

        verify(mockWriter).write("success");
    }

    @Test
    void testDeleteUser() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("delete");
        when(mockRequest.getParameter("userId")).thenReturn("1");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        userServlet.doPost(mockRequest, mockResponse);

        verify(mockUserDAO).deleteUser(1);
        verify(mockWriter).write("success");
    }
}