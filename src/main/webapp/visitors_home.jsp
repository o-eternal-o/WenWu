<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>数字文物展厅系统 - 游客中心</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
            background-color: var(--light-bg);
            color: #333;
            line-height: 1.6;
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

        /* 导航容器-三列布局 */
        .nav-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            height: 100%;
        }

        /* 左侧区域（Logo+菜单） */
        .nav-left {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-shrink: 0;
        }

        /* 右侧用户区域 */
        .nav-right {
            flex-shrink: 0;
            display: flex;
            align-items: center;
            position: relative;
        }

        /* 优化后的Logo尺寸 */
        .nav-logo {
            width: 80px;
            height: auto;
            object-fit: contain;
        }

        /* 汉堡菜单按钮 */
        .menu-toggle {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            display: none;
        }

        /* 导航链接 */
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

        /* 用户信息区域 */
        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            position: relative;
        }

        .user-name {
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

        .user-dropdown {
            position: absolute;
            top: 50px;
            right: 0;
            background: white;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            width: 150px;
            display: none;
            z-index: 1000;
            border: 1px solid var(--border-color);
        }

        .user-dropdown.active {
            display: block;
        }

        .user-dropdown a {
            display: block;
            padding: 12px 15px;
            color: var(--dark-bg);
            text-decoration: none;
            transition: background 0.3s;
            font-size: 14px;
        }

        .user-dropdown a:hover {
            background: #f5f5f5;
            color: var(--primary-red);
        }

        .user-dropdown a i {
            margin-right: 8px;
            color: var(--primary-red);
            width: 18px;
            text-align: center;
        }

        /* 游客中心内容样式 */
        .container {
            max-width: 1200px;
            margin: 100px auto 40px;
            padding: 0 20px;
        }

        .profile-header {
            background-color: #fff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
            display: flex;
            border: 1px solid var(--gold);
            position: relative;
        }

        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 30px;
            border: 3px solid var(--gold);
            background-color: #e8f4fc;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: var(--primary-red);
            flex-shrink: 0;
        }

        .user-info {
            flex: 1;
        }

        .username {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--primary-red);
        }

        .user-role {
            display: inline-block;
            background-color: var(--gold);
            color: #fff;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .user-info p {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .user-stats {
            display: flex;
            margin-top: 15px;
        }

        .stat-item {
            margin-right: 30px;
            text-align: center;
            min-width: 80px;
        }

        .stat-value {
            font-size: 20px;
            font-weight: bold;
            color: var(--primary-red);
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 13px;
            color: #666;
        }

        .profile-nav {
            display: flex;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
            overflow: hidden;
            border: 1px solid var(--gold);
        }

        .nav-item {
            padding: 15px 25px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border-bottom: 3px solid transparent;
            flex: 1;
            color: var(--primary-red);
            font-weight: 500;
            font-size: 15px;
        }

        .nav-item:hover, .nav-item.active {
            color: var(--primary-red);
            border-bottom-color: var(--gold);
            background-color: rgba(200, 168, 106, 0.1);
        }

        .content-section {
            background-color: #fff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: none;
            border: 1px solid var(--gold);
            margin-bottom: 20px;
        }

        .content-section.active {
            display: block;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--gold);
            color: var(--primary-red);
        }

        .info-grid {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-label {
            font-weight: 500;
            color: var(--primary-red);
            font-size: 14px;
            align-self: center;
        }

        .info-value {
            font-size: 14px;
            color: #333;
        }

        .booking-list {
            margin-top: 20px;
        }

        .booking-item {
            display: flex;
            padding: 15px;
            border: 1px solid var(--gold);
            border-radius: 6px;
            margin-bottom: 10px;
            transition: all 0.3s;
            align-items: center;
        }

        .booking-item:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }

        .booking-hall {
            width: 200px;
            font-weight: 500;
            color: var(--primary-red);
            font-size: 15px;
        }

        .booking-time {
            flex: 1;
            font-size: 14px;
            color: #555;
        }

        .booking-status {
            width: 80px;
            text-align: center;
            border-radius: 4px;
            padding: 5px 8px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-pending {
            background-color: #fff7e6;
            color: #fa8c16;
        }

        .status-confirmed {
            background-color: #f6ffed;
            color: #52c41a;
        }

        .status-canceled {
            background-color: #fff1f0;
            color: #f5222d;
        }

        .empty-tip {
            text-align: center;
            padding: 40px 0;
            color: #999;
        }

        .empty-tip p {
            margin-bottom: 15px;
            font-size: 15px;
        }

        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: var(--primary-red);
            color: white;
            border-radius: 4px;
            text-decoration: none;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }

        .btn:hover {
            background-color: #c12a2e;
            transform: translateY(-1px);
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--primary-red);
            color: var(--primary-red);
        }

        .btn-outline:hover {
            background-color: rgba(155, 27, 31, 0.1);
        }

        .settings-form {
            max-width: 500px;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--primary-red);
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--gold);
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-red);
            box-shadow: 0 0 0 2px rgba(155, 27, 31, 0.1);
        }

        .form-actions {
            text-align: center;
            margin-top: 30px;
        }

        .auth-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-left: 10px;
            font-weight: 500;
        }

        .auth-yes {
            background-color: #52c41a;
            color: white;
        }

        .auth-no {
            background-color: #f5222d;
            color: white;
            cursor: pointer;
            transition: opacity 0.3s;
        }

        .auth-no:hover {
            opacity: 0.8;
        }

        .feedback-item {
            padding: 15px;
            border: 1px solid var(--gold);
            border-radius: 6px;
            margin-bottom: 15px;
            background-color: #fff;
        }

        .feedback-item strong {
            font-size: 15px;
            color: var(--primary-red);
        }

        .feedback-item p {
            font-size: 14px;
            color: #333;
            margin: 10px 0;
        }

        .feedback-time {
            font-size: 12px;
            color: #999;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .menu-toggle {
                display: block;
            }

            .nav-logo {
                width: 70px;
            }

            .nav-links {
                position: fixed;
                top: 80px;
                left: 0;
                right: 0;
                background: var(--primary-red);
                flex-direction: column;
                padding: 20px;
                display: none;
                gap: 15px;
                z-index: 999;
            }

            .nav-links.active {
                display: flex;
            }

            .nav-link {
                padding: 12px 20px;
            }

            .user-name {
                display: none;
            }

            .profile-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
                padding: 20px;
            }

            .avatar {
                margin-right: 0;
                margin-bottom: 15px;
                width: 80px;
                height: 80px;
                font-size: 32px;
            }

            .user-stats {
                justify-content: center;
            }

            .stat-item {
                margin: 0 15px;
            }

            .profile-nav {
                flex-wrap: wrap;
            }

            .nav-item {
                flex: 1 0 50%;
                padding: 12px;
                font-size: 14px;
            }

            .content-section {
                padding: 20px;
            }

            .booking-item {
                flex-direction: column;
                align-items: flex-start;
            }

            .booking-hall, .booking-time, .booking-status {
                width: 100%;
                margin-bottom: 8px;
            }

            .booking-status {
                align-self: flex-start;
            }

            .info-grid {
                grid-template-columns: 1fr;
                gap: 5px;
            }
        }
    </style>
</head>
<body>
<!-- 故宫风格导航栏 -->
<nav class="palace-nav">
    <div class="nav-container">
        <!-- 左侧：Logo和菜单 -->
        <div class="nav-left">
            <img src="${pageContext.request.contextPath}/assets/img/logo.jpg" alt="数字文物展厅" class="nav-logo">
            <button class="menu-toggle" onclick="toggleMenu()">
                <i class="fas fa-bars"></i>
            </button>
            <div class="nav-links">
                <a href="<c:url value="/visitors.jsp"/>" class="nav-link">首页</a>
            </div>
        </div>

        <!-- 右侧：用户信息 -->
        <div class="nav-right">
            <div class="user-profile" onclick="toggleUserDropdown()">
                <span class="user-name">${not empty sessionScope.username ? sessionScope.username : '游客用户'}</span>
                <div class="user-dropdown">
                    <a href="<c:url value="/index.html"/>" id="logoutBtn"><i class="fas fa-sign-out-alt"></i> 退出登录</a>
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="container">
    <!-- 用户信息头部 -->
    <div class="profile-header">
        <div class="avatar">${user.username != null ? user.username.substring(0,1) : '游'}</div>
        <div class="user-info">
            <h1 class="username">${user.username}</h1>
            <span class="user-role">游客</span>
            <p>注册时间: ${user.createdAt}</p>
            <div class="user-stats">
                <div class="stat-item">
                    <div class="stat-value">${bookingCount}</div>
                    <div class="stat-label">预约记录</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${feedbackCount}</div>
                    <div class="stat-label">反馈记录</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 导航菜单 -->
    <div class="profile-nav">
        <div class="nav-item active" data-section="booking">我的预约</div>
        <div class="nav-item" data-section="feedback">我的反馈</div>
        <div class="nav-item" data-section="settings">个人信息</div>
    </div>

   <!-- 我的预约内容区 -->
   <div id="booking-section" class="content-section active">
       <div class="booking-list">
           <c:choose>
               <c:when test="${not empty bookingList}">
                   <c:forEach var="b" items="${bookingList}">
                       <div class="booking-item">
                           <div class="booking-hall">${b.hallId}</div>
                           <div class="booking-time">${b.bookingTime}</div>
                           <div class="booking-status
                               <c:choose>
                                   <c:when test="${b.status eq 'pending'}"> 处理中</c:when>
                                   <c:when test="${b.status eq 'confirmed'}"> 预约成功</c:when>
                                   <c:when test="${b.status eq 'canceled'}"> 预约失败</c:when>
                               </c:choose>
                           ">${b.status}</div>
                       </div>
                   </c:forEach>
               </c:when>
               <c:otherwise>
                   <div class="empty-tip">
                       <p>您还没有任何预约记录</p>
                       <a href="${pageContext.request.contextPath}/bookingServlet" class="btn btn-outline">立即预约</a>
                   </div>
               </c:otherwise>
           </c:choose>
       </div>
   </div>

    <!-- 我的反馈内容区 -->
    <div id="feedback-section" class="content-section">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 class="section-title">我的反馈</h2>
        </div>
        <div class="feedback-list">
            <c:choose>
                <c:when test="${not empty feedbackList}">
                    <c:forEach var="f" items="${feedbackList}">
                        <div class="feedback-item">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                                <strong>反馈ID: ${f.feedbackId}</strong>
                                <span style="color: var(--gold);">
                                    <c:choose>
                                        <c:when test="${f.status eq 'processing'}">处理中</c:when>
                                        <c:when test="${f.status eq 'resolved'}">已解决</c:when>
                                        <c:otherwise>未处理</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <p style="margin-bottom: 10px;">${f.content}</p>
                            <div class="feedback-time">提交时间: ${f.createdAt}</div>
                            <c:if test="${not empty f.resolvedResult}">
                                <div style="margin-top:8px;color:#52c41a;">处理结果：${f.resolvedResult}</div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-tip">
                        <p>您还没有提交过任何反馈</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 个人信息内容区 -->
    <div id="settings-section" class="content-section">
        <h2 class="section-title">个人信息</h2>
        <div class="settings-form">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" value="${user.username}" readonly>
            </div>
            <div class="form-group">
                <label>真实姓名</label>
                <div style="display: flex; align-items: center;">
                    <input type="text" value="${verification != null ? verification.realName : ''}" readonly>
                    <span id="auth-status" class="auth-badge ${user.realNameVerified ? 'auth-yes' : 'auth-no'}"
                          ${user.realNameVerified ? '' : 'onclick="goToAuth()"'} >
                        ${user.realNameVerified ? '已认证' : '未认证'}
                    </span>
                </div>
            </div>
            <div class="form-group">
                <label>联系电话</label>
                <input type="tel" value="${verification != null ? verification.phone : ''}" readonly>
            </div>
        </div>
        <div class="form-actions">
            <a href="${pageContext.request.contextPath}/visitors/edit_profile.jsp" class="btn">修改信息</a>
        </div>
    </div>
</div>

<script>
    // 菜单切换
    function toggleMenu() {
        const menu = document.querySelector('.nav-links');
        menu.classList.toggle('active');
    }

    // 用户下拉菜单切换
    function toggleUserDropdown() {
        const dropdown = document.querySelector('.user-dropdown');
        dropdown.classList.toggle('active');
    }

    // 关闭弹出层
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.nav-left')) {
            document.querySelector('.nav-links').classList.remove('active');
        }
        if (!e.target.closest('.user-profile')) {
            document.querySelector('.user-dropdown').classList.remove('active');
        }
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            document.querySelector('.nav-links').classList.remove('active');
            document.querySelector('.user-dropdown').classList.remove('active');
        }
    });

    // 页面切换功能
    document.addEventListener('DOMContentLoaded', function() {
        const navItems = document.querySelectorAll('.nav-item');
        const contentSections = document.querySelectorAll('.content-section');

        navItems.forEach(item => {
            item.addEventListener('click', function() {
                // 移除所有active类
                navItems.forEach(nav => nav.classList.remove('active'));
                contentSections.forEach(section => section.classList.remove('active'));

                // 添加active类到当前点击的项
                this.classList.add('active');
                const sectionId = this.getAttribute('data-section') + '-section';
                document.getElementById(sectionId).classList.add('active');
            });
        });
    });

    // 跳转实名认证
    function goToAuth() {
        const authStatus = document.getElementById('auth-status');
        if (authStatus.classList.contains('auth-no')) {
            window.location.href = '${pageContext.request.contextPath}/identityVerificationServlet';
        }
    }

    // 退出登录
    document.getElementById('logoutBtn').addEventListener('click', function(e) {
        e.preventDefault();
        // 跳转到首页
        window.location.href = 'index.html';
    });

    // 页面加载时检查认证状态
    window.onload = function() {
        // 这里应该是从服务器获取认证状态
        const isAuthenticated = false; // 改为true测试已认证状态

        const authStatus = document.getElementById('auth-status');
        if (isAuthenticated) {
            authStatus.classList.remove('auth-no');
            authStatus.classList.add('auth-yes');
            authStatus.textContent = '已认证';
            authStatus.removeAttribute('onclick');
        }
    };
</script>
</body>
</html>