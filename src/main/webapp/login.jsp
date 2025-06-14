<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>用户登录 - 数字文物展厅系统</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    :root {
      --primary-red: #9b1b1f;
      --gold: #c8a86a;
      --dark-bg: #2a2a2a;
      --light-bg: #f8f1e5;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Microsoft YaHei', '宋体', sans-serif; }
    body { min-height: 100vh; background-color: var(--light-bg); color: #333; }
    .palace-nav { background: var(--primary-red); height: 80px; display: flex; align-items: center; padding: 0 5%; position: fixed; top: 0; left: 0; right: 0; z-index: 1000; box-shadow: 0 2px 10px rgba(0,0,0,0.3);}
    .nav-container { display: flex; align-items: center; justify-content: space-between; width: 100%; }
    .nav-logo { width: 80px; height: auto; object-fit: contain; }
    .nav-links { display: flex; gap: 25px; align-items: center; }
    .nav-link { color: white; text-decoration: none; font-size: 16px; position: relative; padding: 5px 0; }
    .nav-link::after { content: ''; position: absolute; bottom: 0; left: 0; width: 0; height: 2px; background: var(--gold); transition: width 0.3s; }
    .nav-link:hover::after { width: 100%; }
    .login-container { max-width: 500px; margin: 120px auto 40px; padding: 40px; background: white; border-radius: 8px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); border: 1px solid var(--gold); position: relative; overflow: hidden; }
    .login-container::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 5px; background: var(--primary-red); }
    h2 { text-align: center; color: var(--primary-red); margin-bottom: 30px; font-size: 28px; font-weight: 600; letter-spacing: 2px; }
    .form-group { margin-bottom: 25px; position: relative; }
    .form-group label { display: block; margin-bottom: 8px; color: var(--primary-red); font-weight: 500; }
    input { width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 4px; font-size: 16px; transition: all 0.3s; }
    input:focus { border-color: var(--gold); box-shadow: 0 0 0 3px rgba(200, 168, 106, 0.2); outline: none; }
    button { width: 100%; padding: 14px; background: var(--primary-red); color: white; border: none; border-radius: 4px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s; margin-top: 10px; }
    button:hover { background: #7e1518; }
    .register-link { display: block; text-align: center; margin-top: 20px; color: #666; text-decoration: none; transition: color 0.3s; }
    .register-link:hover { color: var(--primary-red); text-decoration: underline; }
    @media (max-width: 768px) {
      .palace-nav { padding: 0 20px; }
      .nav-logo { width: 60px; }
      .nav-links { gap: 15px; }
      .login-container { margin: 100px 20px 40px; padding: 30px; }
      h2 { font-size: 24px; }
    }
    @media (max-width: 480px) {
      .nav-links { display: none; }
      .login-container { padding: 25px; }
    }
  </style>
</head>
<body>
<!-- 故宫风格导航栏 -->
<nav class="palace-nav">
  <div class="nav-container">
    <img src="imgs/img/logo.jpg" alt="数字文物展厅" class="nav-logo">
    <div class="nav-links">
      <a href="index.html" class="nav-link">首页</a>
      <a href="#" class="nav-link">参观导览</a>
      <a href="#" class="nav-link">数字文物</a>
      <a href="#" class="nav-link">特展在线</a>
    </div>
  </div>
</nav>

<!-- 登录表单 -->
<div class="login-container">
  <h2>欢迎来到数字文物展厅</h2>
  <form id="loginForm" action="${pageContext.request.contextPath}/LoginServlet" method="POST">
    <div class="form-group">
      <label for="username">用户名</label>
      <input
        type="text"
        id="username"
        name="username"
        placeholder="请输入用户名"
        autocomplete="username"
        required
      >
    </div>
    <div class="form-group">
      <label for="password">密码</label>
      <input
        type="password"
        id="password"
        name="password"
        placeholder="请输入密码"
        autocomplete="current-password"
        required
      >
    </div>
    <button type="submit">立即登录</button>
    <a href="register.jsp" class="register-link">还没有账号？立即注册</a>
  </form>
  <!-- 显示错误消息 -->
  <c:if test="${not empty errorMessage}">
    <div style="color: red; text-align: center; margin-top: 1rem;">
      ${errorMessage}
    </div>
  </c:if>
</div>
</body>
</html>