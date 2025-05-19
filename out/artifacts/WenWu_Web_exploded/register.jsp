<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>用户注册 - 文物展厅系统</title>
  <style>
    :root {
      --primary-color: #2c3e50;
      --secondary-color: #3498db;
      --error-color: #e74c3c;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f5f6fa;
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .register-container {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
      width: 100%;
      max-width: 500px;
    }

    h2 {
      color: var(--primary-color);
      text-align: center;
      margin-bottom: 2rem;
    }

    .form-group {
      margin-bottom: 1.5rem;
      position: relative;
    }

    label {
      display: block;
      margin-bottom: 0.5rem;
      color: var(--primary-color);
      font-weight: 500;
    }

    input {
      width: 100%;
      padding: 0.8rem;
      border: 2px solid #e0e0e0;
      border-radius: 6px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }

    input:focus {
      outline: none;
      border-color: var(--secondary-color);
    }

    .error-message {
      color: var(--error-color);
      font-size: 0.875rem;
      margin-top: 0.25rem;
      display: none;
    }

    .captcha-wrapper {
      display: flex;
      gap: 1rem;
    }

    #captchaInput {
      flex: 1;
    }

    #getCaptchaBtn {
      background: var(--secondary-color);
      color: white;
      border: none;
      padding: 0.8rem 1.5rem;
      border-radius: 6px;
      cursor: pointer;
      transition: background 0.3s ease;
    }

    #getCaptchaBtn:disabled {
      background: #bdc3c7;
      cursor: not-allowed;
    }

    #submitBtn {
      width: 100%;
      background: var(--primary-color);
      color: white;
      padding: 1rem;
      border: none;
      border-radius: 6px;
      font-size: 1rem;
      cursor: pointer;
      transition: background 0.3s ease;
    }

    #submitBtn:hover {
      background: #34495e;
    }

    .login-link {
      text-align: center;
      margin-top: 1.5rem;
    }

    .login-link a {
      color: var(--secondary-color);
      text-decoration: none;
    }

    /* 显示动态消息 */
    .message {
      text-align: center;
      margin-bottom: 1rem;
      padding: 0.5rem;
      border-radius: 6px;
    }

    .success {
      background: #d4edda;
      color: #155724;
    }

    .error {
      background: #f8d7da;
      color: #721c24;
    }
  </style>
</head>
<body>
<div class="register-container">
  <h2>创建新账号</h2>

  <!-- 显示动态消息 -->
  <c:if test="${not empty successMessage}">
    <div class="message success">${successMessage}</div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="message error">${errorMessage}</div>
  </c:if>

  <form id="registerForm" action="${pageContext.request.contextPath}/RegisterServlet" method="POST">
    <div class="form-group">
      <label for="username">用户名</label>
      <input
              type="text"
              id="username"
              name="username"
              placeholder="请输入4-16位字母/数字"
              required
              pattern="[A-Za-z0-9]{4,16}"
      >
      <div class="error-message" id="usernameError">用户名格式不正确</div>
    </div>

    <div class="form-group">
      <label for="password">密码</label>
      <input
              type="password"
              id="password"
              name="password"
              placeholder="至少包含字母、数字，8-20位"
              required
              pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$"
      >
      <div class="error-message" id="passwordError">密码需包含字母和数字</div>
    </div>

    <div class="form-group">
      <label for="confirmPassword">确认密码</label>
      <input
              type="password"
              id="confirmPassword"
              name="confirmPassword"
              placeholder="请再次输入密码"
              required
      >
      <div class="error-message" id="confirmPasswordError">两次密码不一致</div>
    </div>

    <div class="form-group captcha-wrapper" >
      <input
              type="text"
              id="captchaInput"
              name="captchaInput"
              placeholder="请输入验证码"
              required
      >
      <!-- 显示验证码图片 -->
      <img id="captchaImage" src="${pageContext.request.contextPath}/CaptchaServlet" alt="验证码图片" style="cursor: pointer;">
      <button type="button" id="getCaptchaBtn" onclick="refreshCaptcha()">刷新验证码</button>
    </div>


    <button type="submit" id="submitBtn">注册</button>
  </form>



  <script>
    function getCaptcha() {
      // 打开 CaptchaServlet 生成的验证码图片
      window.open('${pageContext.request.contextPath}/CaptchaServlet', '_blank');
    }
    function refreshCaptcha() {
      // 刷新验证码图片
      const captchaImage = document.getElementById('captchaImage');
      captchaImage.src = '${pageContext.request.contextPath}/CaptchaServlet?time=' + new Date().getTime();
    }
  </script>

  <div class="login-link">
    已有账号？<a href="login.jsp">立即登录</a>
  </div>
</div>

<script>
  // 简单前端校验示例
  document.getElementById('registerForm').addEventListener('submit', function (event) {
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (password !== confirmPassword) {
      event.preventDefault();
      document.getElementById('confirmPasswordError').style.display = 'block';
    } else {
      document.getElementById('confirmPasswordError').style.display = 'none';
    }
  });
</script>
</body>
</html>