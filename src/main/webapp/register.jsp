<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 数字文物展厅系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-red: #9b1b1f;
            --gold: #c8a86a;
            --dark-bg: #2a2a2a;
            --error-color: #e74c3c;
            --background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Microsoft YaHei', '宋体', sans-serif; }
        body { min-height: 100vh; background: var(--background); }
        .palace-nav { background: var(--primary-red); height: 80px; display: flex; align-items: center; padding: 0 5%; box-shadow: 0 2px 10px rgba(0,0,0,0.3); position: fixed; width: 100%; top: 0; z-index: 1000; }
        .nav-container { width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .nav-logo { width: 80px; height: auto; object-fit: contain; }
        .nav-links { display: flex; gap: 35px; align-items: center; }
        .nav-link { color: white; text-decoration: none; font-size: 18px; position: relative; padding: 5px 0; transition: color 0.3s; }
        .nav-link::after { content: ''; position: absolute; bottom: 0; left: 0; width: 0; height: 2px; background: var(--gold); transition: width 0.3s; }
        .nav-link:hover { color: var(--gold); }
        .nav-link:hover::after { width: 100%; }
        .register-container { background: rgba(255, 255, 255, 0.95); padding: 2.5rem; border-radius: 16px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); width: 90%; max-width: 600px; margin: 120px auto 50px; border: 2px solid var(--gold); backdrop-filter: blur(10px); }
        h2 { color: var(--primary-red); text-align: center; margin-bottom: 2rem; font-size: 2.2em; text-shadow: 2px 2px 4px rgba(0,0,0,0.1); letter-spacing: 2px; }
        .form-group { margin-bottom: 1.8rem; position: relative; }
        label { display: block; margin-bottom: 0.8rem; color: var(--primary-red); font-weight: 600; font-size: 1.1rem; }
        input { width: 100%; padding: 14px 18px; border: 2px solid var(--gold); border-radius: 8px; font-size: 1rem; transition: all 0.3s ease; background: rgba(255,255,255,0.9); }
        input:focus { outline: none; border-color: var(--primary-red); box-shadow: 0 0 0 3px rgba(155,27,31,0.2); }
        .error-message { color: var(--error-color); font-size: 0.9rem; margin-top: 0.5rem; display: none; padding-left: 8px; }
        .captcha-group { margin-bottom: 1.8rem; }
        .captcha-wrapper { display: flex; gap: 1rem; align-items: center; }
        #captchaImage { height: 50px; border: 2px solid var(--gold); border-radius: 6px; cursor: pointer; transition: all 0.3s ease; }
        #captchaImage:hover { transform: scale(1.05); }
        .refresh-btn { background: var(--gold); color: var(--primary-red); border: none; padding: 10px; border-radius: 6px; cursor: pointer; transition: all 0.3s ease; }
        .refresh-btn:hover { background: #b89c5a; }
        #submitBtn { width: 100%; background: var(--primary-red); color: white; padding: 16px; border: none; border-radius: 8px; font-size: 1.1rem; cursor: pointer; transition: all 0.3s ease; text-transform: uppercase; letter-spacing: 2px; margin-top: 1rem; }
        #submitBtn:hover { background: #8a171a; box-shadow: 0 4px 12px rgba(155,27,31,0.3); transform: translateY(-2px); }
        .login-link { text-align: center; margin-top: 2rem; color: var(--primary-red); font-size: 1rem; }
        .login-link a { color: var(--gold); text-decoration: none; font-weight: 600; border-bottom: 2px solid transparent; transition: all 0.3s ease; }
        .login-link a:hover { border-bottom-color: var(--gold); }
        .message { text-align: center; margin-bottom: 1rem; padding: 0.5rem; border-radius: 6px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        @media (max-width: 768px) {
            .nav-links { display: none; }
            .register-container { margin-top: 100px; padding: 1.8rem; }
            h2 { font-size: 1.8em; }
            .captcha-wrapper { flex-direction: column; }
        }
        @media (max-width: 480px) {
            .nav-logo { width: 140px; }
            .register-container { padding: 1.5rem; margin-top: 90px; }
            input { padding: 12px 16px; }
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<nav class="palace-nav">
    <div class="nav-container">
        <img src="imgs/img/logo.jpg" alt="数字文物展厅" class="nav-logo">
        <div class="nav-links">
            <a href="index.html" class="nav-link">首页</a>
            <a href="#" class="nav-link">参观导览</a>
            <a href="#" class="nav-link">数字文物</a>
        </div>
    </div>
</nav>

<div class="register-container">
    <h2>创建故宫文化账号</h2>

    <!-- JSTL 消息显示 -->
    <c:if test="${not empty successMessage}">
        <div class="message success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="message error">${errorMessage}</div>
    </c:if>

    <form id="registerForm" action="${pageContext.request.contextPath}/RegisterServlet" method="POST" autocomplete="off">
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

        <!-- 验证码 -->
        <div class="form-group captcha-group">
            <label>验证码</label>
            <div class="captcha-wrapper">
                <input
                    type="text"
                    id="captchaInput"
                    name="captchaInput"
                    placeholder="请输入图中字母"
                    required
                    maxlength="4"
                >
                <img id="captchaImage" src="${pageContext.request.contextPath}/CaptchaServlet" alt="验证码">
                <button type="button" class="refresh-btn" onclick="refreshCaptcha()">
                    <i class="fas fa-sync-alt"></i>
                </button>
            </div>
            <div class="error-message" id="captchaError">验证码错误</div>
        </div>

        <button type="submit" id="submitBtn">立即注册</button>
    </form>

    <div class="login-link">
        已有故宫账号？<a href="login.jsp">立即登录</a>
    </div>
</div>

<script>
    // 刷新验证码图片
    function refreshCaptcha() {
        const captchaImage = document.getElementById('captchaImage');
        captchaImage.src = '${pageContext.request.contextPath}/CaptchaServlet?time=' + new Date().getTime();
    }
    document.getElementById('captchaImage').addEventListener('click', refreshCaptcha);

    // 前端表单校验
    const form = document.getElementById('registerForm');
    function validateField(input, pattern) {
        const isValid = new RegExp(pattern).test(input.value);
        input.style.borderColor = isValid ? '#2ecc71' : '#e74c3c';
        document.getElementById(input.id + 'Error').style.display = isValid ? 'none' : 'block';
        return isValid;
    }
    function checkPasswordMatch() {
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const isValid = password.value === confirmPassword.value;
        confirmPassword.style.borderColor = isValid ? '#2ecc71' : '#e74c3c';
        document.getElementById('confirmPasswordError').style.display = isValid ? 'none' : 'block';
        return isValid;
    }
    form.addEventListener('input', (e) => {
        const target = e.target;
        if (target.pattern) {
            validateField(target, target.pattern);
        }
        if (target.id === 'password' || target.id === 'confirmPassword') {
            checkPasswordMatch();
        }
    });
    form.addEventListener('submit', function (e) {
        let valid = true;
        // 用户名和密码格式校验
        const username = document.getElementById('username');
        const password = document.getElementById('password');
        if (!validateField(username, username.pattern)) valid = false;
        if (!validateField(password, password.pattern)) valid = false;
        if (!checkPasswordMatch()) valid = false;
        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>