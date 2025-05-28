package test;

import com.login.RegisterServlet;
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

@ExtendWith(MockitoExtension.class)
class RegisterServletTest {

    @InjectMocks
    private RegisterServlet registerServlet;

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
        when(mockRequest.getSession()).thenReturn(mockSession);
    }

    @Test
    void testRegisterSuccess() throws Exception {
        // 模拟请求参数
        when(mockRequest.getParameter("username")).thenReturn("testUser");
        when(mockRequest.getParameter("password")).thenReturn("Test1234");
        when(mockRequest.getParameter("confirmPassword")).thenReturn("Test1234");
        when(mockRequest.getParameter("captchaInput")).thenReturn("abcd");

        // 模拟 Session 中的验证码
        when(mockSession.getAttribute("captcha")).thenReturn("abcd");

        // 模拟转发到注册页面
        when(mockRequest.getRequestDispatcher("register.jsp")).thenReturn(mockDispatcher);

        // 执行测试
        registerServlet.doPost(mockRequest, mockResponse);

        // 验证成功消息和转发
        verify(mockRequest).setAttribute("successMessage", "注册成功，请登录！");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testRegisterCaptchaError() throws Exception {
        // 模拟请求参数
        when(mockRequest.getParameter("username")).thenReturn("testUser");
        when(mockRequest.getParameter("password")).thenReturn("Test1234");
        when(mockRequest.getParameter("confirmPassword")).thenReturn("Test1234");
        when(mockRequest.getParameter("captchaInput")).thenReturn("wrongCaptcha");

        // 模拟 Session 中的验证码
        when(mockSession.getAttribute("captcha")).thenReturn("abcd");

        // 模拟转发到注册页面
        when(mockRequest.getRequestDispatcher("register.jsp")).thenReturn(mockDispatcher);

        // 执行测试
        registerServlet.doPost(mockRequest, mockResponse);

        // 验证错误消息和转发
        verify(mockRequest).setAttribute("errorMessage", "验证码错误，请重试！<br>");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testRegisterPasswordMismatch() throws Exception {
        // 模拟请求参数
        when(mockRequest.getParameter("username")).thenReturn("testUser");
        when(mockRequest.getParameter("password")).thenReturn("Test1234");
        when(mockRequest.getParameter("confirmPassword")).thenReturn("Mismatch1234");
        when(mockRequest.getParameter("captchaInput")).thenReturn("abcd");

        // 模拟 Session 中的验证码
        when(mockSession.getAttribute("captcha")).thenReturn("abcd");

        // 模拟转发到注册页面
        when(mockRequest.getRequestDispatcher("register.jsp")).thenReturn(mockDispatcher);

        // 执行测试
        registerServlet.doPost(mockRequest, mockResponse);

        // 验证错误消息和转发
        verify(mockRequest).setAttribute("errorMessage", "两次输入的密码不一致，请重新输入。<br>");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }
}

