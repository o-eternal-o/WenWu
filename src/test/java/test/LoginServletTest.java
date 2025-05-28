package test;

import com.DAO.UserDAO;
import com.SQL.User_Bean;
import com.login.LoginServlet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import static org.mockito.Mockito.*;
import java.util.List;
import java.util.Collections;

@ExtendWith(MockitoExtension.class)
class LoginServletTest {

    @InjectMocks
    private LoginServlet loginServlet;

    @Mock
    private UserDAO mockUserDAO;

    @Mock
    private HttpServletRequest mockRequest;

    @Mock
    private HttpServletResponse mockResponse;

    @Mock
    private HttpSession mockSession;

    @Mock
    private RequestDispatcher mockDispatcher;

    @BeforeEach
    void setUp() {
        loginServlet = new LoginServlet(mockUserDAO); // 使用 mockUserDAO
    }

    @Test
    void testLoginSuccess() throws Exception {
        // 模拟请求参数
        when(mockRequest.getParameter("username")).thenReturn("admin");
        when(mockRequest.getParameter("password")).thenReturn("123456");

        // 模拟 DAO 返回的用户
        User_Bean mockUser = createMockUser("admin", "123456", "admin");
        when(mockUserDAO.findUserByUsername("admin")).thenReturn(mockUser);
        when(mockUserDAO.searchUsers("username", "admin")).thenReturn(Collections.singletonList(mockUser));
        // 确保会话和重定向行为被正确模拟
        when(mockRequest.getSession()).thenReturn(mockSession);

        // 执行测试
        loginServlet.doPost(mockRequest, mockResponse);

        // 验证会话属性和重定向
        verify(mockSession).setAttribute("userid", mockUser.getUserId());
        verify(mockSession).setAttribute("username", "admin");
        verify(mockSession).setAttribute("role", "admin");
        verify(mockResponse).sendRedirect(contains("/AdminServlet"));
    }
    @Test
    void testLoginFailure() throws Exception {
        // 模拟请求参数
        when(mockRequest.getParameter("username")).thenReturn("wrongUser");
        when(mockRequest.getParameter("password")).thenReturn("wrongPass");

        // 模拟 DAO 返回 null
        when(mockUserDAO.findUserByUsername("wrongUser")).thenReturn(null);

        // 模拟转发到登录页面
        when(mockRequest.getRequestDispatcher("login.jsp")).thenReturn(mockDispatcher);

        // 执行测试
        loginServlet.doPost(mockRequest, mockResponse);

        // 验证错误消息和转发
        verify(mockRequest).setAttribute("errorMessage", "用户名或密码错误，请重试！");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testDaoException() throws Exception {
        // 模拟请求参数
        when(mockRequest.getParameter("username")).thenReturn("testUser");
        when(mockRequest.getParameter("password")).thenReturn("testPass");

        // 模拟 DAO 抛出异常
        when(mockUserDAO.findUserByUsername("testUser")).thenThrow(new RuntimeException("Database error"));

        // 模拟转发到登录页面
        when(mockRequest.getRequestDispatcher("login.jsp")).thenReturn(mockDispatcher);

        // 执行测试
        loginServlet.doPost(mockRequest, mockResponse);

        // 验证错误消息和转发
        verify(mockRequest).setAttribute("errorMessage", "用户名或密码错误，请重试！");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    private User_Bean createMockUser(String username, String password, String role) {
        User_Bean user = new User_Bean();
        user.setUserId(1);
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);
        return user;
    }
}