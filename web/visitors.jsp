<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>数字文物展厅系统 - 用户</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-red: #9b1b1f;
            --gold: #c8a86a;
            --dark-bg: #2a2a2a;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', '宋体', sans-serif;
        }

        /* 故宫风格导航栏 */
        .palace-nav {
            background: var(--primary-red);
            height: 80px;
            display: flex;
            align-items: center;
            padding: 0 5%;
            position: relative;
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

        /* 中间搜索区域 */
        .nav-center {
            flex: 1;
            max-width: 600px;
            margin: 0 20px;
            position: relative;
        }

        .search-toggle {
            background: none;
            border: none;
            color: var(--gold);
            font-size: 20px;
            cursor: pointer;
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 1;
        }

        .search-box {
            width: 100%;
            position: static;
            opacity: 1;
            visibility: visible;
            background: transparent;
            box-shadow: none;
            padding: 0;
        }

        .search-input {
            width: 100%;
            padding: 10px 10px 10px 40px;
            border: 2px solid var(--gold);
            border-radius: 25px;
            background: rgba(255,255,255,0.92);
            color: black;
        }

        /* 用户信息区域 */
        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        .user-name {
            color: white;
            font-weight: bold;
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
        }

        .user-dropdown.active {
            display: block;
        }

        .user-dropdown a {
            display: block;
            padding: 10px 15px;
            color: var(--dark-bg);
            text-decoration: none;
            transition: background 0.3s;
        }

        .user-dropdown a:hover {
            background: #f5f5f5;
        }

        .user-dropdown a i {
            margin-right: 8px;
            color: var(--primary-red);
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .menu-toggle {
                display: block;
            }

            .nav-logo {
                width: 80px;
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

            .nav-center {
                display: none;
            }

            .nav-right .search-toggle {
                display: block;
                position: static;
                transform: none;
            }

            .user-name {
                display: none;
            }
        }

        /* 轮播图样式 */
        .palace-carousel {
            height: 600px;
            position: relative;
            overflow: hidden;
            margin-top: 80px;
        }

        .carousel-item {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 1s;
        }

        .carousel-item.active {
            opacity: 1;
        }

        .carousel-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* 其他内容样式 */
        .title-plaque {
            text-align: center;
            margin: 40px 0;
            padding: 20px 0;
            background: linear-gradient(to right, transparent 10%, var(--gold) 50%, transparent 90%);
        }

        .title-plaque h2 {
            font-size: 2.5em;
            color: var(--primary-red);
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
            letter-spacing: 4px;
        }

        .divider {
            height: 4px;
            background: var(--primary-red);
            margin: 30px 10%;
        }

        .relic-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            padding: 0 5%;
        }

        .relic-card {
            border: 2px solid var(--gold);
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s;
        }

        .relic-card:hover {
            transform: translateY(-5px);
        }

        .relic-image {
            height: 250px;
            background: var(--dark-bg);
            position: relative;
        }

        .relic-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .relic-info {
            padding: 15px;
            background: white;
        }

        /* 用户专属内容 */
        .user-welcome {
            text-align: center;
            margin: 30px 0;
            padding: 20px;
            background: rgba(155, 27, 31, 0.1);
            border-radius: 8px;
        }

        .user-welcome h2 {
            color: var(--primary-red);
            margin-bottom: 10px;
        }

        .user-welcome p {
            color: #555;
        }
    </style>
    <%--新闻样式--%>
    <style>
        .news-section {
            margin: 50px 5% 0 5%;
            background: #fff8f0;
            border-radius: 10px;
            border: 2px solid var(--gold);
            padding: 30px 30px 10px 30px;
            box-shadow: 0 2px 12px rgba(200,168,106,0.08);
        }
        .news-list {
            display: flex;
            flex-direction: column;
            gap: 22px;
        }
        .news-item {
            border-bottom: 1px solid #e5d3b3;
            padding-bottom: 12px;
        }
        .news-title {
            color: var(--primary-red);
            font-size: 1.2em;
            margin-bottom: 4px;
        }
        .news-meta {
            color: var(--gold);
            font-size: 0.95em;
            margin-bottom: 6px;
        }
        .news-content {
            color: #444;
            font-size: 1em;
            line-height: 1.6;
        }
    </style>
</head>
<body>
<!-- 修改后的导航栏结构 -->
<nav class="palace-nav">
    <div class="nav-container">
        <!-- 左侧：Logo和菜单 -->
        <div class="nav-left">
            <img src="${pageContext.request.contextPath}/assets/img/logo.jpg" alt="数字文物展厅" class="nav-logo">
            <button class="menu-toggle" onclick="toggleMenu()">
                <i class="fas fa-bars"></i>
            </button>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/visitors/hallList" class="nav-link">文物展厅</a>
                <a href="${pageContext.request.contextPath}/visitors/relicList" class="nav-link">文物</a>
                <a href="${pageContext.request.contextPath}/bookingServlet" class="nav-link">展厅预约</a>
            </div>
        </div>

        <!-- 中间：搜索框 -->
       <form class="search-bar" action="${pageContext.request.contextPath}/visitors/relicList" method="get" style="margin:0;max-width:600px;">
           <select name="searchType" style="padding:8px 14px;border-radius:16px;border:1.5px solid var(--gold);font-size:1em;">
               <option value="relic_name">文物名称</option>
               <option value="dynasty">所属朝代</option>
               <option value="description">描述</option>
           </select>
           <input type="text" name="searchInput" placeholder="请输入查询内容" style="padding:8px 14px;border-radius:16px;border:1.5px solid var(--gold);font-size:1em;">
           <button type="submit" style="padding:8px 24px;border-radius:16px;border:none;background:var(--primary-red);color:#fff;font-size:1em;font-weight:bold;cursor:pointer;">
               <i class="fas fa-search"></i> 搜索
           </button>
       </form>

        <!-- 右侧：用户信息 -->
        <div class="nav-right">
            <div class="user-profile" onclick="toggleUserDropdown()">
                <span class="user-name">${not empty sessionScope.username ? sessionScope.username : '游客用户'}</span>
                <div class="user-dropdown">
                    <a href="${pageContext.request.contextPath}/visitors/home"><i class="fas fa-user"></i> 个人中心</a>
                    <a href="${pageContext.request.contextPath}/index.html" id="logoutBtn"><i class="fas fa-sign-out-alt"></i> 退出登录</a>
                </div>
            </div>
        </div>
    </div>
</nav>

<!-- 轮播图 -->
<div class="palace-carousel">
    <div class="carousel-item active">
        <img src="assets/img/s5e9926e6ea567.jpg" alt="太和殿全景">
    </div>
    <div class="carousel-item">
        <img src="assets/img/VCG211345429946.jpg" alt="文物精品">
    </div>
</div>

<!-- 核心内容 -->
<div class="title-plaque">
    <h2>紫禁城六百年</h2>
</div>

<div class="divider"></div>

<h2 class="section-title">为您推荐</h2>
<div class="relic-grid">
    <div class="relic-card">
        <div class="relic-image">
            <img src="assets/img/s591529137db2e.jpg" alt="清明上河图">
        </div>
        <div class="relic-info">
            <h3>清明上河图</h3>
            <p>北宋·张择端</p>
        </div>
    </div>
    <div class="relic-card">
        <div class="relic-image">
            <img src="assets/img/qinghua.jpg" alt="青花瓷">
        </div>
        <div class="relic-info">
            <h3>青花缠枝莲纹瓶</h3>
            <p>明·永乐年间</p>
        </div>
    </div>
</div>

<!-- 新闻动态模块 -->
<div class="news-section">
    <h2 class="section-title">新闻动态</h2>
    <div class="news-list">
        <c:forEach var="news" items="${newsList}">
            <div class="news-item">
                <h3 class="news-title">${news.title}</h3>
                <div class="news-meta">${news.publishTime}</div>
                <div class="news-content">${news.content}</div>
            </div>
        </c:forEach>
        <c:if test="${empty newsList}">
            <div style="color:#888;text-align:center;">暂无新闻</div>
        </c:if>
    </div>
</div>

<script>
    // 菜单切换
    function toggleMenu() {
        const menu = document.querySelector('.nav-links');
        menu.classList.toggle('active');
    }

    // 搜索框切换
    function toggleSearch() {
        const searchBox = document.querySelector('.search-box');
        searchBox.classList.toggle('active');
    }

    // 用户下拉菜单切换
    function toggleUserDropdown() {
        const dropdown = document.querySelector('.user-dropdown');
        dropdown.classList.toggle('active');
    }

    // 关闭弹出层
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.search-wrapper')) {
            document.querySelector('.search-box').classList.remove('active');
        }
        if (!e.target.closest('.nav-left')) {
            document.querySelector('.nav-links').classList.remove('active');
        }
        if (!e.target.closest('.user-profile')) {
            document.querySelector('.user-dropdown').classList.remove('active');
        }
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            document.querySelector('.search-box').classList.remove('active');
            document.querySelector('.nav-links').classList.remove('active');
            document.querySelector('.user-dropdown').classList.remove('active');
        }
    });

    // 轮播图逻辑
    let currentSlide = 0;
    const slides = document.querySelectorAll('.carousel-item');

    setInterval(() => {
        slides[currentSlide].classList.remove('active');
        currentSlide = (currentSlide + 1) % slides.length;
        slides[currentSlide].classList.add('active');
    }, 5000);

    // 退出登录
    document.getElementById('logoutBtn').addEventListener('click', function(e) {
        e.preventDefault();
        window.location.href = 'index.html';
    });
</script>
</body>
</html>