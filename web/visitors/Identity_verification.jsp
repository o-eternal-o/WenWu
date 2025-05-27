<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>实名认证 - 数字文物展厅系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
<!-- 导航栏 -->
<header class="palace-nav">
    <div class="nav-container">
        <img src="<c:url value="/assets/img/logo.jpg"/>" alt="Logo" class="nav-logo">
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/VisitorsServlet" class="nav-link">首页</a>
            <a href="#" class="nav-link">关于我们</a>
            <a href="#" class="nav-link">帮助中心</a>
        </nav>
    </div>
</header>

<!-- 主内容区 -->
<div class="main-container">
    <div id="message-box" class="message-box">
        <p id="message-content"></p>
    </div>
    <!-- 认证步骤指示器 -->
    <div class="auth-steps">
        <div class="step ${currentStep >= 1 ? 'active' : ''} ${currentStep > 1 ? 'completed' : ''}">
            <div class="step-number">1</div>
            <div class="step-text">填写表单</div>
            <!-- 动态内容 -->
            <c:if test="${currentStep == 1}">
                <div class="step-info">
                    请填写您的个人信息并上传身份证照片。
                </div>
            </c:if>
        </div>
        <div class="step ${currentStep >= 2 ? 'active' : ''} ${currentStep > 2 ? 'completed' : ''}">
            <div class="step-number">2</div>
            <div class="step-text">审核中</div>
            <!-- 动态内容 -->
            <c:if test="${currentStep == 2}">
                <div class="step-info">
                    您的信息已提交，请耐心等待管理员审核。
                </div>
            </c:if>
        </div>
        <div class="step ${currentStep >= 3 ? 'active' : ''} ${currentStep > 3 ? 'completed' : ''}">
            <div class="step-number">3</div>
            <div class="step-text">认证成功</div>
            <!-- 动态内容 -->
            <c:if test="${currentStep == 3}">
                <div class="step-info">
                    恭喜！您的实名认证已成功完成。
                </div>
            </c:if>
        </div>
    </div>

    <!-- 根据 currentStep 控制表单的显示 -->
    <c:if test="${currentStep == 1}">
        <!-- 认证表单 -->
        <div class="auth-container">
            <h2 class="auth-title">实名认证</h2>
            <form id="verifyForm" method="post" action="${pageContext.request.contextPath}/identityVerificationServlet" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="realName">真实姓名</label>
                    <input type="text" id="realName" name="realName" required placeholder="请输入您的真实姓名">
                </div>
                <div class="form-group">
                    <label for="phone">手机号</label>
                    <input type="tel" id="phone" name="phone" required pattern="1[3-9]\d{9}" placeholder="请输入有效的手机号">
                </div>
                <div class="form-group">
                    <label for="idNumber">身份证号</label>
                    <input type="text" id="idNumber" name="idNumber" required pattern="(^\d{15}$)|(^\d{17}([0-9Xx])$)" placeholder="请输入您的身份证号码">
                </div>
                <div class="form-group file-input-wrapper">
                    <label for="idImage">身份证照片</label>
                    <input type="file" id="idImage" name="idImage" accept="image/*" required onchange="previewImage(event)">
                    <img id="preview" class="preview-image" alt="身份证预览">
                </div>
                <button type="submit" class="btn">提交认证</button>
                <div id="msg" class="msg"></div>
            </form>
        </div>
    </c:if>

    <!-- 审核中的提示 -->
    <c:if test="${currentStep == 2}">
        <div class="auth-container">
            <h2 class="auth-title">审核中</h2>
            <p class="auth-message">
                您的实名认证信息正在审核中，请耐心等待。如有疑问，请联系管理员。
            </p>
        </div>
    </c:if>

    <!-- 认证成功的提示 -->
    <c:if test="${currentStep == 3}">
        <div class="auth-container">
            <h2 class="auth-title">认证成功</h2>
            <p class="auth-message">
                您的实名认证已成功完成！您可以继续使用系统的所有功能。
            </p>
        </div>
    </c:if>
</div>

<script>
    // 图片预览逻辑
    document.getElementById('idImage').addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const previewImage = document.getElementById('preview');
                previewImage.src = e.target.result;
                previewImage.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            document.getElementById('preview').style.display = 'none';
        }
    });

    // 表单提交逻辑
    document.getElementById('verifyForm').onsubmit = function(e) {
        e.preventDefault();
        const form = e.target;
        const formData = new FormData(form);
        const msg = document.getElementById('msg');
        msg.textContent = '';
        msg.className = 'msg';

        fetch(form.action, {
            method: 'POST',
            body: formData
        }).then(res => res.json())
            .then(data => {
                if (data.status === 'success') {
                    msg.textContent = data.message;
                    msg.className = 'msg success';
                    form.reset();
                    document.getElementById('preview').style.display = 'none'; // 清除预览图片
                } else {
                    msg.textContent = data.message;
                    msg.className = 'msg error';
                }
            }).catch(() => {
            msg.textContent = '提交失败，请稍后重试';
            msg.className = 'msg error';
        });
    };

    // 显示消息的函数
    function showMessage(message, type = 'info', duration = 3000) {
        const messageBox = document.getElementById('message-box');
        const messageContent = document.getElementById('message-content');

        // 设置消息内容和样式
        messageContent.textContent = message;
        messageBox.className = 'message-box'; // 清除之前的样式
        messageBox.classList.add(type); // 添加当前类型样式
        messageBox.style.display = 'block'; // 显示消息盒子

        // 自动隐藏消息盒子
        setTimeout(() => {
            messageBox.style.display = 'none';
        }, duration);
    }

    // 示例：调用函数显示消息
    showMessage('操作成功！', 'success'); // 成功消息
    showMessage('发生错误，请重试。', 'error'); // 错误消息
</script>
</body>
</html>