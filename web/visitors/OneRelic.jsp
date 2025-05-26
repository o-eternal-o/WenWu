<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${relic.relicName} - 文物详情</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-red: #9b1b1f;
            --gold: #c8a86a;
            --dark-bg: #2a2a2a;
            --light-bg: #f8f1e5;
        }
        body {
            font-family: 'Microsoft YaHei', '宋体', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--light-bg);
            color: #333;
        }
        .main-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 30px 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(200,168,106,0.10);
        }
        .relic-title {
            text-align: center;
            color: var(--primary-red);
            font-size: 2.2em;
            margin-bottom: 30px;
            letter-spacing: 2px;
            position: relative;
        }
        .relic-title::after {
            content: '';
            position: absolute;
            bottom: -12px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--gold);
            border-radius: 2px;
        }
        .relic-details {
            display: flex;
            gap: 40px;
            align-items: flex-start;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .relic-img-box {
            flex: 0 0 340px;
            background: var(--dark-bg);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(200,168,106,0.08);
        }
        .relic-img-box img {
            width: 100%;
            height: 260px;
            object-fit: cover;
            display: block;
            transition: transform 0.3s;
        }
        .relic-img-box img:hover {
            transform: scale(1.05);
        }
        .relic-info {
            flex: 1;
            min-width: 220px;
        }
        .relic-info p {
            font-size: 1.1em;
            margin: 18px 0;
            color: #444;
        }
        .relic-info strong {
            color: var(--primary-red);
        }
        /* 反馈按钮 */
        .feedback-btn {
            display: inline-block;
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
            margin-top: 10px;
        }
        .feedback-btn:hover {
            background: #7e1518;
        }
        /* 弹窗样式 */
        .feedback-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }
        .feedback-modal.active {
            display: flex;
        }
        .feedback-modal-content {
            background: #fff;
            border-radius: 10px;
            width: 90%;
            max-width: 480px;
            padding: 32px 24px 24px 24px;
            position: relative;
            box-shadow: 0 4px 18px rgba(200,168,106,0.13);
        }
        .close {
            position: absolute;
            top: 18px;
            right: 18px;
            font-size: 24px;
            color: #aaa;
            cursor: pointer;
        }
        .close:hover { color: var(--primary-red);}
        .feedback-modal-content h2 {
            color: var(--primary-red);
            margin-bottom: 18px;
            font-size: 1.3em;
        }
        textarea {
            width: 100%;
            padding: 12px;
            border: 1.5px solid var(--gold);
            border-radius: 8px;
            font-size: 1em;
            margin-bottom: 18px;
            resize: none;
            background: #f8f1e5;
            color: #333;
            outline: none;
            transition: border 0.2s;
        }
        textarea:focus {
            border: 2px solid var(--primary-red);
        }
        .submit-btn {
            width: 100%;
            padding: 12px 0;
            background: var(--primary-red);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }
        .submit-btn:hover {
            background: #7e1518;
        }
        /* 提示条 */
        .feedback-tip {
            display: none;
            position: fixed;
            top: 30px;
            left: 50%;
            transform: translateX(-50%);
            background: var(--gold);
            color: #fff;
            padding: 14px 32px;
            border-radius: 8px;
            font-size: 1.1em;
            z-index: 2000;
            box-shadow: 0 2px 8px rgba(200,168,106,0.13);
        }
        .feedback-tip.success { background: var(--primary-red);}
        .feedback-tip.error { background: #888;}
        @media (max-width: 900px) {
            .relic-details { flex-direction: column; gap: 18px;}
            .relic-img-box { width: 100%; }
            .relic-img-box img { height: 180px;}
        }
    </style>
</head>
<body>
<div class="main-container">
    <h1 class="relic-title">${relic.relicName}</h1>
    <div class="relic-details">
        <div class="relic-img-box">
            <img src="${empty relic.imagePath ? '/assets/img/default_relic.jpg' : relic.imagePath}" alt="${relic.relicName}">
        </div>
        <div class="relic-info">
            <p><strong>所属朝代：</strong>${relic.dynasty}</p>
            <p><strong>描述：</strong>${relic.description}</p>
            <button class="feedback-btn" id="openFeedbackModal"><i class="fas fa-comment-dots"></i> 我要反馈</button>
        </div>
    </div>
    <!-- 反馈弹窗 -->
    <!-- 反馈弹窗 -->
    <div class="feedback-modal" id="feedbackModal">
        <div class="feedback-modal-content">
            <span class="close" id="closeModal">&times;</span>
            <h2>提交反馈</h2>
            <form id="feedbackForm" method="post" action="${pageContext.request.contextPath}/visitors/OneRelic">
                <input type="hidden" name="relicId" value="${relic.relicId}">
                <textarea name="content" rows="5" placeholder="请输入您的反馈内容" required></textarea>
                <button type="submit" class="submit-btn">提交</button>
            </form>
        </div>
    </div>
    <div class="feedback-tip" id="feedbackTip"></div>
    <script>
        // 弹窗控制
        document.getElementById('openFeedbackModal').onclick = function() {
            document.getElementById('feedbackModal').classList.add('active');
        };
        document.getElementById('closeModal').onclick = function() {
            document.getElementById('feedbackModal').classList.remove('active');
        };
        // 可选：提交后显示提示
        <% if (request.getAttribute("feedbackMsg") != null) { %>
        document.getElementById('feedbackTip').innerText = '<%= request.getAttribute("feedbackMsg") %>';
        document.getElementById('feedbackTip').classList.add('success');
        document.getElementById('feedbackTip').style.display = 'block';
        setTimeout(function(){ document.getElementById('feedbackTip').style.display = 'none'; }, 2000);
        <% } %>
    </script>
</div>
</body>
</html>