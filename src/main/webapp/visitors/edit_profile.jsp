<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>修改个人信息</title>
    <style>
        :root {
            --primary-red: #9b1b1f;
            --gold: #c8a86a;
            --dark-bg: #2a2a2a;
            --light-bg: #f8f8f8;
            --border-color: #e0e0e0;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', '宋体', sans-serif;
        }

        body {
            background: url('https://example.com/forbidden_city_background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: #fff;
            line-height: 1.6;
            position: relative;
        }

        /* 故宫风格导航栏 */
        .palace-nav {
            background: var(--primary-red);
            height: 80px;
            display: flex;
            align-items: center;
            padding: 0 5%;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }

        .nav-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            height: 100%;
        }

        .nav-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .nav-logo {
            width: 80px;
            height: auto;
            object-fit: contain;
        }

        .nav-links {
            display: flex;
            gap: 25px;
            align-items: center;
        }

        .nav-link {
            color: white;
            text-decoration: none;
            font-size: 16px;
            position: relative;
            padding: 5px 0;
            transition: color 0.3s;
        }

        .nav-link:hover {
            color: var(--gold);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--gold);
            transition: width 0.3s;
        }

        .nav-link:hover::after {
            width: 100%;
        }

        /* 表单样式 */
        .form-container {
            max-width: 400px;
            margin: 100px auto 0;
            padding: 40px;
            background: rgba(0, 0, 0, 0.6);
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        }

        h2 {
            text-align: center;
            color: var(--gold);
            margin-bottom: 20px;
        }

        label {
            color: white;
            margin-bottom: 5px;
            display: block;
        }

        input[type="text"],
        input[type="tel"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid var(--border-color);
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        button {
            background: var(--gold);
            border: none;
            color: var(--primary-red);
            padding: 10px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            width: 100%;
            transition: background 0.3s;
        }

        button:hover {
            background: #d4af37; /* 更深一点的金色 */
        }

        a {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: var(--gold);
            text-decoration: none;
            font-size: 14px;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<div class="palace-nav">
    <div class="nav-container">
        <div class="nav-left">
            <img src="https://example.com/logo.png" alt="Logo" class="nav-logo">
            <a href="${pageContext.request.contextPath}/visitors/home" class="nav-link">首页</a>
        </div>
    </div>
</div>

<!-- 表单 -->
<div class="form-container">
    <h2>修改个人信息</h2>
    <form method="post" action="${pageContext.request.contextPath}/updateProfileServlet">
        <div>
            <label>用户名：</label>
            <input type="text" name="username" value="${user.username}" required>
        </div>
        <div>
            <label>联系电话：</label>
            <input type="tel" name="phone" value="${verification != null ? verification.phone : ''}">
        </div>
        <button type="submit">保存</button>
        <a href="${pageContext.request.contextPath}/visitors/home">取消</a>
    </form>
</div>
</body>
</html>