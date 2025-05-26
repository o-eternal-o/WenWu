<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>预约参观 - 数字文物展厅系统</title>
    <style>
        :root {
            --primary-red: #9b1b1f;
            --gold: #c8a86a;
            --dark-bg: #2a2a2a;
            --light-bg: #f8f1e5;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', '宋体', sans-serif;
        }

        body {
            min-height: 100vh;
            background-color: var(--light-bg);
            color: #333;
        }

        /* 导航栏 */
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
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .nav-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
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

        /* 主内容区 */
        .main-container {
            max-width: 1000px;
            margin: 120px auto 40px;
            padding: 0 20px;
        }

        /* 认证步骤指示器 */
        .auth-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 40px;
            position: relative;
        }

        .auth-steps::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: #ddd;
            transform: translateY(-50%);
            z-index: 1;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .step-number {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #ddd;
            color: #666;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .step.active .step-number {
            background: var(--primary-red);
            color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .step.completed .step-number {
            background: var(--gold);
            color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .step-text {
            font-size: 14px;
            color: #666;
            transition: all 0.3s ease;
        }

        .step.active .step-text,
        .step.completed .step-text {
            color: var(--primary-red);
            font-weight: 500;
        }

        .step-info {
            margin-top: 10px;
            font-size: 14px;
            color: #666;
            transition: all 0.3s ease;
        }

        .step.active .step-info {
            color: var(--primary-red);
        }

        .step.completed .step-info {
            color: var(--gold);
        }

        /* 认证表单 */
        .auth-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gold);
            padding: 40px;
            margin-bottom: 30px;
            text-align: center;
        }

        .auth-title {
            font-size: 24px;
            color: var(--primary-red);
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        input[type="text"],
        input[type="tel"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="tel"]:focus {
            border-color: var(--primary-red);
            outline: none;
        }

        .file-input-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .preview-image {
            max-width: 100%;
            height: auto;
            margin-top: 10px;
            border: 1px solid #ddd;
            padding: 5px;
            display: none; /* 默认隐藏 */
        }

        input[type="file"] + img.preview-image {
            display: block;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background: var(--primary-red);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .btn:hover {
            background: #7d1418;
        }

        .msg {
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
        }

        .msg.success {
            color: #28a745;
        }

        .msg.error {
            color: #dc3545;
        }
        /* 消息盒子容器 */
        .message-box {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 15px 25px;
            z-index: 9999;
            display: none; /* 默认隐藏 */
            max-width: 400px;
            text-align: center;
        }

        /* 消息内容 */
        #message-content {
            font-size: 14px;
            color: #333;
            margin: 0;
        }

        /* 不同状态的消息样式 */
        .message-box.success {
            border-color: #28a745;
            background-color: #d4edda;
            color: #155724;
        }

        .message-box.error {
            border-color: #dc3545;
            background-color: #f8d7da;
            color: #721c24;
        }

        .message-box.warning {
            border-color: #ffc107;
            background-color: #fff3cd;
            color: #856404;
        }

        .message-box.info {
            border-color: #17a2b8;
            background-color: #d1ecf1;
            color: #0c5460;
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="auth-steps">
        <div class="step ${currentStep >= 1 ? 'active' : ''} ${currentStep > 1 ? 'completed' : ''}">
            <div class="step-number">1</div>
            <div class="step-text">填写预约</div>
        </div>
        <div class="step ${currentStep >= 2 ? 'active' : ''} ${currentStep > 2 ? 'completed' : ''}">
            <div class="step-number">2</div>
            <div class="step-text">审核中</div>
        </div>
        <div class="step ${currentStep >= 3 ? 'active' : ''} ${currentStep > 3 ? 'completed' : ''}">
            <div class="step-number">3</div>
            <div class="step-text">预约成功</div>
        </div>
    </div>

    <c:if test="${currentStep == 1}">
        <div class="auth-container">
            <h2 class="auth-title">预约参观</h2>
            <form method="post" action="${pageContext.request.contextPath}/bookingServlet">
                <div class="form-group">
                    <label for="hallId">展厅ID</label>
                    <input type="number" id="hallId" name="hallId" required>
                </div>
                <div class="form-group">
                    <label for="bookingTime">预约时间</label>
                    <input type="datetime-local" id="bookingTime" name="bookingTime" required>
                </div>
                <div class="form-group">
                    <label>
                        <input type="checkbox" name="isGroup" id="isGroup" onchange="toggleGroupSize()"> 团队预约
                    </label>
                </div>
                <div class="form-group" id="groupSizeDiv" style="display:none;">
                    <label for="groupSize">团队人数</label>
                    <input type="number" id="groupSize" name="groupSize" min="2">
                </div>
                <button type="submit" class="btn">提交预约</button>
            </form>
        </div>
    </c:if>

    <c:if test="${currentStep == 2}">
        <div class="auth-container">
            <h2 class="auth-title">审核中</h2>
            <p>您的预约正在审核中，请耐心等待。</p>
        </div>
    </c:if>

    <c:if test="${currentStep == 3}">
        <div class="auth-container">
            <h2 class="auth-title">预约成功</h2>
            <p>您的预约已确认！请按时参观。</p>
        </div>
    </c:if>
</div>
<script>
    function toggleGroupSize() {
        document.getElementById('groupSizeDiv').style.display =
            document.getElementById('isGroup').checked ? 'block' : 'none';
    }
</script>
</body>
</html>