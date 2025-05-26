<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <html>
    <head>
        <title>文物浏览</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            :root {
                --primary-red: #9b1b1f;
                --gold: #c8a86a;
                --dark-bg: #2a2a2a;
                --light-bg: #f8f1e5;
            }
            body {
                background: var(--light-bg);
                color: #333;
                font-family: 'Microsoft YaHei', '宋体', sans-serif;
            }
            .main-container {
                max-width: 1400px;
                margin: 40px auto;
                padding: 0 20px;
            }
            .page-title {
                text-align: center;
                color: var(--primary-red);
                font-size: 36px;
                margin-bottom: 40px;
                letter-spacing: 4px;
                position: relative;
            }
            .page-title::after {
                content: '';
                position: absolute;
                bottom: -12px;
                left: 50%;
                transform: translateX(-50%);
                width: 100px;
                height: 4px;
                background: var(--gold);
                border-radius: 2px;
            }
            /* 搜索栏放大并加金色边框 */
            .search-bar {
                display: flex;
                gap: 18px;
                margin: 40px auto 0 auto;
                max-width: 700px;
                justify-content: center;
                background: #fff;
                border: 2px solid var(--gold);
                border-radius: 32px;
                box-shadow: 0 4px 16px rgba(200,168,106,0.08);
                padding: 18px 28px;
            }
            .search-bar select, .search-bar input {
                padding: 12px 18px;
                border-radius: 20px;
                border: 1.5px solid var(--gold);
                font-size: 1.1em;
                outline: none;
                background: #f8f1e5;
                color: #333;
                transition: border 0.2s;
            }
            .search-bar select:focus, .search-bar input:focus {
                border: 2px solid var(--primary-red);
            }
            .search-bar button {
                padding: 12px 32px;
                border-radius: 20px;
                border: none;
                background: var(--primary-red);
                color: #fff;
                font-size: 1.1em;
                font-weight: bold;
                cursor: pointer;
                transition: background 0.2s;
                box-shadow: 0 2px 8px rgba(155,27,31,0.08);
            }
            .search-bar button:hover {
                background: #7e1518;
            }
            /* 卡片网格 */
            .relics-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 36px;
                margin-top: 40px;
            }
            .relic-card {
                background: #fff;
                border-radius: 12px;
                border: 2px solid var(--gold);
                box-shadow: 0 4px 18px rgba(200,168,106,0.10);
                overflow: hidden;
                transition: transform 0.2s, box-shadow 0.2s;
                display: flex;
                flex-direction: column;
            }
            .relic-card:hover {
                transform: translateY(-8px) scale(1.03);
                box-shadow: 0 12px 32px rgba(155,27,31,0.13);
                border-color: var(--primary-red);
            }
            .relic-image {
                width: 100%;
                height: 220px;
                background: var(--dark-bg);
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
            }
            .relic-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.4s;
            }
            .relic-card:hover .relic-image img {
                transform: scale(1.06);
            }
            .relic-content {
                padding: 22px 18px 16px 18px;
                flex: 1;
                display: flex;
                flex-direction: column;
            }
            .relic-name {
                font-size: 1.3em;
                font-weight: bold;
                margin-bottom: 10px;
                color: var(--primary-red);
                letter-spacing: 2px;
            }
            .relic-meta {
                font-size: 1em;
                color: var(--gold);
                margin-bottom: 12px;
            }
            .relic-description {
                font-size: 1.05em;
                color: #444;
                flex: 1;
                margin-bottom: 0;
                line-height: 1.7;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
            @media (max-width: 900px) {
                .relics-grid {
                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                    gap: 18px;
                }
                .relic-image {
                    height: 140px;
                }
                .search-bar {
                    flex-direction: column;
                    gap: 10px;
                    padding: 14px 10px;
                }
            }
        </style>
    </head>
    <body>
    <div class="main-container">
        <h1 class="page-title">文物浏览</h1>
        <!-- 搜索栏 -->
        <form class="search-bar" action="${pageContext.request.contextPath}/visitors/relicList" method="get">
            <select name="searchType">
                <option value="relic_name">文物名称</option>
                <option value="dynasty">所属朝代</option>
                <option value="description">描述</option>
            </select>
            <input type="text" name="searchInput" placeholder="请输入查询内容" value="${param.searchInput}">
            <button type="submit"><i class="fas fa-search"></i> 搜索</button>
        </form>
        <!-- 卡片展示 -->
        <div class="relics-grid">
            <c:forEach var="relic" items="${relics}">
                <div class="relic-card">
                    <div class="relic-image">
                        <img src="${pageContext.request.contextPath}${empty relic.imagePath ? 'assets/img/error.png' :relic.imagePath}" alt="${relic.relicName}">
                    </div>
                    <div class="relic-content">
                        <h3 class="relic-name">${relic.relicName}</h3>
                        <div class="relic-meta">
                            <span>${relic.dynasty}</span>
                        </div>
                        <p class="relic-description">${relic.description}</p>
                        <a href="${pageContext.request.contextPath}/visitors/OneRelic?relicId=${relic.relicId}" class="relic-link" style="color: var(--primary-red); font-weight: bold; text-decoration: none;">查看详情</a>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty relics}">
                <div style="grid-column: 1/-1; text-align: center; color: #888; margin-top: 40px;">暂无文物信息</div>
            </c:if>
        </div>
    </div>
    </body>
    </html>