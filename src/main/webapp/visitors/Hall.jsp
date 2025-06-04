<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>展厅浏览 - 数字文物展厅系统</title>
    <!-- 保留原有样式和CDN -->
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
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }

        .nav-logo {
            width: 80px;
            height: auto;
            margin-right: 30px;
        }

        .nav-links {
            display: flex;
            gap: 25px;
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
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }

        /* 页面标题 */
        .page-title {
            text-align: center;
            color: var(--primary-red);
            font-size: 32px;
            margin-bottom: 40px;
            position: relative;
        }

        .page-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: var(--gold);
        }

        /* 展厅筛选 */
        .hall-filters {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .filter-button {
            padding: 8px 16px;
            background: white;
            border: 1px solid var(--gold);
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .filter-button:hover, .filter-button.active {
            background: var(--gold);
            color: white;
        }

        /* 展厅网格 */
        .halls-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 50px;
        }

        .hall-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
            border: 1px solid var(--gold);
            cursor: pointer;
        }

        .hall-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .hall-image {
            height: 200px;
            overflow: hidden;
            position: relative;
        }

        .hall-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }

        .hall-card:hover .hall-image img {
            transform: scale(1.05);
        }

        .hall-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--primary-red);
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
        }

        .hall-content {
            padding: 20px;
        }

        .hall-name {
            font-size: 20px;
            color: var(--primary-red);
            margin-bottom: 10px;
        }

        .hall-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 14px;
            color: #666;
        }

        .meta-item i {
            color: var(--gold);
        }

        .hall-description {
            color: #555;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .view-button {
            display: inline-block;
            padding: 8px 16px;
            background: var(--primary-red);
            color: white;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            transition: background 0.3s;
        }

        .view-button:hover {
            background: #7e1518;
        }

        /* 展厅详情弹窗 */
        .hall-modal {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s;
        }

        .hall-modal.active {
            opacity: 1;
            visibility: visible;
        }

        .modal-content {
            background: white;
            border-radius: 8px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 30px;
            position: relative;
            transform: translateY(20px);
            transition: transform 0.3s;
        }

        .hall-modal.active .modal-content {
            transform: translateY(0);
        }

        .close-modal {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 24px;
            cursor: pointer;
            color: #666;
        }

        .close-modal:hover {
            color: var(--primary-red);
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .halls-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }

            .hall-image {
                height: 180px;
            }
        }

        @media (max-width: 576px) {
            .halls-grid {
                grid-template-columns: 1fr;
            }

            .hall-filters {
                justify-content: flex-start;
            }
        }
    </style>
</head>
<body>
<!-- 故宫风格导航栏 -->
<nav class="palace-nav">
    <img src="/assets/img/logo.jpg" alt="数字文物展厅" class="nav-logo">
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/visitors.jsp" class="nav-link">首页</a>
        <a href="#" class="nav-link">参观导览</a>
        <a href="#" class="nav-link">数字文物</a>
        <a href="#" class="nav-link">特展在线</a>
        <a href="#" class="nav-link">展厅预约</a>
    </div>
</nav>

<!-- 主内容区 -->
<div class="main-container">
    <h1 class="page-title">展厅浏览</h1>

    <!-- 展厅筛选 -->
    <div class="hall-filters">
        <div class="filter-button active" data-filter="all">全部展厅</div>
        <div class="filter-button" data-filter="painting">书画艺术</div>
        <div class="filter-button" data-filter="ceramic">陶瓷艺术</div>
        <div class="filter-button" data-filter="bronze">青铜器</div>
        <div class="filter-button" data-filter="jade">玉器</div>
    </div>

    <!-- 展厅网格 -->
    <div class="halls-grid" id="hallsContainer">
        <c:forEach var="hall" items="${halls}">
            <div class="hall-card" data-id="${hall.hallId}" data-category="${hall.type}">
                <div class="hall-image">
                    <img src="/assets/img/default_hall.jpg" alt="${hall.hallName}">
                    <c:choose>
                        <c:when test="${hall.openBooking}">
                            <div class="hall-badge">可预约</div>
                        </c:when>
                        <c:otherwise>
                            <div class="hall-badge" style="background:#666">维护中</div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="hall-content">
                    <h3 class="hall-name">${hall.hallName}</h3>
                    <div class="hall-meta">
                        <div class="meta-item">
                            <i class="fas fa-landmark"></i>
                            <span>${hall.dynasty}</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-tag"></i>
                            <span>${hall.type}</span>
                        </div>
                    </div>
                    <p class="hall-description">${hall.layoutRules}</p>
                    <a href="/visitors/OneHall?hallId=${hall.hallId}" class="view-button">查看详情</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    // 展厅筛选
    document.querySelectorAll('.filter-button').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.filter-button').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            const filter = this.getAttribute('data-filter');
            document.querySelectorAll('.hall-card').forEach(card => {
                if (filter === 'all' || card.getAttribute('data-category') === filter) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });
</script>
</body>
</html>