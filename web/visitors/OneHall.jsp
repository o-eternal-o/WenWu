<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${hall.hallName} - 展厅详情</title>
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
        .main-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .hall-header {
            background: #fff;
            border: 2px solid var(--gold);
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(200,168,106,0.10);
            padding: 32px 28px 18px 28px;
            margin-bottom: 36px;
            position: relative;
        }
        .hall-title {
            color: var(--primary-red);
            font-size: 2.2em;
            margin-bottom: 10px;
            letter-spacing: 3px;
        }
        .hall-meta {
            color: var(--gold);
            font-size: 1.1em;
            margin-bottom: 12px;
        }
        .hall-layout {
            color: #555;
            font-size: 1.05em;
            margin-bottom: 0;
        }
        .relics-title {
            color: var(--primary-red);
            font-size: 1.5em;
            margin-bottom: 24px;
            letter-spacing: 2px;
            border-left: 6px solid var(--gold);
            padding-left: 12px;
        }
        .relics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 28px;
        }
        .relic-card {
            background: #fff;
            border-radius: 10px;
            border: 2px solid var(--gold);
            box-shadow: 0 4px 18px rgba(200,168,106,0.10);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
        }
        .relic-card:hover {
            transform: translateY(-6px) scale(1.03);
            box-shadow: 0 12px 32px rgba(155,27,31,0.13);
            border-color: var(--primary-red);
        }
        .relic-image {
            width: 100%;
            height: 180px;
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
            padding: 18px 16px 14px 16px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .relic-name {
            font-size: 1.2em;
            font-weight: bold;
            margin-bottom: 8px;
            color: var(--primary-red);
            letter-spacing: 1.5px;
        }
        .relic-meta {
            font-size: 1em;
            color: var(--gold);
            margin-bottom: 10px;
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
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 14px;
            }
            .relic-image {
                height: 110px;
            }
        }
    </style>
</head>
<body>
<nav class="palace-nav">
    <img src="<c:url value='/assets/img/logo.jpg'/>" alt="数字文物展厅" class="nav-logo">
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/visitors.jsp" class="nav-link">首页</a>
    </div>
</nav>
<div class="main-container">
    <div class="hall-header">
        <div class="hall-title">${hall.hallName}（${hall.dynasty}）</div>
        <div class="hall-meta">
            类型：${hall.type}
            <c:if test="${hall.openBooking}">
                &nbsp;|&nbsp;<span style="color:green;">可预约</span>
            </c:if>
            <c:if test="${!hall.openBooking}">
                &nbsp;|&nbsp;<span style="color:#888;">维护中</span>
            </c:if>
        </div>
        <div class="hall-layout">${hall.layoutRules}</div>
    </div>
    <div class="relics-title"><i class="fa fa-cube"></i> 展厅文物列表</div>
    <div class="relics-grid">
        <c:forEach var="relic" items="${relics}">
            <div class="relic-card">
                <div class="relic-image">
                    <img src="${empty relic.imagePath ? '/assets/img/default_relic.jpg' : relic.imagePath}" alt="${relic.relicName}">
                </div>
                <div class="relic-content">
                    <div class="relic-name">${relic.relicName}</div>
                    <div class="relic-meta">${relic.dynasty}</div>
                    <div class="relic-description">${relic.description}</div>
                </div>
                <a href="${pageContext.request.contextPath}/visitors/OneRelic?relicId=${relic.relicId}" class="relic-link" style="color: var(--primary-red); font-weight: bold; text-decoration: none;">查看详情</a>
            </div>
        </c:forEach>
        <c:if test="${empty relics}">
            <div style="grid-column: 1/-1; text-align: center; color: #888; margin-top: 40px;">该展厅暂无文物。</div>
        </c:if>
    </div>
</div>
</body>
</html>